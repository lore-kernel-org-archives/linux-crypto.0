Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_MED,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B222BC5B57D
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 01:20:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B2CB2064A
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 01:20:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFTGEtAH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbfGCBUm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 2 Jul 2019 21:20:42 -0400
Received: from mail-pg1-f202.google.com ([209.85.215.202]:45406 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfGCBUk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 2 Jul 2019 21:20:40 -0400
Received: by mail-pg1-f202.google.com with SMTP id n7so513866pgr.12
        for <linux-crypto@vger.kernel.org>; Tue, 02 Jul 2019 18:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=5pef2FmAnlM+QWRsh4dTLRGQILNCjv4NmeuYpQBmgEA=;
        b=HFTGEtAH+TiPSW0rjw3Mi+iJdcR98StRYDiH88gvvbwa6f/D0j8dTS7RXBv9w26MId
         SfRPUxiljRg2yh/fQ558NrAbM/8elfRqhcdJN7x+tYTwZLmQF5OP8LhDnGk7JqPqjWLv
         tqLWCH1zVSyWQScYIQqJvuxzO8AIdqWbBGpEyzdKtT6f9cPh27ACMxAYZDSz5AapvhWu
         rT73tfO1uup3LaVGb7e/lEjey5r3LN2IyH48iSwKeg5xGL3gNg9GazedobtHrspjH//R
         4XAHipiFE8qrM8hVBXabL16ovb1CDR1dB9xbE+1QJMlpZrm++PKrVQMqTtvTBrSWkrWZ
         sjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=5pef2FmAnlM+QWRsh4dTLRGQILNCjv4NmeuYpQBmgEA=;
        b=SIHEKodz/ptKajeVJd6llmvlVq7vRDxe61mpebVxUb7Z8N0W+yHuDGYEWvSdc7ghbE
         oVQAvhqgA2b//ReJc7zebFMhorMKiNFTIIrgDphuI0NnBe1YBYnHJdKL7M8NAFZFgavQ
         alDizK4GpkSfM2oIXQyGKo56E6iRIUk0KIvOYpKEO8c9Rff61kacKJtFVyKUAD037y5G
         fXg+MGBZUsMBT24V235NgjFoVvLjah5kfXD72YosOe/GGQmDiatE5XrV92RWXXtgbl1O
         YjonHpGcmps8mwRDS/VKEVxRAirbWDuYpRLX5upfql/Pi2yry4qLkwIDtvlykp2HiEG2
         YXXw==
X-Gm-Message-State: APjAAAVHWUZfjiFlTolTu8GnjZvjwo+rqvQX8zlNRoP2KTrcKH1o8lQm
        4SKHSYPV6VRwgiqYT+F7fe3GR0UfqwbZ1hI=
X-Google-Smtp-Source: APXvYqyGy2X1QyFInWll9cR9+qCKZirNRmZ7tB0RIVjS53rewNqC45t5w4HsIlrc5nNmfd1XHbj1RJqDHbSXSc0=
X-Received: by 2002:a63:e250:: with SMTP id y16mr32019623pgj.392.1562105829343;
 Tue, 02 Jul 2019 15:17:09 -0700 (PDT)
Date:   Tue,  2 Jul 2019 15:16:02 -0700
Message-Id: <20190702221602.120879-1-hannahpan@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH] crypto: testmgr - add tests for lzo-rle
From:   Hannah Pan <hannahpan@google.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Cc:     Dave Rodgman <dave.rodgman@arm.com>,
        Hannah Pan <hannahpan@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add self-tests for the lzo-rle algorithm.

Signed-off-by: Hannah Pan <hannahpan@google.com>
---
 crypto/testmgr.c | 10 ++++++
 crypto/testmgr.h | 80 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 658a7eeebab2..c8a2fd96384d 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4437,6 +4437,16 @@ static const struct alg_test_desc alg_test_descs[] = {
 				.decomp = __VECS(lzo_decomp_tv_template)
 			}
 		}
+	}, {
+		.alg = "lzo-rle",
+		.test = alg_test_comp,
+		.fips_allowed = 1,
+		.suite = {
+			.comp = {
+				.comp = __VECS(lzorle_comp_tv_template),
+				.decomp = __VECS(lzorle_decomp_tv_template)
+			}
+		}
 	}, {
 		.alg = "md4",
 		.test = alg_test_hash,
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 1fdae5993bc3..e7f71df2386e 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -32454,6 +32454,86 @@ static const struct comp_testvec lzo_decomp_tv_template[] = {
 	},
 };
 
+static const struct comp_testvec lzorle_comp_tv_template[] = {
+	{
+		.inlen	= 70,
+		.outlen	= 59,
+		.input	= "Join us now and share the software "
+			"Join us now and share the software ",
+		.output	= "\x11\x01\x00\x0d\x4a\x6f\x69\x6e"
+			  "\x20\x75\x73\x20\x6e\x6f\x77\x20"
+			  "\x61\x6e\x64\x20\x73\x68\x61\x72"
+			  "\x65\x20\x74\x68\x65\x20\x73\x6f"
+			  "\x66\x74\x77\x70\x01\x32\x88\x00"
+			  "\x0c\x65\x20\x74\x68\x65\x20\x73"
+			  "\x6f\x66\x74\x77\x61\x72\x65\x20"
+			  "\x11\x00\x00",
+	}, {
+		.inlen	= 159,
+		.outlen	= 133,
+		.input	= "This document describes a compression method based on the LZO "
+			"compression algorithm.  This document defines the application of "
+			"the LZO algorithm used in UBIFS.",
+		.output	= "\x11\x01\x00\x2c\x54\x68\x69\x73"
+			  "\x20\x64\x6f\x63\x75\x6d\x65\x6e"
+			  "\x74\x20\x64\x65\x73\x63\x72\x69"
+			  "\x62\x65\x73\x20\x61\x20\x63\x6f"
+			  "\x6d\x70\x72\x65\x73\x73\x69\x6f"
+			  "\x6e\x20\x6d\x65\x74\x68\x6f\x64"
+			  "\x20\x62\x61\x73\x65\x64\x20\x6f"
+			  "\x6e\x20\x74\x68\x65\x20\x4c\x5a"
+			  "\x4f\x20\x2a\x8c\x00\x09\x61\x6c"
+			  "\x67\x6f\x72\x69\x74\x68\x6d\x2e"
+			  "\x20\x20\x2e\x54\x01\x03\x66\x69"
+			  "\x6e\x65\x73\x20\x74\x06\x05\x61"
+			  "\x70\x70\x6c\x69\x63\x61\x74\x76"
+			  "\x0a\x6f\x66\x88\x02\x60\x09\x27"
+			  "\xf0\x00\x0c\x20\x75\x73\x65\x64"
+			  "\x20\x69\x6e\x20\x55\x42\x49\x46"
+			  "\x53\x2e\x11\x00\x00",
+	},
+};
+
+static const struct comp_testvec lzorle_decomp_tv_template[] = {
+	{
+		.inlen	= 133,
+		.outlen	= 159,
+		.input	= "\x00\x2b\x54\x68\x69\x73\x20\x64"
+			  "\x6f\x63\x75\x6d\x65\x6e\x74\x20"
+			  "\x64\x65\x73\x63\x72\x69\x62\x65"
+			  "\x73\x20\x61\x20\x63\x6f\x6d\x70"
+			  "\x72\x65\x73\x73\x69\x6f\x6e\x20"
+			  "\x6d\x65\x74\x68\x6f\x64\x20\x62"
+			  "\x61\x73\x65\x64\x20\x6f\x6e\x20"
+			  "\x74\x68\x65\x20\x4c\x5a\x4f\x2b"
+			  "\x8c\x00\x0d\x61\x6c\x67\x6f\x72"
+			  "\x69\x74\x68\x6d\x2e\x20\x20\x54"
+			  "\x68\x69\x73\x2a\x54\x01\x02\x66"
+			  "\x69\x6e\x65\x73\x94\x06\x05\x61"
+			  "\x70\x70\x6c\x69\x63\x61\x74\x76"
+			  "\x0a\x6f\x66\x88\x02\x60\x09\x27"
+			  "\xf0\x00\x0c\x20\x75\x73\x65\x64"
+			  "\x20\x69\x6e\x20\x55\x42\x49\x46"
+			  "\x53\x2e\x11\x00\x00",
+		.output	= "This document describes a compression method based on the LZO "
+			"compression algorithm.  This document defines the application of "
+			"the LZO algorithm used in UBIFS.",
+	}, {
+		.inlen	= 59,
+		.outlen	= 70,
+		.input	= "\x11\x01\x00\x0d\x4a\x6f\x69\x6e"
+			  "\x20\x75\x73\x20\x6e\x6f\x77\x20"
+			  "\x61\x6e\x64\x20\x73\x68\x61\x72"
+			  "\x65\x20\x74\x68\x65\x20\x73\x6f"
+			  "\x66\x74\x77\x70\x01\x32\x88\x00"
+			  "\x0c\x65\x20\x74\x68\x65\x20\x73"
+			  "\x6f\x66\x74\x77\x61\x72\x65\x20"
+			  "\x11\x00\x00",
+		.output	= "Join us now and share the software "
+			"Join us now and share the software ",
+	},
+};
+
 /*
  * Michael MIC test vectors from IEEE 802.11i
  */
-- 
2.22.0.410.gd8fdbe21b5-goog

