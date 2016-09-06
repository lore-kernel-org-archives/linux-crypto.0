From: Colin King <colin.king@canonical.com>
Subject: [PATCH][V2] s390/crypto: initialize ret to nbytes to avoid returning garbage value
Date: Tue,  6 Sep 2016 08:25:13 +0100
Message-ID: <20160906072513.7210-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43728 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932140AbcIFH0n (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Sep 2016 03:26:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Static analysis with cppcheck detected that ret is not initialized
and hence garbage is potentially being returned in the case where
prng_data->ppnows.reseed_counter <= prng_reseed_limit.

Thanks to Martin Schwidefsky for spotting a mistake in my original
fix.

Fixes: 0177db01adf26cf9 ("s390/crypto: simplify return code handling")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 arch/s390/crypto/prng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/crypto/prng.c b/arch/s390/crypto/prng.c
index 79e3a1f..5592df9 100644
--- a/arch/s390/crypto/prng.c
+++ b/arch/s390/crypto/prng.c
@@ -412,7 +412,7 @@ static int prng_sha512_reseed(void)
 
 static int prng_sha512_generate(u8 *buf, size_t nbytes)
 {
-	int ret;
+	int ret = nbytes;
 
 	/* reseed needed ? */
 	if (prng_data->ppnows.reseed_counter > prng_reseed_limit) {
-- 
2.9.3
