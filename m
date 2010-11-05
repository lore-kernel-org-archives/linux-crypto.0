From: Lee Nipper <lee.nipper@gmail.com>
Subject: Re: [PATCH 1/1] crypto: api.c: doc on crypto_alg_lookup,
 crypto_larval_lookup, and crypto_alg_mod_lookup
Date: Fri, 5 Nov 2010 13:27:53 -0500
Message-ID: <AANLkTik7ttMgG97EOkDK7Cmh=7yUe8eUaTfnCoo12Q_9@mail.gmail.com>
References: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
Reply-To: lee.nipper@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-crypto@vger.kernel.org
To: Mark Allyn <mark.a.allyn@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab0KES1z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Nov 2010 14:27:55 -0400
Received: by bwz11 with SMTP id 11so2933224bwz.19
        for <linux-crypto@vger.kernel.org>; Fri, 05 Nov 2010 11:27:54 -0700 (PDT)
In-Reply-To: <1288980346-15961-1-git-send-email-mark.a.allyn@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
