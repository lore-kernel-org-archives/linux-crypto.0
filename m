From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 5/8] KEYS: Provide software public key query function [ver #2]
Date: Fri, 24 Jun 2016 13:06:02 +0100
Message-ID: <7446.1466769962@warthog.procyon.org.uk>
References: <20160624100215.GA19150@gondor.apana.org.au>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160624100215.GA19150@gondor.apana.org.au>
Content-ID: <7445.1466769962.1@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> wrote:

> IOW exporting the raw RSA might make sense because the key may
> not be visible to user-space, or that the RSA might be implemented
> in hardware offload, but there is no sane reason to export pkcs1pad.

The problem is that if I'm to produce consistency with, say, the TPM
interface, then I have to deal in wrapped/padded data - leastways as far as I
can tell from reading the docs.

David
