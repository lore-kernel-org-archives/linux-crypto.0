From: Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: [BUGFIX] crypto: Fix ctr(aes) testing by specifying geniv
Date: Fri, 14 Aug 2009 16:47:27 +0300
Message-ID: <1250257647.25202.21.camel@localhost>
References: <1249285483-22286-1-git-send-email-ying.huang@intel.com>
	 <20090805094506.GA12528@gondor.apana.org.au>
	 <1249524767.24238.318.camel@yhuang-dev.sh.intel.com>
	 <1250044020.5337.214.camel@yhuang-dev.sh.intel.com>
	 <20090813045300.GA19993@gondor.apana.org.au>
	 <20090813073910.GA21784@gondor.apana.org.au>
	 <20090813131253.GA27289@gondor.apana.org.au>
	 <20090814130241.GA7068@gondor.apana.org.au>
Reply-To: dedekind1@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Huang Ying <ying.huang@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:39191 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820AbZHNNuX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 14 Aug 2009 09:50:23 -0400
In-Reply-To: <20090814130241.GA7068@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, 2009-08-14 at 23:02 +1000, Herbert Xu wrote:
> diff --git a/crypto/ablkcipher.c b/crypto/ablkcipher.c
> index 03fb5fa..f6f0833 100644
> --- a/crypto/ablkcipher.c
> +++ b/crypto/ablkcipher.c
> @@ -183,6 +183,12 @@ EXPORT_SYMBOL_GPL(crypto_givcipher_type);
> =20
>  const char *crypto_default_geniv(const struct crypto_alg *alg)
>  {
> +	if (((alg->cra_flags & CRYPTO_ALG_TYPE_MASK) =3D=3D
> +	     CRYPTO_ALG_TYPE_BLKCIPHER ? alg->cra_blkcipher.ivsize :
> +					 alg->cra_ablkcipher.ivsize) !=3D
> +	    alg->cra_blocksize)
> +		return "chainiv";

I guess you used this cryptic construct instead of something more
readable because this is about a crypto algorithms? ;-)

--=20
Best Regards,
Artem Bityutskiy (=D0=90=D1=80=D1=82=D1=91=D0=BC =D0=91=D0=B8=D1=82=D1=8E=
=D1=86=D0=BA=D0=B8=D0=B9)

--
To unsubscribe from this list: send the line "unsubscribe linux-crypto"=
 in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
