From: Eric Biggers <ebiggers@google.com>
Subject: [PATCH] crypto: cmac - return -EINVAL if block size is unsupported
Date: Mon, 10 Oct 2016 10:15:14 -0700
Message-ID: <1476119715-71397-1-git-send-email-ebiggers@google.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

cmac_create() previously returned 0 if a cipher with a block size other
than 8 or 16 bytes was specified.  It should return -EINVAL instead.
Granted, this doesn't actually change any behavior because cryptomgr
currently ignores any return value other than -EAGAIN from template
->create() functions.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/cmac.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/cmac.c b/crypto/cmac.c
index 7a8bfbd..b6c4059 100644
--- a/crypto/cmac.c
+++ b/crypto/cmac.c
@@ -243,6 +243,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
 	case 8:
 		break;
 	default:
+		err = -EINVAL;
 		goto out_put_alg;
 	}
 
-- 
2.8.0.rc3.226.g39d4020
