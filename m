From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/4] /dev/crypto implementation
Date: Wed, 11 Aug 2010 07:13:18 -0400
Message-ID: <20100811111318.GA6676@gondor.apana.org.au>
References: <1281039477-29703-1-git-send-email-mitr@redhat.com> <1281039477-29703-3-git-send-email-mitr@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Neil Horman <nhorman@redhat.com>,
	Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>,
	linux-crypto@vger.kernel.org
To: Miloslav =?utf-8?B?VHJtYcSN?= <mitr@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:39264 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab0HKLNX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Aug 2010 07:13:23 -0400
Content-Disposition: inline
In-Reply-To: <1281039477-29703-3-git-send-email-mitr@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Aug 05, 2010 at 10:17:55PM +0200, Miloslav Trma=C4=8D wrote:
>
> +static const struct algo_properties_st algo_properties[] =3D {
> +	{ .algo =3D NCR_ALG_NULL, .kstr =3D "ecb(cipher_null)",=20
> +		.needs_iv =3D 0, .is_symmetric=3D1, .can_encrypt=3D1,
> +		.key_type =3D NCR_KEY_TYPE_INVALID },

Hard-coding names like this is completely unacceptable.  User-space
should be able to specify the algorithm as a string.

Thanks,
--=20
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
