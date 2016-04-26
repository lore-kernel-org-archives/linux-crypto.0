From: Andi Kleen <andi@firstfloor.org>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 13:47:09 -0700
Message-ID: <20160426204709.GH13997@two.firstfloor.org>
References: <20160426030735.GD28496@thunk.org>
 <20160426110415.GA19340@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, smueller@chronox.de,
	sandyinchina@gmail.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, jason@lakedaemon.net, jsd@av8n.com,
	hpa@zytor.com, andi@firstfloor.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:53253 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbcDZUrN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 16:47:13 -0400
Content-Disposition: inline
In-Reply-To: <20160426110415.GA19340@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Apr 26, 2016 at 07:04:15PM +0800, Herbert Xu wrote:
> Theodore Ts'o <tytso@mit.edu> wrote:
> >
> > Yet another difference which I've noticed as I've been going over the
> > patches is that that since it relies on CRYPTO_DRBG, it drags in a
> > fairly large portion of the crypto subsystem, and requires it to be
> > compiled into the kernel (instead of being loaded as needed as a
> > module).  So the people who are worrying about keeping the kernel on a
> > diet aren't going to be particularly happy about this.
> 
> As the IPv4 stack now selects CRYPTO_AES, the crypto system will
> be pulled into your kernel anyway unless you can live without IPv4.

I posted patches to fix this. At some point it definitely has to be.

-Andi
