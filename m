Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30A62C433DB
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 04:01:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD1D761959
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Mar 2021 04:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230244AbhC3EA2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Mar 2021 00:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbhC3EAM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Mar 2021 00:00:12 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B86C061762;
        Mon, 29 Mar 2021 21:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:MIME-Version
        :Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hYfRYTxBigBwTh0JILosDjKFMVzAvZhJg1P7LSziAz8=; b=JcidEuHCe0eqhcxA64WH3kGKF+
        7ha0FGDncpQ+OVz94HAsQYvsX5yT4YvcJFdXNm0SXJ79H+ytLj7u6/ZE2n1gl9NjxVbPJG4BXbCMk
        AvLEEOPunbWLaXo9vZ5NSEBnneXgaAy+4Pv+7xrZPMt3TvO3BQNpj3KOBYd14GmgUHZg+jThlsYQ2
        KJdi8mWvly0A+pOgg4StUhV/xNL6euiY2xZFdqu1YzDcc8hVtLAo52tgBYkF7KE8ggLNzsS+LXotp
        hPm4lfc+QWxEnIZoR2pU8lREHM+uD8kNZ/QVEhiefdIZgZkMoFT+4TsPvJ2jInPM5qz77GJwCeN4H
        yIgLbTeg==;
Received: from [2601:1c0:6280:3f0::4557] (helo=smtpauth.infradead.org)
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lR5Xy-002dGI-Aj; Tue, 30 Mar 2021 04:00:09 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Dexuan Cui <decui@microsoft.com>, linux-crypto@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH] Documentation: crypto: add info about "fips=" boot option
Date:   Mon, 29 Mar 2021 21:00:01 -0700
Message-Id: <20210330040001.31524-1-rdunlap@infradead.org>
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

 Documentation/admin-guide/kernel-parameters.txt |   15 ++++++++++++++
 1 file changed, 15 insertions(+)

--- linux-next-20210329.orig/Documentation/admin-guide/kernel-parameters.txt
+++ linux-next-20210329/Documentation/admin-guide/kernel-parameters.txt
@@ -1370,6 +1370,21 @@
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
+			If fips_enabled = 1, some crypto tests are skipped.
+			It can also effect which ECC curve is used.
+			If fips_enabled = 1 and a test fails, it will cause a
+			kernel panic.
+			If fips_enabled = 1, RSA test requires a key size of
+			2K or larger.
+
 	floppy=		[HW]
 			See Documentation/admin-guide/blockdev/floppy.rst.
 
