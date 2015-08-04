From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 4 Aug 2015 21:32:18 +0800
Message-ID: <20150804133218.GA30148@gondor.apana.org.au>
References: <20150730094138.GA15941@gondor.apana.org.au>
 <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au>
 <55BBDD1F.4020208@intel.com>
 <20150802012354.GB10055@gondor.apana.org.au>
 <55BF9E4E.6020006@intel.com>
 <20150804095909.GA28167@gondor.apana.org.au>
 <55C0BDA2.2030302@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:60688 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933077AbbHDNcV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:32:21 -0400
Content-Disposition: inline
In-Reply-To: <55C0BDA2.2030302@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 06:26:58AM -0700, Tadeusz Struk wrote:
>
> The way we handle it in qat is as follows - when tfm allocates a
> crypto "instance" on a qat dev it then calls qat_crypto_put_instance(),
> which calls also adf_dev_put() on the appropriate qat device.
> This then calls module_put() on accel_dev->owner.
> This way, when any tfm is allocated on a device the attempts to rmmod
> or ioctl shutdown returns -EBUSY. See adf_ctl_is_device_in_use()
> One can only successfully shut down a device or rmmod qat_dh895 when
> all tfms are freed.
> 
> The only possibility when we may try to restart a device when tfms are
> allocated is when we handle HW uncorrectable errors, which in theory
> should never happen :)

What if someone calls adf_remove? For a software implementation
you can prevent the algorithm from going away by holding module
reference counts.  But a device can always be removed and you're
not going to stop that no matter how many reference counts you
hold :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
