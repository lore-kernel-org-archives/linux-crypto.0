Return-Path: <SRS0=EVKT=6F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9493C2BA19
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 07:41:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6022073A
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Apr 2020 07:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587454896;
	bh=zh2H7DRySG6m96/3f26C5OxmbKDqup5V8vk5fUcSMS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=O/g9r3LOppV8M3mI+FcP1QNdk69wDFA9PQbf7b7DZO2kTpWcJccLbW3h3y0FjH8n+
	 67D49DZcCja3jErR0j/QDKHbTfxyD3zW3aPcvMOv1B1zlxK0wjQIm5+/DYE+XqDk+h
	 kFF/I3P0uRWJ57Bie1kN39+ic8rJsLPlhO73pmzo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726931AbgDUHlg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Apr 2020 03:41:36 -0400
Received: from conuserg-08.nifty.com ([210.131.2.75]:30981 "EHLO
        conuserg-08.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgDUHlf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Apr 2020 03:41:35 -0400
Received: from oscar.flets-west.jp (softbank126090202047.bbtec.net [126.90.202.47]) (authenticated)
        by conuserg-08.nifty.com with ESMTP id 03L7dstU022941;
        Tue, 21 Apr 2020 16:39:56 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-08.nifty.com 03L7dstU022941
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1587454796;
        bh=hDth+M9ZwaPqBRV2FRAMHf1NN8+Bjd7sx4+asoEQ3Z8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1pOuLkiIr2qBPM7IIf4OwT/D3ZBko3CDnFRxbu/c707moGDSsxMYC5RJV0yRQJcwg
         mzgohE2T51XMqWv3YTiYa3CdCt06kW2f1DvdI+8c+BSI3pxjaLAaaHxwaXndJaV3Kq
         NLF9vKCBXhVttQg17c9NaRdA++jny+U951ZKqNhggU6asiERorX26VaGny51LAsP0f
         e+OhCRAeln38aZKlleLG5r0+/VXvH0rT/iqSSZHgS9Ym5LY8dAwBUDvZz6Oc4EPytV
         RIAiEURY8NPwSslZuc8LI9iNoBFP/pIZuu3OlBo7tG5iuMZIxzLZWsbd9muMfzvq31
         qqsObdt9Ycecg==
X-Nifty-SrcIP: [126.90.202.47]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     x86@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>
Cc:     "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] raid6/algos.c: refactor raid6_algos array for x86
Date:   Tue, 21 Apr 2020 16:39:47 +0900
Message-Id: <20200421073947.586662-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421073947.586662-1-masahiroy@kernel.org>
References: <20200421073947.586662-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Factor out the common pointer references.

Common for i386 and x86_64:
  raid6_avx512x2
  raid6_avx512x1
  raid6_avx2x2
  raid6_avx2x1
  raid6_sse2x2
  raid6_sse2x1
  raid6_sse1x2

Only for i386:
  raid6_sse1x1
  raid6_mmxx2
  raid6_mmxx1

Only for x86_64:
  raid6_avx512x4
  raid6_avx2x4
  raid6_sse2x4

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 lib/raid6/algos.c | 24 ++++++++++--------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 978fa19efbbf..c0f2fd6e0621 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -30,32 +30,28 @@ EXPORT_SYMBOL_GPL(raid6_call);
 
 const struct raid6_calls * const raid6_algos[] = {
 #ifdef CONFIG_X86
-#if defined(CONFIG_X86_32)
 #ifdef CONFIG_AS_AVX512
-	&raid6_avx512x2,
-	&raid6_avx512x1,
-#endif
-	&raid6_avx2x2,
-	&raid6_avx2x1,
-	&raid6_sse2x2,
-	&raid6_sse2x1,
-	&raid6_sse1x2,
-	&raid6_sse1x1,
-	&raid6_mmxx2,
-	&raid6_mmxx1,
-#endif
 #if defined(CONFIG_X86_64)
-#ifdef CONFIG_AS_AVX512
 	&raid6_avx512x4,
+#endif
 	&raid6_avx512x2,
 	&raid6_avx512x1,
 #endif
+#ifdef CONFIG_X86_64
 	&raid6_avx2x4,
+#endif
 	&raid6_avx2x2,
 	&raid6_avx2x1,
+#ifdef CONFIG_X86_64
 	&raid6_sse2x4,
+#endif
 	&raid6_sse2x2,
 	&raid6_sse2x1,
+	&raid6_sse1x2,
+#ifdef CONFIG_X86_32
+	&raid6_sse1x1,
+	&raid6_mmxx2,
+	&raid6_mmxx1,
 #endif
 #endif /* CONFIG_X86 */
 #ifdef CONFIG_ALTIVEC
-- 
2.25.1

