From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: random(4) changes
Date: Tue, 26 Apr 2016 19:04:15 +0800
Message-ID: <20160426110415.GA19340@gondor.apana.org.au>
References: <20160426030735.GD28496@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: smueller@chronox.de, sandyinchina@gmail.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	jason@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	andi@firstfloor.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50551 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbcDZLE3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Apr 2016 07:04:29 -0400
Content-Disposition: inline
In-Reply-To: <20160426030735.GD28496@thunk.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Theodore Ts'o <tytso@mit.edu> wrote:
>
> Yet another difference which I've noticed as I've been going over the
> patches is that that since it relies on CRYPTO_DRBG, it drags in a
> fairly large portion of the crypto subsystem, and requires it to be
> compiled into the kernel (instead of being loaded as needed as a
> module).  So the people who are worrying about keeping the kernel on a
> diet aren't going to be particularly happy about this.

As the IPv4 stack now selects CRYPTO_AES, the crypto system will
be pulled into your kernel anyway unless you can live without IPv4.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
