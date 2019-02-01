Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94AB6C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 63FEE218AC
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 07:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549007526;
	bh=FnVYn8qF0+QeyMw1S+mh+0ro1ICT8cNf+QV/Kcx1Q2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=feY/sia8RC+3uNedFIz9W/0wBQqNR0XWkzgyw+BxhUh6/L9V6wvUozgDOwDQHxaLp
	 NkK9SDfeEDz/VLX2UB/ac7BrcjiXL3TiyhD1Iq8EknRjtKa94kxAviLmJ2w00BoMSE
	 u6+LUUe+nsVzGkIZR+U3xYmZWIIsaf7hI7GUries=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727035AbfBAHwF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 02:52:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:36676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725831AbfBAHwD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 02:52:03 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8A98218AC;
        Fri,  1 Feb 2019 07:52:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549007522;
        bh=FnVYn8qF0+QeyMw1S+mh+0ro1ICT8cNf+QV/Kcx1Q2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iNI3qUfiis0BVxEwUzdJNCHR0eDt/sHOPlPwV1ZjLl+ysEXS4G4Vm5VSBv30CaYOZ
         rDcOpktSIpU9IF+NJ2AABTJmiLDMc/PT081mOIR+PDJscWOYukPeR4YhZf10ixR6i2
         YFAUT8eTM9mg9cdTeASDzo5YNwDeaImKCKn4/Axk=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dave Watson <davejwatson@fb.com>
Subject: [PATCH v2 05/15] crypto: x86/aesni-gcm - fix crash on empty plaintext
Date:   Thu, 31 Jan 2019 23:51:40 -0800
Message-Id: <20190201075150.18644-6-ebiggers@kernel.org>
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
index 9b5ccde3ef315..1e3d2102033a0 100644
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
2.20.1

