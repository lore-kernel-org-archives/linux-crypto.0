Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8700C04A6B
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CFCC21479
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:32:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qYzl9fLU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEJRcA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 13:32:00 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:40961 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJRb7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 13:31:59 -0400
Received: by mail-ed1-f66.google.com with SMTP id m4so6121141edd.8;
        Fri, 10 May 2019 10:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=w7FukaSOWmU1MZzQqS+AmxHZTAQNw2SrsDsc9k5kRs0=;
        b=qYzl9fLUzXiEcDEudYYZG9z4EZzyB0fYZl4wq9mDCOi5OFRQiD0vtS7yehPbo7lCbI
         UC988nHKI4i+dJI6WNij5/63TbO4pVnAXWTLklylRyFefzKmNQdMJV6Qe3tfy8nKysV2
         Aqv2+guc+GqFEtY68R5BmfH0ZTURhyoHUL3TuoB9pWtVHOJAtisz3iwkyIl0xckxXy3v
         B+PJ4qWr+iBFwl3fsX5wydly9fxxLRoD6HucLGxAeVCLSy1ThUwuwIfbYoJruY3kEZfH
         A1JvDtzTSXf6JBBYvergPvsZOVdZbDgK8f2+baIbvdaU7jd03u6VqIEtGxJWj6rm3DRi
         ViAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=w7FukaSOWmU1MZzQqS+AmxHZTAQNw2SrsDsc9k5kRs0=;
        b=LNVGmLVu/hlk8P5DAfphfEK5Ve7Z71t0RAwpqcgYvQRc3dBdak1zIOoDo77K6em8yg
         jRD34S8HcinVBH24JEzLTQKhTit0/dSZDmRWzy2WQ2cKpL/15uu5/blXP9eXlas+lGXK
         ZyxVnsSmxeULNr8OxK8/7ajgmQsg5CUXBEtt04koNy4XzBs+/mJjDb+PdgACkB2Ka6Qs
         5p5Jyuq1ACa10M0GLi/pGySWdS5f44MsJsgNZtc+V/8RJEvwIX9Q08G8B8M0uYT7+r/y
         wkvfkz/8DkhyWS3cedJAPvjz0DzhT5ti7o3Mg3WFbMS2t7LJWd8MfDzR0O5fm9wNjpST
         tQzw==
X-Gm-Message-State: APjAAAXcEk2oZ7wWTsJ8AOWRCqZLw2ybF6xmxlaI6aHgs/zBXl/K/+jk
        96HTrtoXV3FjG0p17G8d3VFNcDnM
X-Google-Smtp-Source: APXvYqxA/71Z6cfoww2mIZJyYH2jEGbUgRiMBIJC+7SOpG/Sa9uTAE+AGJ6aHz6MVd7YP755lBdqTQ==
X-Received: by 2002:a17:906:3955:: with SMTP id g21mr9629259eje.61.1557509517569;
        Fri, 10 May 2019 10:31:57 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id v16sm1599567edm.56.2019.05.10.10.31.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 10:31:56 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, stefan.wahren@i2se.com,
        wahrenst@gmx.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, mpm@selenic.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH 1/2] dt-bindings: rng: Document BCM7211 RNG compatible string
Date:   Fri, 10 May 2019 10:31:10 -0700
Message-Id: <20190510173112.2196-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190510173112.2196-1-f.fainelli@gmail.com>
References: <20190510173112.2196-1-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM7211 features a RNG200 block, document its compatible string.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
index 0014da9145af..c223e54452da 100644
--- a/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
+++ b/Documentation/devicetree/bindings/rng/brcm,iproc-rng200.txt
@@ -2,6 +2,7 @@ HWRNG support for the iproc-rng200 driver
 
 Required properties:
 - compatible : Must be one of:
+	       "brcm,bcm7211-rng200"
 	       "brcm,bcm7278-rng200"
 	       "brcm,iproc-rng200"
 - reg : base address and size of control register block
-- 
2.17.1

