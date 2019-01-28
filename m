Return-Path: <SRS0=71ZY=QE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D57C282CA
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 03:22:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17EEC2148E
	for <linux-crypto@archiver.kernel.org>; Mon, 28 Jan 2019 03:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbfA1DWJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 22:22:09 -0500
Received: from regular1.263xmail.com ([211.150.99.137]:55120 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbfA1DWJ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 22:22:09 -0500
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Jan 2019 22:22:07 EST
Received: from huangtao?rock-chips.com (unknown [192.168.167.153])
        by regular1.263xmail.com (Postfix) with ESMTP id 18356212;
        Mon, 28 Jan 2019 11:14:35 +0800 (CST)
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
Received: from [172.16.12.62] (unknown [58.22.7.114])
        by smtp.263.net (postfix) whith ESMTP id P18171T140704284124928S1548645272799817_;
        Mon, 28 Jan 2019 11:14:34 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <1de1742e5d7f1c4892cde975e98f0e26>
X-RL-SENDER: huangtao@rock-chips.com
X-SENDER: huangtao@rock-chips.com
X-LOGIN-NAME: huangtao@rock-chips.com
X-FST-TO: huangtao@rock-chips.com
X-SENDER-IP: 58.22.7.114
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        ezequiel@collabora.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Zhang Zhijie <zhangzj@rock-chips.com>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
From:   Tao Huang <huangtao@rock-chips.com>
Message-ID: <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
Date:   Mon, 28 Jan 2019 11:14:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <1894799.pWIprST79S@phil>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Eric and Heiko:

>> On Sat, 26 Jan 2019 at 22:05, Eric Biggers <ebiggers@kernel.org> wrote:
>>>
>>> Hello,
>>>
>>> I don't know whether anyone is actually maintaining the Rockchip crypto driver
>>> in drivers/crypto/rockchip/, but it's failing the improved crypto tests
>>> that I currently have out for review: https://patchwork.kernel.org/cover/10778089/

Zhang Zhijie, engineer from Rockchip, will try to fix this software bug.

>>>
>>> See the boot logs for RK3288 from the KernelCI job here:
>>>
>>> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-rock2-square.txt
>>> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-veyron-jaq.txt
>>>
>>> alg: skcipher: ecb-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: use_digest src_divs=[15.64%@+3258, 84.36%@+4059] dst_divs=[69.11%@+1796, 8.49%@+4027, 6.34%@+1, 16.6%@+4058] iv_offset=21\"
>>> alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@alignmask+3993] dst_divs=[65.31%@alignmask+1435, 34.69%@+14]\"
>>> alg: skcipher: ecb-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_final src_divs=[<flush> 66.52%@+11, 33.48%@+1519] dst_divs=[58.82%@+1, 19.43%@+4082, 21.75%@+8]\"
>>> alg: skcipher: cbc-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_finup src_divs=[100.0%@+3980] dst_divs=[60.4%@+3763, 23.9%@+4011, 16.87%@+4046]\"
>>> alg: skcipher: ecb-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+4] dst_divs=[47.25%@+19, 14.83%@+22, 37.92%@+31]\"
>>> alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"two even aligned splits\"
>>>
>>> In other words: the ecb-aes-rk, cbc-aes-rk, ecb-des-rk, cbc-des-rk,
>>> ecb-des3-ede-rk, and cbc-des3-ede-rk algorithms are failing because they produce
>>> the wrong ciphertext on some scatterlist layouts.
>>>
>>> You can reproduce by pulling from
>>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
>>> branch "testmgr-improvements", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
>>> setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.
>>>
>>> Note that I don't have this hardware myself, so if it turns out that no one is
>>> interested in fixing this anytime soon I'll instead have to propose disabling
>>> these algorithms until they can be fixed.
>>>
>>> Thanks,
>>>
>>> - Eric
>>
> 


