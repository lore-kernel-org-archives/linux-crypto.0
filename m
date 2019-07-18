Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3933CC76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 13:16:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E0DC20880
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 13:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cRoEXgvJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727685AbfGRNQ0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 09:16:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39319 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726608AbfGRNQ0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 09:16:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id u17so12894622pgi.6;
        Thu, 18 Jul 2019 06:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E264ER/0qOw955RgC9Lbu6scgSqBy/HNaAzmWqDshh8=;
        b=cRoEXgvJ5mOD5AC1NfZ5n0dqbxnmKR6608avDM/hCQ6Eb3WU6CeMZhJTSGDOX+UP5G
         YOlKOzsLVh2TJo0lUb2P17QZH7S1dDDyM0vsF8mYOHkXGmYb1aNdNwIK+6t2PJ6opJ33
         prGqBuzXg6KhGLwSt+PfUdEyfxucVnMV/etoWncWmwhPVBSEpdTTLOE8tbeiVjYFijfO
         +zZwuJ7N8/ywE4ouoBB1mge2Px4jE+IftVCa/AWTLfTkGxddtpXKeStH3nnCxEiszms5
         Mk/PYpKNrlCcpXnH8S6YTBEBQ45aUHL7iD1rVi1Nxza3mYfxi0l7YLOFbJZSRdBmA5Zp
         9jug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=E264ER/0qOw955RgC9Lbu6scgSqBy/HNaAzmWqDshh8=;
        b=hGOqcLlUBspb1/veM1uSX0dI9IBIn/CM2h2N5i7ABtuK7iR6iB02Hjl73WhGdEjs1X
         S5L9b8j4sTKUSLTYMpyuXGrYuj3C5FO1akT2lY7tiXrUoPuLtx4+um/vQJ1tEfT7VH0w
         HaJAkdJqBEO651q1Ar4qYunH1HSnYGO8Oj/gA5o1cr77QUeEf4iB1lmRpZWrrZsApqmt
         Nja/EKbdrAwWLVmW+joF5JHaN7zUhrJfUY2p4nkl907TxSqiFf9XSczl4VRvXI4FyqBc
         zXd33B6+wlC4TRAJQxIsIZ6TgsmycmGhUREQTLDfir4uXj+kK/5mXbvZ+LL5W1s1Udtj
         p9oQ==
X-Gm-Message-State: APjAAAWPXIR/P4gjlwNJGNqxDQFDOhGV9eiXQUC3GegSOUAhwCUtXBtt
        Iv+gEgth4+aRb4uitkAKkkc=
X-Google-Smtp-Source: APXvYqzoNS6Jmxd03akK30N8Q/ylVMot22aJcCL4uy2fkFx3l3dFZVCEGNIIP4liSQxO8L5UvGhNFw==
X-Received: by 2002:a63:2f44:: with SMTP id v65mr46788233pgv.185.1563455785645;
        Thu, 18 Jul 2019 06:16:25 -0700 (PDT)
Received: from suzukaze.ipads-lab.se.sjtu.edu.cn ([202.120.40.82])
        by smtp.gmail.com with ESMTPSA id j12sm17324439pff.4.2019.07.18.06.16.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 06:16:24 -0700 (PDT)
From:   Chuhong Yuan <hslester96@gmail.com>
Cc:     Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chuhong Yuan <hslester96@gmail.com>
Subject: [PATCH] crypto: ccp - Replace dma_pool_alloc + memset with dma_pool_zalloc
Date:   Thu, 18 Jul 2019 21:16:09 +0800
Message-Id: <20190718131609.10974-1-hslester96@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Use dma_pool_zalloc instead of using dma_pool_alloc to allocate
memory and then zeroing it with memset 0.
This simplifies the code.

Signed-off-by: Chuhong Yuan <hslester96@gmail.com>
---
 drivers/crypto/ccp/ccp-ops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 866b2e05ca77..03797c42b336 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -150,14 +150,13 @@ static int ccp_init_dm_workarea(struct ccp_dm_workarea *wa,
 	if (len <= CCP_DMAPOOL_MAX_SIZE) {
 		wa->dma_pool = cmd_q->dma_pool;
 
-		wa->address = dma_pool_alloc(wa->dma_pool, GFP_KERNEL,
+		wa->address = dma_pool_zalloc(wa->dma_pool, GFP_KERNEL,
 					     &wa->dma.address);
 		if (!wa->address)
 			return -ENOMEM;
 
 		wa->dma.length = CCP_DMAPOOL_MAX_SIZE;
 
-		memset(wa->address, 0, CCP_DMAPOOL_MAX_SIZE);
 	} else {
 		wa->address = kzalloc(len, GFP_KERNEL);
 		if (!wa->address)
-- 
2.20.1

