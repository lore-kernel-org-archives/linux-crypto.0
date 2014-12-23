From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/5] MIPS/crypto: MD5 for OCTEON
Date: Wed, 24 Dec 2014 08:15:19 +1100
Message-ID: <20141223211519.GA3051@gondor.apana.org.au>
References: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	Ralf Baechle <ralf@linux-mips.org>,
	David Daney <david.daney@cavium.com>,
	linux-crypto@vger.kernel.org, linux-mips@linux-mips.org,
	linux-kernel@vger.kernel.org
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:52639 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbaLWVPd (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Dec 2014 16:15:33 -0500
Content-Disposition: inline
In-Reply-To: <1419195242-546-1-git-send-email-aaro.koskinen@iki.fi>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, Dec 21, 2014 at 10:53:57PM +0200, Aaro Koskinen wrote:
> Hi,
> 
> This adds accelerated MD5 cryptoapi module for OCTEON.
> 
> Tested with 3.19-rc1 on EdgeRouter Lite (OCTEON+) and EdgeRouter Pro
> (OCTEON2) by running selftest, tcrypt and also by sending TCP MD5SIG
> traffic between OCTEON <-> X86 box.
> 
> Below figures show the improvement on ER Lite compared to md5-generic
> (calculated from output of tcrypt mode=402).

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
