Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D618AC433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9549E61953
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 05:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbhC3FHq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 01:07:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhC3FHQ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 01:07:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483AAC061762;
        Mon, 29 Mar 2021 22:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=QQzXfAlsDNFWrU7NG4I9qbfmrWvWg7YebVZEeDgtWM4=; b=OIGK3YbTBZ4Blj3s2AwlBrPV98
        N1ucQJ3BSQwwuw0lTy99f06X3/dZRjzs7xzFRzB+TUjHdZvRifDlmYHzDeQsQye+sgkYBOWHmwCxt
        d8jPyoYNyjXHHrJIsByXRDAJ7JfyAeEK12Q33XxWI34nlfJDafvIx8OyxAwwWwYhDaDWTwMIWsz3T
        GcNVaM22yNSHUsxZofpZLXgbB9HRNrs6JGpQjU9vMnj5dfk06+5B86a5CjYP/7oonQgfeOEHJugNf
        YmOTht8qzQ5NhURazGpGDoSLQQaRETQLq+UoWvtVkP2EAkvHZ7OmGti2TCCslZBGKsQgZ48VW1EcL
        0o7GSTpg==;
Received: from [2601:1c0:6280:3f0::4557] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lR6ae-002Xds-DJ; Tue, 30 Mar 2021 05:07:00 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Dexuan Cui <decui@microsoft.com>, linux-crypto@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH v2] Documentation: crypto: add info about "fips=" boot option
Date:   Mon, 29 Mar 2021 22:06:51 -0700
Message-Id: <20210330050651.13344-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Having just seen a report of using "fips=1" on the kernel command line,
I could not find it documented anywhere, so add some help for it.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dexuan Cui <decui@microsoft.com>
Cc: linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
Updates/corrections welcome.

v2: drop comment that "fips_enabled can cause some tests to be skipped".

 Documentation/admin-guide/kernel-parameters.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- linux-next-20210329.orig/Documentation/admin-guide/kernel-parameters.txt
+++ linux-next-20210329/Documentation/admin-guide/kernel-parameters.txt
@@ -1370,6 +1370,20 @@
 			See Documentation/admin-guide/sysctl/net.rst for
 			fb_tunnels_only_for_init_ns
 
+	fips=		Format: { 0 | 1}
+			Use to disable (0) or enable (1) FIPS mode.
+			If enabled, any process that is waiting on the
+			'fips_fail_notif_chain' will be notified of fips
+			failures.
+			This setting can also be modified via sysctl at
+			/proc/sysctl/crypto/fips_enabled, i.e.,
+			crypto.fips_enabled.
+			If fips_enabled = 1 and a test fails, it will cause a
+			kernel panic.
+			If fips_enabled = 1, RSA test requires a key size of
+			2K or larger.
+			It can also effect which ECC curve is used.
+
 	floppy=		[HW]
 			See Documentation/admin-guide/blockdev/floppy.rst.
 
