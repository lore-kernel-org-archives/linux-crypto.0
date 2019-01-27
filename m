Return-Path: <SRS0=Rknj=QD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F025BC282C0
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 08:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF41E20989
	for <linux-crypto@archiver.kernel.org>; Sun, 27 Jan 2019 08:55:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="j4Bmxi9u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfA0IzI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 27 Jan 2019 03:55:08 -0500
Received: from mail-io1-f49.google.com ([209.85.166.49]:33475 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726327AbfA0IzI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 27 Jan 2019 03:55:08 -0500
Received: by mail-io1-f49.google.com with SMTP id t24so11100597ioi.0
        for <linux-crypto@vger.kernel.org>; Sun, 27 Jan 2019 00:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DdMckKEcWICyP6+dmYxRWpMFp9C9/P0ba38gUhiNXhU=;
        b=j4Bmxi9uLxmCIli5O0OOmHvmGf3hqwcnaI+kc1v+eVLUEXjOKr/mu5DoCVhS5HY6UH
         h0FiZUXm0Ki0cPR/+M3dXVEXSA9ac6qfSmfpR375Pv1X7AlwiXcxVJCozXhSKer7Q8SH
         rWdafWUXfzyEZbMwiz+HfygT9ZjwiQML72AyA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DdMckKEcWICyP6+dmYxRWpMFp9C9/P0ba38gUhiNXhU=;
        b=UmAqZ4F6ua+GeuvUg+5wnwfN8DGZhnPsNhf2WpT7vURMaQpOxwVTCRFTvfFDmMaY9K
         kDLwCBXEL2EgTWoaPrrDg9X+z9rBNIiXMFH6WCbK6JScOk9QF1BDu+HFTsqWrwmrKHqP
         q1DZaJIWCFMU8xmRuxLkr8/gd6uIG74Icp3f3M4iwAHIWimJ2OMBvuZ3ZV1P14nuZTfL
         0SF9cm6UkMcH47J4BqYBZq2kMW0wiC4/kfr9eIcif7tuXCRkVKx2YK7OY7MqlyczMVx3
         YmJiIoCdlwlE5vzR0kKfm8iC+AhYotg6OWG4HBGUo+h6UYusN+pyKdNxxAKXzuxkYUq4
         BI8Q==
X-Gm-Message-State: AHQUAuaBW6a/yDrwI5rRwWGxdeCz9/cRiFDkzjA4IP1yJCMjiIqz1ElU
        6eYaZyRFCCz6NhLFgIMfaAyTfOqyoxa1b0Uh65oqDlktwoU=
X-Google-Smtp-Source: ALg8bN4kxXlUhNNkKDKt/5NXGmkTCrvnZn0Vdfyt1NCEroJXhSgBiFvyFFc4nkvAHM6QuOv8B7yJAQtVRC55dOZ+Qf0=
X-Received: by 2002:a5d:8410:: with SMTP id i16mr10317879ion.173.1548579306987;
 Sun, 27 Jan 2019 00:55:06 -0800 (PST)
MIME-Version: 1.0
References: <20190126210530.GB709@sol.localdomain>
In-Reply-To: <20190126210530.GB709@sol.localdomain>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Sun, 27 Jan 2019 09:54:54 +0100
Message-ID: <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc:     Zain Wang <wzz@rock-chips.com>, Heiko Stuebner <heiko@sntech.de>,
        linux-rockchip@lists.infradead.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(add LAKML and arm-soc maintainers)

On Sat, 26 Jan 2019 at 22:05, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Hello,
>
> I don't know whether anyone is actually maintaining the Rockchip crypto driver
> in drivers/crypto/rockchip/, but it's failing the improved crypto tests
> that I currently have out for review: https://patchwork.kernel.org/cover/10778089/
>
> See the boot logs for RK3288 from the KernelCI job here:
>
> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-rock2-square.txt
> https://storage.kernelci.org/ardb/for-kernelci/v5.0-rc1-86-geaffe22db9d1/arm/multi_v7_defconfig/lab-collabora/boot-rk3288-veyron-jaq.txt
>
> alg: skcipher: ecb-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: use_digest src_divs=[15.64%@+3258, 84.36%@+4059] dst_divs=[69.11%@+1796, 8.49%@+4027, 6.34%@+1, 16.6%@+4058] iv_offset=21\"
> alg: skcipher: cbc-aes-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@alignmask+3993] dst_divs=[65.31%@alignmask+1435, 34.69%@+14]\"
> alg: skcipher: ecb-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_final src_divs=[<flush> 66.52%@+11, 33.48%@+1519] dst_divs=[58.82%@+1, 19.43%@+4082, 21.75%@+8]\"
> alg: skcipher: cbc-des-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_finup src_divs=[100.0%@+3980] dst_divs=[60.4%@+3763, 23.9%@+4011, 16.87%@+4046]\"
> alg: skcipher: ecb-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"random: may_sleep use_digest src_divs=[100.0%@+4] dst_divs=[47.25%@+19, 14.83%@+22, 37.92%@+31]\"
> alg: skcipher: cbc-des3-ede-rk encryption test failed (wrong result) on test vector 0, cfg=\"two even aligned splits\"
>
> In other words: the ecb-aes-rk, cbc-aes-rk, ecb-des-rk, cbc-des-rk,
> ecb-des3-ede-rk, and cbc-des3-ede-rk algorithms are failing because they produce
> the wrong ciphertext on some scatterlist layouts.
>
> You can reproduce by pulling from
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> branch "testmgr-improvements", unsetting CONFIG_CRYPTO_MANAGER_DISABLE_TESTS,
> setting CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y, rebooting and checking dmesg.
>
> Note that I don't have this hardware myself, so if it turns out that no one is
> interested in fixing this anytime soon I'll instead have to propose disabling
> these algorithms until they can be fixed.
>
> Thanks,
>
> - Eric
