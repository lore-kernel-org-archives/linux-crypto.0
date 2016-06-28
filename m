From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function
 [ver #2]
Date: Tue, 28 Jun 2016 12:54:14 +0800
Message-ID: <20160628045414.GA14429@gondor.apana.org.au>
References: <20160625013759.GA25613@gondor.apana.org.au>
 <20160624100215.GA19150@gondor.apana.org.au>
 <7446.1466769962@warthog.procyon.org.uk>
 <31794.1467037633@warthog.procyon.org.uk>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <31794.1467037633@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Jun 27, 2016 at 03:27:13PM +0100, David Howells wrote:
> 
> I have some patches I need to finish revamping.  I had it kind of working
> (though with a slightly different user interface) - then TPMv2 support was
> added to the TPM driver before I finished and I need to redo the patches.

In that case can we wait until this is ready before pushing the
user-space interface? Once you add a user-space interface it's
very difficult to change it again so we should be absolutely sure
what it's supposed to  look like before we add a new interace.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
