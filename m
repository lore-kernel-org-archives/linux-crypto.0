From: Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: [PATCH 5/5] crypto: enable OCTEON MD5 module selection
Date: Sun, 21 Dec 2014 22:54:02 +0200
Message-ID: <1419195242-546-6-git-send-email-aaro.koskinen@iki.fi>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Cc: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Daney <david.daney@cavium.com>,
        linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Return-path: <linux-mips-bounce@linux-mips.org>
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
List-Id: linux-crypto.vger.kernel.org

Enable user to select OCTEON MD5 module.

Signed-off-by: Aaro Koskinen <aaro.koskinen@iki.fi>
---
 crypto/Kconfig | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 87bbc9c..1618468 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -427,6 +427,15 @@ config CRYPTO_MD5
 	help
 	  MD5 message digest algorithm (RFC1321).
 
+config CRYPTO_MD5_OCTEON
+	tristate "MD5 digest algorithm (OCTEON)"
+	depends on CPU_CAVIUM_OCTEON
+	select CRYPTO_MD5
+	select CRYPTO_HASH
+	help
+	  MD5 message digest algorithm (RFC1321) implemented
+	  using OCTEON crypto instructions, when available.
+
 config CRYPTO_MD5_SPARC64
 	tristate "MD5 digest algorithm (SPARC64)"
 	depends on SPARC64
-- 
2.2.0
