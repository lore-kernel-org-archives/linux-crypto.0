From: "Allyn, Mark A" <mark.a.allyn@intel.com>
Subject: RE: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup,
 crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Fri, 5 Nov 2010 12:36:41 -0600
Message-ID: <8A0E4C92AE2D6D40AF99653191DA32316141414460@rrsmsx501.amr.corp.intel.com>
References: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
 <AANLkTik7ttMgG97EOkDK7Cmh=7yUe8eUaTfnCoo12Q_9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "lee.nipper@gmail.com" <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:51619 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab0KESgp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:45 -0400
In-Reply-To: <AANLkTik7ttMgG97EOkDK7Cmh=7yUe8eUaTfnCoo12Q_9@mail.gmail.com>
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Can you please explain what larval means in this context? I tried googl=
ing it an could not find anything meaningful.=20

What is the difference between crypto_alg_lookup and crypto_larval_look=
up?

I was making an assumption that larval is shorthand for large value as =
there is nothing meaningful in google except for a type of wormlike for=
m.

Thank you

Mark Allyn

-----Original Message-----
=46rom: Lee Nipper [mailto:lee.nipper@gmail.com]=20
Sent: Friday, November 05, 2010 11:28 AM
To: Allyn, Mark A
Cc: linux-crypto@vger.kernel.org
Subject: Re: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup, crypt=
o_larval_lookup, and crypto_alg_mod_lookup

On Fri, Nov 5, 2010 at 13:05, Mark Allyn <mark.a.allyn@intel.com> wrote=
:
> Resubmit due to errors on patch submitted 11/4/2010
>
> Signed-off-by: Mark A. Allyn <mark.a.allyn@intel.com>
> ---
> =A0crypto/api.c | =A0 25 +++++++++++++++++++++++++
> =A01 files changed, 25 insertions(+), 0 deletions(-)
>
> diff --git a/crypto/api.c b/crypto/api.c
> index 033a714..d8a7c35 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -193,6 +193,14 @@ static struct crypto_alg *crypto_larval_wait(str=
uct crypto_alg *alg)
> =A0 =A0 =A0 =A0return alg;
> =A0}
>
> +/**
> + * crypto_alg_lookup() - get the crypto_alg structure for an algorit=
hm
> + * @name: =A0 =A0 =A0text string containing name of algorithm
> + * @type: =A0 =A0 =A0crypto type defined in include/linux/crypto.h
> + * @mask: =A0 =A0 =A0mask of allowable crypto types (use or'd list
> + * =A0 =A0 =A0 =A0 =A0 =A0 of types as defined in include/linux/cryp=
to.h)
> + * @returns: =A0 pointer to crypto_alg structure
> + */
> =A0struct crypto_alg *crypto_alg_lookup(const char *name, u32 type, u=
32 mask)
> =A0{
> =A0 =A0 =A0 =A0struct crypto_alg *alg;
> @@ -205,6 +213,15 @@ struct crypto_alg *crypto_alg_lookup(const char =
*name, u32 type, u32 mask)
> =A0}
> =A0EXPORT_SYMBOL_GPL(crypto_alg_lookup);
>
> +/**
> + * crypto_larval_lookup() - gets large value (larval) crypto_alg
> + * =A0 =A0 structure for an algorithm

larval is an adjective.  omit "large value", as it only adds confusion.

> + * @name: =A0 =A0 =A0text string containing name of algorithm
> + * @type: =A0 =A0 =A0crypto type defined in include/linux/crypto.h
> + * @mask: =A0 =A0 =A0mask of allowable crypto types (use or'd list
> + * =A0 =A0 =A0 =A0 =A0 =A0 of types as defined in include/linux/cryp=
to.h)
> + * @returns: =A0 pointer to crypto_alg structure
> + */
> =A0struct crypto_alg *crypto_larval_lookup(const char *name, u32 type=
, u32 mask)
> =A0{
> =A0 =A0 =A0 =A0struct crypto_alg *alg;
> @@ -247,6 +264,14 @@ int crypto_probing_notify(unsigned long val, voi=
d *v)
> =A0}
> =A0EXPORT_SYMBOL_GPL(crypto_probing_notify);
>
> +/**
> + * crypto_alg_mod_lookup() - gets the algorithm module
> + * @name: =A0 =A0 =A0text string containing name of algorithm
> + * @type: =A0 =A0 =A0crypto type defined in include/linux/crypto.h
> + * @mask: =A0 =A0 =A0mask of allowable crypto types (use or'd list
> + * =A0 =A0 =A0 =A0 =A0 =A0 of types as defined in include/linux/cryp=
to.h)
> + * @returns: =A0 pointer to crypto_alg structure
> + */
> =A0struct crypto_alg *crypto_alg_mod_lookup(const char *name, u32 typ=
e, u32 mask)
> =A0{
> =A0 =A0 =A0 =A0struct crypto_alg *alg;
> --
