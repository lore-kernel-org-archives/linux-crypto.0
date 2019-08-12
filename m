Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2942FC31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD45208C2
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 20:08:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fxRGsySO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfHLUIW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 16:08:22 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34627 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727533AbfHLUIV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 16:08:21 -0400
Received: by mail-pl1-f196.google.com with SMTP id i2so48331684plt.1;
        Mon, 12 Aug 2019 13:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8ZK5y0NuBb1Z+mREJ9g5/HGQ03jRD7kE7KKrJnxhVYM=;
        b=fxRGsySO0kbbsBdRLh1mtbTE65CtV6MFuwpRKt4K9LJMVY55aNMT1VXyVsS3dNRIdz
         YkwnJe+lMxK4CeGJJD5xSH4SoJYdYUG+qel+d7vr03lOh1YO9w8GpzK/F2ucHPJwF4LK
         VaxrjjUcfwP4hNM5AZf7f6D1KeHlJtY5Dmfce4n1cqb5uxhVo3LePOFmoqM2FOfhyOiP
         zLTf00oQ53KdwRPuhDDAP0RY5w3f+uTsPxobccNZBvxwjrxP/8dfwz7foSZeTwS5OKF+
         xH8AHn6Zf6UBjICpnBNE6pSVoS/xGs+sRmV4s+6lu8Vd/vnUzrYw2xYJVjMkKAX10fIf
         lTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8ZK5y0NuBb1Z+mREJ9g5/HGQ03jRD7kE7KKrJnxhVYM=;
        b=O8WEkJudIEZ2xftKl7mjfd2MX9keGJK8dF/G9ei7b4L+G/xhOIRN4pLzMnkTROrQPN
         Z3p/PDk90kvI3HrYOGOBED8QBPqljHZFetefR9psqyZEFTrVpU/aRH07RoN2WRERlOHK
         oDWvFqD8sFIa9nTTw0TrGplk3RWyIdZlEy7/opQHFMFuTRrJXNNNJtRMItNTyaqd9yRY
         tx8iVEABhWE5X6WEBFUyn3lIz7ai2oqDWDDY9jDtLXdEo+Gwe/Kp+NkwPo2/uR+SISY/
         dQGjQHeeJJGqAccnTSpIBWKVWkkKwTfX68ychDRriFUwFUlvORwTzbMHsHnBcFIpw1gR
         i1vA==
X-Gm-Message-State: APjAAAVm5q1/wPlN6mWoTBbIQNS2hIkSRGW6Bo2h+OVM/Ys4n4Gtjm0u
        POWS87t3ik6IfPsWo0hd49LGrYp/
X-Google-Smtp-Source: APXvYqyWZX7Y0c4B5mH2KVQj9lC2Ua3IlYpR8LaEqrF7WmIcKNhTBjLvCdrzF+tELO6AUCWdrOShmw==
X-Received: by 2002:a17:902:3103:: with SMTP id w3mr35013368plb.84.1565640500766;
        Mon, 12 Aug 2019 13:08:20 -0700 (PDT)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id o14sm352844pjp.19.2019.08.12.13.08.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 12 Aug 2019 13:08:20 -0700 (PDT)
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
Subject: [PATCH v7 15/15] crypto: caam - add clock entry for i.MX8MQ
Date:   Mon, 12 Aug 2019 13:07:39 -0700
Message-Id: <20190812200739.30389-16-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190812200739.30389-1-andrew.smirnov@gmail.com>
References: <20190812200739.30389-1-andrew.smirnov@gmail.com>
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
index d3bdc56b9256..c6c46939d534 100644
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

