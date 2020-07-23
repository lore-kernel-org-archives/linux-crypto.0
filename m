Return-Path: <SRS0=6JMd=BC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD30EC433EA
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:28:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8991620888
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Jul 2020 08:28:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=foundries-io.20150623.gappssmtp.com header.i=@foundries-io.20150623.gappssmtp.com header.b="XWBB+39p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgGWI22 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Jul 2020 04:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726975AbgGWI22 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Jul 2020 04:28:28 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9422C0619DC
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2020 01:28:27 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o8so4158816wmh.4
        for <linux-crypto@vger.kernel.org>; Thu, 23 Jul 2020 01:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foundries-io.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pqbf/JlzmrnxTusv/MCCIfLKAll9saWvqmEUS6doAKA=;
        b=XWBB+39pUAgBiMhoQnEPb5NISkEOeCzOjwQd7J69FxfbO32zX8yotjMJ36aZ75VE+s
         aydG9h2pkphAtsa0wdHferuXlMfD1ed14VEOKEhXbR2iH8b/qh2UNJv5ltUCX6iAHonW
         6ppjm11dHVvrAGhedgBVv4NqXXuzytlaMOXuf5Cvp8DAPyfJD2BKo1Mx+BFGp0VhJWCV
         552YwVkx8Vs99u3zVR+PusZTsPGMoMZoHr5Phm/+jLF9Gmh1MusbJUoayogqEWsK2wU+
         O0VRmSnwhoKsht4hShoOsWuwVF4hBVAUvAWZzjwopvMDSybLCJYEpQN81IQZLlHwmH1n
         nJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pqbf/JlzmrnxTusv/MCCIfLKAll9saWvqmEUS6doAKA=;
        b=Pd5V4UAu04RpryhLhkFfmRCTIjMisUk4WJT+X9CgcuGqLsiMwnmZyUJecrKT1hmb9M
         0LDHfPVkgIdzls9McP6UKo1j9zVIl6bx3KHUwHlChMsHCWWSjDsHpT30hbrvqOcdG9YT
         GbTO9OMtHgIYTYSB9i1/rCJpBusWPEpQAOPPFy2ufzvnSejCBAb6y9A0kK0efzxUKl3b
         SruTscTqQxgXhOoUt6URl1ZYCRD+esRuUqTR0ozj4n3q58XL5VssdiCFeKKVMa3qd6dr
         m1h8a6Ib89Hvk3qf/pukarKoPgmIhFCSLg/80RvFG7eD2+utkv7ROiUfKbyqQ+GRS0rg
         C7pg==
X-Gm-Message-State: AOAM533J0xnR2mrOWicYXoZgf1XHDTz+4thfkK8fD2J90AF2RHrXibxK
        6mnsu/s7HmAdy1xgNtjQOIopWA==
X-Google-Smtp-Source: ABdhPJws7V0YymdA86lv4N+zTX4pWZCDq6+vN6OynKbmLdt5md9K+3+DmirsDojMFHAfhro6V83r1g==
X-Received: by 2002:a1c:2350:: with SMTP id j77mr3266459wmj.31.1595492906472;
        Thu, 23 Jul 2020 01:28:26 -0700 (PDT)
Received: from localhost.localdomain (126.red-83-36-179.dynamicip.rima-tde.net. [83.36.179.126])
        by smtp.gmail.com with ESMTPSA id o2sm2879094wrj.21.2020.07.23.01.28.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 01:28:26 -0700 (PDT)
From:   Jorge Ramirez-Ortiz <jorge@foundries.io>
To:     jorge@foundries.io, sumit.garg@linaro.org, mpm@selenic.com,
        herbert@gondor.apana.org.au
Cc:     jens.wiklander@linaro.org, arnd@arndb.de, ricardo@foundries.io,
        mike@foundries.io, gregkh@linuxfoundation.org,
        op-tee@lists.trustedfirmware.org, linux-crypto@vger.kernel.org
Subject: [PATCH 2/2] hwrng: optee: fix wait use case
Date:   Thu, 23 Jul 2020 10:28:21 +0200
Message-Id: <20200723082821.26237-2-jorge@foundries.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200723082821.26237-1-jorge@foundries.io>
References: <20200723082821.26237-1-jorge@foundries.io>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The current code waits for data to be available before attempting a
second read. However the second read would not be executed as the
while loop exits.

This fix does not wait if all data has been read and reads a second
time if only partial data was retrieved on the first read.

Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
---
 drivers/char/hw_random/optee-rng.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/optee-rng.c b/drivers/char/hw_random/optee-rng.c
index 5bc4700c4dae..967d58bb9fda 100644
--- a/drivers/char/hw_random/optee-rng.c
+++ b/drivers/char/hw_random/optee-rng.c
@@ -122,13 +122,15 @@ static int optee_rng_read(struct hwrng *rng, void *buf, size_t max, bool wait)
 	if (max > MAX_ENTROPY_REQ_SZ)
 		max = MAX_ENTROPY_REQ_SZ;
 
-	while (read == 0) {
+	for (;;) {
 		rng_size = get_optee_rng_data(pvt_data, data, (max - read));
 
 		data += rng_size;
 		read += rng_size;
 
 		if (wait && pvt_data->data_rate) {
+			if (read == max)
+				return read;
 			if (timeout-- == 0)
 				return read;
 			msleep((1000 * (max - read)) / pvt_data->data_rate);
-- 
2.17.1

