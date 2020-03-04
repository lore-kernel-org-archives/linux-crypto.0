Return-Path: <SRS0=WWUc=4V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18760C3F2D7
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC30420866
	for <linux-crypto@archiver.kernel.org>; Wed,  4 Mar 2020 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583361879;
	bh=leqCjZukBB6a7qZfVohOmJJvhFksFhT6HOEz7wKBCs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=kolaFcLoW8Qp0LbT37+Ucn/tjDXFzrcMcBwZYzSiwL/Rq7RGAffK/nz24FSf8uv7l
	 T/kuMuy4KGOHgd6qhHebIDvhWQOVerChqG8RZ0B/3b1ESzejFuYoCl5EK4jl70JYRp
	 3IoKvJkdcBkjRpfKg9DsHrc46DKjEw4GA1oGVYBQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388351AbgCDWoi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 Mar 2020 17:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387931AbgCDWoi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 Mar 2020 17:44:38 -0500
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DB1420866;
        Wed,  4 Mar 2020 22:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583361877;
        bh=leqCjZukBB6a7qZfVohOmJJvhFksFhT6HOEz7wKBCs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GzYesWwduTV86SebF8TCJT4fLNlxDECxV0+OmpyDG0S7gtOg1yzf+2jnd18rrb18O
         ezuu8eBGLI6Rpy58m3EmLo9fZT0cCJnehT/BFqLdRMbcrRxB7uvcpMwV2bQhZplens
         eXTL+4Cjlza9F8q/o/DHoTu0uaGPGJ39hAarscdY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>
Subject: [PATCH 2/3] crypto: testmgr - do comparison tests before inauthentic input tests
Date:   Wed,  4 Mar 2020 14:44:04 -0800
Message-Id: <20200304224405.152829-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200304224405.152829-1-ebiggers@kernel.org>
References: <20200304224405.152829-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Do test_aead_vs_generic_impl() before test_aead_inauthentic_inputs() so
that any differences with the generic driver are detected before getting
to the inauthentic input tests, which intentionally use only the driver
being tested (so that they run even if a generic driver is unavailable).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/testmgr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 0a10dbde27ef..428a5f8bc80f 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2512,11 +2512,11 @@ static int test_aead_extra(const char *driver,
 		goto out;
 	}
 
-	err = test_aead_inauthentic_inputs(ctx);
+	err = test_aead_vs_generic_impl(ctx);
 	if (err)
 		goto out;
 
-	err = test_aead_vs_generic_impl(ctx);
+	err = test_aead_inauthentic_inputs(ctx);
 out:
 	kfree(ctx->vec.key);
 	kfree(ctx->vec.iv);
-- 
2.25.1

