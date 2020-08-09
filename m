Return-Path: <SRS0=r3hN=BT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CF0C433E0
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Aug 2020 15:04:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49C32206B2
	for <linux-crypto@archiver.kernel.org>; Sun,  9 Aug 2020 15:04:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MKtuhae+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHIPEg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 9 Aug 2020 11:04:36 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36358 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726507AbgHIPEd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Aug 2020 11:04:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596985472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=FuXqqlyBLIh85DO5/avWuTbEGQOdsQUAzmArktoPV3E=;
        b=MKtuhae+pF23MamyWE0rsIZun/wJQI4/3jCx81nkfQgbBkUVa152MvQ03+gLh9HDGRFXcX
        1ectv1sgTw56yxS4hGwLHG6Voi19a1aKBdxn6fp30UEWWuit/z+Q5GAGkJz9+hrerkeVal
        fEAolXxvad8KPCXwFFd19NAqYkyCZHI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-418-fRTXvzCEM7WQ-KvTl1GfNQ-1; Sun, 09 Aug 2020 11:04:30 -0400
X-MC-Unique: fRTXvzCEM7WQ-KvTl1GfNQ-1
Received: by mail-qt1-f200.google.com with SMTP id m13so5710230qth.16
        for <linux-crypto@vger.kernel.org>; Sun, 09 Aug 2020 08:04:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=FuXqqlyBLIh85DO5/avWuTbEGQOdsQUAzmArktoPV3E=;
        b=b90QH3/ZKjz9ybYkXaBm4JT+1vG/N5oERxSR/8ZkfVDyT76UIB0WDDt6UyEp95DgDR
         DkoNak0U28OWuFtLH2B1iyJrxtPfqNSQlqdIM5ob+856Ayl4rHS/3T0lOSvxHdmPZAfE
         cn+MKi/danw5tSkMqYni91B5EhtDWfPTUboqNPbLKtNGITRx5TSvrkxwAVsGYokyRec0
         eK/GDqBUjMu9E5QzZiGR+5+67WYIiSoRoeTHqZ580mAmAlAjoQmREm0I238nVzP6PniQ
         RJzP0xJpIQsTg+A0pZDubd5oZywNrpIhAkc9VzBgRC4BdMAmwedRD9ifJ+ryNYgMCKIy
         MMYw==
X-Gm-Message-State: AOAM532oQeDoIR2W0X2ayRrKWjPb7mA+Yn9XDmzwdxu7RzbDPu9l746x
        FcmtGCQvNVpbwbKNiqL+NlM3LeCCMk9cGHxgC0a+zSt0Ko0Ph3Uw72uzLus0cPZQ3L9Wxkv3Ly6
        O46K0TikbrSaaeFfcF6nuox/9
X-Received: by 2002:ad4:52e3:: with SMTP id p3mr24354569qvu.70.1596985469796;
        Sun, 09 Aug 2020 08:04:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzwhusDKO/YhHzoC56SKWKm7gS4s2SkPT/PI9PLLl8Yf4JlkBUQcMSrM8EoXGJTMRGCr1kbtg==
X-Received: by 2002:ad4:52e3:: with SMTP id p3mr24354553qvu.70.1596985469573;
        Sun, 09 Aug 2020 08:04:29 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id n33sm11389118qtd.43.2020.08.09.08.04.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Aug 2020 08:04:29 -0700 (PDT)
From:   trix@redhat.com
To:     mpm@selenic.com, herbert@gondor.apana.org.au, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] hwrng : cleanup initialization
Date:   Sun,  9 Aug 2020 08:04:23 -0700
Message-Id: <20200809150423.31557-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

intel-rng.c:333:2: warning: Assigned value is garbage or undefined
        void __iomem *mem = mem;
        ^~~~~~~~~~~~~~~~~   ~~~

Because mem is assigned before it is used, this is not
a real problem.  But the initialization is strange and not
needed, so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/char/hw_random/intel-rng.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 9f205bd1acc0..eb7db27f9f19 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -330,7 +330,7 @@ static int __init mod_init(void)
 	int err = -ENODEV;
 	int i;
 	struct pci_dev *dev = NULL;
-	void __iomem *mem = mem;
+	void __iomem *mem;
 	u8 hw_status;
 	struct intel_rng_hw *intel_rng_hw;
 
-- 
2.18.1

