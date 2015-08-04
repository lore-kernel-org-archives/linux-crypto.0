From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 6/8] crypto: qat - Convert to new AEAD interface
Date: Tue, 04 Aug 2015 06:26:58 -0700
Message-ID: <55C0BDA2.2030302@intel.com>
References: <20150730094138.GA15941@gondor.apana.org.au> <E1ZKkWe-0004C6-SN@gondolin.me.apana.org.au> <55BBDD1F.4020208@intel.com> <20150802012354.GB10055@gondor.apana.org.au> <55BF9E4E.6020006@intel.com> <20150804095909.GA28167@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:48923 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933244AbbHDN1u (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Aug 2015 09:27:50 -0400
In-Reply-To: <20150804095909.GA28167@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/04/2015 02:59 AM, Herbert Xu wrote:
> Good catch.  However it's not as simple as that.  We have a bigger
> problem here.
> 
> For software implementations it's really easy because we use the
> module reference count to prevent unregisters from happening while
> there are tfms using it.
> 
> However for hardware devices this breaks down because you can remove
> the device at any time.  So we'll have to come up with a way of
> handling this without causing live tfms to explode.
> 
> FWIW the current qat code (and possibly other drivers) is buggy
> because if you call unregister while there are still tfms using
> it, it will BUG in the unregister call.

The way we handle it in qat is as follows - when tfm allocates a
crypto "instance" on a qat dev it then calls qat_crypto_put_instance(),
which calls also adf_dev_put() on the appropriate qat device.
This then calls module_put() on accel_dev->owner.
This way, when any tfm is allocated on a device the attempts to rmmod
or ioctl shutdown returns -EBUSY. See adf_ctl_is_device_in_use()
One can only successfully shut down a device or rmmod qat_dh895 when
all tfms are freed.

The only possibility when we may try to restart a device when tfms are
allocated is when we handle HW uncorrectable errors, which in theory
should never happen :)
