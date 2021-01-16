Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AF81C4332B
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC0B227BF
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Jan 2021 17:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbhAPRPK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:15:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727062AbhAPRPH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Jan 2021 12:15:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20ADB227C3;
        Sat, 16 Jan 2021 16:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610815695;
        bh=itBjRJc9YynZBRMLVPKWRGi6QCoBtZrcoKgfPqFoGak=;
        h=From:To:Cc:Subject:Date:From;
        b=YUFoJvkBj0mw6XD8d3Qguhaq7CRWJhqMGlE9Sx+RiYdM7Y1lL7DtO33zrJWsn1QOA
         okw4YfsraPbg7hs0jCc6BJGBvoM94uBmtLafrP12MBCUA4xmEeSDT/kxsUjIBuJE05
         5U6QyBxKLOW73R2NzhPU7Wjg31aH5YAfdg00qaARUrDr1nArO22Wum8UFyAwFHJxL2
         070FYwk3tB7xPZCUIFCmrFmc3HhCsu9KFicpGVAjaI7JWkY08INm3UG9QaESGpZ1fl
         yVb4/gUyw5L0HSDl3EoJnCTuI9RLP133OMYRSQZvu20vNVMg77jGuypCHa/A60kp68
         kHfiAuE2gq+jw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>, Megha Dey <megha.dey@intel.com>,
        Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 0/2] crypto: aesni - fix more FPU handling and indirect call issues
Date:   Sat, 16 Jan 2021 17:48:08 +0100
Message-Id: <20210116164810.21192-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

My recent patches to the AES-NI driver addressed all the instances of
indirect calls occurring in the XTS and GCM drivers, and while at it,
limited the scope of FPU enabled/preemption disabled regions not to
cover the work that goes on inside the skcipher walk API. This gets rid
of scheduling latency spikes for large skcipher/aead inputs, which are
more common these days after the introduction of s/w kTLS.

Let's address the other modes in this driver as well: ECB, CBC and CTR,
all of which currently keep the FPU enabled (and thus preemption disabled)
for the entire skcipher request, which is unnecessary, and potentially
problematic for workloads that are sensitive to scheduling latency.

Let's also switch to a static call for the CTR mode asm helper, which
gets chosen once at driver init time.

Cc: Megha Dey <megha.dey@intel.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>

Ard Biesheuvel (2):
  crypto: aesni - replace CTR function pointer with static call
  crypto: aesni - release FPU during skcipher walk API calls

 arch/x86/crypto/aesni-intel_glue.c | 78 +++++++++-----------
 1 file changed, 35 insertions(+), 43 deletions(-)

-- 
2.17.1

