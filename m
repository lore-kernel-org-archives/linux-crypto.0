Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E62BC33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 16:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06DA424673
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 16:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579193993;
	bh=aojxDSdvCecGgB7WVsEtpC9T7zE3JaEiD3OBVdKo3ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ogowaDQxtzIuvEfDMpxUotRAag9efzEkD27W23gVfTRkqjapoUc7neN1kHo0faCjg
	 knpmR2vaET3MSE69pnd2OQIL3tO5W9e4RwqG/5qPQkMN8uW2999on+16nxkp97oWH1
	 fqRtPFoTfiRrQulrb80iQGZzWTKEpebtQGWP3BBI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387592AbgAPQ7v (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 11:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387562AbgAPQ7u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 11:59:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95A1E22525;
        Thu, 16 Jan 2020 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193990;
        bh=aojxDSdvCecGgB7WVsEtpC9T7zE3JaEiD3OBVdKo3ho=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kBpUuhlfAOmTfYamUglXo0IcAhY5FxHyw7Oo57ISjlQkKJ8oIP0t48IyWVp4HYZXm
         uMubbv0jBQpPVWupHoUtt2eIk7LsBSi7bec8QCprOKehH3tzjMaYE5mktOtzMq56Q5
         uqCV94BB1lXeTYkcoE7CThlsAhe1MdR7urBP5wQE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 121/671] crypto: tgr192 - fix unaligned memory access
Date:   Thu, 16 Jan 2020 11:50:30 -0500
Message-Id: <20200116165940.10720-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165940.10720-1-sashal@kernel.org>
References: <20200116165940.10720-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit f990f7fb58ac8ac9a43316f09a48cff1a49dda42 ]

Fix an unaligned memory access in tgr192_transform() by using the
unaligned access helpers.

Fixes: 06ace7a9bafe ("[CRYPTO] Use standard byte order macros wherever possible")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/tgr192.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/tgr192.c b/crypto/tgr192.c
index 022d3dd76c3b..f8e1d9f9938f 100644
--- a/crypto/tgr192.c
+++ b/crypto/tgr192.c
@@ -25,8 +25,9 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/mm.h>
-#include <asm/byteorder.h>
 #include <linux/types.h>
+#include <asm/byteorder.h>
+#include <asm/unaligned.h>
 
 #define TGR192_DIGEST_SIZE 24
 #define TGR160_DIGEST_SIZE 20
@@ -468,10 +469,9 @@ static void tgr192_transform(struct tgr192_ctx *tctx, const u8 * data)
 	u64 a, b, c, aa, bb, cc;
 	u64 x[8];
 	int i;
-	const __le64 *ptr = (const __le64 *)data;
 
 	for (i = 0; i < 8; i++)
-		x[i] = le64_to_cpu(ptr[i]);
+		x[i] = get_unaligned_le64(data + i * sizeof(__le64));
 
 	/* save */
 	a = aa = tctx->a;
-- 
2.20.1

