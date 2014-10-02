From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: inconsistent handling of unaligned hash inputs
Date: Thu, 2 Oct 2014 10:04:39 +0800
Message-ID: <20141002020439.GA24240@gondor.apana.org.au>
References: <20141001.011034.1533102319982018632.davem@davemloft.net>
 <20141002003353.GA23780@gondor.apana.org.au>
 <20141001.180614.1843735881125772362.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, bpicco@meloft.net,
	bob.picco@oracle.com, sparclinux@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141001.180614.1843735881125772362.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 01, 2014 at 06:06:14PM -0700, David Miller wrote:
>
> In these specific hash functions we only read the u32/u64 inputs
> a byte at a time once, to get them into the work buffer.
> 
> If we have the crypto layer do it, we'll bounce the data around
> once to the crypto layer bounce buffer, then once again into
> the hash implementation's work buffer.

Oh of course if your data is unaligned it'll be worse.  But most
in-kernel input should be aligned.  So we need to balance this
against the cost of unaligned loads on aligned data.  If the cost
of unaligned loads on aligned data is negligible then sure let's
just do unaligned loads unconditionally.

PS Sorry for the earlier HTML email, I sent it from Android and
it seems that there is no way to disable HTML.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
