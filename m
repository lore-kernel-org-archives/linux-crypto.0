Return-Path: <SRS0=BixN=4J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FCB5C35646
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 16:55:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EB76208C4
	for <linux-crypto@archiver.kernel.org>; Fri, 21 Feb 2020 16:55:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgBUQzP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 21 Feb 2020 11:55:15 -0500
Received: from verein.lst.de ([213.95.11.211]:56480 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbgBUQzP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Feb 2020 11:55:15 -0500
Received: by verein.lst.de (Postfix, from userid 2005)
        id E5EB068BFE; Fri, 21 Feb 2020 17:55:11 +0100 (CET)
Date:   Fri, 21 Feb 2020 17:55:11 +0100
From:   Torsten Duwe <duwe@lst.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: s390 crypto: explicitly memzero stack key material in aes_s390.c
Message-ID: <20200221165511.GB6928@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Torsten Duwe <duwe@suse.de>

s390 crypto: explicitly memzero stack key material in aes_s390.c

aes_s390.c has several functions which allocate space for key material on
the stack and leave the used keys there. It is considered good practice
to clean these locations before the function returns.

Signed-off-by: Torsten Duwe <duwe@suse.de>
---
This popped up during our FIPS certification.
It's obviously a good idea not to leave key material on the stack.

--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -392,6 +392,7 @@ static int cbc_aes_crypt(struct blkciphe
 		ret = blkcipher_walk_done(desc, walk, nbytes - n);
 	}
 	memcpy(walk->iv, param.iv, AES_BLOCK_SIZE);
+	memzero_explicit(&param, sizeof(param));
 	return ret;
 }
 
@@ -576,6 +577,8 @@ static int xts_aes_crypt(struct blkciphe
 			 walk->dst.virt.addr, walk->src.virt.addr, n);
 		ret = blkcipher_walk_done(desc, walk, nbytes - n);
 	}
+	memzero_explicit(&pcc_param, sizeof(pcc_param));
+	memzero_explicit(&xts_param, sizeof(xts_param));
 	return ret;
 }
 

