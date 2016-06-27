From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function [ver #2]
Date: Mon, 27 Jun 2016 15:27:13 +0100
Message-ID: <31794.1467037633@warthog.procyon.org.uk>
References: <20160625013759.GA25613@gondor.apana.org.au> <20160624100215.GA19150@gondor.apana.org.au> <7446.1466769962@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com,
	Mat Martineau <mathew.j.martineau@linux.intel.com>,
	dwmw2@infradead.org, tadeusz.struk@intel.com,
	linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Morris <jmorris@namei.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20160625013759.GA25613@gondor.apana.org.au>
Content-ID: <31793.1467037633.1@warthog.procyon.org.uk>
Sender: owner-linux-security-module@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> > The problem is that if I'm to produce consistency with, say, the TPM
> > interface, then I have to deal in wrapped/padded data - leastways as far
> > as I can tell from reading the docs.
> 
> So the TPM device is accessed through the same interface? Where is
> the code for it?

I have some patches I need to finish revamping.  I had it kind of working
(though with a slightly different user interface) - then TPMv2 support was
added to the TPM driver before I finished and I need to redo the patches.

David
