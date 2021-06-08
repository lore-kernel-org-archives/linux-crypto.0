Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01874C48BE5
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBB30613BA
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhFHV0M (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:26:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60761 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234229AbhFHV0K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jun 2021 17:26:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4gIQrxNh8rCNXWF5A+cmW2C8HVpKFKLZxYRvN1nK0FM=;
        b=Jr7/svOCkP+idGGp2j5KXaTRedqzqzjDCCOP7ygpE49YjHG/9V2DzInoWMCg2MKPDEg56F
        u2TLHSbPAvopasudrgBWm+HyxvagS5XX9tqWO7LP0bSo14Fs+IwSF/RTDheIX3ctks1dYz
        5da907zz6ouqre5Q+gtUWlwgWRnt3Og=
Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com
 [209.85.161.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-349-UXYEbI_7MeCPXD2T3Cp_3Q-1; Tue, 08 Jun 2021 17:24:14 -0400
X-MC-Unique: UXYEbI_7MeCPXD2T3Cp_3Q-1
Received: by mail-oo1-f71.google.com with SMTP id m22-20020a0568200356b0290248e4270f00so11363371ooe.14
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jun 2021 14:24:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4gIQrxNh8rCNXWF5A+cmW2C8HVpKFKLZxYRvN1nK0FM=;
        b=l//hoYLjIyRqK5r04Bf0L6pO64gQ3585MtUl4BJ3kJyQ9zlzSpVHv4FTKMqcC9whe/
         GianG3vfPZb9f4M9XW5439MoJF34mBynRvYTFrv+XxuIC+i3YLVgHKT8V1PrZc9OYhHV
         sa13+naikOnLN4CKISJs8ZH1pp4J0L6NKl4+cdJOl1KP+ZeTaAx0EiLWoUvARWfuFafj
         slM4xWW77aCkov1qIxCmsouyC61RykaDJvcqtYifaST7PSJDMeNF+vqqXQxCEHtpCeyz
         mqUI71KbZpVxduxeW1LvjdF0lFEHX33/B3kaqlbgBe4gbKVUJLmkBSE6rBv9jFv2XDDZ
         9K7w==
X-Gm-Message-State: AOAM532LY4ciogfFsckr00ZVGd7jiLguzsFJSzh54fDQPznZd0TOMJ7S
        Smsr09h/VXCl2ToNBG3wBO15HD72sKH1ptHjOutHALAw7N32yECTFscUrSZerbVh3K6rbxccQJG
        O1JWyNWOu0ZUDwHaJOvFnf0km
X-Received: by 2002:a05:6808:999:: with SMTP id a25mr4182076oic.123.1623187453960;
        Tue, 08 Jun 2021 14:24:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxXsoUQfchNBKnL8EdmQmEAp/5gAc1hlFks6ooIHfYu2jxHqDv442A3KNzBoqbETAUPGj1thg==
X-Received: by 2002:a05:6808:999:: with SMTP id a25mr4182055oic.123.1623187453793;
        Tue, 08 Jun 2021 14:24:13 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id x199sm1954310oif.5.2021.06.08.14.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:24:13 -0700 (PDT)
From:   trix@redhat.com
To:     mdf@kernel.org, robh+dt@kernel.org, hao.wu@intel.com,
        corbet@lwn.net, fbarrat@linux.ibm.com, ajd@linux.ibm.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        gregkh@linuxfoundation.org, Sven.Auhagen@voleatech.de,
        grandmaster@al2klimov.de
Cc:     linux-fpga@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
        linux-staging@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH 05/11] fpga: change FPGA indirect article to an
Date:   Tue,  8 Jun 2021 14:23:44 -0700
Message-Id: <20210608212350.3029742-7-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
In-Reply-To: <20210608212350.3029742-1-trix@redhat.com>
References: <20210608212350.3029742-1-trix@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Change use of 'a fpga' to 'an fpga'

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/fpga/Kconfig | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/fpga/Kconfig b/drivers/fpga/Kconfig
index 33e15058d0dc7..8cd454ee20c0c 100644
--- a/drivers/fpga/Kconfig
+++ b/drivers/fpga/Kconfig
@@ -7,7 +7,7 @@ menuconfig FPGA
 	tristate "FPGA Configuration Framework"
 	help
 	  Say Y here if you want support for configuring FPGAs from the
-	  kernel.  The FPGA framework adds a FPGA manager class and FPGA
+	  kernel.  The FPGA framework adds an FPGA manager class and FPGA
 	  manager drivers.
 
 if FPGA
@@ -134,7 +134,7 @@ config FPGA_REGION
 	tristate "FPGA Region"
 	depends on FPGA_BRIDGE
 	help
-	  FPGA Region common code.  A FPGA Region controls a FPGA Manager
+	  FPGA Region common code.  An FPGA Region controls an FPGA Manager
 	  and the FPGA Bridges associated with either a reconfigurable
 	  region of an FPGA or a whole FPGA.
 
-- 
2.26.3

