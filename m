From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [cryptodev:master 130/134] aes_generic.c:undefined reference to `_restgpr_31_x'
Date: Fri, 12 Jan 2018 15:55:47 +0100
Message-ID: <CAK8P3a0Rfbo=wJgEAm3vVFY1MpPWLE3HMGcUdoOXxqOVm8jRyw@mail.gmail.com>
References: <201801122249.RHvvGQJ6%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:46555 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933764AbeALOzs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 12 Jan 2018 09:55:48 -0500
Received: by mail-oi0-f68.google.com with SMTP id d124so4066942oib.13
        for <linux-crypto@vger.kernel.org>; Fri, 12 Jan 2018 06:55:48 -0800 (PST)
In-Reply-To: <201801122249.RHvvGQJ6%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 12, 2018 at 3:11 PM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   b40fa82cd6138350f723aa47b37e3e3e80906b40
> commit: 148b974deea927f5dbb6c468af2707b488bfa2de [130/134] crypto: aes-generic - build with -Os on gcc-7+
> config: powerpc-linkstation_defconfig (attached as .config)
> compiler: powerpc-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 148b974deea927f5dbb6c468af2707b488bfa2de
>         # save the attached .config to linux build tree
>         make.cross ARCH=powerpc
>
> All errors (new ones prefixed by >>):
>
>    crypto/aes_generic.o: In function `crypto_aes_set_key':
>>> aes_generic.c:(.text+0x4e0): undefined reference to `_restgpr_31_x'

adding linuxpcc-dev to Cc, maybe someone knows a way out of this.
It appears related to https://gcc.gnu.org/bugzilla/show_bug.cgi?id=43810
but I don't know what _restgpr_31_x actually does, why it's not provided
by the kernel or why the aes_generic implementation needs this on
powerpc when built with 'gcc -Os'. FWIW, the -Os change was needed
to work around a possible kernel stack overflow that can happen with
gcc-7.2, see https://patchwork.kernel.org/patch/10143607/ and
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=83356

         Arnd
