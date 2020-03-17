Return-Path: <SRS0=I3Dt=5C=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00B89C3F2CE
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 06:15:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDBF220719
	for <linux-crypto@archiver.kernel.org>; Tue, 17 Mar 2020 06:15:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ZlPyXdxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbgCQGP4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 17 Mar 2020 02:15:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:39150 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbgCQGP4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Mar 2020 02:15:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id h6so3741778wrs.6
        for <linux-crypto@vger.kernel.org>; Mon, 16 Mar 2020 23:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=I+q7+Jbaq1SKd35pnpj+Zyxbo7Ea5dhgdfNOx7vAwoo=;
        b=ZlPyXdxvvPTjYi7zINWE9eUXHfXmsARoIRffaNWXDE3NnwL2jFmlhRTvvgYqCuhVng
         yiGsBoBhsBaRNjea3XYB1RnftWbqpufu1AL3cqUqdnmiztRFYAXen+eOGr176MzYZAnG
         LNeygZU83jC6ydw+Om0WGB3+gMZH2kGZfqMEY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=I+q7+Jbaq1SKd35pnpj+Zyxbo7Ea5dhgdfNOx7vAwoo=;
        b=TmSg3bUPDbcbZV1nAUptrvd8t3HN2/OSc7hU8XbFRCFKAYc3SsY+3vM/zbiyt9JZei
         8hndj3Vm4U6iF/7MQfA2hi4Qx61godUn9xptEDw6S4CLpCtcaSJE10xnfYIG1JthLxbP
         QcFV9fcAnU21Xp8bjHBDlk+BLRVQV2JG6gir3JoD6vg7s1XCSevwwWNMKcjAc4FlJvNP
         jq2qEl4a2Ys9nd0YPAc+xYyxH+Fa3anSIl4ClefipxZhV84vZAydKm+ndEmhv1DPnckA
         Si8ktF2cTnqtDgjN42e0xyVypM6NAlF9VkYFmsXWo3pXXGMY02nRaw+VlFoj3Gom10su
         Q+nw==
X-Gm-Message-State: ANhLgQ0bqsP02PTtwa0PK+x+Pm7ICdz1OV0AwWD+0aZEya0cMSopUWeb
        +fUYFRAtXbss5LQK8rIa08ZLlQ==
X-Google-Smtp-Source: ADFU+vthGfbwy0mIHC4QwmBqoU7mDAhGf6AkLOvvv8M41Cnd7TlLgwjG9W9KsdWbYXVHZ5BW796CjA==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr3911842wrx.396.1584425754526;
        Mon, 16 Mar 2020 23:15:54 -0700 (PDT)
Received: from rayagonda.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id o5sm2658096wmb.8.2020.03.16.23.15.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 23:15:53 -0700 (PDT)
From:   Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
To:     Dan Williams <dan.j.williams@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Allison Randal <allison@lohutok.net>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
Subject: [PATCH v1 1/2] async_tx: return error instead of BUG_ON
Date:   Tue, 17 Mar 2020 11:45:21 +0530
Message-Id: <20200317061522.12685-2-rayagonda.kokatanur@broadcom.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200317061522.12685-1-rayagonda.kokatanur@broadcom.com>
References: <20200317061522.12685-1-rayagonda.kokatanur@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Return error upon failure instead of using BUG_ON().
BUG_ON() will crash the kernel.

Signed-off-by: Rayagonda Kokatanur <rayagonda.kokatanur@broadcom.com>
---
 crypto/async_tx/async_raid6_recov.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/crypto/async_tx/async_raid6_recov.c b/crypto/async_tx/async_raid6_recov.c
index f249142ceac4..33f2a8f8c9f4 100644
--- a/crypto/async_tx/async_raid6_recov.c
+++ b/crypto/async_tx/async_raid6_recov.c
@@ -205,7 +205,9 @@ __2data_recov_5(int disks, size_t bytes, int faila, int failb,
 		good = i;
 		good_srcs++;
 	}
-	BUG_ON(good_srcs > 1);
+
+	if (good_srcs > 1)
+		return NULL;
 
 	p = blocks[disks-2];
 	q = blocks[disks-1];
@@ -339,7 +341,9 @@ async_raid6_2data_recov(int disks, size_t bytes, int faila, int failb,
 	void *scribble = submit->scribble;
 	int non_zero_srcs, i;
 
-	BUG_ON(faila == failb);
+	if (faila == failb)
+		return NULL;
+
 	if (failb < faila)
 		swap(faila, failb);
 
@@ -455,7 +459,8 @@ async_raid6_datap_recov(int disks, size_t bytes, int faila,
 				break;
 		}
 	}
-	BUG_ON(good_srcs == 0);
+	if (good_srcs == 0)
+		return NULL;
 
 	p = blocks[disks-2];
 	q = blocks[disks-1];
-- 
2.17.1

