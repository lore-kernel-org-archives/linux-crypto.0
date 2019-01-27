Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE1F8C282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 10:29:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95C442148D
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 10:29:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfA0K3n (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 05:29:43 -0500
Received: from gloria.sntech.de ([185.11.138.130]:46756 "EHLO gloria.sntech.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726453AbfA0K3m (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 05:29:42 -0500
Received: from p5b12725f.dip0.t-ipconnect.de ([91.18.114.95] helo=phil.localnet)
        by gloria.sntech.de with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <heiko@sntech.de>)
        id 1gnhh0-0007bB-Ti; Sun, 27 Jan 2019 11:29:34 +0100
From:   Heiko Stuebner <heiko@sntech.de>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Zain Wang <wzz@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, ezequiel@collabora.com
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Date:   Sun, 27 Jan 2019 11:29:33 +0100
Message-ID: <1894799.pWIprST79S@phil>
In-Reply-To: <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
References: <20190126210530.GB709@sol.localdomain> <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(also add Ezequiel who has spent a bit of time on the rockchip crypto
driver recently)

Am Sonntag, 27. Januar 2019, 09:54:54 CET schrieb Ard Biesheuvel:
> (add LAKML and arm-soc maintainers)
> 
> On Sat, 26 Jan 2019 at 22:05, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Hello,
> >
> > I don't know whether anyone is actually maintaining the Rockchip crypto driver
> > in drivers/crypto/rockchip/, but it's failing the improved crypto tests
> > that I currently have out for review: https://patchwork.kernel.org/cover/10778089/
> >
> > See the boot logs for RK3288 from the KernelCI job here:
> >
> > https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-rock2-square.txt
> > https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-veyron-jaq.txt
> >
> > alg: skcipher: ecb-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: use_digest src_divs=[15.64%@+3258, 84.36%@+4059] dst_divs=[69.11%@+1796, 8.49%@+4027, 6.34%@+1, 16.6%@+4058] iv_offset=21\"
> > alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@alignmask+3993] dst_divs=[65.31%@alignmask+1435, 34.69%@+14]\"
> > alg: skcipher: ecb-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_final src_divs=[<flush> 66.52%@+11, 33.48%@+1519] dst_divs=[58.82%@+1, 19.43%@+4082, 21.75%@+8]\"
> > alg: skcipher: cbc-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_finup src_divs=[100.0%@+3980] dst_divs=[60.4%@+3763, 23.9%@+4011, 16.87%@+4046]\"
> > alg: skcipher: ecb-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+4] dst_divs=[47.25%@+19, 14.83%@+22, 37.92%@+31]\"
> > alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"two even aligned splits\"
> >
> > In other words: the ecb-aes-rk, cbc-aes-rk, ecb-des-rk, cbc-des-rk,
> > ecb-des3-ede-rk, and cbc-des3-ede-rk algorithms are failing because they produce
> > the wrong ciphertext on some scatterlist layouts.
> >
> > You can reproduce by pulling from
> > https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> > branch "testmgr-improvements", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
> > setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.
> >
> > Note that I don't have this hardware myself, so if it turns out that no one is
> > interested in fixing this anytime soon I'll instead have to propose disabling
> > these algorithms until they can be fixed.
> >
> > Thanks,
> >
> > - Eric
> 




