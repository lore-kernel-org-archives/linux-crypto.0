From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 119/123] include/linux/pci.h:389:12: error:
 'struct pci_dev' has no member named 'physfn'
Date: Mon, 10 Aug 2015 12:06:56 -0700
Message-ID: <55C8F650.707@intel.com>
References: <201508110230.YCHwvKep%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:17856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932531AbbHJTIA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 15:08:00 -0400
In-Reply-To: <201508110230.YCHwvKep%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/10/2015 11:47 AM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   9cfaf082b8775e9f99fa5f2e8b2ae0ca8baff785
> commit: dd0f368398ea100e34259bf812bc482e15c81991 [119/123] crypto: qat - Add qat dh895xcc VF driver
> config: sh-allyesconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout dd0f368398ea100e34259bf812bc482e15c81991
>   # save the attached .config to linux build tree
>   make.cross ARCH=sh 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    In file included from drivers/media/common/b2c2/flexcop-common.h:10:0,
>                     from drivers/media/usb/b2c2/flexcop-usb.c:8:
>    include/linux/pci.h: In function 'pci_physfn':
>>> >> include/linux/pci.h:389:12: error: 'struct pci_dev' has no member named 'physfn'
> vim +389 include/linux/pci.h
> 
> ^1da177e Linus Torvalds 2005-04-16  383  };
> ^1da177e Linus Torvalds 2005-04-16  384  
> dda56549 Yinghai        2010-04-09  385  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
> dda56549 Yinghai        2010-04-09  386  {
> dda56549 Yinghai        2010-04-09  387  #ifdef CONFIG_PCI_IOV
> dda56549 Yinghai        2010-04-09  388  	if (dev->is_virtfn)
> dda56549 Yinghai        2010-04-09 @389  		dev = dev->physfn;
> dda56549 Yinghai        2010-04-09  390  #endif
> dda56549 Yinghai        2010-04-09  391  	return dev;
> dda56549 Yinghai        2010-04-09  392  }

Sorry, but what commit dd0f368398ea100e34259bf812bc482e15c81991 crypto: qat - Add qat dh895xcc VF driver
has to do with drivers/media/usb/b2c2/flexcop-usb.c?
