Return-Path: <SRS0=CR7J=DD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF6ABC2D0A8
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Sep 2020 10:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70A062396D
	for <linux-crypto@archiver.kernel.org>; Sat, 26 Sep 2020 10:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601116020;
	bh=hyr7KlbrQjTIrBXGGORmyQbaJrD1a0wNg1Gzn4Ce0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=ZkCrlCgF/9c3UdgyUK7va/9r525pkqVMzyepPLSGcoo4xxSkdgzuqFhMwWnnFdxZf
	 JIlbu/gRoiy0bQIv3zYWz41IRaq3vMZJZxNf8MhF7hD1mIiz1sSiG5iKisZ2jtt4AX
	 M5r0u/DVvwt26ywCf2wlFVsHJUyu6OaN169hsWlc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726923AbgIZK07 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 26 Sep 2020 06:26:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:41644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726210AbgIZK07 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Sep 2020 06:26:59 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD11B238E6;
        Sat, 26 Sep 2020 10:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601116019;
        bh=hyr7KlbrQjTIrBXGGORmyQbaJrD1a0wNg1Gzn4Ce0Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mPXT58qqdDuEWaH4Ne2Iv8zSwyzpWqXdYTqyQ+aYQvoJNt6hY34ksebLWAMVG9OEC
         lFaSI6aizV5CwOkRLsxNFB4LIDDt7dGDopQwEj9sHJenx1QQRRGOJMchEwygfalZQR
         O06lNUMd1PGXjW1AYOpFmZ9E8PY09m8pSSCTDCPw=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, Ard Biesheuvel <ardb@kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        David Laight <David.Laight@aculab.com>
Subject: [PATCH v2 1/2] crypto: xor - defer load time benchmark to a later time
Date:   Sat, 26 Sep 2020 12:26:50 +0200
Message-Id: <20200926102651.31598-2-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200926102651.31598-1-ardb@kernel.org>
References: <20200926102651.31598-1-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the XOR module performs its boot time benchmark at core
initcall time when it is built-in, to ensure that the RAID code can
make use of it when it is built-in as well.

Let's defer this to a later stage during the boot, to avoid impacting
the overall boot time of the system. Instead, just pick an arbitrary
implementation from the list, and use that as the preliminary default.

Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 crypto/xor.c | 29 +++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/crypto/xor.c b/crypto/xor.c
index ea7349e6ed23..b42c38343733 100644
--- a/crypto/xor.c
+++ b/crypto/xor.c
@@ -54,6 +54,28 @@ EXPORT_SYMBOL(xor_blocks);
 /* Set of all registered templates.  */
 static struct xor_block_template *__initdata template_list;
 
+#ifndef MODULE
+static void __init do_xor_register(struct xor_block_template *tmpl)
+{
+	tmpl->next = template_list;
+	template_list = tmpl;
+}
+
+static int __init register_xor_blocks(void)
+{
+	active_template = XOR_SELECT_TEMPLATE(NULL);
+
+	if (!active_template) {
+#define xor_speed	do_xor_register
+		// register all the templates and pick the first as the default
+		XOR_TRY_TEMPLATES;
+#undef xor_speed
+		active_template = template_list;
+	}
+	return 0;
+}
+#endif
+
 #define BENCH_SIZE (PAGE_SIZE)
 
 static void __init
@@ -129,6 +151,7 @@ calibrate_xor_blocks(void)
 #define xor_speed(templ)	do_xor_speed((templ), b1, b2)
 
 	printk(KERN_INFO "xor: measuring software checksum speed\n");
+	template_list = NULL;
 	XOR_TRY_TEMPLATES;
 	fastest = template_list;
 	for (f = fastest; f; f = f->next)
@@ -150,6 +173,10 @@ static __exit void xor_exit(void) { }
 
 MODULE_LICENSE("GPL");
 
+#ifndef MODULE
 /* when built-in xor.o must initialize before drivers/md/md.o */
-core_initcall(calibrate_xor_blocks);
+core_initcall(register_xor_blocks);
+#endif
+
+module_init(calibrate_xor_blocks);
 module_exit(xor_exit);
-- 
2.17.1

