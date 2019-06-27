Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3332C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC20B20828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 10:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F0Qzyeux"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbfF0K2D (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 06:28:03 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44949 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726659AbfF0K2C (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 06:28:02 -0400
Received: by mail-wr1-f68.google.com with SMTP id r16so49154wrl.11
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 03:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TEkyEzYA9z24dLcVZzAphhOs6uMPB3TRScCj5mulxhM=;
        b=F0Qzyeux+dCKngRehSdIDngCe+wHs5fNOoDW3q126dSrSAGOF270GYPZwYhrga9cBy
         mx/RvqAXRoHBNEc2bz2kuKB7eQjog1PHAukgcxKr8QoiFDwnQQpQbZG6tqMu9Zw/+pKy
         vE7Fi4EanxaBgLFcLkIVyDgktm+w7S81STdQ1yGvoqdZ72SirCamZPeUFd7q0ejBpSCK
         HsGEDn4cc7KQRlnaJIpQvxO2q+Ha77KaTfpLbqVgfFPOrNPSfZTCMhKawDCw8p9yEjap
         NzvOGCriAYL0nYiCaz1zoCkjbDwb9uUq1G8VP7I+6Iv0oNc39g57S4JrEBv24/KaNYmc
         V2wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TEkyEzYA9z24dLcVZzAphhOs6uMPB3TRScCj5mulxhM=;
        b=GToyu3lokOoe9WccP+uLJ7Fr2vQn0JBjsUoD0skqTI3uT0/w7KEt4W7tYcqFOaLv+2
         BVFY5hekwuBMWSlFxwJAulrf0kskKd9MegMBw1wiVvrmt+itBSQUpKY05agwjJaByvVc
         p1Oacs3anenRUke9//+ORTyh6j/GnbSHSad+cw3Y2DIleEOVcd6u+CE1Mb0kuemNU7xu
         70orcMmJtUh8bpKk8z15GiBJQuw6U2WioYs3ySAe1ZJRG+bFJIJ/EI1HsQtcLot1ihZr
         dZADcqy7P4QFMvU63hVvu09ID6d+o+PLfPmms1S7J/+a2HoKXWIlsZQuKjY9L60j5lbO
         B1AQ==
X-Gm-Message-State: APjAAAXF5FZvdqpWg/NnS81g3YVpBQRFq3NtFsI54bV+gwQIcMhciNOt
        OilNJVwma2FDqo+J+Oe0ZNwZe1p0NGg=
X-Google-Smtp-Source: APXvYqzskndiBGiZy/MIkL5pCdEM3961VN6CRqi6dFY+eEcnHwFk6+hwungzIvugTSePLZdI+xDbLQ==
X-Received: by 2002:a5d:63c9:: with SMTP id c9mr2802409wrw.81.1561631280581;
        Thu, 27 Jun 2019 03:28:00 -0700 (PDT)
Received: from localhost.localdomain (aaubervilliers-681-1-8-173.w90-88.abo.wanadoo.fr. [90.88.13.173])
        by smtp.gmail.com with ESMTPSA id g2sm5584533wmh.0.2019.06.27.03.27.59
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:27:59 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v3 09/32] crypto: safexcel/aes - switch to library version of key expansion routine
Date:   Thu, 27 Jun 2019 12:26:24 +0200
Message-Id: <20190627102647.2992-10-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
References: <20190627102647.2992-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Switch to the new AES library that also provides an implementation of
the AES key expansion routine. This removes the dependency on the
generic AES cipher, allowing it to be omitted entirely in the future.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 drivers/crypto/Kconfig                         | 2 +-
 drivers/crypto/inside-secure/safexcel_cipher.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index fdccadc94819..b30b84089d11 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -718,7 +718,7 @@ config CRYPTO_DEV_SAFEXCEL
 	tristate "Inside Secure's SafeXcel cryptographic engine driver"
 	depends on OF
 	depends on (ARM64 && ARCH_MVEBU) || (COMPILE_TEST && 64BIT)
-	select CRYPTO_AES
+	select CRYPTO_LIB_AES
 	select CRYPTO_AUTHENC
 	select CRYPTO_BLKCIPHER
 	select CRYPTO_DES
diff --git a/drivers/crypto/inside-secure/safexcel_cipher.c b/drivers/crypto/inside-secure/safexcel_cipher.c
index 8cdbdbe35681..19ec086dce4f 100644
--- a/drivers/crypto/inside-secure/safexcel_cipher.c
+++ b/drivers/crypto/inside-secure/safexcel_cipher.c
@@ -178,7 +178,7 @@ static int safexcel_skcipher_aes_setkey(struct crypto_skcipher *ctfm,
 	struct crypto_aes_ctx aes;
 	int ret, i;
 
-	ret = crypto_aes_expand_key(&aes, key, len);
+	ret = aes_expandkey(&aes, key, len);
 	if (ret) {
 		crypto_skcipher_set_flags(ctfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
 		return ret;
-- 
2.20.1

