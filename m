Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80232C282DE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DC7A21841
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878932;
	bh=XtbcAfD4X6f5TVPRHGxFRL2Qg/zb9DIuNRWW2Fqv5gI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=f5E2+NzqxvQFR8jIhTh4/7WskudvU0pBZCa0FBJ9l0QJJ0zVDwtRCepsekpGgcgm7
	 ffRNkOrirD5k4pG5fpLHu5WLt3f5u2jx1/+QcfQvjIw270stuW20EJGZrn4qyIxJMV
	 zL+VmHQt9HgiJr77zTPuUL7iRvcJ2AZPzY/jg+vU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728723AbfDJGsr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728710AbfDJGsr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9078217F4;
        Wed, 10 Apr 2019 06:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878926;
        bh=XtbcAfD4X6f5TVPRHGxFRL2Qg/zb9DIuNRWW2Fqv5gI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sG9VL2kR4v3cKhDbTrQmSwONlSI/BtNMHx34rN0D7Rn7wRyi+qXIEfkBU5HOGoOds
         HC1vU24W38fU4mbJjChNhQcl8ON63k+HV2yzR8r4zQ9q6ALkk3gq4YWtdP5nzOz9Wh
         mVpOn1OPqqTWplffBw0no2URkV+R3MtQVEVSL3z0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 3/7] crypto: arm/aes-neonbs - don't access already-freed walk.iv
Date:   Tue,  9 Apr 2019 23:46:31 -0700
Message-Id: <20190410064635.11813-4-ebiggers@kernel.org>
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

arm32 xts-aes-neonbs doesn't set an alignmask, so currently it isn't
affected by this despite unconditionally accessing walk.iv.  However
this is more subtle than desired, and it was actually broken prior to
the alignmask being removed by commit cc477bf64573 ("crypto: arm/aes -
replace bit-sliced OpenSSL NEON code").  Thus, update xts-aes-neonbs to
start checking the return value of skcipher_walk_virt().

Fixes: e4e7f10bfc40 ("ARM: add support for bit sliced AES using NEON instructions")
Cc: <stable@vger.kernel.org> # v3.13+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm/crypto/aes-neonbs-glue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm/crypto/aes-neonbs-glue.c b/arch/arm/crypto/aes-neonbs-glue.c
index 07e31941dc674..617c2c99ebfb3 100644
--- a/arch/arm/crypto/aes-neonbs-glue.c
+++ b/arch/arm/crypto/aes-neonbs-glue.c
@@ -278,6 +278,8 @@ static int __xts_crypt(struct skcipher_request *req,
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	crypto_cipher_encrypt_one(ctx->tweak_tfm, walk.iv, walk.iv);
 
-- 
2.21.0

