// **************************************************
// MetaHook function from MetaHook.amxx
// By 展鸿 2015-4-23
// 自由分享 保留作者信息
// **************************************************

/***
 * @note			设置玩家V模型Body
 * @param iPlayer	要设置的玩家
 * @param iBody		要设置的值
 * @return			成功返回1，失败返回0
 */
native MH_SetViewBody(iPlayer, iBody);

/***
 * @note			设置玩家V模型Skin
 * @param iPlayer	要设置的玩家
 * @param iSkin		要设置的值
 * @return			成功返回1，失败返回0
 */
native MH_SetViewSkin(iPlayer, iSkin);

/***
 * @note			设置玩家V模型贴图
 * @param iPlayer	要设置的玩家
 * @param szSrc		模型中贴图的名
 * @param szNew		要设置的贴图名(自动加载)
 * @return			成功返回1，失败返回0
 * @note			新的贴图必须为TGA-32位格式，并且放置在metahook\textures\目录下。
 *					参数写 "AK47" 则表示 "metahook\textures\AK47.tga"
 */
native MH_SetViewTexture(iPlayer, const szSrc[], const szNew[])

/***
 * @note			设置玩家V模型动作播放速度
 * @param iPlayer	要设置的玩家
 * @param szSeq		要设置速度的动作名
 * @param iFps		要设置的速度
 * @return			成功返回1，失败返回0
 */
native MH_SetViewFps(iPlayer, const szSeq[], iFps);

/***
 * @note			设置玩家V模型的渲染特效
 * @param iPlayer	要设置的玩家
 * @param iMode		渲染模式
 * @param iFx		渲染特效
 * @param ...		更多参数请参考 fakemeta_util.inc -> fm_set_rendering()
 * @return			成功返回1，失败返回0
 */
native MH_SetViewRender(iPlayer, iMode, iFx, r, g, b, iAmt);

