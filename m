Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F2BC282CE
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51F0B2083E
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878933;
	bh=WYZz6UW+QsmJS/csSZiX17NE+KNrkgeCJgokTzb+BeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=u7NjmGsfgR5wWAeIkVUwd0CCy9Ne8/Mj8T9xb6PFldzdA/wP4GZg/eACaIt8sTiI3
	 fJWzC9jJKpG6CA1e+mFgGw9z21l7nOY+IOwQbCPxCWh9X5AsiqWGXjjcKnY83W5Tlb
	 h4p8/+oSU43FXYhJ/ALSVgDDot+y51CRarasiY/I=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbfDJGsw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:53356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728716AbfDJGsr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BD42083E;
        Wed, 10 Apr 2019 06:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878927;
        bh=WYZz6UW+QsmJS/csSZiX17NE+KNrkgeCJgokTzb+BeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TbPzgj5+iOWlnXt/ustaNLa5flfifrBunU1BEusJf/F7dBht/A3hi5cFskXNtDP6L
         VlgeBx4cW7kcdIjPLZK6LkmT6wrtRY397pNubcGJET2pO9RcPNruz2UDyYP0CuXo0Z
         +GNFtDUF6b7oucEDjNHQqSSD1qpE5htAK1nVOVEY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 4/7] crypto: arm64/aes-neonbs - don't access already-freed walk.iv
Date:   Tue,  9 Apr 2019 23:46:32 -0700
Message-Id: <20190410064635.11813-5-ebiggers@kernel.org>
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

xts-aes-neonbs doesn't set an alignmask, so currently it isn't affected
by this despite unconditionally accessing walk.iv.  However this is more
subtle than desired, and unconditionally accessing walk.iv has caused a
real problem in other algorithms.  Thus, update xts-aes-neonbs to start
checking the return value of skcipher_walk_virt().

Fixes: 1abee99eafab ("crypto: arm64/aes - reimplement bit-sliced ARM/NEON implementation for arm64")
Cc: <stable@vger.kernel.org> # v4.11+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index 4737b6c6c5cf5..5144551177334 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -304,6 +304,8 @@ static int __xts_crypt(struct skcipher_request *req,
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, false);
+	if (err)
+		return err;
 
 	kernel_neon_begin();
 	neon_aes_ecb_encrypt(walk.iv, walk.iv, ctx->twkey, ctx->key.rounds, 1);
-- 
2.21.0

