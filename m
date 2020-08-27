Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BE6C433E1
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:58:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B81322B4E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:58:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727968AbgH0O5q (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:57:46 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44006 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728979AbgH0MYa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 08:24:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id f24so4709454edw.10;
        Thu, 27 Aug 2020 05:24:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Vdm5bOPgHGnazrV/Kf0E8YPoyr6BTDTZTERvVKKiRHM=;
        b=Nv2eLtFi7qUWI+BkaMRgMDzKansk6py7a6fhEsVw3637DYVhatbDiGdLhBaQug0Mb3
         db58+FBogSBiPKcIu6n/unzweD/musmlbHPvejuAr4Wc9oMcPqeNtII5O+zI0Orn/31B
         KIl8kILId48IKVsKE2VKR4vON6r1Yz3WDYM27MwG7wtMZo9BZlHkgozkkR575Y1gROMg
         tr/xmbbv9U7YNsIBQ2nZb8YSRcTq1sOIX+72Mc41D5hvD+uOkDAO8hJIKlKSXeTgb5QF
         /VR9+7kWhYBEp5jy+GNSW2URQVuZGqmJgKOLuZP8hfEm813DmPsoe2/Snoc0q1NNcBXl
         Knhw==
X-Gm-Message-State: AOAM533df0Z7kEdlBNzMPEORMCqTnU/QHVaAYjg0ax08q1plhiMoDxga
        inFq45B4/aweSFI6CPC5Z8FFdmxh/+M=
X-Google-Smtp-Source: ABdhPJyyvKxCqX6kyF+9lvjOAwGkbcCCXX1PSBj1we4uxG0oHrShT7n2rDYVeh00xibYfjNLDsxuKg==
X-Received: by 2002:a2e:1417:: with SMTP id u23mr10159832ljd.44.1598530582939;
        Thu, 27 Aug 2020 05:16:22 -0700 (PDT)
Received: from localhost.localdomain ([213.87.147.111])
        by smtp.googlemail.com with ESMTPSA id 85sm434871ljj.61.2020.08.27.05.16.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 05:16:22 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
Cc:     Denis Efremov <efremov@linux.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] crypto: sun8i-ss - remove redundant memzero_explicit()
Date:   Thu, 27 Aug 2020 15:16:11 +0300
Message-Id: <20200827121611.18308-1-efremov@linux.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200827080310.GA29222@Red>
References: <20200827080310.GA29222@Red>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Remove redundant memzero_explicit() in sun8i_ss_cipher() before calling
kfree_sensitive(). kfree_sensitive() will zero the memory with
memzero_explicit().

Fixes: 453431a54934 ("mm, treewide: rename kzfree() to kfree_sensitive()")
Signed-off-by: Denis Efremov <efremov@linux.com>
---
Changes in v2:
 - fixes tag added

 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
index deb8b39a86db..ed2a69f82e1c 100644
--- a/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
+++ b/drivers/crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c
@@ -248,7 +248,6 @@ static int sun8i_ss_cipher(struct skcipher_request *areq)
 			offset = areq->cryptlen - ivsize;
 			if (rctx->op_dir & SS_DECRYPTION) {
 				memcpy(areq->iv, backup_iv, ivsize);
-				memzero_explicit(backup_iv, ivsize);
 				kfree_sensitive(backup_iv);
 			} else {
 				scatterwalk_map_and_copy(areq->iv, areq->dst, offset,
-- 
2.26.2

