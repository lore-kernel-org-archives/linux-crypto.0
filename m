Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A97C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 17:04:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F8F3205F4
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 17:04:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfCUREA (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:04:00 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:50654 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728013AbfCURD7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 13:03:59 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: gportay)
        with ESMTPSA id D35E72819B9
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
From:   Gael PORTAY <gael.portay@collabora.com>
To:     Ezequiel Garcia <ezequiel.garcia@collabora.com>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Tao Huang <huangtao@rock-chips.com>,
        Zain Wang <wzz@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
References: <875-5c8d7980-7-55088a00@27384378>
 <20c7a1d9-bc68-c5e5-d666-6db2d10b1f87@collabora.com>
Message-ID: <cb075264-614e-5741-b6b9-4aa014e5277d@collabora.com>
Date:   Thu, 21 Mar 2019 13:04:08 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20c7a1d9-bc68-c5e5-d666-6db2d10b1f87@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

On 3/18/19 11:03 AM, Gael PORTAY wrote:
> Hello,
> 
> On 3/16/19 6:31 PM, Ezequiel Garcia wrote:
>> Adding my colleague Gael, who has been working on fixing this driver.
> 
> I have a couple of pending commits that may fix that issue.
> 
> I will give it a try, and get back to you then.
> 

The patches I had fix the same issue than recent commit to [1] and [2] 
in a different way.

But they do not fix the issue below.

>> ...
>>>
>>> Thanks for the fixes, but I've improved the self-tests more, and 
>>> there is
>>> another bug.  See the KernelCI job here:
>>>
>>>     https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-11071-g7d597cc3f0ef/ 
>>>
>>>
>>> The self-tests are failing on the rk3288-rock2-square platform:
>>>
>>>     alg: skcipher: cbc-aes-rk encryption test failed (wrong output 
>>> IV) on test vector 0, cfg=\"in-place\"
>>>     alg: skcipher: cbc-des-rk encryption test failed (wrong output 
>>> IV) on test vector 0, cfg=\"in-place\"
>>>     alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong 
>>> output IV) on test vector 0, cfg=\"in-place\"
>>>
>>> The issue is that the self-tests now verify that CBC implementations 
>>> update the
>>> IV buffer to contain the next IV, aka the last ciphertext block.  But 
>>> the
>>> Rockchip crypto driver doesn't do that, so it needs to be fixed.
>>>
>>> This has always been a requirement for CBC implementations so that 
>>> users can
>>> chain CBC requests.  Unfortunately it was just never tested for...
>>>
>>> This should be easily reproducible using the mainline kernel.
>>>
>>> - Eric
>>
>>
>> _______________________________________________
>> linux-arm-kernel mailing list
>> linux-arm-kernel@lists.infradead.org
>> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>>
> 
> Gael

[1]: 
https://github.com/torvalds/linux/commit/c1c214adcb56d36433480c8fedf772498e7e539c#diff-440313f9d25f65c14d4bffb1360a3c60
[2]: 
https://github.com/torvalds/linux/commit/4359669a087633132203c52d67dd8c31e09e7b2e#diff-440313f9d25f65c14d4bffb1360a3c60

Gael
