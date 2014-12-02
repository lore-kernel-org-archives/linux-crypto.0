From: "George Spelvin" <linux@horizon.com>
Subject: [PATCH 14/17] crypto: ansi_cprng - If DT is omitted, don't buffer old output
Date: 2 Dec 2014 03:58:03 -0500
Message-ID: <20141202085803.19513.qmail@ns.horizon.com>
References: <20141202083314.17647.qmail@ns.horizon.com>
Cc: linux-crypto@vger.kernel.org, linux@horizon.com,
	smueller@chronox.de
To: herbert@gondor.apana.org.au, nhorman@tuxdriver.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns.horizon.com ([71.41.210.147]:41683 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751454AbaLBI6E (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 2 Dec 2014 03:58:04 -0500
In-Reply-To: <20141202083314.17647.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This is a separate patch so it may be considered separately.
I think it's in the spirit of the original ANSI specs, but opinions
are solicited.

Signed-off-by: George Spelvin <linux@horizon.com>
---
 crypto/ansi_cprng.c | 9 +++++++++
 1 file changed, 9 insertions(+)

I'm really not sure what people will think of this.

diff --git a/crypto/ansi_cprng.c b/crypto/ansi_cprng.c
index c2c285f3..4ed7c0cf 100644
--- a/crypto/ansi_cprng.c
+++ b/crypto/ansi_cprng.c
@@ -213,6 +213,15 @@ static int get_prng_bytes(unsigned char *buf, unsigned int nbytes,
 	len = nbytes - pos;
 	memcpy(buf + pos, ctx->rand_data.bytes + read_pos, len);
 	read_pos += len;
+	/*
+	 * If not in deterministic mode, never buffer old entropy;
+	 * re-seed on each read request.  This is in the spirit of the
+	 * specifications, which are themselves not clear on the subject
+	 * of multiple requests for output over a period of time.
+	 */
+	if (!(ctx->flags & PRNG_DETERMINISTIC))
+		read_pos = DEFAULT_BLK_SZ;
+
 	memzero_explicit(ctx->rand_data.bytes, read_pos);
 	ctx->rand_read_pos = read_pos;
 	err = nbytes;
-- 
2.1.3
