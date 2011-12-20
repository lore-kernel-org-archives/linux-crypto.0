From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 3.2] crypto: twofish-x86_64-3way - blacklist pentium4
	and atom
Date: Tue, 20 Dec 2011 15:19:42 +0800
Message-ID: <20111220071942.GA3870@gondor.apana.org.au>
References: <20111203141004.4329.29784.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:37460 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047Ab1LTHTr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Dec 2011 02:19:47 -0500
Content-Disposition: inline
In-Reply-To: <20111203141004.4329.29784.stgit@localhost6.localdomain6>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Dec 03, 2011 at 04:10:04PM +0200, Jussi Kivilinna wrote:
> Performance of twofish-x86_64-3way on Intel Pentium 4 and Atom is lower than
> of twofish-x86_64 module. So blacklist these CPUs.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Please send patches based on cryptodev instead.  If necessary I
can then rebase them to crypto.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
