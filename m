Return-Path: <SRS0=MzAP=55=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE209C2BA2B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 19:52:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACDC7206DA
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Apr 2020 19:52:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q0dRq4el"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388144AbgDMTwA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Apr 2020 15:52:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388140AbgDMTv7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Apr 2020 15:51:59 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF090C0A3BDC;
        Mon, 13 Apr 2020 12:51:57 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id l21so4782850otd.9;
        Mon, 13 Apr 2020 12:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/SNyg00K2RwmSQDXWhtQELp/kcSR3KGW1LXJbdnOpQ=;
        b=Q0dRq4ely6RLAhSX1StR+9Jf6tB4Yl0Ok6oR0atbLDcb1iA2l0vmDteomZyJ+dSL/Y
         XN7LVUBsBQc2bT7C+rsDXdoB4vcCqbmZe0gOV/JqE8EXsdzLcrWi2PPQoA+pfMpKqy3c
         iQufiEA8rCbCz11dbUWli0jZiyDSBAjzSA7irsk4EqXsKrl+PaifM+/YbhXw8zf/OLwM
         TFLvOP0UtL1VOuHsn6PRo52Jg2slpcEYsrli+mIajGYDQZoVryZXRUCH8lsi1H6g6bJs
         m6voCiHeABFVW+ZjC6xogpek8bqMjnmhiUTuvFHqW3lf+Z0hVUi0a+OOsgkKv66Q9MNs
         ZSNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/SNyg00K2RwmSQDXWhtQELp/kcSR3KGW1LXJbdnOpQ=;
        b=A9I3w5NZmyzbZmM5U9GpSd4qIiNgKFkAeE06nxHb01ApJ1Y9aFc2QpB3Z+M7/5nNLF
         osDoyAow7Mg9yWKDOdxnDQzwEViW8iBJto58WPBakkfQ7E0+GX+YC5QFFRev1JFBlhT7
         jwcwIpWn0YrOc0XJCfPmDNktldUQI304vgUE9TCdp4Dr+vvOh9V/7+C8LfhtoMuewAtu
         QuqC8TjwsaVpo5F9h9pZKABt2Dcp0ndW6xoL1pwVG11DImInSVzKdfm1uf4Ek0SIMOJ/
         wk2slJ2Fp40f1XJkSI44xfb5qxo8ab5P7Pni2xNhQHvNqMj4HZSR89yx+AfnsL2mYvg1
         3xXA==
X-Gm-Message-State: AGi0PuYm19YcOtIktcnxNDz4YMvIbZqXMWZsibQpZ9lGTL0m1QWUfzUQ
        r7xTdu4U/nF5mxx69K+zdGs=
X-Google-Smtp-Source: APiQypKcyBXUAjalJbfVVO3djNnYHVDw1NxMcM9ZBwADCdMrg+lhgj5MBPG1RZm/TdnV09v9osC1lQ==
X-Received: by 2002:a4a:95ee:: with SMTP id p43mr15297173ooi.24.1586807517032;
        Mon, 13 Apr 2020 12:51:57 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::3])
        by smtp.gmail.com with ESMTPSA id t193sm5062852oif.34.2020.04.13.12.51.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 12:51:56 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        kbuild test robot <lkp@intel.com>
Subject: [PATCH] lib/mpi: Fix building for powerpc with clang
Date:   Mon, 13 Apr 2020 12:50:42 -0700
Message-Id: <20200413195041.24064-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

0day reports over and over on an powerpc randconfig with clang:

lib/mpi/generic_mpih-mul1.c:37:13: error: invalid use of a cast in a
inline asm context requiring an l-value: remove the cast or build with
-fheinous-gnu-extensions

Remove the superfluous casts, which have been done previously for x86
and arm32 in commit dea632cadd12 ("lib/mpi: fix build with clang") and
commit 7b7c1df2883d ("lib/mpi/longlong.h: fix building with 32-bit
x86").

Reported-by: kbuild test robot <lkp@intel.com>
Link: https://github.com/ClangBuiltLinux/linux/issues/991
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Herbet seems to take lib/mpi patches but there does not seem to be a
formal maintainer so Michael could take it since it is just a powerpc
thing.

 lib/mpi/longlong.h | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/lib/mpi/longlong.h b/lib/mpi/longlong.h
index 2dceaca27489..891e1c3549c4 100644
--- a/lib/mpi/longlong.h
+++ b/lib/mpi/longlong.h
@@ -722,22 +722,22 @@ do {									\
 do { \
 	if (__builtin_constant_p(bh) && (bh) == 0) \
 		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{aze|addze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"%r" ((USItype)(al)), \
 		"rI" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
 		__asm__ ("{a%I4|add%I4c} %1,%3,%4\n\t{ame|addme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"%r" ((USItype)(al)), \
 		"rI" ((USItype)(bl))); \
 	else \
 		__asm__ ("{a%I5|add%I5c} %1,%4,%5\n\t{ae|adde} %0,%2,%3" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "%r" ((USItype)(ah)), \
 		"r" ((USItype)(bh)), \
 		"%r" ((USItype)(al)), \
@@ -747,36 +747,36 @@ do { \
 do { \
 	if (__builtin_constant_p(ah) && (ah) == 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfze|subfze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(ah) && (ah) == ~(USItype) 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{sfme|subfme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{ame|addme} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else if (__builtin_constant_p(bh) && (bh) == ~(USItype) 0) \
 		__asm__ ("{sf%I3|subf%I3c} %1,%4,%3\n\t{aze|addze} %0,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"rI" ((USItype)(al)), \
 		"r" ((USItype)(bl))); \
 	else \
 		__asm__ ("{sf%I4|subf%I4c} %1,%5,%4\n\t{sfe|subfe} %0,%3,%2" \
-		: "=r" ((USItype)(sh)), \
-		"=&r" ((USItype)(sl)) \
+		: "=r" (sh), \
+		"=&r" (sl) \
 		: "r" ((USItype)(ah)), \
 		"r" ((USItype)(bh)), \
 		"rI" ((USItype)(al)), \
@@ -787,7 +787,7 @@ do { \
 do { \
 	USItype __m0 = (m0), __m1 = (m1); \
 	__asm__ ("mulhwu %0,%1,%2" \
-	: "=r" ((USItype) ph) \
+	: "=r" (ph) \
 	: "%r" (__m0), \
 	"r" (__m1)); \
 	(pl) = __m0 * __m1; \

base-commit: 8f3d9f354286745c751374f5f1fcafee6b3f3136
-- 
2.26.0

