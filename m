Return-Path: <SRS0=0i+u=ZA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BE9FC6195
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7D1521882
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Nov 2019 15:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20150623.gappssmtp.com header.i=@baylibre-com.20150623.gappssmtp.com header.b="ms0ZZbhA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbfKHPmX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:42:23 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44768 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbfKHPmW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Nov 2019 10:42:22 -0500
Received: by mail-wr1-f68.google.com with SMTP id f2so7502917wrs.11
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2019 07:42:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=jKPwU4G5ZX4lcKZD1A5yKqJfsxOjsfGHCxHwZ6UfGno=;
        b=ms0ZZbhABfwMbyFEPzoqrZW+YW98SUb4ndQoyJeWjteLp/6YGXV8Ca2KwaEzdToEEy
         Vk3x6HKHsbp1kydx+WpVsSMO2LEWT0hXrSC3FC5aWPWymSLdefXnz2fd+ifW9DFU3jU6
         eXMLogwp9e5WfN/sRjYPxeWnEOE9GWZk3lo51X0ZrZRHmVF4HWWsm+BjxhcwY9MZ98RH
         JDTVqGHTV0gS8h0fv3at6BHI7dKVqXy8e+yVsgzUdihD08eRWx6PV6JN3cIuyiFQRerr
         jftvtORLpeXTX4MXw7KZtGh653rUv56tPokH/iakFAPxFV9KpEcraiUCfwlJguuZPfjZ
         68og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=jKPwU4G5ZX4lcKZD1A5yKqJfsxOjsfGHCxHwZ6UfGno=;
        b=q8eMuokM1VDofxnZm8Hc4lPj6ZOzNhU5nQibsmalwpG9u7oeBsVto4Gct4VSP8Db01
         EjY/i5+GgREFJGcAw0zPro6AlenKUwcKdAm3Sw3NT01qRz4XFTZKJ/OMn4Esw5MLlEkM
         atliky5DidwC3SZp3A6xCWxziWfyNA0FlCLUpZaGacnzlfg9aNpPKV9HTj0quj96rSFS
         kPuQpFNG84GaK1ZARbSwL4/uuWxEp4T3Ql3GF3gEyq4quvJh3PQ4oIRPcr9VJCoL1sRG
         5YlSPKZwhK0h7XrC6/XZrRhnsbQjTw3/zPsCzZ8MdgY2JdVj/9V4UeHWgx5spU3/VpmZ
         uUlg==
X-Gm-Message-State: APjAAAXK4Ap2SZz/xfYSH9N6TA0Jbr1Say9AOFE7TdMKMOyme76jGbZj
        ExYFggBcZUNdnHLwSBNLsIVbKw==
X-Google-Smtp-Source: APXvYqwEsGbr93t2+n4r/AAfkYjXnQq7ETdPx8Y8kIolecEl6bhAKL63EtJDoI8Eaoer/RAkASE3kQ==
X-Received: by 2002:adf:eed2:: with SMTP id a18mr6790890wrp.273.1573227739417;
        Fri, 08 Nov 2019 07:42:19 -0800 (PST)
Received: from localhost.localdomain ([51.15.160.169])
        by smtp.googlemail.com with ESMTPSA id v16sm7474024wrc.84.2019.11.08.07.42.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 08 Nov 2019 07:42:18 -0800 (PST)
From:   Corentin Labbe <clabbe@baylibre.com>
To:     davem@davemloft.net, herbert@gondor.apana.org.au
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Corentin Labbe <clabbe@baylibre.com>
Subject: [PATCH] crypto: tcrypt: constify check alg list
Date:   Fri,  8 Nov 2019 15:42:13 +0000
Message-Id: <1573227733-36704-1-git-send-email-clabbe@baylibre.com>
X-Mailer: git-send-email 2.7.4
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

this patchs constify the alg list because this list is never modified.

Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
---
 crypto/tcrypt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 83ad0b1fab30..f42f486e90e8 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -65,7 +65,7 @@ static int mode;
 static u32 num_mb = 8;
 static char *tvmem[TVMEMSIZE];
 
-static char *check[] = {
+static const char *check[] = {
 	"des", "md5", "des3_ede", "rot13", "sha1", "sha224", "sha256", "sm3",
 	"blowfish", "twofish", "serpent", "sha384", "sha512", "md4", "aes",
 	"cast6", "arc4", "michael_mic", "deflate", "crc32c", "tea", "xtea",
@@ -1634,7 +1634,7 @@ static void test_cipher_speed(const char *algo, int enc, unsigned int secs,
 
 static void test_available(void)
 {
-	char **name = check;
+	const char **name = check;
 
 	while (*name) {
 		printk("alg %s ", *name);
-- 
2.23.0

