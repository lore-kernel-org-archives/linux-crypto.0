Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70337C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 03:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38016218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 03:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552620705;
	bh=uF01UR9y60givakqqMOf4UJOv7kIJvNN7F5TewuZEMk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ZCUZ3Hl6NHF5SKsz1RGaF8AdaQgSnekFKIMzLUch8Mc7qil/HftwpxncvaHtL73i0
	 U/TmwJJ0zozvux2QF8N1seF/mzQTs/FD8dq4T07KUcWqRIgr91c+3tFGxp5bGLAOzl
	 ul4K9oiCmn4LxfHZbKVWhJIHjR6vcj2ijJxZsG/M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfCODbo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 14 Mar 2019 23:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbfCODbo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 14 Mar 2019 23:31:44 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B1E32186A;
        Fri, 15 Mar 2019 03:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552620702;
        bh=uF01UR9y60givakqqMOf4UJOv7kIJvNN7F5TewuZEMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c+st7HBbDCpBwqiKnKS3ZmUNYbT1nwvXWGrMzu6Mcd92r+dVytExP1iWl2VISWMTU
         ZgLpJgieD6dPXNL9VGVY6sYwi82g7raAsz7gvbUD+pyGdmgVOLvNYt2jlGyftd2TTU
         Cvae1d0XtpT1UIxFp31kc1rN8vQWyIdYn3OGEBvY=
Date:   Thu, 14 Mar 2019 20:31:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Zhijie <zhangzj@rock-chips.com>
Cc:     Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        ezequiel@collabora.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Message-ID: <20190315033140.GB1671@sol.localdomain>
References: <20190126210530.GB709@sol.localdomain>
 <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Zhang,

On Mon, Jan 28, 2019 at 11:14:32AM +0800, Tao Huang wrote:
> Hi Eric and Heiko:
> 
> >> On Sat, 26 Jan 2019 at 22:05, Eric Biggers <ebiggers@kernel.org> wrote:
> >>>
> >>> Hello,
> >>>
> >>> I don't know whether anyone is actually maintaining the Rockchip crypto driver
> >>> in drivers/crypto/rockchip/, but it's failing the improved crypto tests
> >>> that I currently have out for review: https://patchwork.kernel.org/cover/10778089/
> 
> Zhang Zhijie, engineer from Rockchip, will try to fix this software bug.
> 
> >>>
> >>> See the boot logs for RK3288 from the KernelCI job here:
> >>>
> >>> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-rock2-square.txt
> >>> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-veyron-jaq.txt
> >>>
> >>> alg: skcipher: ecb-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: use_digest src_divs=[15.64%@+3258, 84.36%@+4059] dst_divs=[69.11%@+1796, 8.49%@+4027, 6.34%@+1, 16.6%@+4058] iv_offset=21\"
> >>> alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@alignmask+3993] dst_divs=[65.31%@alignmask+1435, 34.69%@+14]\"
> >>> alg: skcipher: ecb-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_final src_divs=[<flush> 66.52%@+11, 33.48%@+1519] dst_divs=[58.82%@+1, 19.43%@+4082, 21.75%@+8]\"
> >>> alg: skcipher: cbc-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_finup src_divs=[100.0%@+3980] dst_divs=[60.4%@+3763, 23.9%@+4011, 16.87%@+4046]\"
> >>> alg: skcipher: ecb-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+4] dst_divs=[47.25%@+19, 14.83%@+22, 37.92%@+31]\"
> >>> alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"two even aligned splits\"
> >>>
> >>> In other words: the ecb-aes-rk, cbc-aes-rk, ecb-des-rk, cbc-des-rk,
> >>> ecb-des3-ede-rk, and cbc-des3-ede-rk algorithms are failing because they produce
> >>> the wrong ciphertext on some scatterlist layouts.
> >>>
> >>> You can reproduce by pulling from
> >>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> >>> branch "testmgr-improvements", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
> >>> setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.
> >>>
> >>> Note that I don't have this hardware myself, so if it turns out that no one is
> >>> interested in fixing this anytime soon I'll instead have to propose disabling
> >>> these algorithms until they can be fixed.
> >>>
> >>> Thanks,
> >>>
> >>> - Eric
> >>

Thanks for the fixes, but I've improved the self-tests more, and there is
another bug.  See the KernelCI job here:

	https://kernelci.org/boot/all/job/ardb/branch/for-kernelci/kernel/v5.0-11071-g7d597cc3f0ef/

The self-tests are failing on the rk3288-rock2-square platform:

	alg: skcipher: cbc-aes-rk encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
	alg: skcipher: cbc-des-rk encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"
	alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong output IV) on test vector 0, cfg=\"in-place\"

The issue is that the self-tests now verify that CBC implementations update the
IV buffer to contain the next IV, aka the last ciphertext block.  But the
Rockchip crypto driver doesn't do that, so it needs to be fixed.

This has always been a requirement for CBC implementations so that users can
chain CBC requests.  Unfortunately it was just never tested for...

This should be easily reproducible using the mainline kernel.

- Eric
