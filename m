Return-Path: <SRS0=9w58=AX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 575CFC4345E
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AAFA2070B
	for <linux-crypto@archiver.kernel.org>; Sun, 12 Jul 2020 16:43:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="DiXKWEB3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729180AbgGLQnD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 Jul 2020 12:43:03 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:15814 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgGLQnC (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 Jul 2020 12:43:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594572180;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=rt6PTRApr0yAQz5sJ1wzaRBKf0EMTUCrILlJclvyH1Y=;
        b=DiXKWEB3uob6Mn4+k+FyBcpiKpUJ9L3P375SJ9jLuEpSwG2a6czPoXvklxH+SZ0kOw
        RfEMddBMLyd/vJ838ffOLu654Z9CYkYbLHOfkywEjJOelFYOB69QqS6e5yEjCZsVHeT1
        c1qB2225MuwtzNmL+Qylk5XQ3slQclchHLb8BjN4d54S2g44Z+nf4zBPWTCpfSFPsNqr
        NjN5fSeGV43pzqptmVlpJRrhYHW/gm2J8ei2yo/szFoMARKaovycK3nNYWzq/jfMzePa
        3CdWd6/4EdxxD4Ruv0rrQZKXJgimSTsrd96GBdJT6xhpy7QY07IAt+4v9vNcs6fG61Ja
        UWkQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6CGgMieH
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 12 Jul 2020 18:42:22 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: [PATCH v2 1/5] crypto: ECDH - check validity of Z before export
Date:   Sun, 12 Jul 2020 18:39:26 +0200
Message-ID: <4348752.LvFx2qVVIh@positron.chronox.de>
In-Reply-To: <5722559.lOV4Wx5bFT@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de> <5722559.lOV4Wx5bFT@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

SP800-56A rev3 section 5.7.1.2 step 2 mandates that the validity of the
calculated shared secret is verified before the data is returned to the
caller. Thus, the export function and the validity check functions are
reversed. In addition, the sensitive variables of priv and rand_z are
zeroized.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/ecc.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/ecc.c b/crypto/ecc.c
index 02d35be7702b..52e2d49262f2 100644
--- a/crypto/ecc.c
+++ b/crypto/ecc.c
@@ -1495,11 +1495,16 @@ int crypto_ecdh_shared_secret(unsigned int curve_id, unsigned int ndigits,
 
 	ecc_point_mult(product, pk, priv, rand_z, curve, ndigits);
 
-	ecc_swap_digits(product->x, secret, ndigits);
-
-	if (ecc_point_is_zero(product))
+	if (ecc_point_is_zero(product)) {
 		ret = -EFAULT;
+		goto err_validity;
+	}
+
+	ecc_swap_digits(product->x, secret, ndigits);
 
+err_validity:
+	memzero_explicit(priv, sizeof(priv));
+	memzero_explicit(rand_z, sizeof(rand_z));
 	ecc_free_point(product);
 err_alloc_product:
 	ecc_free_point(pk);
-- 
2.26.2




