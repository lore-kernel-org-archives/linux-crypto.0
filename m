Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9C31C07E9E
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 22:32:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0B09610CB
	for <linux-crypto@archiver.kernel.org>; Sun, 11 Jul 2021 22:32:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231873AbhGKWeo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Jul 2021 18:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbhGKWen (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Jul 2021 18:34:43 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99514C0613E9;
        Sun, 11 Jul 2021 15:31:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=ijUqqScILHzX/ULhm5sgi7N9PrNOxifBEV6VgXlbCXw=; b=3EhBipHwu13pnjugdbbvom2YEO
        wAuwjflpNIDBUqh4plBjWz+UhLLzoTMLUHdpP4qmW38an/R9L5dEyqtXz00hkm3H4DsFriQj8EMKS
        /uZZ/u4h1PFLEaGYa6/cya2cniFl+xAvGMpZ8+XvMD/35bOatK+/1i2pOG6/VQqDqVM8ZAqqdHIrJ
        TKNDjPj4/CeBG3rMCNaiXPge+CBMHyrN7svWQw5Tr/Vvf9+Q55LsyTrjRTfyDDQPv48/NKWvv4CPd
        vbSItRr/FmYWJy7a2k4Ui28VHvlsDPaazcTquvJAr7wBvkcwqICETsvjQbnLs1D1drQtQTjO/nqn2
        lO15V++Q==;
Received: from [2601:1c0:6280:3f0::aefb] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m2hzL-005U4u-Ck; Sun, 11 Jul 2021 22:31:51 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>,
        linux-geode@lists.infradead.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org,
        Christian Gromm <christian.gromm@microchip.com>,
        Krzysztof Halasa <khc@pm.waw.pl>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Schiller <ms@dev.tdt.de>, linux-x25@vger.kernel.org,
        wireguard@lists.zx2c4.com, patches@armlinux.org.uk,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 1/6 v2] arm: crypto: rename 'mod_init' & 'mod_exit' functions to be module-specific
Date:   Sun, 11 Jul 2021 15:31:43 -0700
Message-Id: <20210711223148.5250-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210711223148.5250-1-rdunlap@infradead.org>
References: <20210711223148.5250-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Rename module_init & module_exit functions that are named
"mod_init" and "mod_exit" so that they are unique in both the
System.map file and in initcall_debug output instead of showing
up as almost anonymous "mod_init".

This is helpful for debugging and in determining how long certain
module_init calls take to execute.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: patches@armlinux.org.uk
Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
KernelVersion: v5.13

v2: add KernelVersion: info for the armlinux patch daemon;
    add Russell's Ack;

 arch/arm/crypto/curve25519-glue.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- linux-next-20210708.orig/arch/arm/crypto/curve25519-glue.c
+++ linux-next-20210708/arch/arm/crypto/curve25519-glue.c
@@ -112,7 +112,7 @@ static struct kpp_alg curve25519_alg = {
 	.max_size		= curve25519_max_size,
 };
 
-static int __init mod_init(void)
+static int __init arm_curve25519_init(void)
 {
 	if (elf_hwcap & HWCAP_NEON) {
 		static_branch_enable(&have_neon);
@@ -122,14 +122,14 @@ static int __init mod_init(void)
 	return 0;
 }
 
-static void __exit mod_exit(void)
+static void __exit arm_curve25519_exit(void)
 {
 	if (IS_REACHABLE(CONFIG_CRYPTO_KPP) && elf_hwcap & HWCAP_NEON)
 		crypto_unregister_kpp(&curve25519_alg);
 }
 
-module_init(mod_init);
-module_exit(mod_exit);
+module_init(arm_curve25519_init);
+module_exit(arm_curve25519_exit);
 
 MODULE_ALIAS_CRYPTO("curve25519");
 MODULE_ALIAS_CRYPTO("curve25519-neon");
