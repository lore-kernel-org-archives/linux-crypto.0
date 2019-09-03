Return-Path: <SRS0=7iXC=W6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 016A5C3A5A5
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF52222CED
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Sep 2019 16:44:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o/cSwbn5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730134AbfICQoH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Sep 2019 12:44:07 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44556 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730133AbfICQoH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Sep 2019 12:44:07 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so6089929pfn.11
        for <linux-crypto@vger.kernel.org>; Tue, 03 Sep 2019 09:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aamHsTt7qMo6nP80it71PLpr/6sTUJeGAetaZJptbPw=;
        b=o/cSwbn5Bu3uXQ+r3TPgIG/f55MDyn/ay3aJH67AUeXUl6ipWw5RFMEZ89MskDmHQ/
         mb9qEYIx2+jYCXinXSGcGs7pICXFs3nbxLRiOUymU0avQ+tXEN5P5qI/3ecK22OKfwzE
         REbVVw8gLqd5dDuZbGZXXqHlQuOb5RrHvXWRmc48JnGeTHi9iAOmBprlSZFA9nojifeJ
         F7v7KhrZgzP/sYNutXRf0RxRUqg6W680TBy/ZTrgJQMci6Fm4ffnDyyc1RoOu+gfmQmw
         SXRGnaDH1BSLi46d8qYr9vokyoGHxruEKPWUte42OVDWwdwhgT/eDCncuG9pvqmnXZMd
         /HQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aamHsTt7qMo6nP80it71PLpr/6sTUJeGAetaZJptbPw=;
        b=lrBT7iGFnq6Pctn4YWdW+2A+Bum5PvACqmOyqfXXEf3Tnb+Cs9IhzHAEHW7DtHsyad
         Pbai7N16zS/cHlotComR7ownm7N+5r746RdRS+/+7F6l4rKR+8FphV2e+GuP+3ozEmgX
         q6h6NZaBjl1R2pZA357jQuTVYD6D3uASDqFEmWzYqD9EUS/4c18nxbw0TOi0nl6D1CxF
         C9jfoagU7opTpZ7WCqmBbbqx7mXe8duEXjojmeNlK1siMFd6JPxoBQ4n9jV7+FY6sFkh
         /wbtRKCEkfy+F7p2U1QaSPNNmPNEtSNwlOiKDkE7bKIhN6IwTO+wlmqOLWp6nF7hkSii
         J3sA==
X-Gm-Message-State: APjAAAVvNwnYWSQltQfqxdN9nO9wORozC9JnGGtU/CLa5BwGv9yHBTNX
        ZFpR12z1NRkR5ZIL9+Ro9DVQDi6eAZ7uvIod
X-Google-Smtp-Source: APXvYqz+lAqBUAXpJu3ICnJ3oZ8atMHz42I78xQ8SaezuXHpNEE6pXEIxNcWhVo84k3ICYaQyCuCIQ==
X-Received: by 2002:a62:c141:: with SMTP id i62mr19695910pfg.64.1567529046227;
        Tue, 03 Sep 2019 09:44:06 -0700 (PDT)
Received: from e111045-lin.nice.arm.com ([104.133.8.102])
        by smtp.gmail.com with ESMTPSA id b126sm20311847pfb.110.2019.09.03.09.44.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2019 09:44:05 -0700 (PDT)
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
To:     linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, ebiggers@kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v2 16/17] crypto: testmgr - add test vectors for XTS ciphertext stealing
Date:   Tue,  3 Sep 2019 09:43:38 -0700
Message-Id: <20190903164339.27984-17-ard.biesheuvel@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
References: <20190903164339.27984-1-ard.biesheuvel@linaro.org>
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
index ef7d21f39d4a..86f2db6ae571 100644
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

