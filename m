From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: padlock-aes: Use the correct mask when
	checking whether copying is required
Date: Wed, 28 Oct 2009 15:25:59 +0800
Message-ID: <20091028072559.GA15131@gondor.apana.org.au>
References: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Chuck Ebbert <cebbert@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932607AbZJ1HZ7@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200910272325.n9RNPYfr002918@int-mx08.intmail.prod.int.phx2.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 27, 2009 at 07:25:33PM -0400, Chuck Ebbert wrote:
> crypto: padlock-aes: Use the correct mask when checking whether copying is required
> 
> Masking with PAGE_SIZE is just wrong... and there's no need for the braces and return

Thanks for the patch, that does indeed look wrong.

> statement either.

But can we please keep unrelated stylistic changes in a separate
patch? In this case I'm not even sure that it is better than the
original.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
