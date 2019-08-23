Return-Path: <SRS0=iGjW=WT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29791C3A5A2
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 07:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF63420679
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Aug 2019 07:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730411AbfHWHSI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Aug 2019 03:18:08 -0400
Received: from regular1.263xmail.com ([211.150.70.199]:36998 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728493AbfHWHSH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Aug 2019 03:18:07 -0400
X-Greylist: delayed 459 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Aug 2019 03:18:03 EDT
Received: from zhangzj?rock-chips.com (unknown [192.168.167.172])
        by regular1.263xmail.com (Postfix) with ESMTP id AEDB0407
        for <linux-crypto@vger.kernel.org>; Fri, 23 Aug 2019 15:10:09 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED4: 1
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from [172.16.9.224] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P7360T140429191169792S1566544207442490_;
        Fri, 23 Aug 2019 15:10:08 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <d99d501476352652c40f794ffd33ecda>
X-RL-SENDER: zhangzj@rock-chips.com
X-SENDER: zhangzj@rock-chips.com
X-LOGIN-NAME: zhangzj@rock-chips.com
X-FST-TO: ebiggers@kernel.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Subject: Re: cbc mode broken in rk3288 driver
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>
References: <CAKv+Gu8mjM7o+CuP9VrGX+cuix_zRupfozUoDbEWXHVGsW8syw@mail.gmail.com>
From:   Elon Zhang <zhangzj@rock-chips.com>
Message-ID: <cdf08891-3b55-e123-1e13-23866af3b289@rock-chips.com>
Date:   Fri, 23 Aug 2019 15:10:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8mjM7o+CuP9VrGX+cuix_zRupfozUoDbEWXHVGsW8syw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard,

I will try to fix this bug. Furthermore, I will submit a patch to  set 
crypto node default disable in rk3288.dtsi.

On 8/20/2019 23:45, Ard Biesheuvel wrote:
> Hello all,
>
> While playing around with the fuzz tests on kernelci.org (which has a
> couple of rk3288 based boards for boot testing), I noticed that the
> rk3288 cbc mode driver is still broken (both AES and DES fail).
>
> For instance, one of the runs failed with
>
>   alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on
> test vector \"random: len=6848 klen=32\", cfg=\"random: may_sleep
> use_digest src_divs=[93.41%@+1655, 2.19%@+3968, 4.40%@+22]\"
>
> (but see below for the details of a few runs)
>
> However, more importantly, it looks like the driver violates the
> scatterlist API, by assuming that sg entries are always mapped and
> that sg_virt() and/or page_address(sg_page()) can always be called on
> arbitrary scatterlist entries
>
> The failures in question all occur with inputs whose size > PAGE_SIZE,
> so it looks like the PAGE_SIZE limit is interacting poorly with the
> way the next IV is obtained.
>
> Broken CBC is a recipe for disaster, and so this should really be
> fixed, or the driver disabled.
>


