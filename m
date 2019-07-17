Return-Path: <SRS0=f4o8=VO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9479FC7618F
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EEF42173B
	for <linux-crypto@archiver.kernel.org>; Wed, 17 Jul 2019 15:25:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o45TqQ7q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbfGQPZd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 17 Jul 2019 11:25:33 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33384 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728906AbfGQPZd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jul 2019 11:25:33 -0400
Received: by mail-pg1-f195.google.com with SMTP id f20so2095351pgj.0;
        Wed, 17 Jul 2019 08:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVGDbnDZoiJbze/gsED6nUiGqLN0PdSlW4EjZ/iEn8Y=;
        b=o45TqQ7qc8EmlmIa3hG5StmQOyY+fU9g/w2oulAb8o4AU4AaEaG05GQm/GS/L/euG3
         /aWEUhqgANnE3Dovw+5fP7jyEWhc+Xkxe1XJ+wsQJs5RFE/R+i07kICMTkkS8OmWqV/E
         74SMSUu6X8q0xm0SnQAoqHt+Lrt374n9/KmIvS8yQk3FoP0jI48glhvCLQDStnMLYEL6
         1BkTuVBXVD4/RpKPbUIgauV9gpIpVjCmljIcANsjkjemJgJl5Z651ewrIDb8X94YQ4yS
         zvQCH+Frt5WLVRziTTm17WoWTzXncsehfRB9UGpZSZJ77XiRFMfqd248JNoBaR6bYZBR
         J0hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVGDbnDZoiJbze/gsED6nUiGqLN0PdSlW4EjZ/iEn8Y=;
        b=B0XL/S9sDsnPRVeRii0f5ZOenCNyYnbTR8URpVosAp2eDaHggA4474+YkFg3sAB4wM
         KrST9Lfj446iw3AsSLiR89d6ARuhm+wZS6mBQpXQhvhkpc4w58Me0jawfZIQB1R5r8En
         SKVJYU/SI8Agz39/uYhnraOFwy/Jv9SF7k/usz+uPKSZJh2RMnQg5xibFjzPFjtRXMAz
         8v1ChoqlRBe6KZxbCRLaUr01hkAQrE2hd+rvD5fsxvF+AffeUaU8HAlOpmpkiDkZzsS2
         Doar7Zo4SI/yt0ICWnbE2t/XfYUNL0PJYR4YXZQWN6rqdTgiEd3fHZJsQgVKwgdJ8sLc
         QTUQ==
X-Gm-Message-State: APjAAAVrlEql8VPMUa3VDTMhq0erpAUbFt3lsAYsupexfHnv+toYm717
        hAMxPs27vaq9K/HKSJYBEYTHd9RW
X-Google-Smtp-Source: APXvYqwO/f5/DKLxnPvgphTlioNGZXByj5N8EGJFmdgLvV8ce2tI/ntQesFf629dC40e8O5BxkL62A==
X-Received: by 2002:a63:5b1d:: with SMTP id p29mr40181000pgb.297.1563377132314;
        Wed, 17 Jul 2019 08:25:32 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id l1sm33771386pfl.9.2019.07.17.08.25.31
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 17 Jul 2019 08:25:31 -0700 (PDT)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v6 14/14] crypto: caam - add clock entry for i.MX8MQ
Date:   Wed, 17 Jul 2019 08:24:58 -0700
Message-Id: <20190717152458.22337-15-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190717152458.22337-1-andrew.smirnov@gmail.com>
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add clock entry needed to support i.MX8MQ.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Spencer <christopher.spencer@sea.co.uk>
Cc: Cory Tusar <cory.tusar@zii.aero>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
Cc: Leonard Crestez <leonard.crestez@nxp.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/ctrl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index ad6ff4040bab..6f3b4405dcba 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -527,6 +527,7 @@ static const struct soc_device_attribute caam_imx_soc_table[] = {
 	{ .soc_id = "i.MX6UL", .data = &caam_imx6ul_data },
 	{ .soc_id = "i.MX6*",  .data = &caam_imx6_data },
 	{ .soc_id = "i.MX7*",  .data = &caam_imx7_data },
+	{ .soc_id = "i.MX8MQ", .data = &caam_imx7_data },
 	{ .family = "Freescale i.MX" },
 	{ /* sentinel */ }
 };
-- 
2.21.0

