From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: question about crypto module dependency
Date: Wed, 18 Jan 2012 23:13:25 +1100
Message-ID: <20120118121325.GA25822@gondor.apana.org.au>
References: <CAC9WiBj0oK+mWqnGVPEPAOTKMKeedsD4Wwwv_a0YbmOm2ejyfg@mail.gmail.com> <20120118053933.GA23562@gondor.apana.org.au> <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:36286 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab2ARMN3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 18 Jan 2012 07:13:29 -0500
Content-Disposition: inline
In-Reply-To: <CAC9WiBjQ9qEqNWSKj_c56ekex-nbkLQejO=HhZgRnOSZn0iJkA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 18, 2012 at 08:49:13AM +0100, Francis Moreau wrote:
>
> > What is the user in question?
> 
> btrfs

Hmm, why does it need to do crc32c at module init time?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
