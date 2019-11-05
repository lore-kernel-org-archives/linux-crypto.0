Return-Path: <SRS0=QWZk=Y5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADCC0C5DF61
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85AC8214D8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Nov 2019 15:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XG/QQBNP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389735AbfKEPOB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:14:01 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34522 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389083AbfKEPOA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Nov 2019 10:14:00 -0500
Received: by mail-pg1-f196.google.com with SMTP id e4so14440142pgs.1;
        Tue, 05 Nov 2019 07:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lnPUSmMzWebvtTdv486q9Snfl/2WFziST54BYduBh3o=;
        b=XG/QQBNPKGJ6gv50UbSrqlzKdX2itOiPE7VJKl/R74saG/ERAsDfNQhdeffdo/6a4n
         Xc02khRc7A/768W7qVD7LF1YOons3Z7g54+D0qBObKNGu1brcnmrhLZDSzGrgQScGXyR
         r0m3VP0af4HIV9M+jZg+nrWcqKiQmnSrCMxrzATT5/quiKrTHoBSQjNth3mGHGAceWzF
         RMA0EtztdrN2Q28Q8yBnTuXMNxO+AvsxkZVSHlDCPbjXsg2B7mx8eszlhylJddSXGLBJ
         sL4om6upy5VtHL12p4wS4bpQ3Yz7V9vEyO+60/p1SdIhcQ1um9ZEpcbZx3nOqqZExm/9
         c+VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lnPUSmMzWebvtTdv486q9Snfl/2WFziST54BYduBh3o=;
        b=KV1jzXhJQMclQJSwkmdcAKPj8x7H5MHRwGWZVGtCo2KtmLiIY3ln2HZmXAkRvdLgXY
         uvJf60NabRnqP2/kG9tqjX9n9gIbXSNe//bKOS3/EjyB1SMUcdjP5nrWQU6Y15JqKY5D
         Xdp5kOwiwpFx1YLwmB9T1kvvtHMffZmHgJNtGCEbLnKHFEWgHnreb+q6MV68pPxb62Wo
         3s+aAj9t0kq65Ep6G8WYP+PUd1VecUTXcKpKwfnLG2zanmD2GzNLqbU0koMd5r51YuPR
         wtUNXB0BlI9XRsl0iKW0vW5o9pAk0zeeHVKM4GUG/Ilhmtr4L+QnQkzn04wT+rGTskii
         9yZQ==
X-Gm-Message-State: APjAAAW79Ira/7vY+IUo/YJoG2cQF2rbRv0yp+pd7BmfQq2igDs0gZZf
        GW25c/z/pj1tr/0O1fwIX6/GEdt7
X-Google-Smtp-Source: APXvYqy3BgvociuYQXBbyQoeEhwiYaS8nl6e5wkwxc+83EmsEul+bIOl5i2BY1J5KudjTSNxY6bplg==
X-Received: by 2002:a63:1c10:: with SMTP id c16mr36036600pgc.183.1572966839471;
        Tue, 05 Nov 2019 07:13:59 -0800 (PST)
Received: from localhost.lan (c-67-185-54-80.hsd1.wa.comcast.net. [67.185.54.80])
        by smtp.gmail.com with ESMTPSA id f7sm23120691pfa.150.2019.11.05.07.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 07:13:58 -0800 (PST)
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
To:     linux-crypto@vger.kernel.org
Cc:     Andrey Smirnov <andrew.smirnov@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        =?UTF-8?q?Horia=20Geant=C4=83?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Iuliana Prodan <iuliana.prodan@nxp.com>, linux-imx@nxp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/5] crypto: caam - use static initialization
Date:   Tue,  5 Nov 2019 07:13:49 -0800
Message-Id: <20191105151353.6522-2-andrew.smirnov@gmail.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191105151353.6522-1-andrew.smirnov@gmail.com>
References: <20191105151353.6522-1-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use static initialization for global variables.

Signed-off-by: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: Chris Healy <cphealy@gmail.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Horia Geantă <horia.geanta@nxp.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Iuliana Prodan <iuliana.prodan@nxp.com>
Cc: linux-imx@nxp.com
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/crypto/caam/jr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/caam/jr.c b/drivers/crypto/caam/jr.c
index fc97cde27059..49c98a7f6723 100644
--- a/drivers/crypto/caam/jr.c
+++ b/drivers/crypto/caam/jr.c
@@ -23,7 +23,10 @@ struct jr_driver_data {
 	spinlock_t		jr_alloc_lock;	/* jr_list lock */
 } ____cacheline_aligned;
 
-static struct jr_driver_data driver_data;
+static struct jr_driver_data driver_data = {
+	.jr_list = LIST_HEAD_INIT(driver_data.jr_list),
+	.jr_alloc_lock = __SPIN_LOCK_UNLOCKED(driver_data.jr_alloc_lock),
+};
 static DEFINE_MUTEX(algs_lock);
 static unsigned int active_devs;
 
@@ -589,8 +592,6 @@ static struct platform_driver caam_jr_driver = {
 
 static int __init jr_driver_init(void)
 {
-	spin_lock_init(&driver_data.jr_alloc_lock);
-	INIT_LIST_HEAD(&driver_data.jr_list);
 	return platform_driver_register(&caam_jr_driver);
 }
 
-- 
2.21.0

