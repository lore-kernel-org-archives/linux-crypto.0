From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: inconsistent handling of unaligned hash inputs
Date: Thu, 2 Oct 2014 08:33:53 +0800
Message-ID: <20141002003353.GA23780@gondor.apana.org.au>
References: <20141001.011034.1533102319982018632.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, bpicco@meloft.net,
	bob.picco@oracle.com, sparclinux@vger.kernel.org
To: David Miller <davem@davemloft.net>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141001.011034.1533102319982018632.davem@davemloft.net>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

David Miller <davem@davemloft.net> wrote:
>
> Anyways, I suspect that we need to use get_unaligned_be{32,64}() in
> generic SHA256 and SHA512.

The other option is to set cra_alignmask and have the crypto API
handle this.  So the question is what is the cost benefit of using
a normal load vs. get_unaligned_*?

Most in-kernel crypto uses should be using aligned input/output.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
