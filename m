From: David Miller <davem@davemloft.net>
Subject: Re: [crypto / sparc64] cryptomgr_test OOPS
Date: Wed, 04 May 2016 16:51:28 -0400 (EDT)
Message-ID: <20160504.165128.114715266148025939.davem@davemloft.net>
References: <CADxRZqyMwme53etMrnx3xkpGsR6-W88RHLA3nh0GCGAzcz5=Fw@mail.gmail.com>
	<20160503.123301.298039059390449291.davem@davemloft.net>
	<CADxRZqzynaTAD+vcJwW2ueGnQyy=tQAJq2TvTT-_pZG26=_ZLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
To: matorola@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:43321 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364AbcEDUvb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 16:51:31 -0400
In-Reply-To: <CADxRZqzynaTAD+vcJwW2ueGnQyy=tQAJq2TvTT-_pZG26=_ZLQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Anatoly Pugachev <matorola@gmail.com>
Date: Wed, 4 May 2016 22:10:47 +0300

> Here's a quick diff related to crypto for debian kernel configs:
> 
> $ diff -u /boot/config-4.5.0-2-sparc64-smp /boot/config-4.6.0-rc5-sparc64-smp
> @@ -5299,10 +5380,9 @@
>  CONFIG_CRYPTO_RNG=m
>  CONFIG_CRYPTO_RNG2=y
>  CONFIG_CRYPTO_RNG_DEFAULT=m
> -CONFIG_CRYPTO_PCOMP=m
> -CONFIG_CRYPTO_PCOMP2=y
>  CONFIG_CRYPTO_AKCIPHER2=y
> -# CONFIG_CRYPTO_RSA is not set
> +CONFIG_CRYPTO_AKCIPHER=y
> +CONFIG_CRYPTO_RSA=y
>  CONFIG_CRYPTO_MANAGER=y
>  CONFIG_CRYPTO_MANAGER2=y
>  # CONFIG_CRYPTO_USER is not set
> 
> so, I need to compile 4.5.x kernel (or even older kernels) with
> CRYPTO_RSA=y and test how it would act.

Well yes, that would be an absolutely critical datapoint.
