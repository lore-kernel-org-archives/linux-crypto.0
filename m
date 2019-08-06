Return-Path: <SRS0=y31I=WC=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C343EC31E40
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AB4F2054F
	for <linux-crypto@archiver.kernel.org>; Tue,  6 Aug 2019 08:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uGsaTM/M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfHFICq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 6 Aug 2019 04:02:46 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39270 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732160AbfHFICq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 6 Aug 2019 04:02:46 -0400
Received: by mail-wr1-f66.google.com with SMTP id x4so33716364wrt.6
        for <linux-crypto@vger.kernel.org>; Tue, 06 Aug 2019 01:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=9eCxiU7trAIwWtoYhqWEWGHnQv1gzwh/Q9h6ScO5S58=;
        b=uGsaTM/M2gCO96HNT2CT+L0/NsYOQP5WwmmlN+ya7tI16k5RMO2HwcYWh6H6R3oYHm
         rAzdwy+lnPGdSNHSO1FV3Crk5TwyEYOTLawosrkK1bSB0Ypn33n9eBbZXhy9wY6QNR3S
         amR1DiMRY2rT94FVuPH5ZMNe0BS2+l9qybrY3769M6HE/Fi2yk/NyDTlLcmW4DDJfDRm
         8/3szwCVQVOO/b231zSJdRgRtJQTLJ/3KKLUxisOaBJpzZOBhiIZxOBqyS+o68pY/jBw
         KfuEtggPHIGXBSjQq6RTjYiXzRgy4LhaB1z90bfk5rsi782P9hTmgRJ/c8Be1kI77Sfj
         hwNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=9eCxiU7trAIwWtoYhqWEWGHnQv1gzwh/Q9h6ScO5S58=;
        b=mXvH1BFel9m/gXtvLgWkOIuR/JxWfDOwBrXgNAOlMpMnPysZHpw5ZOJ5PafgrdMGwk
         TPX7O6zingCdnoeRMXfVJCUZE7Yr7aw5qifxNzd+PQegBLpuHK3rZDfMxZBrKWZH14BK
         ZM8B/WxvRZk0eL0KXBLEIFblPLKSUg8dxyO1KPObOqJhoLfG99cwBkyQOj6n/NZf9KN3
         hb2STO/QoFoPZYaAgBG9f0eV99RQqeXRiNMhI84tqKjT/RA4DL4iJYWS15iF7PbqG+DU
         9mq1gzTgp9fmoFZbZ/nNO8TUrftoxfnB3//o5KRI8Ry0IijiFXhoKsbOhyEYT+om5D7B
         mUvw==
X-Gm-Message-State: APjAAAWe55msFvNTomXpY7ZuR5w07lrtE4AT20C4NkU0bsVe4zIMSj14
        RuPhN/XUDs4QKMSN81TxsWq0QOMx6c34sg==
X-Google-Smtp-Source: APXvYqx3eVQe//5zmmtHda+AHpMkDhzZCnwtpz2EpeHXLmtnqf3YRw+KKwvbS6VL0M/WsBChtG66rg==
X-Received: by 2002:a5d:4e02:: with SMTP id p2mr3054604wrt.182.1565078563578;
        Tue, 06 Aug 2019 01:02:43 -0700 (PDT)
Received: from localhost.localdomain ([2a02:587:a407:da00:582f:8334:9cd9:7241])
        by smtp.gmail.com with ESMTPSA id g12sm123785475wrv.9.2019.08.06.01.02.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 01:02:42 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org, agk@redhat.com,
        snitzer@redhat.com, dm-devel@redhat.com, gmazyland@gmail.com,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [RFC PATCH 1/2] md/dm-crypt - restrict EBOIV to cbc(aes)
Date:   Tue,  6 Aug 2019 11:02:33 +0300
Message-Id: <20190806080234.27998-2-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
References: <20190806080234.27998-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Support for the EBOIV IV mode was introduced this cycle, and is
explicitly intended for interoperability with BitLocker, which
only uses it combined with AES in CBC mode.

Using EBOIV in combination with any other skcipher or aead mode
is not recommended, and so there is no need to support this.
However, the way the EBOIV support is currently integrated permits
it to be combined with other skcipher or aead modes, and once the
cat is out of the bag, we will need to support it indefinitely.

So let's restrict EBOIV to cbc(aes), and reject attempts to
instantiate it with other modes.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/md/dm-crypt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index d5216bcc4649..a5e8d5bc1581 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -861,6 +861,13 @@ static int crypt_iv_eboiv_ctr(struct crypt_config *cc, struct dm_target *ti,
 	struct iv_eboiv_private *eboiv = &cc->iv_gen_private.eboiv;
 	struct crypto_cipher *tfm;
 
+	if (test_bit(CRYPT_MODE_INTEGRITY_AEAD, &cc->cipher_flags) ||
+	    strcmp("cbc(aes)",
+	           crypto_tfm_alg_name(crypto_skcipher_tfm(any_tfm(cc))))) {
+		ti->error = "Unsupported encryption mode for EBOIV";
+		return -EINVAL;
+	}
+
 	tfm = crypto_alloc_cipher(cc->cipher, 0, 0);
 	if (IS_ERR(tfm)) {
 		ti->error = "Error allocating crypto tfm for EBOIV";
-- 
2.17.1

