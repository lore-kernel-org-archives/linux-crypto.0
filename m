Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC03EC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:54:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAB042184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284044;
	bh=ufxoBm2hTwA/uh3MG++DT4zHTGEbfgFZcifD2C0Ye2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZH8dNQvJLMQxaw8y6YX9x6JuVFNH06XGAw2zPDmTUgQAxBc1MEhNhIObD7ZI3d9C8
	 wsUiPoEnPib1fqHCUlBCt0DPvgKc4aV0dVi3/oehietclzEMl3SHyU0t1zYlOwKXLE
	 AOreX7QioKPiccWv0oKIOeGhKdCCmWuonaTWABsk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbfAWWxw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726693AbfAWWwd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:33 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 039CE218AD;
        Wed, 23 Jan 2019 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283953;
        bh=ufxoBm2hTwA/uh3MG++DT4zHTGEbfgFZcifD2C0Ye2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yfsgeMR0HtM/jmbeXlKpSWqp47+vF9FhpxQ+JynVSTnb+6zyC9LZXH90k+MW/yYaI
         iYT4v5kYsrsEOgs4kC6k0NQP3ceQ179sBdcuMG3e99DADJmk0mQLMDxQqvBN3CQc2f
         W3o9bl6Nrhl/r8LSklURXNkeVMecgmf/YkTGWQeg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [RFC/RFT PATCH 06/15] crypto: ahash - fix another early termination in hash walk
Date:   Wed, 23 Jan 2019 14:49:17 -0800
Message-Id: <20190123224926.250525-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.20.1.321.g9e740568ce-goog
In-Reply-To: <20190123224926.250525-1-ebiggers@kernel.org>
References: <20190123224926.250525-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Hash algorithms with an alignmask set, e.g. "xcbc(aes-aesni)" and
"michael_mic", fail the improved hash tests because they sometimes
produce the wrong digest.  The bug is that in the case where a
scatterlist element crosses pages, not all the data is actually hashed
because the scatterlist walk terminates too early.  This happens because
the 'nbytes' variable in crypto_hash_walk_done() is assigned the number
of bytes remaining in the page, then later interpreted as the number of
bytes remaining in the scatterlist element.  Fix it.

Fixes: 900a081f6912 ("crypto: ahash - Fix early termination in hash walk")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/ahash.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/crypto/ahash.c b/crypto/ahash.c
index ca0d3e281fef..81e2767e2164 100644
--- a/crypto/ahash.c
+++ b/crypto/ahash.c
@@ -86,17 +86,17 @@ static int hash_walk_new_entry(struct crypto_hash_walk *walk)
 int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 {
 	unsigned int alignmask = walk->alignmask;
-	unsigned int nbytes = walk->entrylen;
 
 	walk->data -= walk->offset;
 
-	if (nbytes && walk->offset & alignmask && !err) {
-		walk->offset = ALIGN(walk->offset, alignmask + 1);
-		nbytes = min(nbytes,
-			     ((unsigned int)(PAGE_SIZE)) - walk->offset);
-		walk->entrylen -= nbytes;
+	if (walk->entrylen && (walk->offset & alignmask) && !err) {
+		unsigned int nbytes;
 
+		walk->offset = ALIGN(walk->offset, alignmask + 1);
+		nbytes = min(walk->entrylen,
+			     (unsigned int)(PAGE_SIZE - walk->offset));
 		if (nbytes) {
+			walk->entrylen -= nbytes;
 			walk->data += walk->offset;
 			return nbytes;
 		}
@@ -116,7 +116,7 @@ int crypto_hash_walk_done(struct crypto_hash_walk *walk, int err)
 	if (err)
 		return err;
 
-	if (nbytes) {
+	if (walk->entrylen) {
 		walk->offset = 0;
 		walk->pg++;
 		return hash_walk_next(walk);
-- 
2.20.1.321.g9e740568ce-goog

