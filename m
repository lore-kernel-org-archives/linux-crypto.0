Return-Path: <SRS0=kwSW=SM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29BEAC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E521F217D6
	for <linux-crypto@archiver.kernel.org>; Wed, 10 Apr 2019 06:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1554878933;
	bh=U8XMb5XBzsDgxfH9TV1QVq2N0dYg0CmuZps41VfC8mY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=bqfXjtLrHE/5mcEROdhJ5Yk7HPPJe05DjSgOWjfIegwQP9x9rzLBaOBedh5bgZrw/
	 scMT8VgvURkM8lZoP7omPLM2NwopOoKMqGxVgTiiPeOo8Vpcs/OC7gcdnwL/tWbs0/
	 JTjAMoVKDeefF5ON2Vaxv8tuRxkYPgc3rTKpsZvU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbfDJGsr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728708AbfDJGsr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 10 Apr 2019 02:48:47 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 802A2217D9;
        Wed, 10 Apr 2019 06:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1554878926;
        bh=U8XMb5XBzsDgxfH9TV1QVq2N0dYg0CmuZps41VfC8mY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0DjnRC8NvZCI+ZWPdJCpwvbJ6/+Y8VlHyBYK1dgZ0w6OFgI3vy7GVmQSgjdKqDHqA
         0Vdr+Uyx/KxVH6x+OtuPqUR3dY8AfIVNEtTqlIc9osv99Q02mILG4WhvzNqNj8xNm/
         9jWkHO2g07Im2LFnp5gjZx2L5r97rnVVOOPyHTws=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 2/7] crypto: salsa20 - don't access already-freed walk.iv
Date:   Tue,  9 Apr 2019 23:46:30 -0700
Message-Id: <20190410064635.11813-3-ebiggers@kernel.org>
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

salsa20-generic doesn't set an alignmask, so currently it isn't affected
by this despite unconditionally accessing walk.iv.  However this is more
subtle than desired, and it was actually broken prior to the alignmask
being removed by commit b62b3db76f73 ("crypto: salsa20-generic - cleanup
and convert to skcipher API").

Since salsa20-generic does not update the IV and does not need any IV
alignment, update it to use req->iv instead of walk.iv.

Fixes: 2407d60872dd ("[CRYPTO] salsa20: Salsa20 stream cipher")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/salsa20_generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/salsa20_generic.c b/crypto/salsa20_generic.c
index 443fba09cbed7..faed244be316f 100644
--- a/crypto/salsa20_generic.c
+++ b/crypto/salsa20_generic.c
@@ -160,7 +160,7 @@ static int salsa20_crypt(struct skcipher_request *req)
 
 	err = skcipher_walk_virt(&walk, req, false);
 
-	salsa20_init(state, ctx, walk.iv);
+	salsa20_init(state, ctx, req->iv);
 
 	while (walk.nbytes > 0) {
 		unsigned int nbytes = walk.nbytes;
-- 
2.21.0

