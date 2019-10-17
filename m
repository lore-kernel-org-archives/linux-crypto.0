Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52977FA372B
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 05:07:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206CF21D7A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 05:07:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="dRUemVlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393210AbfJQFHA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 01:07:00 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:46024 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388392AbfJQFGq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 01:06:46 -0400
Received: by mail-wr1-f65.google.com with SMTP id r5so672947wrm.12
        for <linux-crypto@vger.kernel.org>; Wed, 16 Oct 2019 22:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NliZFeQ9c/Qq6fBGMoYFeWbfIFjnCeTRD5spAgl/f4s=;
        b=dRUemVlFgZXe06Iwa1cQ+/QjBSoPreZqwAKc8O46K1uwcJqYL9kpym/A6G3uZ7Wt/g
         fF0/XTNYYLnvn4piLEjhJaaEbbs8dh/6vkQufKzNzGb1FrBOaKadnvHCSyoAz2c8r18z
         j3wyPn4tDVMdJMRLBAySsH/LOLg0XFCU+bzoBg7PzCTtHA04gH8Bu33+vSs2+ifUZq6a
         9qrMbPI/0AMXGrQQ0rUetL/vHr3YwsIBoM/B4Blsu/rQt7vyRHPscg3AD9XpeglZaBuZ
         +MiMMBcu0EXQ6eUCy6ST7rlZnvR4jp6t2mbGp4UHWtWKJXzhMRvVfaMOOF+r6cqp6kJc
         fIqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NliZFeQ9c/Qq6fBGMoYFeWbfIFjnCeTRD5spAgl/f4s=;
        b=Y4T1O2w53rRmmAAEXF6BkJ5Jn1AVk2ASgnGcDjpZDyQgrBcF9zWzYcutEn/544Sg4p
         4sW0uoaTBLp+r9glizRji+O/SHmlhzX1+LKuYs99IXARqvLoOwoStmAYjdMu+DtQauaF
         /VE4aiLngSGOYUZJXZzQ6Cyp9/TAqXyhhomgsLLVTkrnMlbfp6B9KucScqmyJXwzlI6f
         Dd0swGyc1IAzizcos1bewZAoGHmxjFEt+cyZaTADKoBesdkrti22YzbW+L4LKDLfdep4
         LGI/f4XBsei3vcDt2BErYdWa6CAG0W/kmP68klD6s7CcxJLFN0YNM9t0dJjr1JvZJfyz
         1I7g==
X-Gm-Message-State: APjAAAV2iMNw/fEYsm8QIn8NRryQDwuV2L+4zWkwwfvR2EkAOwCcoCkY
        N+ZsxLpVFSy3OAAt9ZkTD145MA==
X-Google-Smtp-Source: APXvYqwpWPAmMJBUo0MsFvw9uiPvopqY1tScgpI01QQMpwwHyjbjfcGVRkmhS52RZk9CEfhYTAjmtQ==
X-Received: by 2002:adf:fe81:: with SMTP id l1mr1128594wrr.165.1571288804371;
        Wed, 16 Oct 2019 22:06:44 -0700 (PDT)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id b5sm1010762wmj.18.2019.10.16.22.06.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 16 Oct 2019 22:06:43 -0700 (PDT)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au,
        khilman@baylibre.com, mark.rutland@arm.com, robh+dt@kernel.org
Cc:     devicetree@vger.kernel.org, linux-amlogic@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH v3 2/4] MAINTAINERS: Add myself as maintainer of amlogic crypto
Date:   Thu, 17 Oct 2019 05:06:24 +0000
Message-Id: <1571288786-34601-3-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1571288786-34601-1-git-send-email-clabbe@baylibre.com>
References: <1571288786-34601-1-git-send-email-clabbe@baylibre.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I will maintain the amlogic crypto driver.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2120c74f476a..59e360ca9fe7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1477,6 +1477,13 @@ F:	drivers/soc/amlogic/
 F:	drivers/rtc/rtc-meson*
 N:	meson
 
+ARM/Amlogic Meson SoC Crypto Drivers
+M:	Corentin Labbe <clabbe@baylibre.com>
+L:	linux-crypto@vger.kernel.org
+S:	Maintained
+F:	drivers/crypto/amlogic/
+F:	Documentation/devicetree/bindings/crypto/amlogic*
+
 ARM/Amlogic Meson SoC Sound Drivers
 M:	Jerome Brunet <jbrunet@baylibre.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
-- 
2.21.0

