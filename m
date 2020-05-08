Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFE83C47254
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5FC218AC
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 22:35:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a6m+W2qi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728198AbgEHWfU (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 18:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726843AbgEHWfT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 18:35:19 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ADDC05BD43;
        Fri,  8 May 2020 15:35:19 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id y4so3325520ljn.7;
        Fri, 08 May 2020 15:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vNe+ECH+KI0KXYB/C0t3dikvQ9vGDkFhqEvtseTrJKE=;
        b=a6m+W2qicvjohyLDg4yrn+aFqEvR5GuBblUd4qw7xMZe5y8aHLMoYuZr6TwdMwpuEL
         LPAQv57wWv5/tfbmYwZjKVBGb6jbqjYqVp+zR7WtUtiK5tUThkYwa/MJddekkWLI8EY4
         fmp/BGqkyafNOocUquP1BttEm+SY7Lh3qU3OB3DE8t47HGvpeLb7okaImFUwA4/qh3QN
         cn7k0AjUa8l0hu0UDmNMbX/JV4DzkYsa5skC7NiLh5NkFrVJf7MRPOgPwjFgisLFIvgZ
         pKCHFjYec3t32AcRxwn7aK3O8w2+JG6tYseSEF1gtsK98JIc+hQvtFv/4hk9MK6zC8oS
         5oNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vNe+ECH+KI0KXYB/C0t3dikvQ9vGDkFhqEvtseTrJKE=;
        b=RDUAjz0UUcxuLHRKur1gDQSTKlkcHp7US1EXNKX//uNjcZ/OFfE5dvL5dvvzxKQNk8
         gpsvJ/ius9hReKTfwPX2cjB4Y7YYNXiK6hSQG6uIOH5kpFaUtS9UBt+AjoznJq8KAlVX
         G8wA6d4JlCYrJ6UGgZWmExqqtGYfn6o1X/jxJwvp2uW2OQ/ZH91Y/q6oKRiONjq7d3Ev
         OY3JIqrRwpvezt35X7TA6xd0OALe4sKSKe9NTFyi803bgejvkFuIGTyNbQCQ8JBDiLBG
         IYLwmxrcbbRNMv8tBZV8pMYPaNENbyHLltzjfTlPPrEwQmE0tTl5TKYY8yH98jkincHg
         iEnw==
X-Gm-Message-State: AOAM530Ctjn0n3lMEMUtgT+d8rByR/PrMs9SQTjwqNCVQIjSFicYegG5
        xusgLpRgOfIge5DFv7kOsx8=
X-Google-Smtp-Source: ABdhPJy9MbVNIXefpIUqxyYCkjcCwKzx6XB/qWbzjPyNrRHY4uBf7aymrgleAmkATmbX8wEPP0RwVg==
X-Received: by 2002:a05:651c:326:: with SMTP id b6mr3028310ljp.259.1588977317588;
        Fri, 08 May 2020 15:35:17 -0700 (PDT)
Received: from localhost.localdomain (h-158-174-22-22.NA.cust.bahnhof.se. [158.174.22.22])
        by smtp.gmail.com with ESMTPSA id s11sm2316501lfo.86.2020.05.08.15.35.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 15:35:17 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Zaibo Xu <xuzaibo@huawei.com>
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH 4/4] crypto: hisilicon/sec2 - constify sec_dfx_regs
Date:   Sat,  9 May 2020 00:35:02 +0200
Message-Id: <20200508223502.7258-5-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
References: <20200508223502.7258-1-rikard.falkeborn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

sec_dfx_regs is never changed and can therefore be made const.

This allows the compiler to put it in the text section instead of the
data section.

Before:
   text    data     bss     dec     hex filename
  17982    7312     480   25774    64ae drivers/crypto/hisilicon/sec2/sec_main.o

After:
   text    data     bss     dec     hex filename
  18366    6928     480   25774    64ae drivers/crypto/hisilicon/sec2/sec_main.o

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 drivers/crypto/hisilicon/sec2/sec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 07a5f4eb96ff..6f577b34098f 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -110,7 +110,7 @@ static const char * const sec_dbg_file_name[] = {
 	[SEC_CLEAR_ENABLE] = "clear_enable",
 };
 
-static struct debugfs_reg32 sec_dfx_regs[] = {
+static const struct debugfs_reg32 sec_dfx_regs[] = {
 	{"SEC_PF_ABNORMAL_INT_SOURCE    ",  0x301010},
 	{"SEC_SAA_EN                    ",  0x301270},
 	{"SEC_BD_LATENCY_MIN            ",  0x301600},
-- 
2.26.2

