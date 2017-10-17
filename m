From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: vmx ghash buggy on ppc64le
Date: Tue, 17 Oct 2017 21:10:17 +0800
Message-ID: <20171017131017.GB28534@gondor.apana.org.au>
References: <20170919031845.GA28732@gondor.apana.org.au>
 <20171016230953.GA13502@dublin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:38258 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1762057AbdJQNKk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Oct 2017 09:10:40 -0400
Content-Disposition: inline
In-Reply-To: <20171016230953.GA13502@dublin>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Oct 16, 2017 at 09:09:53PM -0200, Paulo Flabiano Smorigo wrote:
> Tue, Sep 19, 2017 at 11:18:45AM +0800, Herbert Xu wrote:
> > Hi:
> > 
> > I have received a report that ghash on ppc64le does not interoperate
> > with other implementations of ghash, e.g., on x86-64.
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1490972
> > 
> > Could you guys take a look at this and see if this is a bug in
> > the mainline vmx driver too?
> > 
> > Thanks!
> > -- 
> > Email: Herbert Xu <herbert@gondor.apana.org.au>
> > Home Page: http://gondor.apana.org.au/~herbert/
> > PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
> > 
> 
> Hi Herbert,
> 
> It seems that this bug is affected by the fact that ctr mode is using
> blkcipher for the fallback.
> 
> I just sent a patch [1] to make it use skcipher and, since then, ipsec
> with  ikev2 and ghash are working fine for ppc64 and ppc64le.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
