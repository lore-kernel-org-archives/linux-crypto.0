Return-Path: <SRS0=IzQh=TY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B096C282E3
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 241AB2075D
	for <linux-crypto@archiver.kernel.org>; Fri, 24 May 2019 16:27:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="etyGkcer"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390605AbfEXQ1k (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 May 2019 12:27:40 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53014 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390337AbfEXQ1k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 May 2019 12:27:40 -0400
Received: by mail-wm1-f67.google.com with SMTP id y3so10026620wmm.2
        for <linux-crypto@vger.kernel.org>; Fri, 24 May 2019 09:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=feMTK1ALuDcB6ANRh60ilE7eIkZ7WZWllXS4rnIjAYY=;
        b=etyGkcerFFK63wVJPJo3fAK6GJwu4arL3yT6oqa6tEDzNWodmPXx8J2hDmjVU+s/62
         FtW5cwEZJvReJiIYHfu52g9IpnAl08zsoHEFzpa2JM9Pder9hqhyDJyIZ4NyNThF/tUg
         rCPo4rXpUSl5n6mc6zDip9MwBZNeqsypfSKfgnSjx21B/wtM9RQIfnPIf0RC/o8zxzrh
         2aeIBX35HY3ROFBAKKQc993TzUfCK5nfErFt0nEISY9TOec9UhC5dL4+d1/aoxDfcHuh
         oiWITzP1MVuIJ/4NVbuD/NRzTqImYz3GpVMkqZU01a9H8Y7kBHgtR0EN0DHrk43ROwar
         DHJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=feMTK1ALuDcB6ANRh60ilE7eIkZ7WZWllXS4rnIjAYY=;
        b=uYOE1GhtgDHEjyE2vzddBSZWYcK087Yli8D77P35e7LohC2D8BYTkj76tRz31iqMDE
         FViQj54Us8van9T9X6EigyuT5hr2R/xcTT5Z7YClSY9KS4GWqCnR9Jt9EByl1e/Ecc+z
         PT1mxKeGDFJKxhCE3xAOARv+TI1nlMolRwiaUEFY9Ydsl9JdZDS6t6Tstpil+foa/Ski
         PY9dcqI7s8Y0WBKCJUVX3VdpMQ4fvkuPqCRx9k0L43hcUtTloTVPQ1VSPI/xe2wi3Iyw
         jVcKsGkDfkQXrL+tstGvBR15t+gssyUcQ8CD9Qpnvvgs5BzGWKGZckTSEAJ9z1GR/orx
         4Klg==
X-Gm-Message-State: APjAAAXfxE+AtNfo3w2QWmRT5D8t22h6EtwTO4jAvUMGS6cjkGlzozeO
        Xias8/1IVzMNiRkmeayDjYc29iNz8hLsTlBa
X-Google-Smtp-Source: APXvYqzhbxBbK42/fNaR/5q/csolUj2TBckrr0JZCetN7bH6brmrHm8o+kekNYDecz00m0FcQC71TQ==
X-Received: by 2002:a1c:f507:: with SMTP id t7mr17188238wmh.149.1558715258061;
        Fri, 24 May 2019 09:27:38 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:2042:d8f2:ded8:fa95])
        by smtp.gmail.com with ESMTPSA id l6sm2200320wmi.24.2019.05.24.09.27.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 09:27:37 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH v2 1/6] i2c: acpi: permit bus speed to be discovered after enumeration
Date:   Fri, 24 May 2019 18:26:46 +0200
Message-Id: <20190524162651.28189-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
References: <20190524162651.28189-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, the I2C ACPI enumeration code only permits the max bus rate
to be discovered before enumerating the slaves on the bus. In some
cases, drivers for slave devices may require this information, e.g.,
some ATmel crypto drivers need to generate a so-called wake token
of a fixed duration, regardless of the bus rate.

So tweak the code so i2c_acpi_lookup_speed() is able to obtain this
information after enumeration as well.

Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/i2c/i2c-core-acpi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/i2c-core-acpi.c b/drivers/i2c/i2c-core-acpi.c
index 272800692088..7240cc07abb4 100644
--- a/drivers/i2c/i2c-core-acpi.c
+++ b/drivers/i2c/i2c-core-acpi.c
@@ -115,8 +115,7 @@ static int i2c_acpi_do_lookup(struct acpi_device *adev,
 	struct list_head resource_list;
 	int ret;
 
-	if (acpi_bus_get_status(adev) || !adev->status.present ||
-	    acpi_device_enumerated(adev))
+	if (acpi_bus_get_status(adev) || !adev->status.present)
 		return -EINVAL;
 
 	if (acpi_match_device_ids(adev, i2c_acpi_ignored_device_ids) == 0)
@@ -151,6 +150,9 @@ static int i2c_acpi_get_info(struct acpi_device *adev,
 	lookup.info = info;
 	lookup.index = -1;
 
+	if (acpi_device_enumerated(adev))
+		return -EINVAL;
+
 	ret = i2c_acpi_do_lookup(adev, &lookup);
 	if (ret)
 		return ret;
-- 
2.20.1

