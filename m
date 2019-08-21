Return-Path: <SRS0=bUM2=WR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10A3C3A59E
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92EF62339F
	for <linux-crypto@archiver.kernel.org>; Wed, 21 Aug 2019 14:33:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V0KpIxUN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbfHUOd3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 21 Aug 2019 10:33:29 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:33543 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729313AbfHUOd2 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 21 Aug 2019 10:33:28 -0400
Received: by mail-wm1-f65.google.com with SMTP id p77so4916545wme.0
        for <linux-crypto@vger.kernel.org>; Wed, 21 Aug 2019 07:33:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=AGMVgjDEG83Kdzuq7B1f+yZ7wOUASWkpWpxVlI6zo6E=;
        b=V0KpIxUNnxq2SWesypTV5fLlGjhpvZUbWWoHb+hh3I5OT99iej3LuJEGVnC9US6MP+
         hKgcQISjxem0S/3CkRl72YfQnW871dZOOrcztgNQhagMTyHTj9bX0THRTXdYDROswzDJ
         TC0iCpjDsmolTvckXNhOs1tAQh3NgWJd03EHcC3clhFbh/hcRrXkOrMr9iiJsMYaoA8C
         NIKGUvhOtDPB7ObZFapVS1M97f98jUijpIC5EJROMo8i0j97f8VNyDQpzyTbrCYJnmdC
         nL06VXat/F0rRhKAnAToC6hhlsaoBxu4A9O6qeuyTndcEAYzgkjEv4tdryF+49gciuJO
         HliA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=AGMVgjDEG83Kdzuq7B1f+yZ7wOUASWkpWpxVlI6zo6E=;
        b=mJ42c4kh1ERRW41GCFzKVP6xuZPj2jyHe0OjN2VkwnJvySYpUg8dA6Vcpy50hM3ucr
         I92gmktbA0N61FYCiULC3MspwLNuoCKRRNA3i1SFcR6GFyj/NpumvR9RkO9C7HAKtKd2
         wkSBI6fUHowuAHvf+0SaXq9xMtnkwt42ebkkHra5o0/hyfzYbagGBGXse43r721WVGQk
         zdG1hrAhmmd01O4hJpPolOmtdULGlEzI9L+MNB6GSA5c/iI+2EcN8RiPMa2zUZZlRuKX
         2jnHFJxhFRAoDLDdSSf4Z/iovGXcRf/RiT+cIkzqew/2MQhXDDZh/NXTajDRfsjfwNj7
         v4ew==
X-Gm-Message-State: APjAAAXv+PoIxItZeVK1viH/13g4ByImz+y4fuVVsPS80HuImryQPesu
        6Mf5MR/+YBBCIRHf6EJM7swMjylhcC9PIQ==
X-Google-Smtp-Source: APXvYqxoMhCOv+pIMDTnpNf02joGF4HdEkeRHRAN6hr5BTz3GYRQNbZ8YSijCMdays/BX07QktdNsg==
X-Received: by 2002:a1c:18a:: with SMTP id 132mr375595wmb.15.1566398007331;
        Wed, 21 Aug 2019 07:33:27 -0700 (PDT)
Received: from mba13.lan (adsl-103.109.242.1.tellas.gr. [109.242.1.103])
        by smtp.gmail.com with ESMTPSA id 16sm181427wmx.45.2019.08.21.07.33.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2019 07:33:26 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 16/17] crypto: testmgr - add test vectors for XTS ciphertext stealing
Date:   Wed, 21 Aug 2019 17:32:52 +0300
Message-Id: <20190821143253.30209-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Import the AES-XTS test vectors from IEEE publication P1619/D16
that exercise the ciphertext stealing part of the XTS algorithm,
which we haven't supported in the Linux kernel implementation up
till now.

Tested-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 crypto/testmgr.h | 60 ++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index 154052d07818..b88a1ba87b58 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15291,6 +15291,66 @@ static const struct cipher_testvec aes_xts_tv_template[] = {
 			  "\xc4\xf3\x6f\xfd\xa9\xfc\xea\x70"
 			  "\xb9\xc6\xe6\x93\xe1\x48\xc1\x51",
 		.len	= 512,
+	}, { /* XTS-AES 15 */
+		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
+			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
+			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
+			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
+		.klen   = 32,
+		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10",
+		.ctext	= "\x6c\x16\x25\xdb\x46\x71\x52\x2d"
+			  "\x3d\x75\x99\x60\x1d\xe7\xca\x09"
+			  "\xed",
+		.len	= 17,
+	}, { /* XTS-AES 16 */
+		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
+			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
+			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
+			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
+		.klen   = 32,
+		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11",
+		.ctext	= "\xd0\x69\x44\x4b\x7a\x7e\x0c\xab"
+			  "\x09\xe2\x44\x47\xd2\x4d\xeb\x1f"
+			  "\xed\xbf",
+		.len	= 18,
+	}, { /* XTS-AES 17 */
+		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
+			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
+			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
+			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
+		.klen   = 32,
+		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12",
+		.ctext	= "\xe5\xdf\x13\x51\xc0\x54\x4b\xa1"
+			  "\x35\x0b\x33\x63\xcd\x8e\xf4\xbe"
+			  "\xed\xbf\x9d",
+		.len	= 19,
+	}, { /* XTS-AES 18 */
+		.key    = "\xff\xfe\xfd\xfc\xfb\xfa\xf9\xf8"
+			  "\xf7\xf6\xf5\xf4\xf3\xf2\xf1\xf0"
+			  "\xbf\xbe\xbd\xbc\xbb\xba\xb9\xb8"
+			  "\xb7\xb6\xb5\xb4\xb3\xb2\xb1\xb0",
+		.klen   = 32,
+		.iv     = "\x9a\x78\x56\x34\x12\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13",
+		.ctext	= "\x9d\x84\xc8\x13\xf7\x19\xaa\x2c"
+			  "\x7b\xe3\xf6\x61\x71\xc7\xc5\xc2"
+			  "\xed\xbf\x9d\xac",
+		.len	= 20,
 	}
 };
 
-- 
2.17.1

