Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5356FC6194
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 10:13:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB4B6214DB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 10:13:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="PXCijcCc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbfKHKNS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 05:13:18 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42132 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729873AbfKHKNS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 05:13:18 -0500
Received: by mail-wr1-f67.google.com with SMTP id a15so6328105wrf.9
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 02:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=cU3L2BBWe8lA2LWE7gRXOVYyqfxgb1FEIKhotYOu9Xk=;
        b=PXCijcCcFDJnq59ddsvYjds27Zng22aFdWDWqJdpNGJIMHInEgrmbDnllDSDlpseVv
         ndv7yrifX9deROcU0bVxOwT22xYXQu9hh3qu6HtK1LKytptdkfMwhiOLlxuozEs7fDX7
         ekcbINwgFnIB1f3PYGXxtvrsVTGVqwc9fO4FE6rLLPlcMsXG0LdGB3K20jbqhsO8+Izr
         ZO9nT9X73Ks4swESUuATZx0VOTBixpPG8QnDSKKc6TEjkDIxbZpUc9BWOEOymq2lQzur
         n5SxVbKa15+zLCTN+BvD9PsOP91lfz5uW/edkJ5CODwQsSuAlsIX8dO85SkJcJC9o7z0
         WKjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cU3L2BBWe8lA2LWE7gRXOVYyqfxgb1FEIKhotYOu9Xk=;
        b=sI0ybSX9MkGRxTZNrpnMYYncJesn3osjYK2GoMJIiYUg93veHPtaJT6PsBvgVTpwI6
         4A9AGxjBfIELu03cL5IjfwRKcRfPGhNzeZfRDQDKf6QTxwUMz7hiGQEnbwml5srOXahL
         lF6PWS+xo3BP7xrLJZpcWLMpGrA0OaqHS+x9xBY2AcjYmDt91FB0SUaBp12mQrae1i/Y
         lkfHWujYeDbRTAZ6EFle5wBInKKKhkqCViOyP4C9Z97HkmrMUgjgBKDN9ksbljinSq1n
         HAD9Ox+fWN+JBNKFfHBqCxiok4boN0J4BGkVGdZJrdV1mcRFC9btPKKGh/egkWXGLpXa
         Z72g==
X-Gm-Message-State: APjAAAXO0n6D9Qa0APEnx6/FiktjmvOoAYpjwmHWIIYgtzbOueaYKeQg
        Gn9B6HyhVtMAIxRls/p2JoO0Ag==
X-Google-Smtp-Source: APXvYqy54qoamMo6mHEiIaRis19DIgx8N4yy7Hc7RiXAPhgRu6JpxysgeEp8fI0vT1GFn/Qpj7mQfg==
X-Received: by 2002:adf:f4c9:: with SMTP id h9mr7041901wrp.354.1573207995337;
        Fri, 08 Nov 2019 02:13:15 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id a11sm5762163wmh.40.2019.11.08.02.13.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 02:13:14 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     herbert@gondor.apana.org.au
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] MAINTAINERS: add linux-amlogic list for amlogic crypto
Date:   Fri,  8 Nov 2019 10:13:06 +0000
Message-Id: <1573207986-26787-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The linux-amlogic mailing list need to be in copy of all patch for the amlogic crypto.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index c4c532c70b86..ec1c71dba03d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1488,6 +1488,7 @@ N:	meson
 ARM/Amlogic Meson SoC Crypto Drivers
 M:	Corentin Labbe <clabbe@baylibre.com>
 L:	linux-crypto@vger.kernel.org
+L:	linux-amlogic@lists.infradead.org
 S:	Maintained
 F:	drivers/crypto/amlogic/
 F:	Documentation/devicetree/bindings/crypto/amlogic*
-- 
2.23.0

