From: Jarod Wilson <jarod@redhat.com>
Subject: [PATCH] crypto: ansi_cprng: fix inverted DT increment routine
Date: Thu, 13 Nov 2008 11:36:11 -0500
Message-ID: <200811131136.15875.jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: Neil Horman <nhorman@tuxdriver.com>, herbert@gondor.apana.org.au,
	davem@davemloft.net, linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50973 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbYKMQgb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Nov 2008 11:36:31 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The ANSI X9.31 PRNG docs aren't particularly clear on how to increment DT,
but empirical testing shows we're incrementing from the wrong end. A 10,000
iteration Monte Carlo RNG test currently winds up not getting the expected
result.

>From http://csrc.nist.gov/groups/STM/cavp/documents/rng/RNGVS.pdf :

# CAVS 4.3
# ANSI931 MCT
[X9.31]
[AES 128-Key]

COUNT = 0
Key = 9f5b51200bf334b5d82be8c37255c848
DT = 6376bbe52902ba3b67c925fa701f11ac
V = 572c8e76872647977e74fbddc49501d1
R = 48e9bd0d06ee18fbe45790d5c3fc9b73

Currently, we get 0dd08496c4f7178bfa70a2161a79459a after 10000 loops.

Inverting the DT increment routine results in us obtaining the expected result
of 48e9bd0d06ee18fbe45790d5c3fc9b73. Verified on both x86_64 and ppc64.

Signed-off-by: Jarod Wilson <jarod@redhat.com>

---

 crypto/ansi_cprng.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index 486aa93..a7c703d 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -161,7 +161,7 @@ static int _get_more_prng_bytes(struct prng_context *ctx)
 	/*
 	 * Now update our DT value
 	 */
-	for (i = 0; i < DEFAULT_BLK_SZ; i++) {
+	for (i = DEFAULT_BLK_SZ - 1; i >= 0; i--) {
 		ctx->DT[i] += 1;
 		if (ctx->DT[i] != 0)
 			break;

-- 
Jarod Wilson
jarod@redhat.com

