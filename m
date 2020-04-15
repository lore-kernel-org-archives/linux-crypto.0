Return-Path: <SRS0=7EYG=57=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11EAAC2BB55
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 12:52:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB29E20767
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Apr 2020 12:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586955146;
	bh=M8E/aNrFYn1/9bNSs0TvZi9Xc8SxJ8APXi7e1rp2YN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=i6nzr8fliR2AKE657rpW+Sn0B+jOy1QM0IIittf7MMrK0jQQSnO4TGgXoYJ868ZUz
	 g4/I08DsVZdFtFhS3Ezw/uIF+yJjNz/7U5Isg4flTy30iKbKVVCrhLitCLKD5IZtUZ
	 fxbpffMtg1QMJ8P4RcB0ORxRnCRsNhK6Ftd/re54=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897480AbgDOLmh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Apr 2020 07:42:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:33840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897472AbgDOLmf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Apr 2020 07:42:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96885214D8;
        Wed, 15 Apr 2020 11:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586950955;
        bh=M8E/aNrFYn1/9bNSs0TvZi9Xc8SxJ8APXi7e1rp2YN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TqlTPf008TCQRVQXsanrxiyI+DhqnqmKTBgR15dLzYFqNr3gD0MH55digbU5XiKzZ
         1CA1fv24EISlFcZbegWUzKj1upAO4l/wAzmv+YChafSDvgi/oemqF8o2qeiZGvuwWj
         tuMvGrDChHA2xvZuKpwi2bQ/Vo+lhTvhIgysw8fI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Torsten Duwe <duwe@suse.de>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 007/106] s390/crypto: explicitly memzero stack key material in aes_s390.c
Date:   Wed, 15 Apr 2020 07:40:47 -0400
Message-Id: <20200415114226.13103-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200415114226.13103-1-sashal@kernel.org>
References: <20200415114226.13103-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Torsten Duwe <duwe@suse.de>

[ Upstream commit 4a559cd15dbc79958fa9b18ad4e8afe4a0bf4744 ]

aes_s390.c has several functions which allocate space for key material on
the stack and leave the used keys there. It is considered good practice
to clean these locations before the function returns.

Link: https://lkml.kernel.org/r/20200221165511.GB6928@lst.de
Signed-off-by: Torsten Duwe <duwe@suse.de>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/crypto/aes_s390.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index ead0b2c9881d1..14d006b424eb1 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -354,6 +354,7 @@ static int cbc_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 		memcpy(walk.iv, param.iv, AES_BLOCK_SIZE);
 		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
+	memzero_explicit(&param, sizeof(param));
 	return ret;
 }
 
@@ -489,6 +490,8 @@ static int xts_aes_crypt(struct skcipher_request *req, unsigned long modifier)
 			 walk.dst.virt.addr, walk.src.virt.addr, n);
 		ret = skcipher_walk_done(&walk, nbytes - n);
 	}
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
+	memzero_explicit(&xts_param, sizeof(xts_param));
 	return ret;
 }
 
-- 
2.20.1

