From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about crypto module dependency
Date: Thu, 19 Jan 2012 09:25:16 +1100
Message-ID: <20120118222516.GA30542@gondor.apana.org.au>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com> <20120118053933.GA23562@gondor.apana.org.au> <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com> <20120118121325.GA25822@gondor.apana.org.au> <CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53306 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab2ARWZS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 17:25:18 -0500
Content-Disposition: inline
In-Reply-To: <CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 02:56:45PM +0100, Francis Moreau wrote:
>
> What do you mean with "at module init time" ?
> 
> My point is:
> 
>   $ grep btrfs /lib/modules/3.2.1/modules.dep
>   kernel/fs/btrfs/btrfs.ko: kernel/lib/zlib_deflate/zlib_deflate.ko
> kernel/lib/libcrc32c.ko
> 
> and
> 
>   $ grep libcrc32c.ko: /lib/modules/3.2.1-1.1-desktop/modules.dep
>   kernel/lib/libcrc32c.ko:
> 
> So there's no dependency here to 'pull' a crc32c backend, therefore
> "crypto_alloc_shash("crc32c", 0, 0)" used by libcrc32c at load time
> fails.

We have a Kconfig dependency and the rest is taken care of by
modprobe.

Perhaps your problem is really with mkinitramfs?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
