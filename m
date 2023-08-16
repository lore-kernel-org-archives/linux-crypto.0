Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE44C001B0
	for <linux-crypto@archiver.kernel.org>; Wed, 16 Aug 2023 06:30:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241972AbjHPG3m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 16 Aug 2023 02:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242166AbjHPG3X (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Aug 2023 02:29:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72396269E
        for <linux-crypto@vger.kernel.org>; Tue, 15 Aug 2023 23:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692167324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=xf2jX+s4LT2hMC1l0XKqus0E14EqqgU5ODjY9R1wft0=;
        b=OhKO+ZR174IJZEeY99pkD2KGl11c1sDLshK7SsxSPbsqdvluExcvJbvmHfhi47CH/fxXl4
        kdcXGEYZk1ixBTbi6kJqifEDDoS3S7pwXsWetgvMLApQLUJIvAyuylFW6OiLfbE6kK+/Hm
        2KtIcEcROAt7Q0HEigV5p617P/EWcTY=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-638-xwc_uWr_PPmAiN6i23u-IA-1; Wed, 16 Aug 2023 02:28:41 -0400
X-MC-Unique: xwc_uWr_PPmAiN6i23u-IA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 23A831C0724E;
        Wed, 16 Aug 2023 06:28:41 +0000 (UTC)
Received: from kaapi.redhat.com (unknown [10.74.17.125])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B8067401E6A;
        Wed, 16 Aug 2023 06:28:38 +0000 (UTC)
From:   Prasad Pandit <ppandit@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        P J P <pjp@fedoraproject.org>
Subject: [PATCH] crypto: use SRCARCH to source arch Kconfigs
Date:   Wed, 16 Aug 2023 12:01:07 +0530
Message-ID: <20230816063107.11215-1-ppandit@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: P J P <pjp@fedoraproject.org>

Use $(SRCARCH) variable to source architecture specific crypto
Kconfig file. It helps to avoid multiple if ARCH conditionals.

Signed-off-by: Prasad Pandit <pjp@fedoraproject.org>
---
 crypto/Kconfig | 25 +------------------------
 1 file changed, 1 insertion(+), 24 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 650b1b3620d8..0ac776d3168b 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -1421,30 +1421,7 @@ config CRYPTO_HASH_INFO
 	bool
 
 if !KMSAN # avoid false positives from assembly
-if ARM
-source "arch/arm/crypto/Kconfig"
-endif
-if ARM64
-source "arch/arm64/crypto/Kconfig"
-endif
-if LOONGARCH
-source "arch/loongarch/crypto/Kconfig"
-endif
-if MIPS
-source "arch/mips/crypto/Kconfig"
-endif
-if PPC
-source "arch/powerpc/crypto/Kconfig"
-endif
-if S390
-source "arch/s390/crypto/Kconfig"
-endif
-if SPARC
-source "arch/sparc/crypto/Kconfig"
-endif
-if X86
-source "arch/x86/crypto/Kconfig"
-endif
+source "arch/$(SRCARCH)/crypto/Kconfig"
 endif
 
 source "drivers/crypto/Kconfig"
-- 
2.41.0

