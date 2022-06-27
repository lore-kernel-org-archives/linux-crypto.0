Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02349C43334
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jun 2022 19:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238587AbiF0Tv4 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jun 2022 15:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238433AbiF0Tvz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jun 2022 15:51:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A44981BE83
        for <linux-crypto@vger.kernel.org>; Mon, 27 Jun 2022 12:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656359513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jiwuO61xqDYsAatAV0xcjY2AT3XPbcqJO2ZheElIFe4=;
        b=FjaTFPO8MoW3Svq8DkB2wpQ6MpZbWM4sPflBvgSHxJzHqd+ejqKZIa0aNom+N74brr7rpz
        njQ5q/zFJn8FKiXLCYD26NX2NXovdU0Y2LCOPg9RlbXEker3EKdsWWNFOGYWreIz0rc59M
        xnF+SyUl7wmc4Mj1ZpqVaGC5qIEms9Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-OIXhawpzPVS0ihlNq5O2Mw-1; Mon, 27 Jun 2022 15:51:52 -0400
X-MC-Unique: OIXhawpzPVS0ihlNq5O2Mw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C8F7A801233;
        Mon, 27 Jun 2022 19:51:51 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 250BD2026D64;
        Mon, 27 Jun 2022 19:51:49 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Vladis Dronov <vdronov@redhat.com>, Simo Sorce <simo@redhat.com>
Subject: [PATCH v3] crypto: fips - make proc files report fips module name and version
Date:   Mon, 27 Jun 2022 21:51:44 +0200
Message-Id: <20220627195144.976741-1-vdronov@redhat.com>
In-Reply-To: <20220620131618.952133-1-vdronov@redhat.com>
References: <20220620131618.952133-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

FIPS 140-3 introduced a requirement for the FIPS module to return
information about itself, specifically a name and a version. These
values must match the values reported on FIPS certificates.

This patch adds two files to read a name and a version from:

/proc/sys/crypto/fips_name
/proc/sys/crypto/fips_version

v2: removed redundant parentheses in config entries.
v3: move FIPS_MODULE_* defines to fips.c where they are used.

Signed-off-by: Simo Sorce <simo@redhat.com>
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 crypto/Kconfig | 21 +++++++++++++++++++++
 crypto/fips.c  | 34 +++++++++++++++++++++++++++++-----
 2 files changed, 50 insertions(+), 5 deletions(-)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 1d44893a997b..3891c331f2e7 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -33,6 +33,27 @@ config CRYPTO_FIPS
 	  certification.  You should say no unless you know what
 	  this is.
 
+config CRYPTO_FIPS_NAME
+	string "FIPS Module Name"
+	default "Linux Kernel Cryptographic API"
+	depends on CRYPTO_FIPS
+	help
+	  This option sets the FIPS Module name reported by the Crypto API via
+	  the /proc/sys/crypto/fips_name file.
+
+config CRYPTO_FIPS_CUSTOM_VERSION
+	bool "Use Custom FIPS Module Version"
+	depends on CRYPTO_FIPS
+	default n
+
+config CRYPTO_FIPS_VERSION
+	string "FIPS Module Version"
+	default "(none)"
+	depends on CRYPTO_FIPS_CUSTOM_VERSION
+	help
+	  This option provides the ability to override the FIPS Module Version.
+	  By default the KERNELRELEASE value is used.
+
 config CRYPTO_ALGAPI
 	tristate
 	select CRYPTO_ALGAPI2
diff --git a/crypto/fips.c b/crypto/fips.c
index 7b1d8caee669..d820f83cb878 100644
--- a/crypto/fips.c
+++ b/crypto/fips.c
@@ -30,13 +30,37 @@ static int fips_enable(char *str)
 
 __setup("fips=", fips_enable);
 
+#define FIPS_MODULE_NAME CONFIG_CRYPTO_FIPS_NAME
+#ifdef CONFIG_CRYPTO_FIPS_CUSTOM_VERSION
+#define FIPS_MODULE_VERSION CONFIG_CRYPTO_FIPS_VERSION
+#else
+#define FIPS_MODULE_VERSION UTS_RELEASE
+#endif
+
+static char fips_name[] = FIPS_MODULE_NAME;
+static char fips_version[] = FIPS_MODULE_VERSION;
+
 static struct ctl_table crypto_sysctl_table[] = {
 	{
-		.procname       = "fips_enabled",
-		.data           = &fips_enabled,
-		.maxlen         = sizeof(int),
-		.mode           = 0444,
-		.proc_handler   = proc_dointvec
+		.procname	= "fips_enabled",
+		.data		= &fips_enabled,
+		.maxlen		= sizeof(int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec
+	},
+	{
+		.procname	= "fips_name",
+		.data		= &fips_name,
+		.maxlen		= 64,
+		.mode		= 0444,
+		.proc_handler	= proc_dostring
+	},
+	{
+		.procname	= "fips_version",
+		.data		= &fips_version,
+		.maxlen		= 64,
+		.mode		= 0444,
+		.proc_handler	= proc_dostring
 	},
 	{}
 };
-- 
2.36.1

