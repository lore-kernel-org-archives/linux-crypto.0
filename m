Return-Path: <SRS0=1tzS=TR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D96C46470
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 17:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BDF721734
	for <linux-crypto@archiver.kernel.org>; Fri, 17 May 2019 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558114205;
	bh=Nt2Knl7gnzVXrvFhFCn/ByrnRw+DIxvw9ac34fmgmjk=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=zuYJVzUJZ19Txfr0bmQod1WASYwJlJZql8N7TbSGnie8/Ev9d6CBTCe10WeIftUQn
	 5UXeoO0OIiqjp/Gt+Z1Y/dHacVu4J6cSAqScxCXqMo/YIMULJq/6gyzH2NEdAdnJFs
	 mPZw2Si8GK8RJF5VqqM/UwYzd8e4D7TkaW0kc4Z4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbfEQRaE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 17 May 2019 13:30:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726078AbfEQRaE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 May 2019 13:30:04 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A347F216C4;
        Fri, 17 May 2019 17:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558114203;
        bh=Nt2Knl7gnzVXrvFhFCn/ByrnRw+DIxvw9ac34fmgmjk=;
        h=From:To:Cc:Subject:Date:From;
        b=R6qxW9p33gQrIQ5QRSaFqxG/tvZJ1vqjdH0NjlB9Ftr7s7iz2FWZd8FvxRtSBoYz4
         2x3OLgHiC6QhJb93mtxjeq4RvRtpeFShSJvjGfc5ljhSp9ZbVXd/S3Qpj+Clf7l2tj
         9ZIb11x70DPwiSLjb+1dbopw96xyXcnEwUEjgkFU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     stable@vger.kernel.org
Cc:     linux-crypto@vger.kernel.org
Subject: [PATCH 4.14] crypto: arm64/aes-neonbs - don't access already-freed walk.iv
Date:   Fri, 17 May 2019 10:29:51 -0700
Message-Id: <20190517172951.58312-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 4a8108b70508df0b6c4ffa4a3974dab93dcbe851 upstream.
[Please apply to 4.14-stable.]

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 arch/arm64/crypto/aes-neonbs-glue.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/crypto/aes-neonbs-glue.c b/arch/arm64/crypto/aes-neonbs-glue.c
index c55d68ccb89f8..52975817fdb66 100644
--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -307,6 +307,8 @@ static int __xts_crypt(struct skcipher_request *req,
 	int err;
 
 	err = skcipher_walk_virt(&walk, req, true);
+	if (err)
+		return err;
 
 	kernel_neon_begin();
 
-- 
2.21.0.1020.gf2820cf01a-goog

