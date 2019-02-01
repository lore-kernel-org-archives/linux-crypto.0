Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2B42C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A219A20869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007566;
	bh=Glt39bQzAXimhbOQxMAzQjQBs87Fs4F8cA+zWGc+30E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=I0F3MMPxfDkKjvmk4HbOpQ0vnLD896RwJySajQt+yVnVtLbAVV0lkvl5glxGZFxhJ
	 3IfukXsMZBGaVc3Xb7tDU7ki50A73Dg3QNIKxcCX1SzmnguArxcskyy/LLDD+oEy0M
	 c5i/e1Gg2PtAZy88B13gEdrAHTvrXN6KoXQzJ7ck=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727366AbfBAHwd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726979AbfBAHwF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:05 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EFFE218FD;
        Fri,  1 Feb 2019 07:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007524;
        bh=Glt39bQzAXimhbOQxMAzQjQBs87Fs4F8cA+zWGc+30E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M9Z4sl3usb52Oz1SmbRahOFkIbayYHV3DK7wnEEegYY5Hsli8nY78MH9bazPDBo6I
         NCY9lF6ZKSDpGNUcidZVpS/0k9H3m84+ZKEq7z8dTW9GBvjyY/17KHLctYd5ljCL+g
         Jy45HKsg5YKD1sWuq3fOjQtsoOtNux/3lOOey9kI=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org
Subject: [PATCH v2 14/15] crypto: testmgr - check for skcipher_request corruption
Date:   Thu, 31 Jan 2019 23:51:49 -0800
Message-Id: <20190201075150.18644-15-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190201075150.18644-1-ebiggers@kernel.org>
References: <20190201075150.18644-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Check that algorithms do not change the skcipher_request structure, as
users may rely on submitting the request again (e.g. after copying new
data into the same source buffer) without reinitializing everything.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 96aa268ff4184..c4ee453e8bf53 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1535,6 +1535,47 @@ static int test_skcipher_vec_cfg(const char *driver, int enc,
 		return err;
 	}
 
+	/* Check that the algorithm didn't overwrite things it shouldn't have */
+	if (req->cryptlen != vec->len ||
+	    req->iv != iv ||
+	    req->src != tsgls->src.sgl_ptr ||
+	    req->dst != tsgls->dst.sgl_ptr ||
+	    crypto_skcipher_reqtfm(req) != tfm ||
+	    req->base.complete != crypto_req_done ||
+	    req->base.flags != req_flags ||
+	    req->base.data != &wait) {
+		pr_err("alg: skcipher: %s %s corrupted request struct on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		if (req->cryptlen != vec->len)
+			pr_err("alg: skcipher: changed 'req->cryptlen'\n");
+		if (req->iv != iv)
+			pr_err("alg: skcipher: changed 'req->iv'\n");
+		if (req->src != tsgls->src.sgl_ptr)
+			pr_err("alg: skcipher: changed 'req->src'\n");
+		if (req->dst != tsgls->dst.sgl_ptr)
+			pr_err("alg: skcipher: changed 'req->dst'\n");
+		if (crypto_skcipher_reqtfm(req) != tfm)
+			pr_err("alg: skcipher: changed 'req->base.tfm'\n");
+		if (req->base.complete != crypto_req_done)
+			pr_err("alg: skcipher: changed 'req->base.complete'\n");
+		if (req->base.flags != req_flags)
+			pr_err("alg: skcipher: changed 'req->base.flags'\n");
+		if (req->base.data != &wait)
+			pr_err("alg: skcipher: changed 'req->base.data'\n");
+		return -EINVAL;
+	}
+	if (is_test_sglist_corrupted(&tsgls->src)) {
+		pr_err("alg: skcipher: %s %s corrupted src sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+	if (tsgls->dst.sgl_ptr != tsgls->src.sgl &&
+	    is_test_sglist_corrupted(&tsgls->dst)) {
+		pr_err("alg: skcipher: %s %s corrupted dst sgl on test vector %u, cfg=\"%s\"\n",
+		       driver, op, vec_num, cfg->name);
+		return -EINVAL;
+	}
+
 	/* Check for the correct output (ciphertext or plaintext) */
 	err = verify_correct_output(&tsgls->dst, enc ? vec->ctext : vec->ptext,
 				    vec->len, 0, true);
-- 
2.20.1

