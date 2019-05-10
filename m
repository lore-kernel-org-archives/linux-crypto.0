Return-Path: <SRS0=xZqV=TK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D82C46470
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:32:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA6F217F4
	for <linux-crypto@archiver.kernel.org>; Fri, 10 May 2019 17:32:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LknVoO4t"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbfEJRcF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 May 2019 13:32:05 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39310 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbfEJRcF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 May 2019 13:32:05 -0400
Received: by mail-ed1-f67.google.com with SMTP id e24so6113677edq.6;
        Fri, 10 May 2019 10:32:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7fV4hVAmAbFHfY0I1yQlpwpkvQ7JKHa98NLgnJBiZDY=;
        b=LknVoO4tUQQjtIggBo/z1KGMKMS9lVmlRSLDduxaz2IEGKOAGot/nDYmGVDJqPEFjB
         LI3cDUwXpOPOTn04X5/Qd5m1rLMbLyf7gRWIb4WTlS1/sonhA2fRyp4UbZPNyKPyiNRx
         o1JRrS7aWOwvpiiQX/86zQJ+1/gIx1sIyU856MVVv0ETgz4wLsQgmvClhOA8jAb5G2kZ
         E3o60yNHm1eIBc2WoGcEghCpDdemPiqLcJ+/Yb6SUQ3Gf9OphElXCgpVhpW42a0FiUew
         7jeTPuFsICH9sQmVBXYbtZMjbc9P+Y5MzoBGCAeXYFWGhxoSnMey4yNGAvBrQPhBkl0U
         Gfiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7fV4hVAmAbFHfY0I1yQlpwpkvQ7JKHa98NLgnJBiZDY=;
        b=qVWLm1cqG5eKCxNPnDUPwzKSfAe6WgSdvLsJyeftA6rLT6esXySBhcB2cYWOpPKY34
         W0M7RgAYLqDIpy/njrFG1olS+VO1OjvCxQseYc4nPRYsNJFjG0NvzRVPbjM716g5ErLx
         tWB20klVfktA+C56zlprQl8N9JsgaS+ekBKKO9knZmJ6eLabDujJ0uFNp6LdprwZKdu9
         FwNDY/TCG5svFQNam+JwD65cDBwTcVdMp0tZ3aWP3l9klbtQqSazZx7MBJlm7Gni8uZU
         KWij1lJ294OumihjGexmmk3yFVqRF2meDSdCnPOeDB/IQJizT2D0OFQNHlaruX+J5b0R
         /HKA==
X-Gm-Message-State: APjAAAWdFU7v4jg7Ht5+FFhrEycpMW85lkFPkvUdxDEJaAv9pVqejmdW
        BrFoh/BlbMz//uTOo9PVGdJwO4Ph
X-Google-Smtp-Source: APXvYqwRhkB3mljJJBOeVkEFqSYiYAhAJbm6CP/YaoYopxarV4lEGAnieQB3w+eNnM5by0z1/qEGVQ==
X-Received: by 2002:a17:906:cd27:: with SMTP id oz39mr3292112ejb.73.1557509523669;
        Fri, 10 May 2019 10:32:03 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.250])
        by smtp.gmail.com with ESMTPSA id v16sm1599567edm.56.2019.05.10.10.32.00
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 10 May 2019 10:32:03 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com, stefan.wahren@i2se.com,
        wahrenst@gmx.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, mpm@selenic.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH 2/2] hwrng: iproc-rng200: Add support for 7211
Date:   Fri, 10 May 2019 10:31:11 -0700
Message-Id: <20190510173112.2196-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190510173112.2196-1-f.fainelli@gmail.com>
References: <20190510173112.2196-1-f.fainelli@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

BCM7211 features a RNG200 hardware random number generator block, add
support for this chip by matching the chip-specific compatible string.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/char/hw_random/iproc-rng200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/iproc-rng200.c b/drivers/char/hw_random/iproc-rng200.c
index 8b5a20b35293..92be1c0ab99f 100644
--- a/drivers/char/hw_random/iproc-rng200.c
+++ b/drivers/char/hw_random/iproc-rng200.c
@@ -220,6 +220,7 @@ static int iproc_rng200_probe(struct platform_device *pdev)
 }
 
 static const struct of_device_id iproc_rng200_of_match[] = {
+	{ .compatible = "brcm,bcm7211-rng200", },
 	{ .compatible = "brcm,bcm7278-rng200", },
 	{ .compatible = "brcm,iproc-rng200", },
 	{},
-- 
2.17.1

