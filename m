From: Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 5/6] crypto: caam: fix indentation of close braces
Date: Sun, 18 Oct 2015 17:51:31 +0100
Message-ID: <E1ZnrBD-0005nf-35@rmk-PC.arm.linux.org.uk>
References: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Victoria Milhoan <vicki.milhoan@freescale.com>,
	horia.geanta@freescale.com, fabio.estevam@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.arm.linux.org.uk ([78.32.30.218]:45373 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932081AbbJRQvm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 18 Oct 2015 12:51:42 -0400
In-Reply-To: <20151018165046.GA7997@n2100.arm.linux.org.uk>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The kernel's coding style suggests that closing braces for initialisers
should not be aligned to the open brace column.  The CodingStyle doc
shows how this should be done.  Remove the additional tab.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
---
 drivers/crypto/caam/caamhash.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/caamhash.c b/drivers/crypto/caam/caamhash.c
index 7dd80b0b3f51..f30c93840bba 100644
--- a/drivers/crypto/caam/caamhash.c
+++ b/drivers/crypto/caam/caamhash.c
@@ -1653,8 +1653,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = SHA1_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_SHA1,
 		.alg_op = OP_ALG_ALGSEL_SHA1 | OP_ALG_AAI_HMAC,
 	}, {
@@ -1675,8 +1675,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = SHA224_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_SHA224,
 		.alg_op = OP_ALG_ALGSEL_SHA224 | OP_ALG_AAI_HMAC,
 	}, {
@@ -1697,8 +1697,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = SHA256_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_SHA256,
 		.alg_op = OP_ALG_ALGSEL_SHA256 | OP_ALG_AAI_HMAC,
 	}, {
@@ -1719,8 +1719,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = SHA384_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_SHA384,
 		.alg_op = OP_ALG_ALGSEL_SHA384 | OP_ALG_AAI_HMAC,
 	}, {
@@ -1741,8 +1741,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = SHA512_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_SHA512,
 		.alg_op = OP_ALG_ALGSEL_SHA512 | OP_ALG_AAI_HMAC,
 	}, {
@@ -1763,8 +1763,8 @@ static struct caam_hash_template driver_hash[] = {
 			.halg = {
 				.digestsize = MD5_DIGEST_SIZE,
 				.statesize = sizeof(struct caam_export_state),
-				},
 			},
+		},
 		.alg_type = OP_ALG_ALGSEL_MD5,
 		.alg_op = OP_ALG_ALGSEL_MD5 | OP_ALG_AAI_HMAC,
 	},
-- 
2.1.0
