From: Colin King <colin.king@canonical.com>
Subject: [PATCH][crypto-next] crypto: tcrypt: fix spelling mistake: "bufufer"-> "buffer"
Date: Tue,  2 Jan 2018 09:21:06 +0000
Message-ID: <20180102092106.7726-1-colin.king@canonical.com>
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

Trivial fix to spelling mistakes in pr_err error message text.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 58e3344d7169..f61d2f40dd90 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -328,7 +328,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 		b_size = aead_sizes;
 		do {
 			if (*b_size + authsize > XBUFSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for bufufer (%lu)\n",
+				pr_err("template (%u) too big for buffer (%lu)\n",
 				       authsize + *b_size,
 				       XBUFSIZE * PAGE_SIZE);
 				goto out;
@@ -1269,7 +1269,7 @@ static void test_mb_skcipher_speed(const char *algo, int enc, int secs,
 		b_size = block_sizes;
 		do {
 			if (*b_size > XBUFSIZE * PAGE_SIZE) {
-				pr_err("template (%u) too big for bufufer (%lu)\n",
+				pr_err("template (%u) too big for buffer (%lu)\n",
 				       *b_size, XBUFSIZE * PAGE_SIZE);
 				goto out;
 			}
-- 
2.14.1
