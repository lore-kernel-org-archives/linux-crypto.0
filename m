Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19FB9C433DF
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:18:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E14122078D
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 10:18:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="DJlN6hfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGJKSs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 06:18:48 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.54]:30721 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727865AbgGJKSr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 06:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1594376326;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=cqSabZtTyfR2LRXbEBKc1H6eXQPJIyQnzA6xyO6VggU=;
        b=DJlN6hfqWkZt1d/CTWvUbj6P29UvnijMl79S4eF/iTwP+XKz6nqSqWZYLNNAaIa+IR
        zktCPCwFJQoGD+7sHzjMzL4lGyOLeuqG29+EE9sx2SXIyoAwoEhLnGlmDSGF65y4yE0i
        Kc2sNEAYNwQMc7e0rHsWkmCk7AZUHvFBuei1JwYtZVLmgKn86p8wS+W79UFvccKGs+a5
        KzSap9arOrrKufWnFLXwcDon7LpRzt0sJ/hDX9GPLLmDIunfTmS1DVv3ms0JGwDoedQZ
        FOphQVi0cr+5mxWhZbKZ59i780PjeU5cj968YRysAwFrp3BiYutyDc3RGrbNOWrpNFhM
        yQ2g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaIvSfHReW"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.10.5 DYNA|AUTH)
        with ESMTPSA id y0546bw6AAGEZsi
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 10 Jul 2020 12:16:14 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH 1/3] crypto: ECDH - check validity of Z before export
Date:   Fri, 10 Jul 2020 12:10:07 +0200
Message-ID: <5377091.DvuYhMxLoT@positron.chronox.de>
In-Reply-To: <2543601.mvXUDI8C0e@positron.chronox.de>
References: <2543601.mvXUDI8C0e@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From 5385865b3f44d331f91c6786a2e7f4e2fb4d8cb2 Mon Sep 17 00:00:00 2001
From: Stephan Mueller <stephan.mueller@atsec.com>
Date: Thu, 11 Jun 2020 08:12:54 +0200
Subject: 

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




