Return-Path: <SRS0=lMhp=YI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9340ECE58E
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8472B21882
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Oct 2019 02:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571107544;
	bh=b9t/PEM8kykRb6AqiN9m37toQH0deHlrIEKOykM8kG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=TudDRN0JHNSuwvWeyUqqOWTwVOv5xZEwhzVD9hLBq1tHQ37gphEPSvmt6JE5u6xOK
	 WoOApdbks2e52G/OjdmvIlYJWtj+r7QBdXoQQuSUPEyTrcm2NnIACY9Jcd4YcSx/jA
	 YJGM1Pe/AsQgOYJ0S7AusP1hxdjUWPTtrQLQpHa0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfJOCpn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Oct 2019 22:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727212AbfJOCpn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Oct 2019 22:45:43 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6091321835;
        Tue, 15 Oct 2019 02:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571107542;
        bh=b9t/PEM8kykRb6AqiN9m37toQH0deHlrIEKOykM8kG4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rc211AtRPSUzku8e49PNFzwwot4Tm23WfXUPJzqotc/sebJSCvD8cv8IGFH5JrOft
         xAIfmZEcnQRkpsVEbmRyhtgp3Wq4RB95Z3wrpxonzcmMbTH++IXaigcBhd9Fvt3g6t
         r1Wz7POUgM7vuvvLQ9y4WtvuSoAYa5FDv8iG0b/A=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Markus Stockhausen <stockhausen@collogia.de>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v2 2/3] crypto: powerpc - don't set ivsize for AES-ECB
Date:   Mon, 14 Oct 2019 19:45:16 -0700
Message-Id: <20191015024517.52790-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191015024517.52790-1-ebiggers@kernel.org>
References: <20191015024517.52790-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Set the ivsize for the "ecb-ppc-spe" algorithm to 0, since ECB mode
doesn't take an IV.

This fixes a failure in the extra crypto self-tests:

	alg: skcipher: ivsize for ecb-ppc-spe (16) doesn't match generic impl (0)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/powerpc/crypto/aes-spe-glue.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/crypto/aes-spe-glue.c b/arch/powerpc/crypto/aes-spe-glue.c
index 319f1dbb3a70..4189d2644f74 100644
--- a/arch/powerpc/crypto/aes-spe-glue.c
+++ b/arch/powerpc/crypto/aes-spe-glue.c
@@ -415,7 +415,6 @@ static struct crypto_alg aes_algs[] = { {
 		.blkcipher = {
 			.min_keysize		=	AES_MIN_KEY_SIZE,
 			.max_keysize		=	AES_MAX_KEY_SIZE,
-			.ivsize			=	AES_BLOCK_SIZE,
 			.setkey			=	ppc_aes_setkey,
 			.encrypt		=	ppc_ecb_encrypt,
 			.decrypt		=	ppc_ecb_decrypt,
-- 
2.23.0

