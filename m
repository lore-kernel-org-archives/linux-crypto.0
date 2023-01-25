Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE84C38142
	for <linux-crypto@archiver.kernel.org>; Wed, 25 Jan 2023 00:23:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234449AbjAYAXb (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 24 Jan 2023 19:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234269AbjAYAX2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 24 Jan 2023 19:23:28 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E79A4C0D5
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:27 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id bk15so43433308ejb.9
        for <linux-crypto@vger.kernel.org>; Tue, 24 Jan 2023 16:23:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dZ27p7zF4T27+K/nN0SUmKAuxZywkQG/U6QyG5d8NyA=;
        b=QJ/19TCg14yqvOQLmIFg24XehYjzB9j13SdaTs1rKJ83AU1VbzHGuKuUMnia3DaMML
         LYwAkiPjcpm6NzEf2MRfedGuZXWLPbji4TBfQVe1kb2+bizrSabk+mvVD4ucmqmdHomI
         sOzZQOyU62Vj1y/SnnJ7ovCeQmu4/ovGgcCLS58UHYkmDqA9IS737Fa8dcPPHHX8FyKU
         X6ffSN2Y1q2FZbNMIoB5MCFOrEAHXpIJuP732o9D10rrJkvmhIKXIgz+muzpARYPOoYa
         4oXKc+9TN6pU4/ulqMYkpcDIyOvjw7ARw0qoWqgw9n9iDD42cWOsF+YLPNx9JYP0EXLl
         oJsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dZ27p7zF4T27+K/nN0SUmKAuxZywkQG/U6QyG5d8NyA=;
        b=5Hlz7tfX8vMiLrWAmEGIdJAoTyIFugmQUgNzR/6XudPO3cF9ynx/KQccrj/Vn291yi
         xAXzYREAij7cwFsjzHmN6ePPeqHk4KXfc7BIYK1JSFOMLW2+jOBg8Off7XYSxK9BDysW
         VYZXkcpsxb+Ukscj/NgPhA93sBMlarNSi05rOr4EGvrnHJav7/W9qAhagpHX/XEULu/9
         rFZhNFm7rjtfcrXucnKSD1UBMLhSvhnXw9X8sS4vq2Fvk44Z/vWNgq4RYpIXpiUmB+a4
         8A3jQA775OLqoqsYBDt0bw0WDpg4gUcFsGEUq+ioWap+kN6+xwE69qtXGN/hGVz0sEVT
         ETkQ==
X-Gm-Message-State: AFqh2kpZXlk/2jDZe+Q8Es/em3zdCkkO/Wn2WQo3WGC33U37npn4ZXY4
        mW1JHb23JJLUKsrEO+4FmI/qOA==
X-Google-Smtp-Source: AMrXdXuPVo13SXKzlv8efr0eXOVX+Rwf2H5jTBFY9jVwKrKrye2EFI7PJBI7aI+BIoZC8hmeQf5ZAg==
X-Received: by 2002:a17:906:a3cf:b0:861:3ed5:e029 with SMTP id ca15-20020a170906a3cf00b008613ed5e029mr44674312ejb.49.1674606202741;
        Tue, 24 Jan 2023 16:23:22 -0800 (PST)
Received: from fedora.local (c-05d8225c.014-348-6c756e10.bbcust.telenor.se. [92.34.216.5])
        by smtp.gmail.com with ESMTPSA id if10-20020a170906df4a00b00738795e7d9bsm1584606ejc.2.2023.01.24.16.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 16:23:22 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 25 Jan 2023 01:23:08 +0100
Subject: [PATCH v3 3/6] crypto: stm32/hash: Use existing busy poll function
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221227-ux500-stm32-hash-v3-3-32ee12cd6f06@linaro.org>
References: <20221227-ux500-stm32-hash-v3-0-32ee12cd6f06@linaro.org>
In-Reply-To: <20221227-ux500-stm32-hash-v3-0-32ee12cd6f06@linaro.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <robh@kernel.org>
X-Mailer: b4 0.11.1
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

When exporting state we are waiting indefinitely in the same
was as the ordinary stm32_hash_wait_busy() poll-for-completion
function but without a timeout, which means we could hang in
an eternal loop. Fix this by waiting for completion like the
rest of the code.

Acked-by: Lionel Debieve <lionel.debieve@foss.st.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- No changes
ChangeLog v1->v2:
- Pick up Lionel's ACK
---
 drivers/crypto/stm32/stm32-hash.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/stm32/stm32-hash.c b/drivers/crypto/stm32/stm32-hash.c
index 0473ced7b4ea..cc0a4e413a82 100644
--- a/drivers/crypto/stm32/stm32-hash.c
+++ b/drivers/crypto/stm32/stm32-hash.c
@@ -960,11 +960,13 @@ static int stm32_hash_export(struct ahash_request *req, void *out)
 	struct stm32_hash_dev *hdev = stm32_hash_find_dev(ctx);
 	u32 *preg;
 	unsigned int i;
+	int ret;
 
 	pm_runtime_get_sync(hdev->dev);
 
-	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
-		cpu_relax();
+	ret = stm32_hash_wait_busy(hdev);
+	if (ret)
+		return ret;
 
 	rctx->hw_context = kmalloc_array(3 + HASH_CSR_REGISTER_NUMBER,
 					 sizeof(u32),

-- 
2.39.0
