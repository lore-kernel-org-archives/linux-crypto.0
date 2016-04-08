From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH v3 2/3] crypto: rsa_helper - add raw integer parser actions
Date: Fri, 8 Apr 2016 13:09:02 -0400
Message-ID: <CAH8yC8kC+5xNrO0Frd80tAfnikxMvfs_Ovrj8_kFMmjTcw-RTg@mail.gmail.com>
References: <1459949826-11840-1-git-send-email-tudor-dan.ambarus@nxp.com>
	<1459949826-11840-3-git-send-email-tudor-dan.ambarus@nxp.com>
	<CAH8yC8mECu967LbYRWzuhGms8MigfYONS-upFz7nHKhhv=suRQ@mail.gmail.com>
	<1665554.PWMBgngPXm@tauon.atsec.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Tudor Ambarus <tudor-dan.ambarus@nxp.com>,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	tadeusz.struk@intel.com, cristian.stoica@nxp.com,
	horia.geanta@nxp.com
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33925 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754756AbcDHRJE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 8 Apr 2016 13:09:04 -0400
Received: by mail-io0-f177.google.com with SMTP id 2so139241460ioy.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Apr 2016 10:09:02 -0700 (PDT)
In-Reply-To: <1665554.PWMBgngPXm@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 8, 2016 at 12:55 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Freitag, 8. April 2016, 12:54:10 schrieb Jeffrey Walton:
>
> Hi Jeffrey,
>
>> > +int rsa_check_key_length(unsigned int len)
>> > +{
>> > +       switch (len) {
>> > +       case 512:
>> > +       case 1024:
>> > +       case 1536:
>> > +       case 2048:
>> > +       case 3072:
>> > +       case 4096:
>> > +               return 0;
>> > +       }
>> > +
>> > +       return -EINVAL;
>> > +}
>>
>> That's an unusual restriction.
>>
>> > +       key->n_sz = vlen;
>> > +       /* In FIPS mode only allow key size 2K & 3K */
>> > +       if (fips_enabled && (key->n_sz != 256 && key->n_sz != 384)) {
>> > +               dev_err(ctx->dev, "RSA: key size not allowed in FIPS
>> > mode\n"); +               goto err;
>> > +       }
>>
>> That's an unusual restriction, too. As far as I know, FIPS does not
>> place that restriction.
>
> It does, see SP80-131A and the requirements on CAVS.

I believe the controlling document is SP800-56B. SP800-131 is just a
guide, and it digests the information from SP800-56B. For current FIPS
140 requirements (SP800-56B), RSA is a Finite Filed (FF) system, and
the requirement is |N| >= 2048.

Also, I did not see the restriction listed in SP800-131A Rev 1. Cf.,
http://csrc.nist.gov/publications/drafts/800-131A/sp800-131a_r1_draft.pdf.

Jeff
