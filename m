From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 119/123] (.text+0x7a3): multiple definition of
 `adf_isr_resource_free'
Date: Tue, 11 Aug 2015 22:10:55 +0800
Message-ID: <20150811141055.GC30943@gondor.apana.org.au>
References: <201508110327.99r9RzJb%fengguang.wu@intel.com>
 <55C902C2.5040809@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48561 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964890AbbHKOLB (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2015 10:11:01 -0400
Content-Disposition: inline
In-Reply-To: <55C902C2.5040809@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Aug 10, 2015 at 01:00:02PM -0700, Tadeusz Struk wrote:
> On 08/10/2015 12:36 PM, kbuild test robot wrote:
> > tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> > head:   9cfaf082b8775e9f99fa5f2e8b2ae0ca8baff785
> > commit: dd0f368398ea100e34259bf812bc482e15c81991 [119/123] crypto: qat - Add qat dh895xcc VF driver
> > config: i386-allyesconfig (attached as .config)
> > reproduce:
> >   git checkout dd0f368398ea100e34259bf812bc482e15c81991
> >   # save the attached .config to linux build tree
> >   make ARCH=i386 
> > 
> > All error/warnings (new ones prefixed by >>):
> > 
> >    drivers/crypto/qat/qat_dh895xccvf/built-in.o: In function `adf_isr_resource_free':
> >>> >> (.text+0x7a3): multiple definition of `adf_isr_resource_free'
> >    drivers/crypto/qat/qat_dh895xcc/built-in.o:(.text+0x5f9): first defined here
> >    drivers/crypto/qat/qat_dh895xccvf/built-in.o: In function `adf_isr_resource_alloc':
> >>> >> (.text+0x818): multiple definition of `adf_isr_resource_alloc'
> >    drivers/crypto/qat/qat_dh895xcc/built-in.o:(.text+0x6d7): first defined here
> 
> ---8<---
> 
> When both PF and VF drivers are build in linker complains about multiple
> definition of adf_isr_resource_[alloc/free] functions.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
