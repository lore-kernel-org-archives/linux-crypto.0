From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/mpi: Fix umul_ppmm() for MIPS64r6
Date: Fri, 22 Dec 2017 19:22:48 +1100
Message-ID: <20171222082248.GA29663@gondor.apana.org.au>
References: <20171205233135.1763-1-james.hogan@mips.com>
 <20171222070808.GB27149@gondor.apana.org.au>
 <20171222075921.GJ28538@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Hogan <james.hogan@mips.com>,
        "David S. Miller" <davem@davemloft.net>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        linux-crypto@vger.kernel.org
To: Ralf Baechle <ralf@linux-mips.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [128.1.224.119] ([128.1.224.119]:46102 "EHLO ringil.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1753056AbdLVIXF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Dec 2017 03:23:05 -0500
Content-Disposition: inline
In-Reply-To: <20171222075921.GJ28538@linux-mips.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Dec 22, 2017 at 08:59:21AM +0100, Ralf Baechle wrote:
> On Fri, Dec 22, 2017 at 06:08:08PM +1100, Herbert Xu wrote:
> 
> > I can take this but I'd like to see an ack from someone on the
> > MIPS side.
> 
> Sure:
> 
> Acked-by: Ralf Baechle <ralf@linux-mips.org>

Thanks Ralf!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
