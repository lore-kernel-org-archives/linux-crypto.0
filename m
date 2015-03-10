From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: AES-NI: fix memory usage in GCM decryption
Date: Tue, 10 Mar 2015 20:45:43 +1100
Message-ID: <20150310094543.GA17358@gondor.apana.org.au>
References: <22281096.OZkxDCz0xu@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <22281096.OZkxDCz0xu@tachyon.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Mar 08, 2015 at 07:49:58PM +0100, Stephan Mueller wrote:
> The RFC4106 GCM decryption operation tries to overwrite cryptlen memory
> in req->dst. As the destination buffer for decryption only needs to hold
> the plaintext memory but cryptlen references the input buffer holding
> (ciphertext || authentication tag), the assumption of the destination
> buffer length in RFC4106 GCM operation leads to a too large size.
> 
> This patch simply subtracts the authentication tag size from cryptlen.
> The kernel crypto API logic requires the caller to provide the
> length of (ciphertext || authentication tag) as cryptlen for the
> AEAD decryption operation. Thus, the cipher implementation must
> caculate the size of the plaintext output itself and cannot simply use
> cryptlen.
> 
> Note, this fixes a kernel crash that can be triggered from user space
> via AF_ALG(aead)  without it (simply use the libkcapi test application
> from [1] and update it to use rfc4106-gcm-aes).
> 
> [1] http://www.chronox.de/libkcapi.html
> 
> CC: Tadeusz Struk <tadeusz.struk@intel.com>
> Signed-off-by: Stephan Mueller <smueller@chronox.de>

Good catch.  However, I think the same confusion exists in the
code that allocates src which may also trigger a crash.  So could
you fix that as well?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
