Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27079C433F5
	for <linux-crypto@archiver.kernel.org>; Wed, 22 Dec 2021 17:29:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhLVR3b (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 22 Dec 2021 12:29:31 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:53832 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229743AbhLVR3b (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 22 Dec 2021 12:29:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640194169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ziVhIeG/+C1hVAL/19RU4EWJLhjrdCffUUmjmXtDbFA=;
        b=Fkk6yfOKeVRfm6mLgWmeQSw+JULolYyk3NrWzH/dJcpga7WMvdF/hwXDyuiYeV3sId3V5B
        9PcMh3Wq2mG0PRj23T8L0HznV3UiRDia/rkWXb/8IKgdevq66zuqrztfhklBuC9cbvUvki
        ThdjsvYXZTKgLwNoCFGUaEnl3wlhFoM=
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com
 [209.85.167.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-537-JTbjHeM0OxyiUr6bJNGGFA-1; Wed, 22 Dec 2021 12:29:28 -0500
X-MC-Unique: JTbjHeM0OxyiUr6bJNGGFA-1
Received: by mail-oi1-f200.google.com with SMTP id p186-20020aca42c3000000b002bc99d2b74aso1389318oia.18
        for <linux-crypto@vger.kernel.org>; Wed, 22 Dec 2021 09:29:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ziVhIeG/+C1hVAL/19RU4EWJLhjrdCffUUmjmXtDbFA=;
        b=ib3kiDLwWJW5ilm+wNsLxh+J+0Ogsx8mV0JVuYqBXovwTKEhTnHaOTjt8zAbETtSuJ
         98mMPv9b9yTT6cuepc9/RXo7kQnKHlwuT57Sq6QqXM3uMr53N3TqrxmbeRGrd6whZVys
         TTIsE4kETbyZcTiuzp9yLR3QE1q8OpPN4xoeVdVQCnBKPDWxwRswGIWdD8wOEij60uhE
         0UoyXPhAETA5b6Z2JTCeWYNYnSt/q5GaFyun7CMtzrKKOkdEv3D1TDAp+6aluMEJ7G88
         4jgK8xuNn91SilFXC4eQESlSRnmyR9lpItpVOjkdeDJfMFTNz9f23XHoRdyaXD3obWl3
         UZyQ==
X-Gm-Message-State: AOAM5302beni7K0Vl5Ay1dcb4rTRX8ngnxiG1fswHrz1g9olWnk6y2Jd
        Z9yAMwGmiwdixKFRL9ss7kbjKg/JX3KfXzVikNsDbop0u+m7XEj8qeKkaJgF70iTcyWOv9Ckbwk
        OeaLlurov0eb3HXeUKrBZU7TT
X-Received: by 2002:a05:6830:314b:: with SMTP id c11mr2687008ots.224.1640194167812;
        Wed, 22 Dec 2021 09:29:27 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLuaJSYaMDrkK3LxDpl+f8Sw4+Sd0epeIomMC+76AxWf8uHWNgfE2xrDKogbzg5ksrKHQIdg==
X-Received: by 2002:a05:6830:314b:: with SMTP id c11mr2687001ots.224.1640194167650;
        Wed, 22 Dec 2021 09:29:27 -0800 (PST)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id m12sm512075oiw.23.2021.12.22.09.29.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 09:29:27 -0800 (PST)
From:   trix@redhat.com
To:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, nathan@kernel.org, ndesaulniers@google.com,
        yekai13@huawei.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] crypto: cleanup warning in qm_get_qos_value()
Date:   Wed, 22 Dec 2021 09:29:23 -0800
Message-Id: <20211222172923.3209810-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Building with clang static analysis returns this warning:

qm.c:4382:11: warning: The left operand of '==' is a garbage value
        if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
            ~~~~ ^

The call to qm_qos_value_init() can return an error without setting
*val.  So check ret before checking *val.

Fixes: 72b010dc33b9 ("crypto: hisilicon/qm - supports writing QoS int the host")
Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: Add Fixes: line

 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index b1fe9c7b8cc89..c906f2e59277b 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4379,7 +4379,7 @@ static ssize_t qm_get_qos_value(struct hisi_qm *qm, const char *buf,
 		return -EINVAL;
 
 	ret = qm_qos_value_init(val_buf, val);
-	if (*val == 0 || *val > QM_QOS_MAX_VAL || ret) {
+	if (ret || *val == 0 || *val > QM_QOS_MAX_VAL) {
 		pci_err(qm->pdev, "input qos value is error, please set 1~1000!\n");
 		return -EINVAL;
 	}
-- 
2.26.3

