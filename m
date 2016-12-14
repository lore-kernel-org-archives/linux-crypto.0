From: "Rob (William) Rice" <rob.rice@broadcom.com>
Subject: Re: [PATCH 3/3] crypto: brcm: Add Broadcom SPU driver DT entry.
Date: Wed, 14 Dec 2016 10:00:22 -0500
Message-ID: <52897a59-f8e6-8df6-348d-c208f1b65575@broadcom.com>
References: <201612110810.BEVbRp0B%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Steve Lin <steven.lin1@broadcom.com>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:35695 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755490AbcLNPA3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 14 Dec 2016 10:00:29 -0500
Received: by mail-pf0-f174.google.com with SMTP id i88so4252836pfk.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Dec 2016 07:00:29 -0800 (PST)
In-Reply-To: <201612110810.BEVbRp0B%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I will rebase to Herbert's latest when I submit v3 to address Mark 
Rutland's DT comments (and any others that come in).

Rob


On 12/10/2016 7:14 PM, kbuild test robot wrote:
> Hi Rob,
>
> [auto build test ERROR on cryptodev/master]
> [also build test ERROR on v4.9-rc8]
> [cannot apply to next-20161209]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Rob-Rice/crypto-brcm-DT-documentation-for-Broadcom-SPU-driver/20161202-010038
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: arm64-defconfig (attached as .config)
> compiler: aarch64-linux-gnu-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>          wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          make.cross ARCH=arm64
>
> All errors (new ones prefixed by >>):
>
>>> ERROR: Input tree has errors, aborting (use -f to force output)
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
