From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser actions
Date: Fri, 08 Apr 2016 18:55:09 +0200
Message-ID: <1665554.PWMBgngPXm@tauon.atsec.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com> <1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com> <CAH8yC8mECu967LbYRWzuhGms8MigfYONS-upFz7nHKhhv=suRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com, cristian.stoica@nxp.com,
	horia.geanta@nxp.com
To: noloader@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34228 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752071AbcDHQzM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 12:55:12 -0400
In-Reply-To: <CAH8yC8mECu967LbYRWzuhGms8MigfYONS-upFz7nHKhhv=suRQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 8. April 2016, 12:54:10 schrieb Jeffrey Walton:

Hi Jeffrey,

> > +int rsa_check_key_length(unsigned int len)
> > +{
> > +       switch (len) {
> > +       case 512:
> > +       case 1024:
> > +       case 1536:
> > +       case 2048:
> > +       case 3072:
> > +       case 4096:
> > +               return 0;
> > +       }
> > +
> > +       return -EINVAL;
> > +}
> 
> That's an unusual restriction.
> 
> > +       key->n_sz = vlen;
> > +       /* In FIPS mode only allow key size 2K & 3K */
> > +       if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
> > +               dev_err(ctx->dev, "RSA: key size not allowed in FIPS
> > mode\n"); +               goto err;
> > +       }
> 
> That's an unusual restriction, too. As far as I know, FIPS does not
> place that restriction.

It does, see SP80-131A and the requirements on CAVS.

Very lately they added 4k too, hence my question.
> 
> Jeff


Ciao
Stephan
