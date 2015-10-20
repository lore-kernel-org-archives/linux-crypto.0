From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] akcipher: Don't #include crypto/public_key.h as the
 contents aren't used
Date: Tue, 20 Oct 2015 22:26:07 +0800
Message-ID: <20151020142607.GI7625@gondor.apana.org.au>
References: <20151019111945.9535.66118.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tadeusz.struk@intel.com, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151019111945.9535.66118.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Oct 19, 2015 at 12:19:45PM +0100, David Howells wrote:
> Don't #include crypto/public_key.h in akcipher as the contents of the
> header aren't used and changes in a future patch cause it to fail to
> compile if CONFIG_KEYS=n.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
