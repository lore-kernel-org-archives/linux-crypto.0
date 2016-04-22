From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/2] crypto: s5p-sss - Use common BIT macro
Date: Fri, 22 Apr 2016 14:15:22 +0200
Message-ID: <1461327323-23288-1-git-send-email-k.kozlowski@samsung.com>
Cc: Vladimir Zapolskiy <vz@mleia.com>,
	Krzysztof Kozlowski <k.kozlowski@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:11983 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbcDVMPc (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Apr 2016 08:15:32 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The BIT() macro is obvious and well known, so prefer to use it instead
of crafted own macro.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/crypto/s5p-sss.c | 95 ++++++++++++++++++++++++------------------------
 1 file changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 71ca6a5d636d..b96532078d0c 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -31,45 +31,44 @@
 #include <crypto/scatterwalk.h>
 
 #define _SBF(s, v)                      ((v) << (s))
-#define _BIT(b)                         _SBF(b, 1)
 
 /* Feed control registers */
 #define SSS_REG_FCINTSTAT               0x0000
-#define SSS_FCINTSTAT_BRDMAINT          _BIT(3)
-#define SSS_FCINTSTAT_BTDMAINT          _BIT(2)
-#define SSS_FCINTSTAT_HRDMAINT          _BIT(1)
-#define SSS_FCINTSTAT_PKDMAINT          _BIT(0)
+#define SSS_FCINTSTAT_BRDMAINT          BIT(3)
+#define SSS_FCINTSTAT_BTDMAINT          BIT(2)
+#define SSS_FCINTSTAT_HRDMAINT          BIT(1)
+#define SSS_FCINTSTAT_PKDMAINT          BIT(0)
 
 #define SSS_REG_FCINTENSET              0x0004
-#define SSS_FCINTENSET_BRDMAINTENSET    _BIT(3)
-#define SSS_FCINTENSET_BTDMAINTENSET    _BIT(2)
-#define SSS_FCINTENSET_HRDMAINTENSET    _BIT(1)
-#define SSS_FCINTENSET_PKDMAINTENSET    _BIT(0)
+#define SSS_FCINTENSET_BRDMAINTENSET    BIT(3)
+#define SSS_FCINTENSET_BTDMAINTENSET    BIT(2)
+#define SSS_FCINTENSET_HRDMAINTENSET    BIT(1)
+#define SSS_FCINTENSET_PKDMAINTENSET    BIT(0)
 
 #define SSS_REG_FCINTENCLR              0x0008
-#define SSS_FCINTENCLR_BRDMAINTENCLR    _BIT(3)
-#define SSS_FCINTENCLR_BTDMAINTENCLR    _BIT(2)
-#define SSS_FCINTENCLR_HRDMAINTENCLR    _BIT(1)
-#define SSS_FCINTENCLR_PKDMAINTENCLR    _BIT(0)
+#define SSS_FCINTENCLR_BRDMAINTENCLR    BIT(3)
+#define SSS_FCINTENCLR_BTDMAINTENCLR    BIT(2)
+#define SSS_FCINTENCLR_HRDMAINTENCLR    BIT(1)
+#define SSS_FCINTENCLR_PKDMAINTENCLR    BIT(0)
 
 #define SSS_REG_FCINTPEND               0x000C
-#define SSS_FCINTPEND_BRDMAINTP         _BIT(3)
-#define SSS_FCINTPEND_BTDMAINTP         _BIT(2)
-#define SSS_FCINTPEND_HRDMAINTP         _BIT(1)
-#define SSS_FCINTPEND_PKDMAINTP         _BIT(0)
+#define SSS_FCINTPEND_BRDMAINTP         BIT(3)
+#define SSS_FCINTPEND_BTDMAINTP         BIT(2)
+#define SSS_FCINTPEND_HRDMAINTP         BIT(1)
+#define SSS_FCINTPEND_PKDMAINTP         BIT(0)
 
 #define SSS_REG_FCFIFOSTAT              0x0010
-#define SSS_FCFIFOSTAT_BRFIFOFUL        _BIT(7)
-#define SSS_FCFIFOSTAT_BRFIFOEMP        _BIT(6)
-#define SSS_FCFIFOSTAT_BTFIFOFUL        _BIT(5)
-#define SSS_FCFIFOSTAT_BTFIFOEMP        _BIT(4)
-#define SSS_FCFIFOSTAT_HRFIFOFUL        _BIT(3)
-#define SSS_FCFIFOSTAT_HRFIFOEMP        _BIT(2)
-#define SSS_FCFIFOSTAT_PKFIFOFUL        _BIT(1)
-#define SSS_FCFIFOSTAT_PKFIFOEMP        _BIT(0)
+#define SSS_FCFIFOSTAT_BRFIFOFUL        BIT(7)
+#define SSS_FCFIFOSTAT_BRFIFOEMP        BIT(6)
+#define SSS_FCFIFOSTAT_BTFIFOFUL        BIT(5)
+#define SSS_FCFIFOSTAT_BTFIFOEMP        BIT(4)
+#define SSS_FCFIFOSTAT_HRFIFOFUL        BIT(3)
+#define SSS_FCFIFOSTAT_HRFIFOEMP        BIT(2)
+#define SSS_FCFIFOSTAT_PKFIFOFUL        BIT(1)
+#define SSS_FCFIFOSTAT_PKFIFOEMP        BIT(0)
 
 #define SSS_REG_FCFIFOCTRL              0x0014
-#define SSS_FCFIFOCTRL_DESSEL           _BIT(2)
+#define SSS_FCFIFOCTRL_DESSEL           BIT(2)
 #define SSS_HASHIN_INDEPENDENT          _SBF(0, 0x00)
 #define SSS_HASHIN_CIPHER_INPUT         _SBF(0, 0x01)
 #define SSS_HASHIN_CIPHER_OUTPUT        _SBF(0, 0x02)
@@ -77,52 +76,52 @@
 #define SSS_REG_FCBRDMAS                0x0020
 #define SSS_REG_FCBRDMAL                0x0024
 #define SSS_REG_FCBRDMAC                0x0028
-#define SSS_FCBRDMAC_BYTESWAP           _BIT(1)
-#define SSS_FCBRDMAC_FLUSH              _BIT(0)
+#define SSS_FCBRDMAC_BYTESWAP           BIT(1)
+#define SSS_FCBRDMAC_FLUSH              BIT(0)
 
 #define SSS_REG_FCBTDMAS                0x0030
 #define SSS_REG_FCBTDMAL                0x0034
 #define SSS_REG_FCBTDMAC                0x0038
-#define SSS_FCBTDMAC_BYTESWAP           _BIT(1)
-#define SSS_FCBTDMAC_FLUSH              _BIT(0)
+#define SSS_FCBTDMAC_BYTESWAP           BIT(1)
+#define SSS_FCBTDMAC_FLUSH              BIT(0)
 
 #define SSS_REG_FCHRDMAS                0x0040
 #define SSS_REG_FCHRDMAL                0x0044
 #define SSS_REG_FCHRDMAC                0x0048
-#define SSS_FCHRDMAC_BYTESWAP           _BIT(1)
-#define SSS_FCHRDMAC_FLUSH              _BIT(0)
+#define SSS_FCHRDMAC_BYTESWAP           BIT(1)
+#define SSS_FCHRDMAC_FLUSH              BIT(0)
 
 #define SSS_REG_FCPKDMAS                0x0050
 #define SSS_REG_FCPKDMAL                0x0054
 #define SSS_REG_FCPKDMAC                0x0058
-#define SSS_FCPKDMAC_BYTESWAP           _BIT(3)
-#define SSS_FCPKDMAC_DESCEND            _BIT(2)
-#define SSS_FCPKDMAC_TRANSMIT           _BIT(1)
-#define SSS_FCPKDMAC_FLUSH              _BIT(0)
+#define SSS_FCPKDMAC_BYTESWAP           BIT(3)
+#define SSS_FCPKDMAC_DESCEND            BIT(2)
+#define SSS_FCPKDMAC_TRANSMIT           BIT(1)
+#define SSS_FCPKDMAC_FLUSH              BIT(0)
 
 #define SSS_REG_FCPKDMAO                0x005C
 
 /* AES registers */
 #define SSS_REG_AES_CONTROL		0x00
-#define SSS_AES_BYTESWAP_DI             _BIT(11)
-#define SSS_AES_BYTESWAP_DO             _BIT(10)
-#define SSS_AES_BYTESWAP_IV             _BIT(9)
-#define SSS_AES_BYTESWAP_CNT            _BIT(8)
-#define SSS_AES_BYTESWAP_KEY            _BIT(7)
-#define SSS_AES_KEY_CHANGE_MODE         _BIT(6)
+#define SSS_AES_BYTESWAP_DI             BIT(11)
+#define SSS_AES_BYTESWAP_DO             BIT(10)
+#define SSS_AES_BYTESWAP_IV             BIT(9)
+#define SSS_AES_BYTESWAP_CNT            BIT(8)
+#define SSS_AES_BYTESWAP_KEY            BIT(7)
+#define SSS_AES_KEY_CHANGE_MODE         BIT(6)
 #define SSS_AES_KEY_SIZE_128            _SBF(4, 0x00)
 #define SSS_AES_KEY_SIZE_192            _SBF(4, 0x01)
 #define SSS_AES_KEY_SIZE_256            _SBF(4, 0x02)
-#define SSS_AES_FIFO_MODE               _BIT(3)
+#define SSS_AES_FIFO_MODE               BIT(3)
 #define SSS_AES_CHAIN_MODE_ECB          _SBF(1, 0x00)
 #define SSS_AES_CHAIN_MODE_CBC          _SBF(1, 0x01)
 #define SSS_AES_CHAIN_MODE_CTR          _SBF(1, 0x02)
-#define SSS_AES_MODE_DECRYPT            _BIT(0)
+#define SSS_AES_MODE_DECRYPT            BIT(0)
 
 #define SSS_REG_AES_STATUS		0x04
-#define SSS_AES_BUSY                    _BIT(2)
-#define SSS_AES_INPUT_READY             _BIT(1)
-#define SSS_AES_OUTPUT_READY            _BIT(0)
+#define SSS_AES_BUSY                    BIT(2)
+#define SSS_AES_INPUT_READY             BIT(1)
+#define SSS_AES_OUTPUT_READY            BIT(0)
 
 #define SSS_REG_AES_IN_DATA(s)		(0x10 + (s << 2))
 #define SSS_REG_AES_OUT_DATA(s)		(0x20 + (s << 2))
@@ -139,7 +138,7 @@
 						SSS_AES_REG(dev, reg))
 
 /* HW engine modes */
-#define FLAGS_AES_DECRYPT               _BIT(0)
+#define FLAGS_AES_DECRYPT               BIT(0)
 #define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
 #define FLAGS_AES_CBC                   _SBF(1, 0x01)
 #define FLAGS_AES_CTR                   _SBF(1, 0x02)
-- 
1.9.1
