From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: [PATCH 2/2] drivers: crypto: fix typo in nx driver config option
Date: Wed, 13 Jun 2012 13:22:43 -0500
Message-ID: <1339611763-14603-2-git-send-email-sjenning@linux.vnet.ibm.com>
References: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
	Paul Mackerras <paulus@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, trivial@kernel.org,
	Kent Yoder <key@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cc: Kent Yoder <key@linux.vnet.ibm.com>
Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/crypto/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 1092a77..b9b11a6 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -298,7 +298,7 @@ config CRYPTO_DEV_TEGRA_AES
 	  will be called tegra-aes.
 
 config CRYPTO_DEV_NX
-	tristate "Support for Power7+ in-Nest cryptographic accleration"
+	tristate "Support for Power7+ in-Nest cryptographic acceleration"
 	depends on PPC64 && IBMVIO
 	select CRYPTO_AES
 	select CRYPTO_CBC
-- 
1.7.9.5
