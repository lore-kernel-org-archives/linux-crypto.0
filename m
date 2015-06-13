From: Dan Streetman <ddstreet@ieee.org>
Subject: Re: [cryptodev:master 73/233] drivers/crypto/nx/nx-842-pseries.c:45:14:
 error: 'DDE_BUFFER_LAST_MULT' undeclared here (not in a function)
Date: Sat, 13 Jun 2015 11:37:30 -0400
Message-ID: <CALZtONCE8MX4G0W+Ct6AFBx3e2=vfZW=C=Ara78M3j1R=frQ3w@mail.gmail.com>
References: <201506132054.Xu47ZgqX%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36472 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbbFMPhv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 13 Jun 2015 11:37:51 -0400
Received: by igbpi8 with SMTP id pi8so28808794igb.1
        for <linux-crypto@vger.kernel.org>; Sat, 13 Jun 2015 08:37:51 -0700 (PDT)
In-Reply-To: <201506132054.Xu47ZgqX%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Jun 13, 2015 at 8:58 AM, kbuild test robot
<fengguang.wu@intel.com> wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   81781e681551ed3f56c9202e9adc7ef941cba654
> commit: 959e6659b6f74ec1fa4d391a3b88d63dc0189f36 [73/233] crypto: nx - add nx842 constraints
> config: powerpc-allmodconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout 959e6659b6f74ec1fa4d391a3b88d63dc0189f36
>   # save the attached .config to linux build tree
>   make.cross ARCH=powerpc
>
> Note: the cryptodev/master HEAD 81781e681551ed3f56c9202e9adc7ef941cba654 builds fine.
>       It only hurts bisectibility.
>
> All error/warnings (new ones prefixed by >>):
>
>>> drivers/crypto/nx/nx-842-pseries.c:45:14: error: 'DDE_BUFFER_LAST_MULT' undeclared here (not in a function)
>      .multiple = DDE_BUFFER_LAST_MULT,
>                  ^

sorry, that is added by the next patch in the patch series, so there
should be no problem except this specific patch will have to be
skipped during bisecting.


>
> vim +/DDE_BUFFER_LAST_MULT +45 drivers/crypto/nx/nx-842-pseries.c
>
>     39
>     40  /* IO buffer must be 128 byte aligned */
>     41  #define IO_BUFFER_ALIGN 128
>     42
>     43  static struct nx842_constraints nx842_pseries_constraints = {
>     44          .alignment =    IO_BUFFER_ALIGN,
>   > 45          .multiple =     DDE_BUFFER_LAST_MULT,
>     46          .minimum =      IO_BUFFER_ALIGN,
>     47          .maximum =      PAGE_SIZE, /* dynamic, max_sync_size */
>     48  };
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> http://lists.01.org/mailman/listinfo/kbuild                 Intel Corporation
