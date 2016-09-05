From: Colin King <colin.king@canonical.com>
Subject: [PATCH] s390/crypto: initialize ret to zero to avoid returning garbage value
Date: Mon,  5 Sep 2016 17:21:18 +0100
Message-ID: <20160905162118.16510-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

static analysis with cppcheck detected that ret is not initialized
and hence garbage is potentially being returned in the case where
prng_data->ppnows.reseed_counter <= prng_reseed_limit.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/s390/crypto/prng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 79e3a1f..a21fdf4 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -412,7 +412,7 @@ static int prng_sha512_reseed(void)
 
 static int prng_sha512_generate(u8 *buf, size_t nbytes)
 {
-	int ret;
+	int ret = 0;
 
 	/* reseed needed ? */
 	if (prng_data->ppnows.reseed_counter > prng_reseed_limit) {
-- 
2.9.3
