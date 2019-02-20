Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89F36C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 04:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DFDE2147A
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 04:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730339AbfBTEKR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Feb 2019 23:10:17 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:40050 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729826AbfBTEKR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Feb 2019 23:10:17 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gwJD5-0000SN-JK; Wed, 20 Feb 2019 12:10:15 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gwJD1-0001k1-Ov; Wed, 20 Feb 2019 12:10:11 +0800
Date:   Wed, 20 Feb 2019 12:10:11 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Hao Fang <fanghao11@huawei.com>
Subject: Re: [PATCH v2 2/4] crypto: hisilicon: Add queue management driver
 for HiSilicon QM module
Message-ID: <20190220041011.oob4e7jk3fwoqjlg@gondor.apana.org.au>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
 <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
 <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
 <5C53F22A.2020804@hisilicon.com>
 <20190201153931.2k4yopm4akunpedg@gondor.apana.org.au>
 <5C54FFA7.1080702@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C54FFA7.1080702@hisilicon.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Feb 02, 2019 at 10:25:43AM +0800, Zhou Wang wrote:
>
> In fact, I planned to register to acomp later.
> 
> It also makes sense to use scomp if hardware engine is faster than CPU.
> So how about registering to scomp firstly, then we register this engine to
> acomp later?

Sorry, but the fact that you're doing a busy-wait for completion
means that scomp is not an appropriate choice.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
