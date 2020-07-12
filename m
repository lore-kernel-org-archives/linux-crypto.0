Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C4FEC43457
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3E109206B6
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="A7MbIWRE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGLQmw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 12:42:52 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:12594 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729168AbgGLQmv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 12:42:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594572168;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=b7bU1Z2NU1Fjnn9Gwf8ukY6zFeFi2K+RYtu2EPvVLIE=;
        b=A7MbIWREf0OHO4uyLV9a7HU2mfHOMJeAC0/H8TKigS1f2iVxZ4yn6RpBeETLyYBGZu
        Ok8xLk6rt7DRSSzm/q0NS3gE6Gw54RA9t5m6PHPeyePOwIo1e/5nDXm3I6WKrxq8zxq0
        1yQ/oAdQyIuZ1PMM18mO8IE4Q0ic/TiSMJUswnktsuburQcSyhKCTl826k6lR2L4FYwK
        +8HE7GfHYDi7NLCXCQRQV7LkipssGji4JRdriiOI/y10zrvp5eUNs3bguC94bGtkARMp
        vrba9vnKEujYVn0nUDRmfG9TkKBK09Wn8CkyLnoDLC9kJGnWq21q7pJvAJwGbBiDfamK
        ktWw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6CGgKieE
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 12 Jul 2020 18:42:20 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v2 4/5] crypto: DH SP800-56A rev 3 local public key validation
Date:   Sun, 12 Jul 2020 18:40:57 +0200
Message-ID: <2833634.e9J7NaK4W3@positron.chronox.de>
In-Reply-To: <5722559.lOV4Wx5bFT@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

After the generation of a local public key, SP800-56A rev 3 section
5.6.2.1.3 mandates a validation of that key with a full validation
compliant to section 5.6.2.3.1.

Only if the full validation passes, the key is allowed to be used.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/dh.c | 59 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/crypto/dh.c b/crypto/dh.c
index f84fd50ec79b..cd4f32092e5c 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -180,32 +180,41 @@ static int dh_compute_value(struct kpp_request *req)
 	if (ret)
 		goto err_free_base;
 
-	/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
-	if (fips_enabled && req->src) {
-		MPI pone;
-
-		/* z <= 1 */
-		if (mpi_cmp_ui(val, 1) < 1) {
-			ret = -EBADMSG;
-			goto err_free_base;
-		}
-
-		/* z == p - 1 */
-		pone = mpi_alloc(0);
-
-		if (!pone) {
-			ret = -ENOMEM;
-			goto err_free_base;
+	if (fips_enabled) {
+		/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
+		if (req->src) {
+			MPI pone;
+
+			/* z <= 1 */
+			if (mpi_cmp_ui(val, 1) < 1) {
+				ret = -EBADMSG;
+				goto err_free_base;
+			}
+
+			/* z == p - 1 */
+			pone = mpi_alloc(0);
+
+			if (!pone) {
+				ret = -ENOMEM;
+				goto err_free_base;
+			}
+
+			ret = mpi_sub_ui(pone, ctx->p, 1);
+			if (!ret && !mpi_cmp(pone, val))
+				ret = -EBADMSG;
+
+			mpi_free(pone);
+
+			if (ret)
+				goto err_free_base;
+
+		/* SP800-56A rev 3 5.6.2.1.3 key check */
+		} else {
+			if (dh_is_pubkey_valid(ctx, val)) {
+				ret = -EAGAIN;
+				goto err_free_val;
+			}
 		}
-
-		ret = mpi_sub_ui(pone, ctx->p, 1);
-		if (!ret && !mpi_cmp(pone, val))
-			ret = -EBADMSG;
-
-		mpi_free(pone);
-
-		if (ret)
-			goto err_free_base;
 	}
 
 	ret = mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
-- 
2.26.2




