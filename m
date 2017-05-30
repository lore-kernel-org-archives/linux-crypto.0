From: Derek Robson <robsonde@gmail.com>
Subject: [PATCH V2 26/27] Drivers: ccree: cc_hw_queue_defs.h - align block
 comments
Date: Tue, 30 May 2017 18:17:10 +1200
Message-ID: <20170530061710.14184-1-robsonde@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Derek Robson <robsonde@gmail.com>,
 driverdev-devel@linuxdriverproject.org, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
To: gilad@benyossef.com,
	gregkh@linuxfoundation.org
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Fixed block comment alignment, Style fix only
Found using checkpatch

Signed-off-by: Derek Robson <robsonde@gmail.com>
---
 drivers/staging/ccree/cc_hw_queue_defs.h | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/ccree/cc_hw_queue_defs.h b/drivers/staging/ccree/cc_hw_queue_defs.h
index 71381760566d..bb64fddc371d 100644
--- a/drivers/staging/ccree/cc_hw_queue_defs.h
+++ b/drivers/staging/ccree/cc_hw_queue_defs.h
@@ -23,8 +23,8 @@
 #include "dx_crys_kernel.h"
 
 /******************************************************************************
-*				DEFINITIONS
-******************************************************************************/
+ *				DEFINITIONS
+ ******************************************************************************/
 
 /* Dma AXI Secure bit */
 #define	AXI_SECURE	0
@@ -36,8 +36,8 @@
 #define _HW_DESC_MONITOR_KICK 0x7FFFC00
 
 /******************************************************************************
-*				TYPE DEFINITIONS
-******************************************************************************/
+ *				TYPE DEFINITIONS
+ ******************************************************************************/
 
 struct cc_hw_desc {
 	u32 word[HW_DESC_SIZE_WORDS];
@@ -400,7 +400,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param numRounds number of rounds for Multi2
-*/
+ */
 #define HW_DESC_SET_MULTI2_NUM_ROUNDS(pDesc, numRounds)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD2, VALUE, (pDesc)->word[2], (u32)(numRounds));	\
@@ -411,7 +411,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param flowMode Any one of the modes defined in [CC7x-DESC]
-*/
+ */
 
 #define HW_DESC_SET_FLOW_MODE(pDesc, flowMode)										\
 	do {														\
@@ -423,7 +423,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param cipherMode Any one of the modes defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_CIPHER_MODE(pDesc, cipherMode)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_MODE, (pDesc)->word[4], (cipherMode));		\
@@ -434,7 +434,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_CIPHER_CONFIG0(pDesc, cipherConfig)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF0, (pDesc)->word[4], (cipherConfig));	\
@@ -445,7 +445,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param cipherConfig Any one of the modes defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_CIPHER_CONFIG1(pDesc, cipherConfig)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_CONF1, (pDesc)->word[4], (cipherConfig));	\
@@ -456,7 +456,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param hwKey The hw key number as in enun HwCryptoKey
-*/
+ */
 #define HW_DESC_SET_HW_CRYPTO_KEY(pDesc, hwKey)										\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (hwKey) & HW_KEY_MASK_CIPHER_DO);		\
@@ -468,7 +468,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param swapConfig Any one of the modes defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_BYTES_SWAP(pDesc, swapConfig)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, BYTES_SWAP, (pDesc)->word[4], (swapConfig));		\
@@ -478,7 +478,7 @@ enum cc_hw_des_key_size {
  * This macro sets the CMAC_SIZE0 mode.
  *
  * \param pDesc pointer HW descriptor struct
-*/
+ */
 #define HW_DESC_SET_CMAC_SIZE0_MODE(pDesc)										\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CMAC_SIZE0, (pDesc)->word[4], 0x1);			\
@@ -489,7 +489,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param keySize key size in bytes (NOT size code)
-*/
+ */
 #define HW_DESC_SET_KEY_SIZE_AES(pDesc, keySize)									\
 	do {													        \
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 2);	\
@@ -500,7 +500,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param keySize key size in bytes (NOT size code)
-*/
+ */
 #define HW_DESC_SET_KEY_SIZE_DES(pDesc, keySize)									\
 	do {													        \
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, KEY_SIZE, (pDesc)->word[4], ((keySize) >> 3) - 1);	\
@@ -511,7 +511,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param setupMode Any one of the setup modes defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_SETUP_MODE(pDesc, setupMode)									\
 	do {														\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, SETUP_OPERATION, (pDesc)->word[4], (setupMode));	\
@@ -522,7 +522,7 @@ enum cc_hw_des_key_size {
  *
  * \param pDesc pointer HW descriptor struct
  * \param cipherDo Any one of the cipher do defined in [CC7x-DESC]
-*/
+ */
 #define HW_DESC_SET_CIPHER_DO(pDesc, cipherDo)											\
 	do {															\
 		CC_REG_FLD_SET(CRY_KERNEL, DSCRPTR_QUEUE_WORD4, CIPHER_DO, (pDesc)->word[4], (cipherDo) & HW_KEY_MASK_CIPHER_DO);	\
-- 
2.13.0
