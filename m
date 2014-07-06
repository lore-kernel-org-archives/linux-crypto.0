From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 6/6] DRBG: HMAC-SHA1 DRBG has crypto strength of 128 bits
Date: Sun, 06 Jul 2014 02:26:37 +0200
Message-ID: <2038501.NQxD5ZZc1H@myon.chronox.de>
References: <2266932.bfVPMOTOeI@myon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: joe@perches.com, dan.carpenter@oracle.com,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	fengguang.wu@intel.com, Randy Dunlap <rdunlap@infradead.org>,
	linux-crypto@vger.kernel.org, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, Rafael Aquini <aquini@redhat.com>,
	aris@redhat.com
To: herbert@gondor.apana.org.au
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <2266932.bfVPMOTOeI@myon.chronox.de>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

The patch corrects the security strength of the HMAC-SHA1 DRBG to 128
bits. This strength defines the size of the seed required for the DRBG.
Thus, the patch lowers the seeding requirement from 256 bits to 128 bits
for HMAC-SHA1.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index a76b3cb..84478cb 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -184,7 +184,7 @@ static const struct drbg_core drbg_cores[] = {
 #endif /* CONFIG_CRYPTO_DRBG_HASH */
 #ifdef CONFIG_CRYPTO_DRBG_HMAC
 	{
-		.flags = DRBG_HMAC | DRBG_STRENGTH256,
+		.flags = DRBG_HMAC | DRBG_STRENGTH128,
 		.statelen = 20, /* block length of cipher */
 		.max_addtllen = 35,
 		.max_bits = 19,
-- 
1.9.3
