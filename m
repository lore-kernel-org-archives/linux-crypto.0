Return-Path: <SRS0=xGgh=RN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849F7C43381
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4949E20657
	for <linux-crypto@archiver.kernel.org>; Sun, 10 Mar 2019 19:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552244533;
	bh=oJsb/MA/0e3ovjL816nRQmBJSWow4UBdaKg1NInXUOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mxIyOOhhulXGxbrZe0dliLvE/5/xYUN09Q+KrP1AHpTSjg8aKepudQqoCwF8abB2A
	 VFkq8tpbJ1sA1jrUnNpJaqakSxSPJ/J1cxMJadmhtZwI7d2/eL04gSCiSPrRlKZ65f
	 AEjIIRBN2ckX5vK5G0mBAJMNv5QaAz5H6ZWX3G58=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726505AbfCJTCM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 10 Mar 2019 15:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726789AbfCJTCM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 10 Mar 2019 15:02:12 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FA7420883;
        Sun, 10 Mar 2019 19:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552244531;
        bh=oJsb/MA/0e3ovjL816nRQmBJSWow4UBdaKg1NInXUOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xp1yU/F596JUartuvhsej2hr3VpcDezHIsHO0GJnBj/4BF9eYzU4Q8Utjk/F7LvSh
         uEh+CJVZSWwmBlS+Cc2+kM24GmQ/+kJJi9AtZl/atQrSDKMrm4ma/Y5SWMNp/1IrfO
         0lfqpeHSCh2Mf4Kj2cYv9FbnH2kQ9Qm7xCZd8Uls=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH 9/9] crypto: testmgr - remove workaround for AEADs that modify aead_request
Date:   Sun, 10 Mar 2019 12:00:58 -0700
Message-Id: <20190310190058.4912-10-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190310190058.4912-1-ebiggers@kernel.org>
References: <20190310190058.4912-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all AEAD algorithms (that I have the hardware to test, at
least) have been fixed to not modify the user-provided aead_request,
remove the workaround from testmgr that reset aead_request::tfm after
each AEAD encryption/decryption.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 8386038d67c7..5d56b2990762 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1237,9 +1237,6 @@ static int test_aead_vec_cfg(const char *driver, int enc,
 	aead_request_set_ad(req, vec->alen);
 	err = crypto_wait_req(enc ? crypto_aead_encrypt(req) :
 			      crypto_aead_decrypt(req), &wait);
-
-	aead_request_set_tfm(req, tfm); /* TODO: get rid of this */
-
 	if (err) {
 		if (err == -EBADMSG && vec->novrfy)
 			return 0;
-- 
2.21.0

