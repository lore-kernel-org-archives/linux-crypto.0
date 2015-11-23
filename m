From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/1] crypto: tcrypt: fix keysize argument of
 test_aead_speed for gcm(aes)
Date: Mon, 23 Nov 2015 21:02:11 +0800
Message-ID: <20151123130211.GD7866@gondor.apana.org.au>
References: <35cb25c643325f2051831dde57cba2362925cd56.1447763536.git.cyrille.pitchen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Cyrille Pitchen <cyrille.pitchen@atmel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <35cb25c643325f2051831dde57cba2362925cd56.1447763536.git.cyrille.pitchen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Nov 17, 2015 at 01:37:10PM +0100, Cyrille Pitchen wrote:
> The key sizes used by AES in GCM mode should be 128, 192 or 256 bits (16,
> 24 or 32 bytes).
> There is no additional 4byte nonce as for RFC 4106.
> 
> Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
