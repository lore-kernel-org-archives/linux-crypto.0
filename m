Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DB4C10F14
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6AE0B217D6
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878928;
	bh=VEYDOmBBHr97pWKSFhOopAvxRZYpAtM8mBU2YLJICzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=tKEy4AV8EKsIvqiLSmXxGsKpSwWjVoQuXGGtZ7bHWYonH9oqe+06gwAMp9vzW2ojW
	 M1ro6MDJP915eiuoAGMtHTg2I/apzk0bQ6zZMsT8D8hKtl1rq/ixTfxWGpuWROElem
	 LVSvaIXP9iDSYACF7dMSUixktBRheOXVfrIONwFU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbfDJGsr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728706AbfDJGsq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:46 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FC1E217D6;
        Wed, 10 Apr 2019 06:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878926;
        bh=VEYDOmBBHr97pWKSFhOopAvxRZYpAtM8mBU2YLJICzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzKSIG8BmDrUQwhxPwDOj3Cb2wwIAP63OyFmJ3ibOvuBUIN/MS0KSowGUy9UVTdWi
         11IbSZwrG9mPiDpeLmpcFugwoVzyl5tReEJlvyWHhIokglh7q+mCki5/AEVGxua4WB
         jwhTfgyvDCP6MmTBN6t9HUh/uNdcJiPNal2TVbQ8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>
Subject: [PATCH v2 1/7] crypto: lrw - don't access already-freed walk.iv
Date:   Tue,  9 Apr 2019 23:46:29 -0700
Message-Id: <20190410064635.11813-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190410064635.11813-1-ebiggers@kernel.org>
References: <20190410064635.11813-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If the user-provided IV needs to be aligned to the algorithm's
alignmask, then skcipher_walk_virt() copies the IV into a new aligned
buffer walk.iv.  But skcipher_walk_virt() can fail afterwards, and then
if the caller unconditionally accesses walk.iv, it's a use-after-free.

Fix this in the LRW template by checking the return value of
skcipher_walk_virt().

This bug was detected by my patches that improve testmgr to fuzz
algorithms against their generic implementation.  When the extra
self-tests were run on a KASAN-enabled kernel, a KASAN use-after-free
splat occured during lrw(aes) testing.

Fixes: c778f96bf347 ("crypto: lrw - Optimize tweak computation")
Cc: <stable@vger.kernel.org> # v4.20+
Cc: Ondrej Mosnacek <omosnace@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/lrw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/crypto/lrw.c b/crypto/lrw.c
index 0430ccd087286..b6666c595a686 100644
--- a/crypto/lrw.c
+++ b/crypto/lrw.c
@@ -162,8 +162,10 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 	}
 
 	err = skcipher_walk_virt(&w, req, false);
-	iv = (__be32 *)w.iv;
+	if (err)
+		return err;
 
+	iv = (__be32 *)w.iv;
 	counter[0] = be32_to_cpu(iv[3]);
 	counter[1] = be32_to_cpu(iv[2]);
 	counter[2] = be32_to_cpu(iv[1]);
-- 
2.21.0

