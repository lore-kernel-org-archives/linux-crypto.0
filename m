Return-Path: <SRS0=CDDf=4T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E74E7C3F2D1
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C21A324695
	for <linux-crypto@archiver.kernel.org>; Mon,  2 Mar 2020 06:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgCBG2P (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 2 Mar 2020 01:28:15 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:41503 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725446AbgCBG2P (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Mar 2020 01:28:15 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0TrMqUGR_1583130473;
Received: from 30.25.170.53(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0TrMqUGR_1583130473)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 02 Mar 2020 14:28:10 +0800
Subject: Re: [PATCH] Introduce OSCCA certificate and SM2 asymmetric algorithm
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     herbert@gondor.apana.org.au, davem@davemloft.net,
        ebiggers@kernel.org, pvanleeuwen@rambus.com, zohar@linux.ibm.com,
        dmitry.kasatkin@intel.com, penguin-kernel@I-love.SAKURA.ne.jp,
        jmorris@namei.org, rusty@rustcorp.com.au, nicstange@gmail.com,
        tadeusz.struk@intel.com, gilad@benyossef.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Message-ID: <b48a70cf-8f3d-011c-275e-0c508ca212f5@linux.alibaba.com>
Date:   Mon, 2 Mar 2020 14:27:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200216085928.108838-1-tianjia.zhang@linux.alibaba.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org



On 2020/2/16 16:59, Tianjia Zhang wrote:
> Hello all,
> 
> This new module implement the OSCCA certificate and SM2 public key
> algorithm. It was published by State Encryption Management Bureau, China.
> List of specifications for OSCCA certificate and SM2 elliptic curve
> public key cryptography:
> 
> * GM/T 0003.1-2012
> * GM/T 0003.2-2012
> * GM/T 0003.3-2012
> * GM/T 0003.4-2012
> * GM/T 0003.5-2012
> * GM/T 0015-2012
> * GM/T 0009-2012
> 
> IETF: https://tools.ietf.org/html/draft-shen-sm2-ecdsa-02
> oscca: http://www.oscca.gov.cn/sca/xxgk/2010-12/17/content_1002386.shtml
> scctc: http://www.gmbz.org.cn/main/bzlb.html
> 
> These patchs add the OID object identifier defined by OSCCA. The
> x509 certificate supports sm2-with-sm3 type certificate parsing
> and verification.
> 
> The sm2 algorithm is based on libgcrypt's mpi implementation, and has
> made some additions to the kernel's original mpi library, and added the
> implementation of ec to better support elliptic curve-like algorithms.
> 
> sm2 has good support in both openssl and gnupg projects, and sm3 and sm4
> of the OSCCA algorithm family have also been implemented in the kernel.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> Thanks,
> Tianjia
> 

Hello all,

This is the review request.

The OSCCA certificate and related algorithms used to verify the 
certificate are newly introduced. Among them, sm3 and sm4 have been well 
implemented in the kernel. This group of patches has newly introduced sm2.
In order to implement sm2 more perfectly, I expanded the mpi library and 
introduced the ec implementation of the mpi library as the basic 
algorithm. Compared to the kernel's crypto/ecc.c, the implementation of 
mpi/ec.c is more complete and elegant, sm2 is implemented based on these 
algorithms.
At this point, the kernel can parse and verify sm2-with-sm3 certificates 
normally.

Thanks,
Tianjia
