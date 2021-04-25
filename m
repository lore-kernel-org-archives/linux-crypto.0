Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBAC6C433ED
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Apr 2021 18:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B857C6128A
	for <linux-crypto@archiver.kernel.org>; Sun, 25 Apr 2021 18:07:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbhDYSIb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 25 Apr 2021 14:08:31 -0400
Received: from condef-05.nifty.com ([202.248.20.70]:33987 "EHLO
        condef-05.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhDYSIa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 25 Apr 2021 14:08:30 -0400
Received: from conuserg-08.nifty.com ([10.126.8.71])by condef-05.nifty.com with ESMTP id 13PHwpNs017026
        for <linux-crypto@vger.kernel.org>; Mon, 26 Apr 2021 02:58:52 +0900
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 13PHvbLT030691;
        Mon, 26 Apr 2021 02:57:38 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 13PHvbLT030691
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1619373459;
        bh=acZHbiFl1BuPwgqBy9eaqf1jnbfxX6j2AfJg+afbRwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GFZyh7aw9NJhnWO3tL3B3YQDCqFbJlXJYXfZ0hkrN9wseNMjr1MQPMZbcPBkGHJz6
         fx/pbUhuI0yp4QofMBr65JtyGpI9jmyYbqApMdOqDHvNaQLrBHlK9RDYly6ebhLPRu
         qCKNTM9X04BHt+pUSTLzl8gdlhivFnqERz1bZ/C8PKskp0kV+taZtQEDJmqI/9ir+Q
         /JXXvU8cpDE0WwxOwzE4MHmRGnBJGJwwvHeAJmfTzO9rB6BkS1RUR2AQKQGSwuGTAB
         tQIMzgZxKep8BRwOa5xwvrbYK5WIaEDcqa6Y4lhd75Ut+xNn29cWWMV2XNd8Fn3Zl4
         +5LNWSznn4Iyw==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] crypto: arm: use a pattern rule for generating *.S files
Date:   Mon, 26 Apr 2021 02:57:32 +0900
Message-Id: <20210425175734.1310191-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210425175734.1310191-1-masahiroy@kernel.org>
References: <20210425175734.1310191-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Unify similar build rules.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 arch/arm/crypto/Makefile | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index 51f160c61740..eafa898ba6a7 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -48,13 +48,7 @@ curve25519-neon-y := curve25519-core.o curve25519-glue.o
 quiet_cmd_perl = PERL    $@
       cmd_perl = $(PERL) $(<) > $(@)
 
-$(obj)/poly1305-core.S: $(src)/poly1305-armv4.pl
-	$(call cmd,perl)
-
-$(obj)/sha256-core.S: $(src)/sha256-armv4.pl
-	$(call cmd,perl)
-
-$(obj)/sha512-core.S: $(src)/sha512-armv4.pl
+$(obj)/%-core.S: $(src)/%-armv4.pl
 	$(call cmd,perl)
 
 clean-files += poly1305-core.S sha256-core.S sha512-core.S
-- 
2.27.0

