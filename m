Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC4C0C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A28CA20869
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007594;
	bh=JEDgNap+M+5drnhJ5E+K09EJAdXkerThpeRFd4qRo+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XNkzF1acMeL12zLo1lRRiIyqyhcfLurG5317cPmMnQ2N4mLOQg84DWGk9ESqP/Av4
	 66fJ2eHd7lWSrt1IlAb8yBRJ63tTR0pKL55YvKtAeEgJDnwA39c42jF+o5jtZVE8T0
	 lcxsd75X6Oa2FKAnTDjUqWifAzLtdO3h2Ve8mODY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728577AbfBAHxN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:53:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:36684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfBAHwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2270E218A6;
        Fri,  1 Feb 2019 07:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007522;
        bh=JEDgNap+M+5drnhJ5E+K09EJAdXkerThpeRFd4qRo+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/LTj55e25jfjbJz6KIHdDI5+GxHXEMGIzFwjqpYYCPTL3/4brJEN8Q5rcsm0A5Ap
         ohFXc6NuoTWZQ0CzuOPI43JkQNMcXxzrXktPppz90of7n8waqZlc/DKpWhfVa7x2Hd
         Vw90V+1rHJPtrHOTfYxKHLwEyqKWT/sbAz8DYg5s=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH v2 06/15] crypto: ahash - fix another early termination in hash walk
Date:   Thu, 31 Jan 2019 23:51:41 -0800
Message-Id: <20190201075150.18644-7-ebiggers@kernel.org>
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
index ca0d3e281fefb..81e2767e2164e 100644
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
2.20.1

