Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 814D2C48BCF
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62F1B61375
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Jun 2021 21:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhFHV0m (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Jun 2021 17:26:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:48425 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234633AbhFHV0Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Jun 2021 17:26:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623187470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jeq8qRfoRfsbx4uL9oOz0deeKscRGraAzU6rnmI4bDk=;
        b=GxkaqM3Cf+lORjEVs/ycRRWiFqkfHKDfiF027LswJI54lBhfsj9NQQp0nPa5Hhl65RpmWN
        cR9KrXaOP/SKWKah1STX8lHUud8rWUeLeTWbLroeY82ldBkwDawx6fcrCcnQpsrHaqx7FH
        3WKPf69/+eu94o78xVJdUcTodhPMjTo=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-GFxNU1A7N8GrEcTAzwpmnA-1; Tue, 08 Jun 2021 17:24:28 -0400
X-MC-Unique: GFxNU1A7N8GrEcTAzwpmnA-1
Received: by mail-ot1-f69.google.com with SMTP id i25-20020a9d4a990000b0290304f00e3e3aso14768217otf.15
        for <linux-crypto@vger.kernel.org>; Tue, 08 Jun 2021 14:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jeq8qRfoRfsbx4uL9oOz0deeKscRGraAzU6rnmI4bDk=;
        b=Bgg2jU3Pm4ImXQIs8jlpsAJZqzcER5GG89URo220A8IM9OTVfKWkAIfJZ7gvfbMCUH
         InmtjpkTlYbRC/IOev5DHYh6NXGKktjSvTTHGy/I1/Gfhf239ULZ+AOSz2qg6bNVRx2l
         eDfpbHPaiI4O3D8X77to174TieFysWBio5YMO9fRAMcqtoR1AsvkiK/VeGftBXqVqp7n
         WNGuuaHXilKt0mzFzK4yikvQnmYB4pSZuvxswDXd0wU1dOJKkQRFw0Ud5KHIW2nA6xjV
         I2A6+oT2nZAASmNTC6y18CWN2MZT/6z1DgyvXJq2pwdN4+t+iBN9TS7vsl4H0Ogng1Nh
         HAug==
X-Gm-Message-State: AOAM531fmv40YpY+RndU5M9VVGXnXUVMYAWdbBrAHG8fNJbYeOSQOYUR
        qoEGH/iZiemoI50Mbk6RR6W14PYKorkbgm5xMGgWEKMvMHkcPVR1T/zVIyF6JgPWe4HQj6hOqav
        wXciJRxXR3jm81OidyKbUJ+GM
X-Received: by 2002:a05:6830:1309:: with SMTP id p9mr12963259otq.209.1623187468230;
        Tue, 08 Jun 2021 14:24:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxKsGI5o2pAZuxgtMx6UsQ5GpgFuru3G9QqB8VKcT3CwJSpYN5gRSP28hE4xYJAJAJCEsUFOQ==
X-Received: by 2002:a05:6830:1309:: with SMTP id p9mr12963250otq.209.1623187468089;
        Tue, 08 Jun 2021 14:24:28 -0700 (PDT)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id x199sm1954310oif.5.2021.06.08.14.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 14:24:27 -0700 (PDT)
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
Subject: [PATCH 11/11] staging: fpgaboot: change FPGA indirect article to an
Date:   Tue,  8 Jun 2021 14:23:50 -0700
Message-Id: <20210608212350.3029742-13-trix@redhat.com>
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
 drivers/staging/gs_fpgaboot/README | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/gs_fpgaboot/README b/drivers/staging/gs_fpgaboot/README
index b85a76849fc4a..ec1235a21bcc1 100644
--- a/drivers/staging/gs_fpgaboot/README
+++ b/drivers/staging/gs_fpgaboot/README
@@ -39,7 +39,7 @@ TABLE OF CONTENTS.
 
 5. USE CASE (from a mailing list discussion with Greg)
 
-	a. As a FPGA development support tool,
+	a. As an FPGA development support tool,
 	During FPGA firmware development, you need to download a new FPGA
 	image frequently.
 	You would do that with a dedicated JTAG, which usually a limited
-- 
2.26.3

