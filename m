Return-Path: <SRS0=hzfm=QI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA190C282D8
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 15:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4DCA218AF
	for <linux-crypto@archiver.kernel.org>; Fri,  1 Feb 2019 15:39:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfBAPjk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 1 Feb 2019 10:39:40 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:59504 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfBAPjj (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 1 Feb 2019 10:39:39 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gpaum-0001ns-Qx; Fri, 01 Feb 2019 23:39:36 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gpauh-0006Oj-M3; Fri, 01 Feb 2019 23:39:31 +0800
Date:   Fri, 1 Feb 2019 23:39:31 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhou Wang <wangzhou1@hisilicon.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linuxarm@huawei.com,
        linux-kernel@vger.kernel.org, Kenneth Lee <liguozhu@hisilicon.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        Hao Fang <fanghao11@huawei.com>
Subject: Re: [PATCH v2 2/4] crypto: hisilicon: Add queue management driver
 for HiSilicon QM module
Message-ID: <20190201153931.2k4yopm4akunpedg@gondor.apana.org.au>
References: <1548248933-149853-1-git-send-email-wangzhou1@hisilicon.com>
 <1548248933-149853-3-git-send-email-wangzhou1@hisilicon.com>
 <20190201052229.wnjeirur6ephew7y@gondor.apana.org.au>
 <5C53F22A.2020804@hisilicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5C53F22A.2020804@hisilicon.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 01, 2019 at 03:15:54PM +0800, Zhou Wang wrote:
>
> > Polling in softirq context is unacceptable.  Can't your hardware
> > send interrupts to signal completion? What is the average speed
> > of processing a single 1500-byte packet on your hardware?
> 
> Our hardware supports interrupt. In fact, implementation of compress/decompress
> interface of crypto_alg in v1 was done using interrupt:
> 
>  compress/decompress:
>      send task to hardware
>      wait task finished(wait_for_completion_timeout)
> 
>  In irq handler:
>      complete
> 
> However, there is get_cpu/put_cpu in scomp, wait and complete in above has to be
> changed to poll:
> 
>  compress/decompress:
>      send task to hardware
>      check if task is finished

If your hardware supports interrupts then you should be using
the acomp interface and not scomp.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
