From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 53/54] crypto/rsa-pkcs1pad.c:135:1: warning:
 'pkcs1pad_encrypt_sign_complete' uses dynamic stack allocation
Date: Thu, 10 Dec 2015 09:47:12 +0800
Message-ID: <20151210014712.GB31692@gondor.apana.org.au>
References: <201512100225.MWaG2I5C%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andrzej Zaborowski <andrew.zaborowski@intel.com>,
	kbuild-all@01.org, linux-crypto@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39088 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbbLJBrS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 9 Dec 2015 20:47:18 -0500
Content-Disposition: inline
In-Reply-To: <201512100225.MWaG2I5C%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 10, 2015 at 02:49:27AM +0800, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   161151d79ff4f7ed35d4ebb0eb7727a517c34ef2
> commit: 3d5b1ecdea6fb94f8c61554fcb2ba776a2d3d0e6 [53/54] crypto: rsa - RSA padding algorithm
> config: s390-allmodconfig (attached as .config)
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 3d5b1ecdea6fb94f8c61554fcb2ba776a2d3d0e6
>         # save the attached .config to linux build tree
>         make.cross ARCH=s390 
> 
> All warnings (new ones prefixed by >>):
> 
>    crypto/rsa-pkcs1pad.c: In function 'pkcs1pad_encrypt_sign_complete':
> >> crypto/rsa-pkcs1pad.c:135:1: warning: 'pkcs1pad_encrypt_sign_complete' uses dynamic stack allocation
>     }
>     ^

Indeed that looks bad.  Andrzej please fix this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
