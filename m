From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: twofish-x86_64-3way - blacklist pentium4
	and atom
Date: Fri, 13 Jan 2012 16:36:09 +1100
Message-ID: <20120113053609.GB13918@gondor.apana.org.au>
References: <20111220071942.GA3870@gondor.apana.org.au> <20111220102016.13429.88526.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:49232 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab2AMFgN (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Jan 2012 00:36:13 -0500
Content-Disposition: inline
In-Reply-To: <20111220102016.13429.88526.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 20, 2011 at 12:20:16PM +0200, Jussi Kivilinna wrote:
> Performance of twofish-x86_64-3way on Intel Pentium 4 and Atom is lower than
> of twofish-x86_64 module. So blacklist these CPUs.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Both patches applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
