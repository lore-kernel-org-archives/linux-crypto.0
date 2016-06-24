From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev:master 79/79] (.text+0x330de0): multiple definition
 of `ecdh_shared_secret'
Date: Fri, 24 Jun 2016 14:23:16 +0800
Message-ID: <20160624062316.GA16985@gondor.apana.org.au>
References: <201606240302.rtIGIxRf%fengguang.wu@intel.com>
 <20160624060649.GA21165@localhost>
 <20160624061012.GA16850@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild test robot <fengguang.wu@intel.com>,
	linux-crypto@vger.kernel.org
To: Salvatore Benedetto <salvatore.benedetto@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40648 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcFXGXW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 02:23:22 -0400
Content-Disposition: inline
In-Reply-To: <20160624061012.GA16850@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 02:10:12PM +0800, Herbert Xu wrote:
> On Fri, Jun 24, 2016 at 07:06:49AM +0100, Salvatore Benedetto wrote:
> >
> > can you squash the following patch?
> 
> No, please prune anything that we don't use from ecc.c.

I take that back.  I see it's actually coming from bluetooth.

How about moving ecc.c to lib so that it's shared between the
two?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
