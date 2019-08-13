Return-Path: <SRS0=ZPwR=WJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BA2C433FF
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 06:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4F25206C2
	for <linux-crypto@archiver.kernel.org>; Tue, 13 Aug 2019 06:06:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfHMGGV (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 13 Aug 2019 02:06:21 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33284 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfHMGGV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Aug 2019 02:06:21 -0400
Received: by mail-lj1-f194.google.com with SMTP id z17so12001213ljz.0;
        Mon, 12 Aug 2019 23:06:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gu8MBA8Z3R+Xt1ucvEfHABWXwqxMeH0K0P1m+jy5GAA=;
        b=O4r1Fygbb97mUrO9+2hqV4rrSAatLqPLnlOBDgKCTwrbTnpivDqQLYHGcEvA9P53dK
         JIkQQcYvSg7zUhcCUby5LtcV0vVGddeALVQb8vDnwR2W+dIIyb3OyN9YYFrR+wlyyiAA
         gJRigEvyaWxD9fezi4TJaBxkM1Loi6lp9WG+1+VwhPc2QTBqx+M/Sdq5Je6I6qv2ICIJ
         v+rZK14H7Me1wFX4AIoSlKxb5p9xxI677drUbPBX0BI1UM3aL8Z2IAeSszuug+EBtyMs
         YN8Qs8sge64Vh/EOFVuwgCkkMSlHDVL++WzBTRrw02LfgpviBo5w7zl+sltScmlrRYyy
         EODQ==
X-Gm-Message-State: APjAAAUYtr3Zw30vbvuO/cPDRu9eSOiq0vpg5lwkRT7pto8it499jGSE
        JNXK5Q3838WlSJ2lyAUMxu1xn4gCvuQ=
X-Google-Smtp-Source: APXvYqyGFaNVnt6vPgCE0R1pH1FkyAyoGQ177vk+qiG7LOsDWnidsXZvFbIZ4pH+8Qyfe6BccMbRfA==
X-Received: by 2002:a2e:9149:: with SMTP id q9mr3564051ljg.228.1565676379401;
        Mon, 12 Aug 2019 23:06:19 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-48-208.ip.moscow.rt.ru. [188.32.48.208])
        by smtp.googlemail.com with ESMTPSA id p15sm21740564lji.80.2019.08.12.23.06.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 23:06:18 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-kernel@vger.kernel.org
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        =?UTF-8?q?Breno=20Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
Subject: [PATCH] MAINTAINERS: nx crypto: Fix typo in a filepath
Date:   Tue, 13 Aug 2019 09:06:10 +0300
Message-Id: <20190813060610.13550-1-efremov@linux.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190325212654.26627-1-joe@perches.com>
References: <20190325212654.26627-1-joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Fix typo in nx_debugfs.c filepath. File extension changed from .h to .c
The file nx_debugfs.h never existed.

Cc: Breno Leitão <leitao@debian.org>
Cc: Nayna Jain <nayna@linux.ibm.com>
Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2117e5f4ff8..99a7392ad6bc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7658,7 +7658,7 @@ F:	drivers/crypto/nx/nx-aes*
 F:	drivers/crypto/nx/nx-sha*
 F:	drivers/crypto/nx/nx.*
 F:	drivers/crypto/nx/nx_csbcpb.h
-F:	drivers/crypto/nx/nx_debugfs.h
+F:	drivers/crypto/nx/nx_debugfs.c
 
 IBM Power Linux RAID adapter
 M:	Brian King <brking@us.ibm.com>
-- 
2.21.0

