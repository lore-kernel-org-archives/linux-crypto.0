From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add missing KERN_* constants to printks
Date: Sat, 7 Feb 2009 23:52:11 +1100
Message-ID: <20090207125211.GA17913@gondor.apana.org.au>
References: <498C46DE.8040700@suse.de> <20090206145838.GA28197@x200.localdomain> <498C4F2E.1070204@f-seidel.de> <20090206150315.GA28249@x200.localdomain> <498C5053.4010809@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	Frank Seidel <frank@f-seidel.de>,
	linux kernel <linux-kernel@vger.kernel.org>,
	akpm@linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, jarod@redhat.com
To: Frank Seidel <fseidel@suse.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:45120 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752801AbZBGMwg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 7 Feb 2009 07:52:36 -0500
Content-Disposition: inline
In-Reply-To: <498C5053.4010809@suse.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Feb 06, 2009 at 03:59:31PM +0100, Frank Seidel wrote:
> 
> Yes, i also thought so, but i didn't venture to change it
> to i think it looks like. And as bevor they also were all at
> the same (unspecified/default) level...
> Do you think its worth/i should redo it and adapt the loglevel
> more appropriate?

Please do.  If it doesn't have any markings at least we know that
it needs fixing.  If you just add WARNINGs then we lose that
information.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
