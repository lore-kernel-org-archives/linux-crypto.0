Return-Path: <SRS0=Ic7o=YK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9966BFA372A
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:39:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 696A621835
	for <linux-crypto@archiver.kernel.org>; Thu, 17 Oct 2019 16:39:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bizxW2iq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440498AbfJQQjd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 17 Oct 2019 12:39:33 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43393 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729529AbfJQQjd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 17 Oct 2019 12:39:33 -0400
Received: by mail-wr1-f67.google.com with SMTP id j18so3113742wrq.10
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 09:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aTLhNcek6xPUcSJYqH/7VnHiyCYLdIPPndN1mNRNi1I=;
        b=bizxW2iqJ/myY96G2MbmcrDi072+j8LLO8OKbyl+gByLVegcACQcY1N+pOFKJa8T5v
         HLUyxWGY7FIZ1GJrgpk8aWWvpb2ZX9RDUW6OujjEtlR0uY6eMNIeSFvFcXeG4ELRjlCf
         VmEWzQTjGsnXJhXo+trwh4Tx95IeR9lCu6IkT4Aw1uRBSvVzxTNKGa/pORmirXIkYI3m
         RB5lRUuwo/xZo+kD+KNxKOZA5cdojJ7aCwlesS+qtjpM8H9dmG1BvZoy6m4aPsa5VSPs
         BBeBObyZir+njaHka0Lc/c6OWmPK0x6shHIA++9NHYIO0idjXFBmruxsb2JrIPD6kQhh
         bgVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aTLhNcek6xPUcSJYqH/7VnHiyCYLdIPPndN1mNRNi1I=;
        b=rgx5rxQyyV0e2o1Kqc8dvNvjM8WPSBxyjT+nCk2xTSdBTTJ3XeyIQ3j6Ujptp33Gjt
         H5kc3bbIQmqbDjcBtX78hr3fLSjgBE38668IyMDOEKEknG7rfcNYiYjv6kqlxcKEL1/B
         dySRyMMfh7XJk/x4diDSlpvZ//KcOI3jn7FgpyDKQYdVUA9eOfTnvpWxSIYGRWFFOR+I
         l2/tXU4du2VGEv2cADCvd9xaIVFhix7Ign84+ldqi8NedgVu/9L1wzRt363b4rfsT74r
         9pHa5Wb9J/zHm18bfQ1z4Q/nYR7Mfuf/LteFQfGSuGJLOJrgrm7Yeo4CUly9Np/5CyFv
         T7dQ==
X-Gm-Message-State: APjAAAU3mbuLbmg9+R/zoxL6uZJc9T/7pyW8ZnslaRtlsJC6nvTq+wkV
        2uBTRFSJ0If+vArFH3GGBGPuKPSR
X-Google-Smtp-Source: APXvYqw2gsUS8cWrjtpkK/tyLBFQyRpfjX+Rsj+T+OwtJn78egH7kTttfDLScrIXQ+ufHZ1tBcDT8g==
X-Received: by 2002:adf:ea07:: with SMTP id q7mr940423wrm.102.1571330370806;
        Thu, 17 Oct 2019 09:39:30 -0700 (PDT)
Received: from localhost.localdomain.com ([188.204.2.113])
        by smtp.gmail.com with ESMTPSA id w125sm3769781wmg.32.2019.10.17.09.39.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 17 Oct 2019 09:39:30 -0700 (PDT)
From:   Pascal van Leeuwen <pascalvanl@gmail.com>
X-Google-Original-From: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
To:     linux-crypto@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, herbert@gondor.apana.org.au,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: [PATCH] crypto: inside-secure - Fix build error with CONFIG_CRYPTO_SM3=m
Date:   Thu, 17 Oct 2019 17:36:28 +0200
Message-Id: <1571326588-8013-1-git-send-email-pvanleeuwen@verimatrix.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Always take the zero length hash value for SM3 from the local constant
to avoid a reported build error when SM3 is configured to be a module.

Signed-off-by: Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
---
 drivers/crypto/inside-secure/safexcel_hash.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/inside-secure/safexcel_hash.c b/drivers/crypto/inside-secure/safexcel_hash.c
index 85c3a07..c906509a 100644
--- a/drivers/crypto/inside-secure/safexcel_hash.c
+++ b/drivers/crypto/inside-secure/safexcel_hash.c
@@ -785,12 +785,8 @@ static int safexcel_ahash_final(struct ahash_request *areq)
 			memcpy(areq->result, sha512_zero_message_hash,
 			       SHA512_DIGEST_SIZE);
 		else if (ctx->alg == CONTEXT_CONTROL_CRYPTO_ALG_SM3) {
-			if (IS_ENABLED(CONFIG_CRYPTO_SM3))
-				memcpy(areq->result, sm3_zero_message_hash,
-				       SM3_DIGEST_SIZE);
-			else
-				memcpy(areq->result,
-				       EIP197_SM3_ZEROM_HASH, SM3_DIGEST_SIZE);
+			memcpy(areq->result,
+			       EIP197_SM3_ZEROM_HASH, SM3_DIGEST_SIZE);
 		}
 
 		return 0;
-- 
1.8.3.1

