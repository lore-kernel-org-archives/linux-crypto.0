Return-Path: <SRS0=ISqn=SC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A633BC10F11
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6999D218EA
	for <linux-crypto@archiver.kernel.org>; Sun, 31 Mar 2019 20:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554062759;
	bh=oiJtI/vzhoQ2z6I52ETOoP3bk0zEtj6TBXP0pN3BiPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=FY5ehSoraBox5PnEzlGLutPsHoh0gxU1vW2D0u8aL8wpeTGgUzsA5kbxcLr4FpYfa
	 OtYAxI7UU9bc9yWS9mJZtN9Puj+o1tay2GoYiGTp5F/qDd5et8FfDcp9L8YDwf1J1/
	 qT8AHjmkYNo5cmIENhV6VCsENbCtCx9Pau0piCGk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731447AbfCaUF6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:42108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731347AbfCaUF6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 Mar 2019 16:05:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4628321874;
        Sun, 31 Mar 2019 20:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554062757;
        bh=oiJtI/vzhoQ2z6I52ETOoP3bk0zEtj6TBXP0pN3BiPM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwczQC+ZUtkbeDhuD+gRsmuOVHdshXtLMpWn17sxOgNdsoV7IiZZEHaCZobmPRWlm
         KUKBAEYYWmZ07HG6Wxe0SfcK3Hx5UQLIEWqY3Yy7Ycc7bvXHq+p0nPV4jV9C77CsAO
         PkiBm8MJYhylOfF80AJVMdtlYtxzzV30NwkBM6Pg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [RFC/RFT PATCH 05/18] crypto: skcipher - don't WARN on unprocessed data after slow walk step
Date:   Sun, 31 Mar 2019 13:04:15 -0700
Message-Id: <20190331200428.26597-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190331200428.26597-1-ebiggers@kernel.org>
References: <20190331200428.26597-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

skcipher_walk_done() assumes it's a bug if, after the "slow" path is
executed where the next chunk of data is processed via a bounce buffer,
the algorithm says it didn't process all bytes.  Thus it WARNs on this.

However, this can happen legitimately when the message needs to be
evenly divisible into "blocks" but isn't, and the algorithm has a
'walksize' greater than the block size.  For example, ecb-aes-neonbs
sets 'walksize' to 128 bytes and only supports messages evenly divisible
into 16-byte blocks.  If, say, 17 message bytes remain but they straddle
scatterlist elements, the skcipher_walk code will take the "slow" path
and pass the algorithm all 17 bytes in the bounce buffer.  But the
algorithm will only be able to process 16 bytes, triggering the WARN.

Fix this by just removing the WARN_ON().  Returning -EINVAL, as the code
already does, is the right behavior.

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.

Fixes: b286d8b1a690 ("crypto: skcipher - Add skcipher walk interface")
Cc: <stable@vger.kernel.org> # v4.10+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/skcipher.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/crypto/skcipher.c b/crypto/skcipher.c
index 0f639f018047d..85836be4f274f 100644
--- a/crypto/skcipher.c
+++ b/crypto/skcipher.c
@@ -131,8 +131,13 @@ int skcipher_walk_done(struct skcipher_walk *walk, int err)
 		memcpy(walk->dst.virt.addr, walk->page, n);
 		skcipher_unmap_dst(walk);
 	} else if (unlikely(walk->flags & SKCIPHER_WALK_SLOW)) {
-		if (WARN_ON(err)) {
-			/* unexpected case; didn't process all bytes */
+		if (err) {
+			/*
+			 * Didn't process all bytes.  Either the algorithm is
+			 * broken, or this was the last step and it turned out
+			 * the message wasn't evenly divisible into blocks but
+			 * the algorithm requires it.
+			 */
 			err = -EINVAL;
 			goto finish;
 		}
-- 
2.21.0

