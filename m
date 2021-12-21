Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE45C433F5
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Dec 2021 21:00:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhLUVAN (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Dec 2021 16:00:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233985AbhLUVAM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Dec 2021 16:00:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1640120411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=opHhr7eJomY1CIR2KI4V/ZHUiBD46mZi8UhoJAWs9bo=;
        b=Zf8GQVKC/bSg2qbywQPm1OCl2ynUrYhn3P3t4gOZR9kQvdjQtC7AWIGGS165RAaSrbn6lD
        OXg73I4eg+L1CdlVeOZEvPZTTFRS57rp7it88ZePzBQdK7nvzthbllQM1gKtxfZ3DP16as
        BIYPljJmhJNZuxJyN3tK28IXoMfo4DU=
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com
 [209.85.167.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-108-kAI4M-AVMrG54JwuzNR52A-1; Tue, 21 Dec 2021 16:00:09 -0500
X-MC-Unique: kAI4M-AVMrG54JwuzNR52A-1
Received: by mail-oi1-f199.google.com with SMTP id n141-20020acad693000000b002c6b2dd398eso218109oig.5
        for <linux-crypto@vger.kernel.org>; Tue, 21 Dec 2021 13:00:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=opHhr7eJomY1CIR2KI4V/ZHUiBD46mZi8UhoJAWs9bo=;
        b=xYzQz91qzmJN7cAMIj5ciBVrSmtJb6TeZMVsUokRlr+srl8deS90m0CTfBH2ua36zj
         NciqJycB44eaLISUvbYkcJt5sGMAaY8oCfm5pHaFmNK7zC9GizlAmznWWQ4K+qRs43WE
         zJP28io6f9ghNS0JNUQY81VwkAXv/SBgdyu64NUz3oSWPmHKgMsXUMHS1fZatDZMVlPb
         lD756ioCubY6tvRb3w9kxccGWIwI3VqsMfiNHqyHt+6pp48XsFk4Is/mcvCAN1iYvlRv
         M+8gGzg9ctlDmG56Gunse6Lkr95hRpfHxiZFVsaMnFMWT+ETUNAdcRmZ8bT7NvVY0Sin
         j6ew==
X-Gm-Message-State: AOAM531XmyogL3ez/wV+c9H2rqMEuPsTT8m3U1BN6drp/vjdtsoITzTN
        3qWmploVIEV4UMSbRpVP0WU6DyRSfl1cIRhkPLePS/+c0qP/MABz5jppU3foJKyWpv8IQMqTBVa
        Z01BPuwUNykHzMGJqJyyiLeb0
X-Received: by 2002:aca:aa49:: with SMTP id t70mr9914oie.85.1640120408917;
        Tue, 21 Dec 2021 13:00:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJziVncuYfrfE+RPUGyGvApAs6V4DsQA0c2MP2vr+q3FzM7aw2hm+pPGcEc53t9Jy+88JOV4pw==
X-Received: by 2002:aca:aa49:: with SMTP id t70mr9890oie.85.1640120408439;
        Tue, 21 Dec 2021 13:00:08 -0800 (PST)
Received: from localhost.localdomain.com (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id f59sm2021otf.9.2021.12.21.13.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Dec 2021 13:00:08 -0800 (PST)
From:   trix@redhat.com
To:     wangzhou1@hisilicon.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] crypto: cleanup warning in qm_get_qos_value()
Date:   Tue, 21 Dec 2021 12:59:53 -0800
Message-Id: <20211221205953.3128923-1-trix@redhat.com>
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

Signed-off-by: Tom Rix <trix@redhat.com>
---
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

