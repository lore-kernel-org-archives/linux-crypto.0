From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller-T9tCv8IpfcWELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 3/4] crypto: axis: add ARTPEC-6/7 crypto accelerator driver
Date: Thu, 20 Jul 2017 16:51:17 +0200
Message-ID: <9168085.KJckqYBggK@tauon.chronox.de>
References: <cover.1500557664.git.larper@axis.com> <b2d7ce4b0fecc4e811c12573f44bd7c45f0147e2.1500557664.git.larper@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        Lars Persson <larper-VrBV9hrLPhE@public.gmane.org>
To: Lars Persson <lars.persson-VrBV9hrLPhE@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b2d7ce4b0fecc4e811c12573f44bd7c45f0147e2.1500557664.git.larper-VrBV9hrLPhE@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 20. Juli 2017, 15:44:31 CEST schrieb Lars Persson:

Hi Lars,

> +static int
> +artpec6_crypto_cipher_set_key(struct crypto_skcipher *cipher, const u8
> *key, +			      unsigned int keylen)
> +{
> +	struct artpec6_cryptotfm_context *ctx =
> +		crypto_skcipher_ctx(cipher);
> +
> +	if (ctx->crypto_type == ARTPEC6_CRYPTO_CIPHER_NULL)
> +		return 0;
> +
> +	switch (keylen) {
> +	case 16:
> +	case 24:
> +	case 32:
> +		break;
> +	case 48:
> +	case 64:
> +		if (ctx->crypto_type == ARTPEC6_CRYPTO_CIPHER_AES_XTS)

Could you please add xts_check_key for XTS keys?


Ciao
Stephan
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
