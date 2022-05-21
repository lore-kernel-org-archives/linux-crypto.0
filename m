Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A342C4332F
	for <linux-crypto@archiver.kernel.org>; Sat, 21 May 2022 11:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354863AbiEULMp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 21 May 2022 07:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353485AbiEULMT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 21 May 2022 07:12:19 -0400
Received: from mail3-relais-sop.national.inria.fr (mail3-relais-sop.national.inria.fr [192.134.164.104])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0D631372;
        Sat, 21 May 2022 04:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=oPdcALAaBw9fcOVQZXeV7Yoon9/2TK0QuC9S3pvCoog=;
  b=rrEX98JdyfaDH4iOqv44r1t8Lxt5w4sFze+MuN8ruu4cVyJPxL4eWyX5
   OMyJmYJvA0P451C+b0E5J2kdPD4BP2vQn8fG23dzRasBTYveT38IgfgxL
   7c5mProM2uPdk5qmeZyDotPjEorGb8V04cL0s3dymVASfugDlLP1KIpFN
   s=;
Authentication-Results: mail3-relais-sop.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.91,242,1647298800"; 
   d="scan'208";a="14727935"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2022 13:11:58 +0200
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     kernel-janitors@vger.kernel.org, John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: ccp - fix typo in comment
Date:   Sat, 21 May 2022 13:10:48 +0200
Message-Id: <20220521111145.81697-38-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Spelling mistake (triple letters) in comment.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/crypto/ccp/ccp-dev.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
index a5d9123a22ea..83350e2d9821 100644
--- a/drivers/crypto/ccp/ccp-dev.h
+++ b/drivers/crypto/ccp/ccp-dev.h
@@ -366,7 +366,7 @@ struct ccp_device {
 
 	/* Master lists that all cmds are queued on. Because there can be
 	 * more than one CCP command queue that can process a cmd a separate
-	 * backlog list is neeeded so that the backlog completion call
+	 * backlog list is needed so that the backlog completion call
 	 * completes before the cmd is available for execution.
 	 */
 	spinlock_t cmd_lock ____cacheline_aligned;

