From: James Hartley <james.hartley@imgtec.com>
Subject: [PATCH] crypto: img-hash: Fix Kconfig selections
Date: Thu, 19 Mar 2015 16:46:24 +0000
Message-ID: <1426783584-11167-1-git-send-email-james.hartley@imgtec.com>
References: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Paul Bolle <pebolle@tiscali.nl>,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>,
	<james.hartley@imgtec.com>
To: Valentin Rothberg <valentinrothberg@gmail.com>,
	<abrestic@chromium.org>, <herbert@gondor.apana.org.au>,
	<davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAD3Xx4Kz0qT+=FKEy8N-rkubSrPAEhmXkTXk1H+-MGJ7BNiGqA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The Kconfig entry for CRYPTO_DEV_IMGTEC_HASH incorrectly selects
CRYPTO_SHA224, which does not exist (and is covered by CRYPTO_SHA256
which covers both 224 and 256). Remove it.

Also correct typo CRYPTO_ALG_API to be CRYPTO_ALGPI.

Reported-by: Valentin Rothberg <valentinrothberg@gmail.com>
Signed-off-by: James Hartley <james.hartley@imgtec.com>
---
 drivers/crypto/Kconfig |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index 8b18b66..800bf41 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -448,10 +448,9 @@ source "drivers/crypto/vmx/Kconfig"
 config CRYPTO_DEV_IMGTEC_HASH
 	depends on MIPS || COMPILE_TEST
 	tristate "Imagination Technologies hardware hash accelerator"
-	select CRYPTO_ALG_API
+	select CRYPTO_ALGAPI
 	select CRYPTO_MD5
 	select CRYPTO_SHA1
-	select CRYPTO_SHA224
 	select CRYPTO_SHA256
 	select CRYPTO_HASH
 	help
-- 
1.7.9.5
