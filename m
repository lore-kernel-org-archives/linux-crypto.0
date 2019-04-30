Return-Path: <SRS0=YET+=TA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6ED5C43219
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 876E820644
	for <linux-crypto@archiver.kernel.org>; Tue, 30 Apr 2019 16:29:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X4pJCHvv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfD3Q3s (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 30 Apr 2019 12:29:48 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:37498 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726448AbfD3Q3r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 30 Apr 2019 12:29:47 -0400
Received: by mail-wr1-f68.google.com with SMTP id r6so21781692wrm.4
        for <linux-crypto@vger.kernel.org>; Tue, 30 Apr 2019 09:29:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XAG/7MBNQKcnyRwTABVR+nnLiDuF8S7/Ttp9kLBqJQA=;
        b=X4pJCHvvH1jl7YriWnYI3P6pm05wYYAwtB5o4CMqVQbMFjXTWi0UDOYoj945mXUEhT
         d/Qzk8ICzQbu/2WivlhGUtzSuhULo5NGEHAGmdgBIsGxXt0SUmIMxLmcTX7/e4/ZRXNr
         qyyO+Yt35VNI0JYwsDQJB0vrIJN/T3pLTy6DlbXBs4p1oSAO0of5HKj4ds5ZvRw9Rqmz
         aX2G/zIyFb1FQAPPvWv4JsYrgr2qtVLn2XuGFduwBcJvcRC/Yp/2Pz1ssb++QZAM9cRd
         zwBWsYWbyiIkk5pPMPjGxJPpVphCHmRawZeUToVWC0BMG3epM5yYyPyEp0uFGAsmoWed
         nxCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XAG/7MBNQKcnyRwTABVR+nnLiDuF8S7/Ttp9kLBqJQA=;
        b=p78jH9GDBhnKNAD8Qqi1VRBeGEoFdBkQOQ18qimZjhf8QdE12NwP9CpD+0d4FyjOKp
         SqZhJIfdK+Z2bNWHfeq6QhdgDRHyc8gDTX30/asnNgQKd2Wx99vNDSrb5FfuEafwHm8T
         sz78M+Kp+bYJ4Dm7cgw9kR3NnJcyu7952ahFoX4EQfxZxj9DX9DWH/1iHIEX+yzlS4DN
         vwFGxhMqDJ1kwvTJTsxqm/Sf3LN2oWgEw8sQPfTUly7sBPp3eeoQc95PFosb42T4FFEN
         17q9PRu5BJQxrXnw86TFKZZ7jn31hh11hSnxt6C6c0l+lC8H0zucXchIh8eC/Y+tvLsZ
         mzCg==
X-Gm-Message-State: APjAAAWjf1ohvm9iCRDFzhoeZFEHqLl5RS9T79iE0e/3XRl56B9vT5vZ
        0dyaZVzPvbuzbgY3LE0I5vjP5Blz2qTFig==
X-Google-Smtp-Source: APXvYqwwUKVo8dN+hu0W322cYGbaZaoO+o1yIqu5vND3Xr90ukmMX12QXn38I8REPelGYGocceQSzQ==
X-Received: by 2002:adf:ebd0:: with SMTP id v16mr18190336wrn.175.1556641785176;
        Tue, 30 Apr 2019 09:29:45 -0700 (PDT)
Received: from sudo.home ([2a01:cb1d:112:6f00:1ca3:6afc:30c:1068])
        by smtp.gmail.com with ESMTPSA id t67sm5848890wmg.0.2019.04.30.09.29.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 09:29:44 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linus.walleij@linaro.org,
        joakim.bech@linaro.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 1/5] i2c: acpi: permit bus speed to be discovered after enumeration
Date:   Tue, 30 Apr 2019 18:29:05 +0200
Message-Id: <20190430162910.16771-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
References: <20190430162910.16771-1-ard.biesheuvel@linaro.org>
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

Cc: Mika Westerberg <mika.westerberg@linux.intel.com>
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

