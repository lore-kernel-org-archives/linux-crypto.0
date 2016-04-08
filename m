From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser actions
Date: Fri, 8 Apr 2016 12:54:10 -0400
Message-ID: <CAH8yC8mECu967LbYRWzuhGms8MigfYONS-upFz7nHKhhv=suRQ@mail.gmail.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
	<1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com, Stephan Mueller <smueller@chronox.de>,
	cristian.stoica@nxp.com, horia.geanta@nxp.com
To: Tudor Ambarus <tudor-dan.ambarus@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37042 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758467AbcDHQyM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 12:54:12 -0400
Received: by mail-ig0-f171.google.com with SMTP id g8so21228881igr.0
        for <linux-crypto@vger.kernel.org>; Fri, 08 Apr 2016 09:54:11 -0700 (PDT)
In-Reply-To: <1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> +int rsa_check_key_length(unsigned int len)
> +{
> +       switch (len) {
> +       case 512:
> +       case 1024:
> +       case 1536:
> +       case 2048:
> +       case 3072:
> +       case 4096:
> +               return 0;
> +       }
> +
> +       return -EINVAL;
> +}

That's an unusual restriction.

> +       key->n_sz = vlen;
> +       /* In FIPS mode only allow key size 2K & 3K */
> +       if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
> +               dev_err(ctx->dev, "RSA: key size not allowed in FIPS mode\n");
> +               goto err;
> +       }

That's an unusual restriction, too. As far as I know, FIPS does not
place that restriction.

Jeff
