Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F9BDC3A5A2
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1EDB2339D
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567528610;
	bh=UAiGUdrPfb+g2lb5wdRr2F7sPCY1m57xplW9JvOlQ/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=alkjH/d5SFBLWpQZW4t353BjqWu0PatJqx42/T60prOIuOUK5HzkAe+UUXFlW1BNr
	 qHgbvQDRumLCCyv9feyKNYuN2/vkHKi1e6NbmejI4dk7fwdqYqm/SksiHM7xGY0lwM
	 nM8DvydLCXXxzWq4EDDsRWHNyLC0arVEZNn2Yfek=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730775AbfICQgt (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:36:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:48194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730766AbfICQ1D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 531F6238C7;
        Tue,  3 Sep 2019 16:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528023;
        bh=UAiGUdrPfb+g2lb5wdRr2F7sPCY1m57xplW9JvOlQ/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVen0V82SYj3OwXJ/xZY4rm2TYBtDsVpWVFbloDGmQSHl+I0vyingezhH9vl1Zrp7
         w3XHUvoQ1JIFNQ0UH9t33dGWUTwqzEoixkOFxqZCZfgGbFG2RyWhVoM96rk3dOFRZc
         7uO5pD+ckVqUwBKWUKxmh1DDNRD6AhBV6TUc/oR0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gilad Ben-Yossef <gilad@benyossef.com>, stable@kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 058/167] crypto: ccree - add missing inline qualifier
Date:   Tue,  3 Sep 2019 12:23:30 -0400
Message-Id: <20190903162519.7136-58-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Gilad Ben-Yossef <gilad@benyossef.com>

[ Upstream commit f1071c3e2473ae19a7f5d892a187c4cab1a61f2e ]

Commit 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
was missing a "inline" qualifier for stub function used when CONFIG_PM
is not set causing a build warning.

Fixes: 1358c13a48c4 ("crypto: ccree - fix resume race condition on init")
Cc: stable@kernel.org # v4.20
Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccree/cc_pm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccree/cc_pm.h b/drivers/crypto/ccree/cc_pm.h
index f626243570209..907a6db4d6c03 100644
--- a/drivers/crypto/ccree/cc_pm.h
+++ b/drivers/crypto/ccree/cc_pm.h
@@ -30,7 +30,7 @@ static inline int cc_pm_init(struct cc_drvdata *drvdata)
 	return 0;
 }
 
-static void cc_pm_go(struct cc_drvdata *drvdata) {}
+static inline void cc_pm_go(struct cc_drvdata *drvdata) {}
 
 static inline void cc_pm_fini(struct cc_drvdata *drvdata) {}
 
-- 
2.20.1

