Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C713C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:16:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DAD5221738
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 12:16:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N583wQoJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726388AbfBSMQN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 07:16:13 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38809 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfBSMQN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 07:16:13 -0500
Received: by mail-wm1-f67.google.com with SMTP id v26so2472507wmh.3;
        Tue, 19 Feb 2019 04:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=qjtegP6eXeh1eBEfCJW6T14ShtJcZpHiRQp/StMhw6E=;
        b=N583wQoJU6fegGrgO+JW0CB8QVzvRo9j2WzXTwgzhhBdLPrFBfolpSprmi3OwWabhX
         AXLkSI3hhuBVXm1SVhGWSnD+uqpTGtlCpbVOrMJkiUQ8oiizltvJFlfQCAcS8PDl5ZDD
         O3OW1dTWFzQW8wTjyVpsp7lKnnLlg9uxrMcJ9QjG0nKQ5ySEjV5BDAepJgSj01a4VMEc
         wbfniQABJXnZt2YLVdbCgS9s4QSx+vvT9/5BxoBuw95fdhUEuH8qh/xPWHIoO3MVbbcq
         8gYLB6L284MMMvkCVBKDLVL1J9/EmxYru+9qVb775AN39zV+UaPNTg9t9K+23b613edb
         RopQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=qjtegP6eXeh1eBEfCJW6T14ShtJcZpHiRQp/StMhw6E=;
        b=fcGabhEOlAvY6+H6BJvqv3NwLKCAaci+OZDdLnfVlTyRRaIKxq6k0dYBiYJ/10sLqI
         ZIe/KSTRtuzfIywxEYrabjyrsRo3GUMX9Vz7vrDGVt/pgUZm1aQ7IqnCk/Usn+cbb/sm
         wj2lQYtOUIvGJRfapCG9O5wLT41y6JXAN937i5cht2XSw0Mh94HLJhejUryJnAskcNE+
         YzzzS7tDvJb7ujtGXuUPqtFTBDWCwhpL/QA0E8vf33fkgAfUAFHfHQHrNJ4JEJbvVpZi
         M01tnN7diagtK8qJBqMJ42KyXQ2kohVYVDfBKa6uVcpFZNRi2thY7VdQfsoYYMcJMIBc
         x/vQ==
X-Gm-Message-State: AHQUAuZ3F3z8j1pIeIzFB5HNipY1eA1qihfPrq8hwS//7uLiGf52m1Hb
        juNF4/DhwkH2SC39spHx8FGuy9QN
X-Google-Smtp-Source: AHgI3IbK9bbn7FzJn4g3wPJKTEa6zn1BS+V8KoBSWORHSxLjEMQ6ZQWHyl6A5wexoQBVvtjd+tDrvg==
X-Received: by 2002:a1c:f319:: with SMTP id q25mr2705484wmq.151.1550578570321;
        Tue, 19 Feb 2019 04:16:10 -0800 (PST)
Received: from localhost.localdomain ([2001:470:9e39::64])
        by smtp.gmail.com with ESMTPSA id a1sm14783353wrq.96.2019.02.19.04.16.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 19 Feb 2019 04:16:09 -0800 (PST)
From:   Jonas Gorski <jonas.gorski@gmail.com>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Eric Anholt <eric@anholt.net>,
        Stefan Wahren <stefan.wahren@i2se.com>
Subject: [PATCH] hwrng: bcm2835 - fix probe as platform device
Date:   Tue, 19 Feb 2019 13:16:08 +0100
Message-Id: <20190219121608.19406-1-jonas.gorski@gmail.com>
X-Mailer: git-send-email 2.13.2
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM63XX (MIPS) does not use device tree, so there cannot be any
of_device_id, causing the driver to fail on probe:

[    0.904564] bcm2835-rng: probe of bcm63xx-rng failed with error -22

Fix this by checking for match data only if we are probing from device
tree.

Fixes: 8705f24f7b57 ("hwrng: bcm2835 - Enable BCM2835 RNG to work on BCM63xx platforms")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
---
 drivers/char/hw_random/bcm2835-rng.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/char/hw_random/bcm2835-rng.c b/drivers/char/hw_random/bcm2835-rng.c
index 256b0b1d0f26..f759790c3cdb 100644
--- a/drivers/char/hw_random/bcm2835-rng.c
+++ b/drivers/char/hw_random/bcm2835-rng.c
@@ -168,14 +168,16 @@ static int bcm2835_rng_probe(struct platform_device *pdev)
 	priv->rng.read = bcm2835_rng_read;
 	priv->rng.cleanup = bcm2835_rng_cleanup;
 
-	rng_id = of_match_node(bcm2835_rng_of_match, np);
-	if (!rng_id)
-		return -EINVAL;
-
-	/* Check for rng init function, execute it */
-	of_data = rng_id->data;
-	if (of_data)
-		priv->mask_interrupts = of_data->mask_interrupts;
+	if (dev_of_node(dev)) {
+		rng_id = of_match_node(bcm2835_rng_of_match, np);
+		if (!rng_id)
+			return -EINVAL;
+
+		/* Check for rng init function, execute it */
+		of_data = rng_id->data;
+		if (of_data)
+			priv->mask_interrupts = of_data->mask_interrupts;
+	}
 
 	/* register driver */
 	err = devm_hwrng_register(dev, &priv->rng);
-- 
2.13.2

