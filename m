Return-Path: <SRS0=I8vn=P7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6C0C282C0
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:54:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8998E2184C
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Jan 2019 22:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548284042;
	bh=qva0Xse0lWrH/U7mmCUyYmvv8J/PRs6KvA4e7PG1R0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hSKm8OfV9/XmtRp0V3sgTT7Wgwp112oHJmDOmbTROfQ6UlIoyLXGKvEfmhrBwwgWc
	 QLx3IpNG3iWs6f9iNAu9ascjHmspPub8G6YcMJr/plWiaZkvbgroTNxqcdSJP6rolK
	 IfP8C/1oG2BIiMnmOhIkOj9PGdeXhuxGK1ezdHJ8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727474AbfAWWxw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Jan 2019 17:53:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726517AbfAWWwd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Jan 2019 17:52:33 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A714F218A6;
        Wed, 23 Jan 2019 22:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548283952;
        bh=qva0Xse0lWrH/U7mmCUyYmvv8J/PRs6KvA4e7PG1R0M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lLThBtyVs0g+kn83jridOI8C6OpSRnlCF+nqEV89ieyg7OqA1JSASzZyxe9w8flVJ
         z0ikscS8KN8vGvthn4FtAYhnXxNNFl2JOGPHO/NYQHgsHRUzUpjzc7ouM0iJBhMu4X
         PfulvRVW393pkJljPQpYPo8JDScWi9jjIivVkqLg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        Dave Watson <davejwatson@fb.com>
Subject: [RFC/RFT PATCH 05/15] crypto: x86/aesni-gcm - fix crash on empty plaintext
Date:   Wed, 23 Jan 2019 14:49:16 -0800
Message-Id: <20190123224926.250525-6-ebiggers@kernel.org>
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

gcmaes_crypt_by_sg() dereferences the NULL pointer returned by
scatterwalk_ffwd() when encrypting an empty plaintext and the source
scatterlist ends immediately after the associated data.

Fix it by only fast-forwarding to the src/dst data scatterlists if the
data length is nonzero.

This bug is reproduced by the "rfc4543(gcm(aes))" test vectors when run
with the new AEAD test manager.

Fixes: e845520707f8 ("crypto: aesni - Update aesni-intel_glue to use scatter/gather")
Cc: <stable@vger.kernel.org> # v4.17+
Cc: Dave Watson <davejwatson@fb.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/x86/crypto/aesni-intel_glue.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
index 9b5ccde3ef31..1e3d2102033a 100644
--- a/arch/x86/crypto/aesni-intel_glue.c
+++ b/arch/x86/crypto/aesni-intel_glue.c
@@ -813,11 +813,14 @@ static int gcmaes_crypt_by_sg(bool enc, struct aead_request *req,
 		scatterwalk_map_and_copy(assoc, req->src, 0, assoclen, 0);
 	}
 
-	src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
-	scatterwalk_start(&src_sg_walk, src_sg);
-	if (req->src != req->dst) {
-		dst_sg = scatterwalk_ffwd(dst_start, req->dst, req->assoclen);
-		scatterwalk_start(&dst_sg_walk, dst_sg);
+	if (left) {
+		src_sg = scatterwalk_ffwd(src_start, req->src, req->assoclen);
+		scatterwalk_start(&src_sg_walk, src_sg);
+		if (req->src != req->dst) {
+			dst_sg = scatterwalk_ffwd(dst_start, req->dst,
+						  req->assoclen);
+			scatterwalk_start(&dst_sg_walk, dst_sg);
+		}
 	}
 
 	kernel_fpu_begin();
-- 
2.20.1.321.g9e740568ce-goog

