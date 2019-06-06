Return-Path: <SRS0=NolZ=UF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8A70C04AB5
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 15:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E41C2083D
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Jun 2019 15:06:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lLrdVkmK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbfFFPGZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Jun 2019 11:06:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34617 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727309AbfFFPGY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Jun 2019 11:06:24 -0400
Received: by mail-pg1-f196.google.com with SMTP id h2so1533083pgg.1;
        Thu, 06 Jun 2019 08:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Ps7YYNVhpbFuxWvfaSyiDLPbZDo03wQ8e8VV9mh4JZ0=;
        b=lLrdVkmK1SlH0fVilflJe5AtBWAQjiMWYPS9DL+02DbBRLCW5pJ26Itws3btMdWbYw
         fymaKr8KaITWDkjnGKaE9T5voVC18R3kYDKX/y0aOsiNxFojo2g/aMT9zXvLqYN0bXFZ
         RJVXKOsEZEPBE4zNuV+MqLiP9jZfzHSZA8+7pZV/bbDNwpSAKYHW+fNLCHg2Bca92Qn5
         QEtPf0TJyN41F87LV7HIfpjNEtwbEPUC/Q4a9pPCQXJt2ADqPZjBN+8uZMrQIZHYIosg
         yAbKMmFw+33yww3ZXiUVNyDvZVbVz4oWsrS/fiW8Dui6GMXrgcSAOt6VV3xDFzbzS9IS
         //uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Ps7YYNVhpbFuxWvfaSyiDLPbZDo03wQ8e8VV9mh4JZ0=;
        b=QkhMagzBrtrxl2qai+8aP0BkJVmM44PEK0vbcv2pQDdzglilAL0oTTN0AxZk2BnApV
         0/Xies2dD/pfts5wpLCFCS1VSuPtFivnh8O3gokLeyRD+UIRXKv57i8jm1qkIv6FzOJF
         bHdjYaPJ4V8hSggD/vy3rjHrLZmpBaW+J8VCHyhhfCOsoOEWUFh4Y1PZ0c4/vEWhaOkX
         jgISqAQO77vs0x7mtyE2o0qnLc7nK9QBOewUxt/PA1KZvolcDtxb6hbbZG1ZQlOZpOsU
         RlrEflsrQBvod2ugfOjcsr1CbiDWYSM6RFWrZDVb2kJy1NTAzc+6qJF+mZx36Dbe848o
         IZ1Q==
X-Gm-Message-State: APjAAAUPQoihbSgcjz1Fc9SqVfNWKt5Z9JVKTMEeE15t+L4NgIs5P8PD
        u5ovOWGJFnqIJDHvMSHJzjo=
X-Google-Smtp-Source: APXvYqyyeUJzL2Hlqkk588lgJJeRAMqRBTyzo1zmd53TROl0MOXwsD7bVBiCPxYJcH7J0u8DjQmOqA==
X-Received: by 2002:a63:c20c:: with SMTP id b12mr3620010pgd.3.1559833583482;
        Thu, 06 Jun 2019 08:06:23 -0700 (PDT)
Received: from nishad (p3261240-ipngn21201hodogaya.kanagawa.ocn.ne.jp. [153.202.122.240])
        by smtp.gmail.com with ESMTPSA id y10sm2508493pfm.68.2019.06.06.08.06.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Jun 2019 08:06:22 -0700 (PDT)
Date:   Thu, 6 Jun 2019 20:36:17 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hisilicon - Use the correct style for SPDX License
 Identifier
Message-ID: <20190606150612.GA4002@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This patch corrects the SPDX License Identifier style
in header file related to Crypto Drivers for Hisilicon
SEC Engine in Hip06 and Hip07.
For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/crypto/hisilicon/sec/sec_drv.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec/sec_drv.h b/drivers/crypto/hisilicon/sec/sec_drv.h
index 2d2f186674ba..4d9063a8b10b 100644
--- a/drivers/crypto/hisilicon/sec/sec_drv.h
+++ b/drivers/crypto/hisilicon/sec/sec_drv.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /* Copyright (c) 2016-2017 Hisilicon Limited. */
 
 #ifndef _SEC_DRV_H_
-- 
2.17.1

