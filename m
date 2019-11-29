Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1071C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:17:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A29BF2158A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 18:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1575051458;
	bh=OculNLKaTtrnRKe8g81hVkG4UU6ZtgQnbcFjyCBg0L4=;
	h=From:To:Subject:Date:List-ID:From;
	b=JJkFbZjfskhUXn1IIjdKCQVjV7/PJLx7/GqJLeKPSnfR7Cug0pnwDROHrRoFfzEhT
	 vK1PXraa3mHKInyT88Q1garzmYoocg1amS7aNdqc98XooIBQ6O86H1nfH3ZvmMU3Bs
	 InH1K7mwduCmvT+mvRvhSfa/VG/ekfsiB2pRGGs4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfK2SRi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 13:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:56484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727022AbfK2SRi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 13:17:38 -0500
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66DBC2158A
        for <linux-crypto@vger.kernel.org>; Fri, 29 Nov 2019 18:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575051457;
        bh=OculNLKaTtrnRKe8g81hVkG4UU6ZtgQnbcFjyCBg0L4=;
        h=From:To:Subject:Date:From;
        b=HIBKJmdB+mujAX5BVDbEn6SLfKLYaGMZ09A+MFEE7M+IYm9A6MIS/z0Cldx6U7MK/
         pp2BfFHm5fC2iYgIpuuHKEWAMKMh+fGophhAhdDaAoK9Xv/2hUF+peZfhepgiMcqpe
         WoxCfpvemtd0iItTycAk3dd4xR35e//MwZxGuLTA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Subject: [PATCH] crypto: api - remove another reference to blkcipher
Date:   Fri, 29 Nov 2019 10:16:48 -0800
Message-Id: <20191129181648.45591-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update a comment to refer to crypto_alloc_skcipher() rather than
crypto_alloc_blkcipher() (the latter having been removed).

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/api.c b/crypto/api.c
index 55bca28df92d..4d3d13872fac 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -516,7 +516,7 @@ EXPORT_SYMBOL_GPL(crypto_find_alg);
  *
  *	The returned transform is of a non-determinate type.  Most people
  *	should use one of the more specific allocation functions such as
- *	crypto_alloc_blkcipher.
+ *	crypto_alloc_skcipher().
  *
  *	In case of error the return value is an error pointer.
  */
-- 
2.24.0

