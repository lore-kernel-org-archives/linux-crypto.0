From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about crypto module dependency
Date: Thu, 19 Jan 2012 22:58:32 +1100
Message-ID: <20120119115831.GA3017@gondor.apana.org.au>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com> <20120118053933.GA23562@gondor.apana.org.au> <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com> <20120118121325.GA25822@gondor.apana.org.au> <CAC9WiBh7VcnSD5ghN+ds9RvzXOwnKqoAYNUgbdsoxNmmG=cNhw@mail.gmail.com> <20120118222516.GA30542@gondor.apana.org.au> <CAC9WiBgSXRizqSNdnPv7yd8O1Ysd4r89f44CCtG4XY_+z+9Khg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:58962 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab2ASL6e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Jan 2012 06:58:34 -0500
Content-Disposition: inline
In-Reply-To: <CAC9WiBgSXRizqSNdnPv7yd8O1Ysd4r89f44CCtG4XY_+z+9Khg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jan 19, 2012 at 09:10:48AM +0100, Francis Moreau wrote:
>
> How things are supposed to work when :
> 
>   - crc32c module is not loaded
>   - libcrc32c module is not loaded
>   - btrfs is not loaded
> 
> and I issue: "modprobe btrfs" ?

When libcrc32c is loaded it'll automatically load crc32c through
the Crypto API.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
