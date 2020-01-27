Return-Path: <SRS0=Q+7j=3Q=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684EAC33CB7
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D865214D8
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jan 2020 16:57:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rkeYz8H9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgA0Q5M (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 11:57:12 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:56073 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0Q5K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 11:57:10 -0500
Received: by mail-pj1-f65.google.com with SMTP id d5so3172128pjz.5;
        Mon, 27 Jan 2020 08:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y820Lp2M/a5OhA2vLH1uw/txeBMDoNX2HSIoVGLcKRY=;
        b=rkeYz8H9ByzmIZ/+BUIIXj3MuldJXN0xDafK/yD7IaJlWrNmw0ax8iEbv/d7yHS3UU
         JULrp1Z27UYjL0LlrPm3XT5fgVmhwrAwu4C0GPHWBIsF8rlBpjB+2xVF6A3U3YzZwdhf
         yqLNmDBWFdcrZOMZH6yZkbkiFziA5X5n542IlkcVPZJV7sj0zWaQh/6hDugDPT6Ifv0e
         6jWh6LaH1A4hQhRtQmVbgvoyYobC4/3Krd0Fmy9pUBMKZ+nWax+caO4dRo3zHAoQS2dz
         ai+7XRy34bgJGTc92nIgANvToQ40RTuQZXnfEwk4ulg8SD26gRL3li0Z1V5ataFLtd2A
         TfCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y820Lp2M/a5OhA2vLH1uw/txeBMDoNX2HSIoVGLcKRY=;
        b=gpVu61cxb7vpNIi9rByLkVsj8wthAc3wq6glpmG7bhDyHxvHGEp/SxOvcUvtHC0enj
         YZPqEOcfiwM5b8iXCpVOgMtfqBPeIqqbuGPItWL3PGqkgA038gmr4trjMAFnJyeB62O+
         cYN41mtSNB6BFcfZzpp3Alg7eE+/fyw6lCTLNq8faValagBpmXp2ZaiC9E3sR6IBRYUW
         CKCL8F6qoupda51aETUvNgotx8hMEhCrTqv1e2U8ht2A2QAT6IOqden2kqbtD9i5SXER
         Yf4jCUAlb5QctgaiHV0rbHoDLw3tcUaLSUoECne2HbuZPRdu/DEPOOKDA2N/ugBsFP5s
         3TOg==
X-Gm-Message-State: APjAAAW7rEClKK45DIkz1PMpGhY5RUub/GHXv1TK47XlxXbKK1gom5sh
        xGPXZomrOBvhqVV/2oU8uZiDnf/U
X-Google-Smtp-Source: APXvYqxTj85P9NypyXFitpnioyZBt5er1aZDrGKs3oXQUgNJpVopnFxNW3w1k7b7yxVZxIpqhzKxZQ==
X-Received: by 2002:a17:902:8341:: with SMTP id z1mr18050363pln.178.1580144229226;
        Mon, 27 Jan 2020 08:57:09 -0800 (PST)
Received: from localhost.localdomain (c-67-165-113-11.hsd1.wa.comcast.net. [67.165.113.11])
        by smtp.gmail.com with ESMTPSA id u23sm16368642pfm.29.2020.01.27.08.57.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 08:57:08 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        linux-kernel@vger.kernel.org, linux-imx@nxp.com
Subject: [PATCH v7 3/9] crypto: caam - use devm_kzalloc to allocate JR data
Date:   Mon, 27 Jan 2020 08:56:40 -0800
Message-Id: <20200127165646.19806-4-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20200127165646.19806-1-andrew.smirnov@gmail.com>
References: <20200127165646.19806-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use devm_kzalloc() to allocate JR data in order to make sure that it
is initialized consistently every time.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-imx@nxp.com
---
 drivers/crypto/caam/jr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc97cde27059..a627de959b1e 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -505,7 +505,7 @@ static int caam_jr_probe(struct platform_device *pdev)
 	int error;
 
 	jrdev = &pdev->dev;
-	jrpriv = devm_kmalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
+	jrpriv = devm_kzalloc(jrdev, sizeof(*jrpriv), GFP_KERNEL);
 	if (!jrpriv)
 		return -ENOMEM;
 
-- 
2.21.0

