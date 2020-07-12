Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0D96C433ED
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 911F0206B6
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:42:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="DiVl2HuH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729149AbgGLQmn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 12:42:43 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:25373 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729142AbgGLQmm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 12:42:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594572159;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=UdqE2yyMuqu8pjiaAGy1WgT6x0xXfxD6YjlMnjBJm3s=;
        b=DiVl2HuHrkfK9Vi4sUBTbjXvBGMFly4amAMizRNRy7/+bm0Kyv+quM/MUo1wLcC/T1
        fDmIq7GxSTEyI1vZxJqIZe2hLlmxzdz07nER0r3wXI/fb5bzZaCrxXFeS0fC6ftqy4In
        uChX2pIFapkMq51tGIHt/apqrzfuueT9Juirb7+xkryuDLzLB0sTHbckHjgpdsrFJNDf
        Wa0JLOuOWK8oQIXxt2dfzst7U0EgL6NEbfb78GDsv64Gw4MHpgv3RTXuevpBnaDvM7Iu
        SjvC1WeHKpQIt/U/cggiChhRLMHvcoWcULnb1UasG5XYRPV9JoTOZ9TKqtiUK2xD5aR5
        uZYA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6CGgLieF
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 12 Jul 2020 18:42:21 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v2 3/5] crypto: DH - check validity of Z before export
Date:   Sun, 12 Jul 2020 18:40:20 +0200
Message-ID: <2134009.irdbgypaU6@positron.chronox.de>
In-Reply-To: <5722559.lOV4Wx5bFT@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SP800-56A rev3 section 5.7.1.1 step 2 mandates that the validity of the
calculated shared secret is verified before the data is returned to the
caller. This patch adds the validation check.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/dh.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/crypto/dh.c b/crypto/dh.c
index 566f624a2de2..f84fd50ec79b 100644
--- a/crypto/dh.c
+++ b/crypto/dh.c
@@ -9,6 +9,7 @@
 #include <crypto/internal/kpp.h>
 #include <crypto/kpp.h>
 #include <crypto/dh.h>
+#include <linux/fips.h>
 #include <linux/mpi.h>
 
 struct dh_ctx {
@@ -179,6 +180,34 @@ static int dh_compute_value(struct kpp_request *req)
 	if (ret)
 		goto err_free_base;
 
+	/* SP800-56A rev3 5.7.1.1 check: Validation of shared secret */
+	if (fips_enabled && req->src) {
+		MPI pone;
+
+		/* z <= 1 */
+		if (mpi_cmp_ui(val, 1) < 1) {
+			ret = -EBADMSG;
+			goto err_free_base;
+		}
+
+		/* z == p - 1 */
+		pone = mpi_alloc(0);
+
+		if (!pone) {
+			ret = -ENOMEM;
+			goto err_free_base;
+		}
+
+		ret = mpi_sub_ui(pone, ctx->p, 1);
+		if (!ret && !mpi_cmp(pone, val))
+			ret = -EBADMSG;
+
+		mpi_free(pone);
+
+		if (ret)
+			goto err_free_base;
+	}
+
 	ret = mpi_write_to_sgl(val, req->dst, req->dst_len, &sign);
 	if (ret)
 		goto err_free_base;
-- 
2.26.2




