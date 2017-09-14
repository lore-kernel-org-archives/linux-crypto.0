From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: algboss: remove redundant setting of len to zero
Date: Thu, 14 Sep 2017 19:02:19 +0100
Message-ID: <20170914180219.12994-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The variable len is set to zero, never read and then later updated
to p - name, so clearly the zero'ing of len is redundant and
can be removed.

Detected by clang scan-build:
" warning: Value stored to 'len' is never read"

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/algboss.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/crypto/algboss.c b/crypto/algboss.c
index 960d8548171b..5e6df2a087fa 100644
--- a/crypto/algboss.c
+++ b/crypto/algboss.c
@@ -122,7 +122,6 @@ static int cryptomgr_schedule_probe(struct crypto_larval *larval)
 		int notnum = 0;
 
 		name = ++p;
-		len = 0;
 
 		for (; isalnum(*p) || *p == '-' || *p == '_'; p++)
 			notnum |= !isdigit(*p);
-- 
2.14.1
