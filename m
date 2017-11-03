From: Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: Re: [cryptodev:master 125/166] FATAL:
 drivers/crypto/marvell/marvell-cesa: struct platform_device_id is not
 terminated with a NULL entry!
Date: Fri, 3 Nov 2017 17:56:48 +0100
Message-ID: <20171103175648.528bbff8@bbrezillon>
References: <201711040025.pWi9huKU%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([62.4.15.54]:38437 "EHLO
        mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753880AbdKCQ47 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 3 Nov 2017 12:56:59 -0400
In-Reply-To: <201711040025.pWi9huKU%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On Sat, 4 Nov 2017 00:38:26 +0800
kbuild test robot <fengguang.wu@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   7a373fd74a8d1c4882e0236cc38345cec1393505
> commit: 7b0c3d693ce65900dd3c79766185f539fa37a29a [125/166] crypto: marvell - Add a platform_device_id table
> config: arm-multi_v7_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 6.1.1-9) 6.1.1 20160705
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 7b0c3d693ce65900dd3c79766185f539fa37a29a
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/crypto/marvell/marvell-cesa: struct platform_device_id is 24 bytes.  The last of 1 is:
>    0x6d 0x76 0x5f 0x63 0x72 0x79 0x70 0x74 0x6f 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 
> >> FATAL: drivers/crypto/marvell/marvell-cesa: struct platform_device_id is not terminated with a NULL entry!  
> 

Just sent a patch fixing the problem. Sorry for the mess.

Regards,

Boris

> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
