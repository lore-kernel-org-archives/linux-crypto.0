From: Richard Weinberger <richard@nod.at>
Subject: [PATCH 05/28] Remove MPILIB_EXTRA
Date: Sun,  9 Feb 2014 19:47:43 +0100
Message-ID: <1391971686-9517-6-git-send-email-richard@nod.at>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
Cc: Richard Weinberger <richard@nod.at>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org (open list:CRYPTO API),
	linux-kernel@vger.kernel.org (open list)
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391971686-9517-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The symbol is an orphan, get rid of it.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 crypto/asymmetric_keys/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
index 03a6eb9..0320c7d 100644
--- a/crypto/asymmetric_keys/Kconfig
+++ b/crypto/asymmetric_keys/Kconfig
@@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
 
 config PUBLIC_KEY_ALGO_RSA
 	tristate "RSA public-key algorithm"
-	select MPILIB_EXTRA
 	select MPILIB
 	help
 	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).
-- 
1.8.4.2
