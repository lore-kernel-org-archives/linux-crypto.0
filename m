Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2760CA9ED0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 05:14:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92F0F222C5
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 05:14:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=umn.edu header.i=@umn.edu header.b="cffg/fV/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388518AbfJRFOg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 01:14:36 -0400
Received: from mta-p7.oit.umn.edu ([134.84.196.207]:47168 "EHLO
        mta-p7.oit.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727606AbfJRFOg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 01:14:36 -0400
X-Greylist: delayed 571 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Oct 2019 01:14:35 EDT
Received: from localhost (unknown [127.0.0.1])
        by mta-p7.oit.umn.edu (Postfix) with ESMTP id 46C77973
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2019 05:05:04 +0000 (UTC)
X-Virus-Scanned: amavisd-new at umn.edu
Received: from mta-p7.oit.umn.edu ([127.0.0.1])
        by localhost (mta-p7.oit.umn.edu [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id sckEe33XRJMC for <linux-crypto@vger.kernel.org>;
        Fri, 18 Oct 2019 00:05:04 -0500 (CDT)
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        (using TLSv1.2 with cipher AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mta-p7.oit.umn.edu (Postfix) with ESMTPS id 204EB83E
        for <linux-crypto@vger.kernel.org>; Fri, 18 Oct 2019 00:05:04 -0500 (CDT)
Received: by mail-io1-f71.google.com with SMTP id e14so7006186iot.16
        for <linux-crypto@vger.kernel.org>; Thu, 17 Oct 2019 22:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=umn.edu; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=o6wi6lKR6QURG+vpCxfFe9q90HMrVgGmLRD3CJAHTaw=;
        b=cffg/fV/nPBsZK3w8HGcdzvxiuSEiuaqoFXjaiyGiRjOa2rbjBk/3dGaLQnkMjM/sI
         Hj6IhVKYvBwe1m5jdEajDeBVW0shdkBG/so63tr7vQHIrMq1/3uOsnPAu/OfXyZQgjuX
         sZFqk6QXAIkzNfQLp5nouVu/1y61ZNcEBelaql5SG8Qs1fnC+kQljBPsM5nTMoBDWEwB
         SvUOBIIYdseqV/r5BHg92eijOP4A2oGTI2sP4f6xPZ9evChaU/LtaA1PSuJSMtvZIIvP
         HdxwuAmOaEpFQ65rJX5sb9B88vb+HzyJEGIJsKJVkxe5AvjzJyHvOJ9thghjm0bk9luz
         Aqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=o6wi6lKR6QURG+vpCxfFe9q90HMrVgGmLRD3CJAHTaw=;
        b=Yd+TVLV9yBcn5nXT6cSo4prbUULhBYSPD1WgPg/EQbUTh0pOTqljlxNV9si7FdVvmV
         PltSqwYakFbU8fOFC5P7/RLTDPqPSDQ8IARa2ioG0QPro/edo1+/mvfPdFqwWSNPB7+N
         nvv/HHiBjYBUqRUTa9SknoIBEDCVFi5lGud2AzteG58QubqBFsj3ycTsId7UHAdeWiuD
         KKwoONSit2R7JOAJM6hhWBHTCfPFf47mXH8tANyqqWWZ+ULaz5bBzFlrut7Nm4CdFN6D
         HJSFmRSYQQQuyiVg096v+c6Dz50OI/+kPv3CoMoQrQmSa4ENFcVFIqR5vYRoR0VfAYKq
         KBPA==
X-Gm-Message-State: APjAAAVTU+Ptqx0uArals159swfrfMmXGz1rfRU+2tLJSmLQlV/ViWT5
        uWAjTBhPp3Db28NPeHNyx+RtdMmWYs1TRmmoIpqMOoWmjd0Wn2Z/wz2us7QfMjY8rMVbMVOVCiM
        Wymgey5RGyFk3mRj4518RSXQi2CLt
X-Received: by 2002:a6b:144f:: with SMTP id 76mr6838366iou.51.1571375103257;
        Thu, 17 Oct 2019 22:05:03 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzm6jnrRw2AGNq6LEQ59zd7K6mheF9Scz8nOpmEeh0/5sAj63ZAs7O9VGtINjnJyH5a1/P33Q==
X-Received: by 2002:a6b:144f:: with SMTP id 76mr6838341iou.51.1571375102964;
        Thu, 17 Oct 2019 22:05:02 -0700 (PDT)
Received: from bee.dtc.umn.edu (cs-bee-u.cs.umn.edu. [128.101.106.63])
        by smtp.gmail.com with ESMTPSA id i4sm1400916iop.6.2019.10.17.22.05.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 22:05:02 -0700 (PDT)
From:   Kangjie Lu <kjlu@umn.edu>
To:     kjlu@umn.edu
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: hash - initializing memory buffer for keys
Date:   Fri, 18 Oct 2019 00:04:56 -0500
Message-Id: <20191018050457.13809-1-kjlu@umn.edu>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

"ctx" is uninitialized. To avoid undefined behaviors or memory
disclosures, we better initialize it.

Signed-off-by: Kangjie Lu <kjlu@umn.edu>
---
 crypto/algif_hash.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/algif_hash.c b/crypto/algif_hash.c
index 178f4cd75ef1..129a124e5056 100644
--- a/crypto/algif_hash.c
+++ b/crypto/algif_hash.c
@@ -433,6 +433,7 @@ static int hash_accept_parent_nokey(void *private, struct sock *sk)
 	ctx = sock_kmalloc(sk, len, GFP_KERNEL);
 	if (!ctx)
 		return -ENOMEM;
+	memset(ctx, 0, len);
 
 	ctx->result = NULL;
 	ctx->len = len;
-- 
2.17.1

