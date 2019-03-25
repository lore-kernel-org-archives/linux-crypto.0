Return-Path: <SRS0=1oRy=R4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7F61C43381
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 06:40:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE3C720830
	for <linux-crypto@archiver.kernel.org>; Mon, 25 Mar 2019 06:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729644AbfCYGkE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Mar 2019 02:40:04 -0400
Received: from regular1.263xmail.com ([211.150.70.204]:49006 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbfCYGkE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Mar 2019 02:40:04 -0400
X-Greylist: delayed 496 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Mar 2019 02:40:02 EDT
Received: from zhangzj?rock-chips.com (unknown [192.168.167.32])
        by regular1.263xmail.com (Postfix) with ESMTP id 6622D2D0;
        Mon, 25 Mar 2019 14:31:36 +0800 (CST)
X-263anti-spam: KSV:0;BIG:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ADDR-CHECKED4: 1
X-ABS-CHECKED: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from [172.16.9.4] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P36533T140516561864448S1553495492710101_;
        Mon, 25 Mar 2019 14:31:34 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <38b57c143677261572d3a94e0e15532c>
X-RL-SENDER: zhangzj@rock-chips.com
X-SENDER: zhangzj@rock-chips.com
X-LOGIN-NAME: zhangzj@rock-chips.com
X-FST-TO: linux-arm-kernel@lists.infradead.org
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
To:     Gael PORTAY <gael.portay@collabora.com>,
        Ezequiel Garcia <ezequiel.garcia@collabora.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Tao Huang <huangtao@rock-chips.com>,
        Zain Wang <wzz@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <875-5c8d7980-7-55088a00@27384378>
 <20c7a1d9-bc68-c5e5-d666-6db2d10b1f87@collabora.com>
 <cb075264-614e-5741-b6b9-4aa014e5277d@collabora.com>
From:   Zhang Zhijie <zhangzj@rock-chips.com>
Message-ID: <f59e52ea-d0b8-0eff-e290-f35f2126c8e6@rock-chips.com>
Date:   Mon, 25 Mar 2019 14:31:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <cb075264-614e-5741-b6b9-4aa014e5277d@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric and Gael,

On 2019/3/22 上午1:04, Gael PORTAY wrote:
> Hello,
>
> On 3/18/19 11:03 AM, Gael PORTAY wrote:
>> Hello,
>>
>> On 3/16/19 6:31 PM, Ezequiel Garcia wrote:
>>> Adding my colleague Gael, who has been working on fixing this driver.
>>
>> I have a couple of pending commits that may fix that issue.
>>
>> I will give it a try, and get back to you then.
>>
>
> The patches I had fix the same issue than recent commit to [1] and [2] 
> in a different way.
>
> But they do not fix the issue below.

I will try to fix the issue below.

>
>>> ...
>>>>
>>>> Thanks for the fixes, but I've improved the self-tests more, and 
>>>> there is
>>>> another bug.  See the KernelCI job here:
>>>>
>>>>     https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-11071-g7d597cc3f0ef/ 
>>>>
>>>>
>>>> The self-tests are failing on the rk3288-rock2-square platform:
>>>>
>>>>     alg: skcipher: cbc-aes-rk encryption test failed (wrong output 
>>>> IV) on test vector 0, cfg=\"in-place\"
>>>>     alg: skcipher: cbc-des-rk encryption test failed (wrong output 
>>>> IV) on test vector 0, cfg=\"in-place\"
>>>>     alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong 
>>>> output IV) on test vector 0, cfg=\"in-place\"
>>>>
>>>> The issue is that the self-tests now verify that CBC 
>>>> implementations update the
>>>> IV buffer to contain the next IV, aka the last ciphertext block.  
>>>> But the
>>>> Rockchip crypto driver doesn't do that, so it needs to be fixed.
>>>>
>>>> This has always been a requirement for CBC implementations so that 
>>>> users can
>>>> chain CBC requests.  Unfortunately it was just never tested for...
>>>>
>>>> This should be easily reproducible using the mainline kernel.
>>>>
>>>> - Eric
>>>
>>>
>>> _______________________________________________
>>> linux-arm-kernel mailing list
>>> linux-arm-kernel@lists.infradead.org
>>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>>
>>
>> Gael
>
> [1]: 
> https://github.com/torvalds/linux/commit/c1c214adcb56d36433480c8fedf772498e7e539c#diff-440313f9d25f65c14d4bffb1360a3c60
> [2]: 
> https://github.com/torvalds/linux/commit/4359669a087633132203c52d67dd8c31e09e7b2e#diff-440313f9d25f65c14d4bffb1360a3c60
>
> Gael
>
>


