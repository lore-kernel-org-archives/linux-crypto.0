From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa - fix buffer overread when stripping leading
 zeroes
Date: Wed, 29 Nov 2017 10:26:48 +1100
Message-ID: <20171128232648.GB17611@gondor.apana.org.au>
References: <20171127071649.25800-1-ebiggers3@gmail.com>
 <9913.1511866472@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        Alexander Potapenko <glider@google.com>,
        Eric Biggers <ebiggers@google.com>, stable@vger.kernel.org,
        Tudor Ambarus <tudor-dan.ambarus@nxp.com>
To: David Howells <dhowells@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9913.1511866472@warthog.procyon.org.uk>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 28, 2017 at 10:54:32AM +0000, David Howells wrote:
> Hi Herbert,
> 
> Are you going to take this?

Yes it's in my queue.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
