From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: caam - fix memory corruption in ahash_final_ctx
Date: Thu, 13 Aug 2015 15:12:55 +0800
Message-ID: <20150813071255.GA21167@gondor.apana.org.au>
References: <1439313560-14347-1-git-send-email-horia.geanta@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org, stable@vger.kernel.org
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1439313560-14347-1-git-send-email-horia.geanta@freescale.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 11, 2015 at 08:19:20PM +0300, Horia Geant=C4=83 wrote:
> When doing pointer operation for accessing the HW S/G table,
> a value representing number of entries (and not number of bytes)
> must be used.
>=20
> Cc: <stable@vger.kernel.org> # 3.6+
> Fixes: 045e36780f115 ("crypto: caam - ahash hmac support")
> Signed-off-by: Horia Geant=C4=83 <horia.geanta@freescale.com>

Applied to crypto.  Thanks!
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
