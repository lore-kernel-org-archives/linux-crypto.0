Return-Path: <SRS0=fFzG=7R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07DF0C433DF
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 07:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC8F02075B
	for <linux-crypto@archiver.kernel.org>; Thu,  4 Jun 2020 07:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgFDHh6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 4 Jun 2020 03:37:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:36742 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbgFDHh5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 4 Jun 2020 03:37:57 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jgkRi-0003bD-KS; Thu, 04 Jun 2020 17:37:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 04 Jun 2020 17:37:50 +1000
Date:   Thu, 4 Jun 2020 17:37:50 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Shukun Tan <tanshukun1@huawei.com>
Subject: [PATCH] crypto: hisilicon - Cap block size at 2^31
Message-ID: <20200604073750.GA30866@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The function hisi_acc_create_sg_pool may allocate a block of
memory of size PAGE_SIZE * 2^(MAX_ORDER - 1).  This value may
exceed 2^31 on ia64, which would overflow the u32.

This patch caps it at 2^31.

Reported-by: kernel test robot <lkp@intel.com>
Fixes: d8ac7b85236b ("crypto: hisilicon - fix large sgl memory...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 0e8c7e324fb4..725a739800b0 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -66,7 +66,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 
 	sgl_size = sizeof(struct acc_hw_sge) * sge_nr +
 		   sizeof(struct hisi_acc_hw_sgl);
-	block_size = PAGE_SIZE * (1 << (MAX_ORDER - 1));
+	block_size = 1 << (PAGE_SHIFT + MAX_ORDER <= 32 ?
+			   PAGE_SHIFT + MAX_ORDER - 1 : 31);
 	sgl_num_per_block = block_size / sgl_size;
 	block_num = count / sgl_num_per_block;
 	remain_sgl = count % sgl_num_per_block;
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
