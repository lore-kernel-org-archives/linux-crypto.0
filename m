From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: mv_cesa hash functions
Date: Sat, 25 Feb 2012 18:38:12 +1100
Message-ID: <20120225073806.GA19079@gondor.apana.org.au>
References: <005b01ccf162$64bd0520$2e370f60$@org> <20120223183439.GA18545@orbit.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Frank <frank@debian-nas.org>,
	'Sebastian Andrzej Siewior' <sebastian@breakpoint.cc>,
	uri@jdland.co.il, linux-crypto@vger.kernel.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.arm.linux.org.uk,
	Simon Baatz <simon2012@baatz.info>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sting.hengli.com.au ([178.18.18.71]:33647 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754250Ab2BYIJE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 25 Feb 2012 03:09:04 -0500
Content-Disposition: inline
In-Reply-To: <20120223183439.GA18545@orbit.nwl.cc>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Feb 23, 2012 at 07:34:39PM +0100, Phil Sutter wrote:
>
> Herbert, please clarify: is it intended behaviour that ahash_alg's final
> callback ignores possibly present data in the request? If I wanted to
> finalise a hash operation with some final data, would I then use the
> finup callback instead? (Note the implied question of the actual
> difference between the two callbacks.)

final should ignore any data present in the request.  So we should
fix this up in mv_cesa.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
