From: Richard Hartmann <richih.mailinglist@gmail.com>
Subject: [PATCH 10/19] crypto: sha1_generic - Fix checkpatch errors
Date: Fri, 19 Feb 2010 01:22:35 +0100
Message-ID: <1266538957-3410-1-git-send-email-richih.mailinglist@gmail.com>
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 crypto/sha1_generic.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/crypto/sha1_generic.c b/crypto/sha1_generic.c
index 0416091..297cb0d 100644
--- a/crypto/sha1_generic.c
+++ b/crypto/sha1_generic.c
@@ -127,11 +127,11 @@ static struct shash_alg alg = {
 	.descsize	=	sizeof(struct sha1_state),
 	.statesize	=	sizeof(struct sha1_state),
 	.base		=	{
-		.cra_name	=	"sha1",
-		.cra_driver_name=	"sha1-generic",
-		.cra_flags	=	CRYPTO_ALG_TYPE_SHASH,
-		.cra_blocksize	=	SHA1_BLOCK_SIZE,
-		.cra_module	=	THIS_MODULE,
+		.cra_name		=	"sha1",
+		.cra_driver_name	=	"sha1-generic",
+		.cra_flags		=	CRYPTO_ALG_TYPE_SHASH,
+		.cra_blocksize		=	SHA1_BLOCK_SIZE,
+		.cra_module		=	THIS_MODULE,
 	}
 };
 
-- 
1.6.6.1
