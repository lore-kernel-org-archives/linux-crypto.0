From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] crypto: ccp - return an actual key size from RSA
 max_size callback
Date: Sun, 4 Mar 2018 20:56:02 +0800
Message-ID: <20180304125602.GA24397@gondor.apana.org.au>
References: <51c265e4-6153-3e5e-316a-ebef059ac36a@maciej.szmigiero.name>
 <20180302164451.GJ21579@gondor.apana.org.au>
 <087e7b27-f839-8d4b-8da8-5d0fa2f8caf1@maciej.szmigiero.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Gary Hook <gary.hook@amd.com>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <087e7b27-f839-8d4b-8da8-5d0fa2f8caf1@maciej.szmigiero.name>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Mar 03, 2018 at 12:15:20AM +0100, Maciej S. Szmigiero wrote:
>
> However, what about the first patch from this series?
> Without it, while it no longer should cause a buffer overflow, in-kernel
> X.509 certificate verification will still fail with CCP driver loaded
> (since CCP RSA implementation has a higher priority than the software
> RSA implementation).

That normally goes through the security tree.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
