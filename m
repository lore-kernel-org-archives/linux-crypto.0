From: Colin King <colin.king@canonical.com>
Subject: [PATCH] crypto: tcrypt - free xoutbuf instead of axbuf
Date: Tue,  2 Jan 2018 15:43:04 +0000
Message-ID: <20180102154304.14523-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
To: Antoine Tenart <antoine.tenart@free-electrons.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There seems to be a cut-n-paste bug with the name of the buffer being
free'd, xoutbuf should be used instead of axbuf.

Detected by CoverityScan, CID#1463420 ("Copy-paste error")

Fixes: 427988d981c4 ("crypto: tcrypt - add multibuf aead speed test")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 crypto/tcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index f61d2f40dd90..14213a096fd2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -298,7 +298,7 @@ static void test_mb_aead_speed(const char *algo, int enc, int secs,
 	for (i = 0; i < num_mb; ++i)
 		if (testmgr_alloc_buf(data[i].xoutbuf)) {
 			while (i--)
-				testmgr_free_buf(data[i].axbuf);
+				testmgr_free_buf(data[i].xoutbuf);
 			goto out_free_axbuf;
 		}
 
-- 
2.14.1
