Return-Path: <SRS0=AT0s=ZU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC78C432C0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 00:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E4840208E4
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Nov 2019 00:41:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oVSnEkfk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727280AbfK1Alo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Nov 2019 19:41:44 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:44673 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727191AbfK1Aln (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Nov 2019 19:41:43 -0500
Received: by mail-pj1-f68.google.com with SMTP id w8so10979081pjh.11;
        Wed, 27 Nov 2019 16:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=9/KvU09jM/BgUeXZbQ33AJI/29n1B/OHRwEMV0UXnHo=;
        b=oVSnEkfkxzWJIkroklQFL5l9SCvxLsZSqEMNbeq64rF3I+DqZBlxPaTH692JzQ6ZGE
         sZl1bfphXuAcTYdYOAgAjBaKOkpM7ywTECEIlJVG6gm7WTNCGzfWWq8TqaEase6QFYHp
         Db77u7G9tGTJrrd4FVBsyQT/aO0GYbzzsxMGfmQxzTZMECbZwBz3YdoxKAO9+qx2tT5W
         dB+pL5wGx/mMD6wCJ0NRui9/EeuRqpcMxxiAVFnwyYD2ztktAUiv/B5O0ndmLa/D4fBx
         SyVmEukW8dYnN06/sFXH4JLM+D0NmG5LNXHE6lAhezm6lWp2UpTZBNqligt2tIgvYXHg
         9qdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=9/KvU09jM/BgUeXZbQ33AJI/29n1B/OHRwEMV0UXnHo=;
        b=lM32yVnKfkNOjLrySOotFXuwjvT0qxi+Apy4D37g9QKuEY/gAHarmOQI/wvr9HnroN
         7Yw/fjO+GF87acRx/R0Big+1NOJJl4m27f11elkFFSOFN6rBVHEjCC560lqdt0y//mxM
         kNk/cPBP1YU+pxNO62MAeg1KdaW2l2own3RTTBpQUJAtjWNugJCIgAHTuUSgvE+0u2HZ
         kvDmjvOng3vS0nToTc/eeISE2v1O11mKOdSqicARCNIxroVGchmxFQ349QjwlNFba6MQ
         6Qs3TpjMp47BLRD432hF0ej+C90cYpp4SW25s/NuUBlLa6Aj+1QNsYj9pmndv9r8pCaD
         XkWA==
X-Gm-Message-State: APjAAAUXIDJP605FPdAxrvJUeusdL3HC9yOOeqxf3RCFq0O0ByYM+3is
        yP+oa39B6YmjmqPvATCD+Q==
X-Google-Smtp-Source: APXvYqw20O9d8eFPTtRIIbXBeE3VCtUDMGZbbzZ+ufD0VvcKHIjRkWES6CtpOsMdXRThBLeok32cng==
X-Received: by 2002:a17:90a:1982:: with SMTP id 2mr9749651pji.30.1574901703028;
        Wed, 27 Nov 2019 16:41:43 -0800 (PST)
Received: from [127.0.0.1] ([203.205.141.52])
        by smtp.gmail.com with ESMTPSA id j7sm8147583pjz.12.2019.11.27.16.41.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 16:41:42 -0800 (PST)
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Subject: [PATCH] CRYPTO: Fix initialize 'psp_ret' to avoid uninitialized usage
 in error paths
To:     linux-crypto@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     thomas.lendacky@amd.com, gary.hook@amd.com,
        herbert@gondor.apana.org.au, davem@davemloft.net
Message-ID: <aa2fd7ae-261a-5c62-821c-96479d11309b@gmail.com>
Date:   Thu, 28 Nov 2019 08:41:32 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

 From 842cac9822aafd3cfe2da154b92b033fa1ed0d2d Mon Sep 17 00:00:00 2001
From: Haiwei Li <lihaiwei@tencent.com>
Date: Thu, 28 Nov 2019 08:25:16 +0800
Subject: [PATCH] fix: initialize @psp_ret to avoid uninitialized usage 
in error paths

Initialize @psp_ret to -1 to avoid uninitialized usage in error paths.
Such as the function 'sev_flush_asides' in file 'arch/x86/kvm/svm.c'.


Signed-off-by: Haiwei Li <lihaiwei@tencent.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
  drivers/crypto/ccp/psp-dev.c | 3 +++
  1 file changed, 3 insertions(+)

diff --git a/drivers/crypto/ccp/psp-dev.c b/drivers/crypto/ccp/psp-dev.c
index 39fdd06..3501562 100644
--- a/drivers/crypto/ccp/psp-dev.c
+++ b/drivers/crypto/ccp/psp-dev.c
@@ -155,6 +155,9 @@ static int __sev_do_cmd_locked(int cmd, void *data, 
int *psp_ret)
  	unsigned int phys_lsb, phys_msb;
  	unsigned int reg, ret = 0;

+	if (psp_ret)
+		*psp_ret = -1;
+
  	if (!psp)
  		return -ENODEV;

--
1.8.3.1
