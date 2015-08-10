From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [kbuild-all] [cryptodev:master 119/123]
 include/linux/pci.h:389:12: error: 'struct pci_dev' has no member named
 'physfn'
Date: Tue, 11 Aug 2015 06:24:42 +0800
Message-ID: <20150810222442.GA21977@wfg-t540p.sh.intel.com>
References: <201508110230.YCHwvKep%fengguang.wu@intel.com>
 <55C8F650.707@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, kbuild-all@01.org,
	Herbert Xu <herbert@gondor.apana.org.au>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:63896 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313AbbHJWYu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 18:24:50 -0400
Content-Disposition: inline
In-Reply-To: <55C8F650.707@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 10, 2015 at 12:06:56PM -0700, Tadeusz Struk wrote:
> On 08/10/2015 11:47 AM, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > head:   9cfaf082b8775e9f99fa5f2e8b2ae0ca8baff785
> > commit: dd0f368398ea100e34259bf812bc482e15c81991 [119/123] crypto: qat - Add qat dh895xcc VF driver
> > config: sh-allyesconfig (attached as .config)
> > reproduce:
> >   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
> >   chmod +x ~/bin/make.cross
> >   git checkout dd0f368398ea100e34259bf812bc482e15c81991
> >   # save the attached .config to linux build tree
> >   make.cross ARCH=sh 
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    In file included from drivers/media/common/b2c2/flexcop-common.h:10:0,
> >                     from drivers/media/usb/b2c2/flexcop-usb.c:8:
> >    include/linux/pci.h: In function 'pci_physfn':
> >>> >> include/linux/pci.h:389:12: error: 'struct pci_dev' has no member named 'physfn'
> > vim +389 include/linux/pci.h
> > 
> > ^1da177e Linus Torvalds 2005-04-16  383  };
> > ^1da177e Linus Torvalds 2005-04-16  384  
> > dda56549 Yinghai        2010-04-09  385  static inline struct pci_dev *pci_physfn(struct pci_dev *dev)
> > dda56549 Yinghai        2010-04-09  386  {
> > dda56549 Yinghai        2010-04-09  387  #ifdef CONFIG_PCI_IOV
> > dda56549 Yinghai        2010-04-09  388  	if (dev->is_virtfn)
> > dda56549 Yinghai        2010-04-09 @389  		dev = dev->physfn;
> > dda56549 Yinghai        2010-04-09  390  #endif
> > dda56549 Yinghai        2010-04-09  391  	return dev;
> > dda56549 Yinghai        2010-04-09  392  }
> 
> Sorry, but what commit dd0f368398ea100e34259bf812bc482e15c81991 crypto: qat - Add qat dh895xcc VF driver
> has to do with drivers/media/usb/b2c2/flexcop-usb.c?

That looks a bad bisect. Sorry for the noise! Bad bisects are rare but
possible because we used optimizations like partial build to speed it up.

Thanks,
Fengguang
