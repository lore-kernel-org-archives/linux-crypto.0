From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function
 [ver #2]
Date: Sat, 25 Jun 2016 09:37:59 +0800
Message-ID: <20160625013759.GA25613@gondor.apana.org.au>
References: <20160624100215.GA19150@gondor.apana.org.au>
 <7446.1466769962@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mat Martineau <mathew.j.martineau@linux.intel.com>,
	dwmw2@infradead.org, tadeusz.struk@intel.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:40924 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbcFYBiS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Jun 2016 21:38:18 -0400
Content-Disposition: inline
In-Reply-To: <7446.1466769962@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 24, 2016 at 01:06:02PM +0100, David Howells wrote:
> 
> The problem is that if I'm to produce consistency with, say, the TPM
> interface, then I have to deal in wrapped/padded data - leastways as far as I
> can tell from reading the docs.

So the TPM device is accessed through the same interface? Where is
the code for it?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
