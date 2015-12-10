From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 50/54] adf_c3xxxvf_hw_data.c:undefined
 reference to `adf_iov_putmsg'
Date: Thu, 10 Dec 2015 12:20:18 -0800
Message-ID: <5669DE82.9060202@intel.com>
References: <201512100448.vh4ozVCt%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:31114 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753240AbbLJUXm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Dec 2015 15:23:42 -0500
In-Reply-To: <201512100448.vh4ozVCt%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 12/09/2015 12:22 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   161151d79ff4f7ed35d4ebb0eb7727a517c34ef2
> commit: 8b206f2d666f41f0aa83dec83504801ee945d3dc [50/54] crypto: qat - add support for c3xxxvf accel type
> config: x86_64-randconfig-x009-12092253 (attached as .config)
> reproduce:
>         git checkout 8b206f2d666f41f0aa83dec83504801ee945d3dc
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `adf_pf2vf_bh_handler':
>    adf_vf_isr.c:(.text+0x8dd066): undefined reference to `adf_enable_pf2vf_interrupts'
>    drivers/built-in.o: In function `adf_isr':
>    adf_vf_isr.c:(.text+0x8dd123): undefined reference to `adf_disable_pf2vf_interrupts'
>    drivers/built-in.o: In function `adf_vf2pf_shutdown':
>>> adf_c3xxxvf_hw_data.c:(.text+0x8ee265): undefined reference to `adf_iov_putmsg'
>    drivers/built-in.o: In function `adf_vf2pf_init':
>    adf_c3xxxvf_hw_data.c:(.text+0x8ee2a5): undefined reference to `adf_iov_putmsg'
>    drivers/built-in.o: In function `adf_init_hw_data_c3xxxiov':
>    (.text+0x8ee3e3): undefined reference to `adf_enable_vf2pf_comms'
> 

In this configuration we have
# CONFIG_PCI_IOV is not set

The patch that I've sent yesterday for the other issue
https://patchwork.kernel.org/patch/7811971/
should fix this one as well.
Thanks

-- 
TS
