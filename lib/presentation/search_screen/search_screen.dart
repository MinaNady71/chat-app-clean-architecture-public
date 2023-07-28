import 'package:chat_app/app/functions.dart';
import 'package:chat_app/presentation/search_screen/widget/search_bottom_sheet_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../domain/models/models.dart';
import '../chat_room_screen/chat_room_screen.dart';
import '../resources/assets_manager.dart';
import '../resources/color_manager.dart';
import '../resources/routes_manger.dart';
import '../resources/strings_manager.dart';
import '../resources/values_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key, required this.list}) : super(key: key);
  final List<UserModel> list;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<UserModel> _filterList = [];

  @override
  void initState() {
      _filterList = widget.list;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The search area here
        title: SizedBox(
          width: double.infinity,
          child: Center(
            child: TextField(
              controller: _searchController,
              onTapOutside: (_){
                unFocusKeyboard();
              },
              onChanged: onChangedTextField,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  splashRadius: AppSize.s20,
                  icon: const Icon(Icons.clear,),
                  onPressed: clearSearch,
                ),
                hintText: AppStrings.search.tr(),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: filterShowDialog,
            icon: const Icon(Icons.filter_alt),
            padding: const EdgeInsets.only(right: 10),
            constraints: const BoxConstraints(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppPadding.p8),
        child: ListView.separated(
          physics: const AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) => usersList(index, _filterList[index]),
          separatorBuilder: (context, index) =>
              const SizedBox(height: AppSize.s5),
          itemCount: _filterList.length,
        ),
      ),
    );
  }

  Widget usersList(index,userModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: ColorManager.borderColor, width: AppSize.s0_25),
            color: Theme.of(context).primaryColor,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(
                    settings: const RouteSettings(name: Routes.chatRoomScreen),
                    builder: (context)=>ChatRoomScreen(userModel:userModel,)));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: AppPadding.p10, horizontal: AppPadding.p10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 0,
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            backgroundImage: Image.asset(ImageAssets.userAvatar).image,
                            foregroundImage:NetworkImage(userModel.image),
                            maxRadius: AppSize.s23,
                          ),
                          CircleAvatar(
                            radius: AppSize.s8,
                            backgroundColor: ColorManager.black45,
                            child: CircleAvatar(
                              maxRadius: AppSize.s5,
                              backgroundColor: userModel.status
                                  ? ColorManager.activeUserDarkModeColor
                                  : ColorManager.disActiveUserDarkModeColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: AppSize.s15,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  userModel.username,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headlineMedium,
                                ),
                              ),
                              const SizedBox(
                                width: AppSize.s5,
                              ),
                              if (userModel.verified)
                                Flexible(
                                    flex: 0,
                                    child: Icon(Icons.verified,
                                        color: ColorManager
                                            .verifiedIconColor,
                                        size: AppSize.s16)),
                            ],
                          ),
                          const SizedBox(
                            height: AppSize.s10,
                          ),
                          Text(
                            userModel.bio,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: AppPadding.p8),
                      child: Text(
                        userModel.status
                            ? AppStrings.online.tr()
                            : AppStrings.offline.tr(),
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: userModel.status
                                  ? ColorManager.activeUserDarkModeColor
                                  : ColorManager.disActiveUserDarkModeColor,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _showModalBottomSheetWidget() {
    return SearchBottomSheet(
      onPress: filterByStatus,
    );
  }

  void filterByStatus(int index) {
    if (index == 0) {
      setState(() {
        _filterList = widget.list.where((element) {
          return element.status == true;
        }).toList();
      });
    }
      if (index == 1) {
        setState(() {
          _filterList = widget.list.where((element) {
            return element.status = true;
          }).toList();
        });
      }
        if (index == 2) {
          setState(() {
            _filterList = widget.list;
          });
        }

  }

  void filterShowDialog() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * MediaQueryAppSize.s0_25,
              child: _showModalBottomSheetWidget());
        });
  }

  void onChangedTextField(value) {
    setState(() {
      _filterList = widget.list.where((element) {
        return element.username
            .toLowerCase()
            .contains(value.toString().toLowerCase());
      }).toList();
    });
  }

  void clearSearch() {
    setState(() {
      _searchController.clear();
      _filterList = widget.list;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    unFocusKeyboard();
    super.dispose();
  }
}
