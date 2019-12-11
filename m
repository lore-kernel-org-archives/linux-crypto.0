Return-Path: <SRS0=IyTV=2B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57307C43603
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:41:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A87E222C4
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Dec 2019 08:41:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="sypZYZzi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbfLKIls (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Dec 2019 03:41:48 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:41036 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728300AbfLKIls (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Dec 2019 03:41:48 -0500
Received: by mail-pg1-f193.google.com with SMTP id x8so10426026pgk.8;
        Wed, 11 Dec 2019 00:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSnofsroC3q0Bz8ZT6LbzRALYay3vg5tkKr0icagGfk=;
        b=sypZYZziLS/YcWob4MchGqcycarvQZxMn1mSMGNavUXnuWQI15mU3JGLc0COr8rNfa
         S+x47EZAWcs5BUYfMPqdssiYJVBOrvSDUCVXCTBPRXVATsss+XcCggIYD5ExhI6C23sP
         IpjDo8WjUaAVIwOkJsbOzF323dESHRNZanM0WrgrlnnkT0EaG9InnfNmbuJHMwiXZPHd
         DajBDlkcloEhOJdhq1l/qHuRKBvS2gtLH2+IkvgUTugKnpUwUq2sCFG6/o8J4B0wX5/M
         QII848BqsJJfF5pRqejJVwKftsk7ZCosaHKbVD7MWdFn5qOH9ahs+DEYPluSnUFViw5P
         KuQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSnofsroC3q0Bz8ZT6LbzRALYay3vg5tkKr0icagGfk=;
        b=SUL/a58sKEaYW1CAyBRm00Y5b6VJAdB6JqtcquBuxpB6B4ZXztEL5xLneWy/7omfCy
         gzij/EVYDABljSifXLfTkn1o3d7H5QfRlXQFuV+P4RMKSMNyH9LMXnCQhU1A8PkzHEKm
         9c6HtbLmRaGPqpsjtg1Tv075o15tp2GHuHhg1GfKDibWmAAvFOUoUu1Jr5lmsViqapC7
         moer6r1GteVu2RAPPfytTvXFnVRVQzPXMu8NkKjsMiJi5I5Fxs/X7tZzS4JXSGPlkBUq
         GuY8PsfdV66yNlElFlq2qjr5br0i//DZUcRTE6KfD0JZIsVc5FoCur4ofPIyd2FopE2C
         KINw==
X-Gm-Message-State: APjAAAXoY/HcjXrvkPARuglBKu6MOaR9gwL0mA0mW6cvmVLsvOrUB+J6
        DkT9yQkL6dwNrt5ZlGYVeJE=
X-Google-Smtp-Source: APXvYqxLtckOJJeAP+OJm1gWfjjRej8ZWHqTmg1NF79cWSx/7GSvheeLLtEy9ENMm0+iJkCsWsKRfQ==
X-Received: by 2002:a62:ee0c:: with SMTP id e12mr2595374pfi.38.1576053707552;
        Wed, 11 Dec 2019 00:41:47 -0800 (PST)
Received: from localhost.localdomain ([103.51.73.137])
        by smtp.gmail.com with ESMTPSA id e16sm1806233pgk.77.2019.12.11.00.41.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 00:41:47 -0800 (PST)
From:   Anand Moon <linux.amoon@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Corentin Labbe <clabbe@baylibre.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCHv1 2/3] dt-bindings: crypto: Add compatible string for amlogic GXBB SoC
Date:   Wed, 11 Dec 2019 08:41:11 +0000
Message-Id: <20191211084112.971-3-linux.amoon@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191211084112.971-1-linux.amoon@gmail.com>
References: <20191211084112.971-1-linux.amoon@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add a compatible string to support cryto controller for Amlogic GXBB SoC.

Cc: Corentin Labbe <clabbe@baylibre.com>
Cc: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Signed-off-by: Anand Moon <linux.amoon@gmail.com>
---
 Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
index 5becc60a0e28..be0c3f73a9cd 100644
--- a/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
+++ b/Documentation/devicetree/bindings/crypto/amlogic,gxl-crypto.yaml
@@ -12,6 +12,7 @@ maintainers:
 properties:
   compatible:
     items:
+    - const: amlogic,gxbb-crypto
     - const: amlogic,gxl-crypto
 
   reg:
-- 
2.24.0

