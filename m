Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 568F2C433B4
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Apr 2021 18:06:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215406128B
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Apr 2021 18:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhDYSGp (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Apr 2021 14:06:45 -0400
Received: from condef-08.nifty.com ([202.248.20.73]:48047 "EHLO
        condef-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230329AbhDYSGo (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Apr 2021 14:06:44 -0400
X-Greylist: delayed 318 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Apr 2021 14:06:44 EDT
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-08.nifty.com with ESMTP id 13PHwVWr023010
        for <linux-crypto@vger.kernel.org>; Mon, 26 Apr 2021 02:58:31 +0900
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 13PHvbLV030691;
        Mon, 26 Apr 2021 02:57:40 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 13PHvbLV030691
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1619373460;
        bh=WPMOAoetHlwoC77DEFN4ntrJF0d2o3QlqMB4lX6w80Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXej5X7WPmbCm/83/+2lzCQeh8tYn71hXSnL1bcHlvM7I9c/cErIXneg6Dzq6oLz8
         XEpriLl3qdwyNMAKuLnBfe2uvkytSW0opskUGhoWUJFmu6JTdd1x+fhVLe2jn3DlGd
         6Ya6Q64AFvknRo1yaa5WU5J6PrHCx7bv4+u244Ptv7haSzlmXO5x+6Gpu0zVGLQuIO
         7Ijd+m2BuiL/I04XYnpBrOoVQetdNPBaekURgmERTs4mNsJiUYK0WlMX3y5jO2i97S
         k9WMImPaQo3LFuvSW7PODAEG6haCAQLU88t/VkfB3SFupl5F8sjHjrut1Qqr0aYcgU
         1A4kgwO01TSyg==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] crypto: arm64: use a pattern rule for generating *.S files
Date:   Mon, 26 Apr 2021 02:57:34 +0900
Message-Id: <20210425175734.1310191-4-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210425175734.1310191-1-masahiroy@kernel.org>
References: <20210425175734.1310191-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unify similar build rules.

sha256-core.S opts out it because it is generated from sha512-armv8.pl.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/arm64/crypto/Makefile | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/crypto/Makefile b/arch/arm64/crypto/Makefile
index 592e52a08c62..09a805cc32d7 100644
--- a/arch/arm64/crypto/Makefile
+++ b/arch/arm64/crypto/Makefile
@@ -71,13 +71,10 @@ $(obj)/aes-glue-%.o: $(src)/aes-glue.c FORCE
 quiet_cmd_perlasm = PERLASM $@
       cmd_perlasm = $(PERL) $(<) void $(@)
 
-$(obj)/poly1305-core.S: $(src)/poly1305-armv8.pl
+$(obj)/%-core.S: $(src)/%-armv8.pl
 	$(call cmd,perlasm)
 
 $(obj)/sha256-core.S: $(src)/sha512-armv8.pl
 	$(call cmd,perlasm)
 
-$(obj)/sha512-core.S: $(src)/sha512-armv8.pl
-	$(call cmd,perlasm)
-
 clean-files += poly1305-core.S sha256-core.S sha512-core.S
-- 
2.27.0

