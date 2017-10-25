From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: [PATCH v8 1/2] crypto: s5p-sss: Change spaces to tabs
Date: Wed, 25 Oct 2017 17:27:34 +0200
Message-ID: <20171025152735.11382-2-k.konieczny@partner.samsung.com>
References: <20171025152735.11382-1-k.konieczny@partner.samsung.com>
        <CGME20171025152755eucas1p253b583d324701826b21272ee477d93e0@eucas1p2.samsung.com>
Cc: Kamil Konieczny <k.konieczny@partner.samsung.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20171025152735.11382-1-k.konieczny@partner.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Change #define lines to use tabs consistently.

Acked-by: Vladimir Zapolskiy <vz@mleia.com>
Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Kamil Konieczny <k.konieczny@partner.samsung.com>
---
 drivers/crypto/s5p-sss.c | 190 +++++++++++++++++++++++------------------------
 1 file changed, 95 insertions(+), 95 deletions(-)

diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
index 7ac657f46d15..dfae1865c384 100644
--- a/drivers/crypto/s5p-sss.c
+++ b/drivers/crypto/s5p-sss.c
@@ -30,98 +30,98 @@
 #include <crypto/algapi.h>
 #include <crypto/scatterwalk.h>
 
-#define _SBF(s, v)                      ((v) << (s))
+#define _SBF(s, v)			((v) << (s))
 
 /* Feed control registers */
-#define SSS_REG_FCINTSTAT               0x0000
-#define SSS_FCINTSTAT_BRDMAINT          BIT(3)
-#define SSS_FCINTSTAT_BTDMAINT          BIT(2)
-#define SSS_FCINTSTAT_HRDMAINT          BIT(1)
-#define SSS_FCINTSTAT_PKDMAINT          BIT(0)
-
-#define SSS_REG_FCINTENSET              0x0004
-#define SSS_FCINTENSET_BRDMAINTENSET    BIT(3)
-#define SSS_FCINTENSET_BTDMAINTENSET    BIT(2)
-#define SSS_FCINTENSET_HRDMAINTENSET    BIT(1)
-#define SSS_FCINTENSET_PKDMAINTENSET    BIT(0)
-
-#define SSS_REG_FCINTENCLR              0x0008
-#define SSS_FCINTENCLR_BRDMAINTENCLR    BIT(3)
-#define SSS_FCINTENCLR_BTDMAINTENCLR    BIT(2)
-#define SSS_FCINTENCLR_HRDMAINTENCLR    BIT(1)
-#define SSS_FCINTENCLR_PKDMAINTENCLR    BIT(0)
-
-#define SSS_REG_FCINTPEND               0x000C
-#define SSS_FCINTPEND_BRDMAINTP         BIT(3)
-#define SSS_FCINTPEND_BTDMAINTP         BIT(2)
-#define SSS_FCINTPEND_HRDMAINTP         BIT(1)
-#define SSS_FCINTPEND_PKDMAINTP         BIT(0)
-
-#define SSS_REG_FCFIFOSTAT              0x0010
-#define SSS_FCFIFOSTAT_BRFIFOFUL        BIT(7)
-#define SSS_FCFIFOSTAT_BRFIFOEMP        BIT(6)
-#define SSS_FCFIFOSTAT_BTFIFOFUL        BIT(5)
-#define SSS_FCFIFOSTAT_BTFIFOEMP        BIT(4)
-#define SSS_FCFIFOSTAT_HRFIFOFUL        BIT(3)
-#define SSS_FCFIFOSTAT_HRFIFOEMP        BIT(2)
-#define SSS_FCFIFOSTAT_PKFIFOFUL        BIT(1)
-#define SSS_FCFIFOSTAT_PKFIFOEMP        BIT(0)
-
-#define SSS_REG_FCFIFOCTRL              0x0014
-#define SSS_FCFIFOCTRL_DESSEL           BIT(2)
-#define SSS_HASHIN_INDEPENDENT          _SBF(0, 0x00)
-#define SSS_HASHIN_CIPHER_INPUT         _SBF(0, 0x01)
-#define SSS_HASHIN_CIPHER_OUTPUT        _SBF(0, 0x02)
-
-#define SSS_REG_FCBRDMAS                0x0020
-#define SSS_REG_FCBRDMAL                0x0024
-#define SSS_REG_FCBRDMAC                0x0028
-#define SSS_FCBRDMAC_BYTESWAP           BIT(1)
-#define SSS_FCBRDMAC_FLUSH              BIT(0)
-
-#define SSS_REG_FCBTDMAS                0x0030
-#define SSS_REG_FCBTDMAL                0x0034
-#define SSS_REG_FCBTDMAC                0x0038
-#define SSS_FCBTDMAC_BYTESWAP           BIT(1)
-#define SSS_FCBTDMAC_FLUSH              BIT(0)
-
-#define SSS_REG_FCHRDMAS                0x0040
-#define SSS_REG_FCHRDMAL                0x0044
-#define SSS_REG_FCHRDMAC                0x0048
-#define SSS_FCHRDMAC_BYTESWAP           BIT(1)
-#define SSS_FCHRDMAC_FLUSH              BIT(0)
-
-#define SSS_REG_FCPKDMAS                0x0050
-#define SSS_REG_FCPKDMAL                0x0054
-#define SSS_REG_FCPKDMAC                0x0058
-#define SSS_FCPKDMAC_BYTESWAP           BIT(3)
-#define SSS_FCPKDMAC_DESCEND            BIT(2)
-#define SSS_FCPKDMAC_TRANSMIT           BIT(1)
-#define SSS_FCPKDMAC_FLUSH              BIT(0)
-
-#define SSS_REG_FCPKDMAO                0x005C
+#define SSS_REG_FCINTSTAT		0x0000
+#define SSS_FCINTSTAT_BRDMAINT		BIT(3)
+#define SSS_FCINTSTAT_BTDMAINT		BIT(2)
+#define SSS_FCINTSTAT_HRDMAINT		BIT(1)
+#define SSS_FCINTSTAT_PKDMAINT		BIT(0)
+
+#define SSS_REG_FCINTENSET		0x0004
+#define SSS_FCINTENSET_BRDMAINTENSET	BIT(3)
+#define SSS_FCINTENSET_BTDMAINTENSET	BIT(2)
+#define SSS_FCINTENSET_HRDMAINTENSET	BIT(1)
+#define SSS_FCINTENSET_PKDMAINTENSET	BIT(0)
+
+#define SSS_REG_FCINTENCLR		0x0008
+#define SSS_FCINTENCLR_BRDMAINTENCLR	BIT(3)
+#define SSS_FCINTENCLR_BTDMAINTENCLR	BIT(2)
+#define SSS_FCINTENCLR_HRDMAINTENCLR	BIT(1)
+#define SSS_FCINTENCLR_PKDMAINTENCLR	BIT(0)
+
+#define SSS_REG_FCINTPEND		0x000C
+#define SSS_FCINTPEND_BRDMAINTP		BIT(3)
+#define SSS_FCINTPEND_BTDMAINTP		BIT(2)
+#define SSS_FCINTPEND_HRDMAINTP		BIT(1)
+#define SSS_FCINTPEND_PKDMAINTP		BIT(0)
+
+#define SSS_REG_FCFIFOSTAT		0x0010
+#define SSS_FCFIFOSTAT_BRFIFOFUL	BIT(7)
+#define SSS_FCFIFOSTAT_BRFIFOEMP	BIT(6)
+#define SSS_FCFIFOSTAT_BTFIFOFUL	BIT(5)
+#define SSS_FCFIFOSTAT_BTFIFOEMP	BIT(4)
+#define SSS_FCFIFOSTAT_HRFIFOFUL	BIT(3)
+#define SSS_FCFIFOSTAT_HRFIFOEMP	BIT(2)
+#define SSS_FCFIFOSTAT_PKFIFOFUL	BIT(1)
+#define SSS_FCFIFOSTAT_PKFIFOEMP	BIT(0)
+
+#define SSS_REG_FCFIFOCTRL		0x0014
+#define SSS_FCFIFOCTRL_DESSEL		BIT(2)
+#define SSS_HASHIN_INDEPENDENT		_SBF(0, 0x00)
+#define SSS_HASHIN_CIPHER_INPUT		_SBF(0, 0x01)
+#define SSS_HASHIN_CIPHER_OUTPUT	_SBF(0, 0x02)
+
+#define SSS_REG_FCBRDMAS		0x0020
+#define SSS_REG_FCBRDMAL		0x0024
+#define SSS_REG_FCBRDMAC		0x0028
+#define SSS_FCBRDMAC_BYTESWAP		BIT(1)
+#define SSS_FCBRDMAC_FLUSH		BIT(0)
+
+#define SSS_REG_FCBTDMAS		0x0030
+#define SSS_REG_FCBTDMAL		0x0034
+#define SSS_REG_FCBTDMAC		0x0038
+#define SSS_FCBTDMAC_BYTESWAP		BIT(1)
+#define SSS_FCBTDMAC_FLUSH		BIT(0)
+
+#define SSS_REG_FCHRDMAS		0x0040
+#define SSS_REG_FCHRDMAL		0x0044
+#define SSS_REG_FCHRDMAC		0x0048
+#define SSS_FCHRDMAC_BYTESWAP		BIT(1)
+#define SSS_FCHRDMAC_FLUSH		BIT(0)
+
+#define SSS_REG_FCPKDMAS		0x0050
+#define SSS_REG_FCPKDMAL		0x0054
+#define SSS_REG_FCPKDMAC		0x0058
+#define SSS_FCPKDMAC_BYTESWAP		BIT(3)
+#define SSS_FCPKDMAC_DESCEND		BIT(2)
+#define SSS_FCPKDMAC_TRANSMIT		BIT(1)
+#define SSS_FCPKDMAC_FLUSH		BIT(0)
+
+#define SSS_REG_FCPKDMAO		0x005C
 
 /* AES registers */
 #define SSS_REG_AES_CONTROL		0x00
-#define SSS_AES_BYTESWAP_DI             BIT(11)
-#define SSS_AES_BYTESWAP_DO             BIT(10)
-#define SSS_AES_BYTESWAP_IV             BIT(9)
-#define SSS_AES_BYTESWAP_CNT            BIT(8)
-#define SSS_AES_BYTESWAP_KEY            BIT(7)
-#define SSS_AES_KEY_CHANGE_MODE         BIT(6)
-#define SSS_AES_KEY_SIZE_128            _SBF(4, 0x00)
-#define SSS_AES_KEY_SIZE_192            _SBF(4, 0x01)
-#define SSS_AES_KEY_SIZE_256            _SBF(4, 0x02)
-#define SSS_AES_FIFO_MODE               BIT(3)
-#define SSS_AES_CHAIN_MODE_ECB          _SBF(1, 0x00)
-#define SSS_AES_CHAIN_MODE_CBC          _SBF(1, 0x01)
-#define SSS_AES_CHAIN_MODE_CTR          _SBF(1, 0x02)
-#define SSS_AES_MODE_DECRYPT            BIT(0)
+#define SSS_AES_BYTESWAP_DI		BIT(11)
+#define SSS_AES_BYTESWAP_DO		BIT(10)
+#define SSS_AES_BYTESWAP_IV		BIT(9)
+#define SSS_AES_BYTESWAP_CNT		BIT(8)
+#define SSS_AES_BYTESWAP_KEY		BIT(7)
+#define SSS_AES_KEY_CHANGE_MODE		BIT(6)
+#define SSS_AES_KEY_SIZE_128		_SBF(4, 0x00)
+#define SSS_AES_KEY_SIZE_192		_SBF(4, 0x01)
+#define SSS_AES_KEY_SIZE_256		_SBF(4, 0x02)
+#define SSS_AES_FIFO_MODE		BIT(3)
+#define SSS_AES_CHAIN_MODE_ECB		_SBF(1, 0x00)
+#define SSS_AES_CHAIN_MODE_CBC		_SBF(1, 0x01)
+#define SSS_AES_CHAIN_MODE_CTR		_SBF(1, 0x02)
+#define SSS_AES_MODE_DECRYPT		BIT(0)
 
 #define SSS_REG_AES_STATUS		0x04
-#define SSS_AES_BUSY                    BIT(2)
-#define SSS_AES_INPUT_READY             BIT(1)
-#define SSS_AES_OUTPUT_READY            BIT(0)
+#define SSS_AES_BUSY			BIT(2)
+#define SSS_AES_INPUT_READY		BIT(1)
+#define SSS_AES_OUTPUT_READY		BIT(0)
 
 #define SSS_REG_AES_IN_DATA(s)		(0x10 + (s << 2))
 #define SSS_REG_AES_OUT_DATA(s)		(0x20 + (s << 2))
@@ -129,22 +129,22 @@
 #define SSS_REG_AES_CNT_DATA(s)		(0x40 + (s << 2))
 #define SSS_REG_AES_KEY_DATA(s)		(0x80 + (s << 2))
 
-#define SSS_REG(dev, reg)               ((dev)->ioaddr + (SSS_REG_##reg))
-#define SSS_READ(dev, reg)              __raw_readl(SSS_REG(dev, reg))
-#define SSS_WRITE(dev, reg, val)        __raw_writel((val), SSS_REG(dev, reg))
+#define SSS_REG(dev, reg)		((dev)->ioaddr + (SSS_REG_##reg))
+#define SSS_READ(dev, reg)		__raw_readl(SSS_REG(dev, reg))
+#define SSS_WRITE(dev, reg, val)	__raw_writel((val), SSS_REG(dev, reg))
 
-#define SSS_AES_REG(dev, reg)           ((dev)->aes_ioaddr + SSS_REG_##reg)
+#define SSS_AES_REG(dev, reg)		((dev)->aes_ioaddr + SSS_REG_##reg)
 #define SSS_AES_WRITE(dev, reg, val)    __raw_writel((val), \
 						SSS_AES_REG(dev, reg))
 
 /* HW engine modes */
-#define FLAGS_AES_DECRYPT               BIT(0)
-#define FLAGS_AES_MODE_MASK             _SBF(1, 0x03)
-#define FLAGS_AES_CBC                   _SBF(1, 0x01)
-#define FLAGS_AES_CTR                   _SBF(1, 0x02)
+#define FLAGS_AES_DECRYPT		BIT(0)
+#define FLAGS_AES_MODE_MASK		_SBF(1, 0x03)
+#define FLAGS_AES_CBC			_SBF(1, 0x01)
+#define FLAGS_AES_CTR			_SBF(1, 0x02)
 
-#define AES_KEY_LEN         16
-#define CRYPTO_QUEUE_LEN    1
+#define AES_KEY_LEN			16
+#define CRYPTO_QUEUE_LEN		1
 
 /**
  * struct samsung_aes_variant - platform specific SSS driver data
-- 
2.14.1.536.g6867272d5b56
