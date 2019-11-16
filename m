Return-Path: <SRS0=zerQ=ZI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A88BC43215
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39F9021845
	for <linux-crypto@archiver.kernel.org>; Sat, 16 Nov 2019 16:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921717;
	bh=SWAWfJzmUKIYI5K513r05IPRQy5xw/PP18Nyx4gvL2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=h3zzi0qGAiJXrqRpm17jbYWNio2jTbO1t85XhwYPjB4D1P1gAR00wISqPyn4tz+zB
	 kVvMrsy/1UgLQpOzJWRq0LkMrW2Yt+xYLR4Pn5U6R4umLellyItEbys3tGndkrWoq0
	 9RIHFYsTlM4NVIlH2N6hPZ26oPzMNIjwHznEWBBk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfKPPlS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:41:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:44176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727655AbfKPPlP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:15 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E33220730;
        Sat, 16 Nov 2019 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918875;
        bh=SWAWfJzmUKIYI5K513r05IPRQy5xw/PP18Nyx4gvL2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hI1w62pwJBP4LmYCJ25FmdwI7+5RaCIdzTAaA64KBP17HRvM5lRRqg5iK2K56Whlp
         czZDgtb+kuktxMaroGXYeRxHVZUnYebsFPclLTr/9VIEMpKjoUKcH0dFrmPZ14GYBV
         oZu1Zg8Aq58Z2d2g7XSyhtEgLjbsk8LfS9QaTs0c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Schupikov <michael@schupikov.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 002/237] crypto: testmgr - fix sizeof() on COMP_BUF_SIZE
Date:   Sat, 16 Nov 2019 10:37:17 -0500
Message-Id: <20191116154113.7417-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Michael Schupikov <michael@schupikov.de>

[ Upstream commit 22a8118d329334833cd30f2ceb36d28e8cae8a4f ]

After allocation, output and decomp_output both point to memory chunks of
size COMP_BUF_SIZE. Then, only the first bytes are zeroed out using
sizeof(COMP_BUF_SIZE) as parameter to memset(), because
sizeof(COMP_BUF_SIZE) provides the size of the constant and not the size of
allocated memory.

Instead, the whole allocated memory is meant to be zeroed out. Use
COMP_BUF_SIZE as parameter to memset() directly in order to accomplish
this.

Fixes: 336073840a872 ("crypto: testmgr - Allow different compression results")

Signed-off-by: Michael Schupikov <michael@schupikov.de>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/testmgr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 3664c26f4838e..13cb2ea99d6a5 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1400,8 +1400,8 @@ static int test_comp(struct crypto_comp *tfm,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(output, 0, sizeof(COMP_BUF_SIZE));
-		memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
+		memset(output, 0, COMP_BUF_SIZE);
+		memset(decomp_output, 0, COMP_BUF_SIZE);
 
 		ilen = ctemplate[i].inlen;
 		ret = crypto_comp_compress(tfm, ctemplate[i].input,
@@ -1445,7 +1445,7 @@ static int test_comp(struct crypto_comp *tfm,
 		int ilen;
 		unsigned int dlen = COMP_BUF_SIZE;
 
-		memset(decomp_output, 0, sizeof(COMP_BUF_SIZE));
+		memset(decomp_output, 0, COMP_BUF_SIZE);
 
 		ilen = dtemplate[i].inlen;
 		ret = crypto_comp_decompress(tfm, dtemplate[i].input,
-- 
2.20.1

