Return-Path: <SRS0=XFsj=M6=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-vk1-f195.google.com ([209.85.221.195]:46291 "EHLO
        mail-vk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeJRNei (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Oct 2018 09:34:38 -0400
Received: by mail-vk1-f195.google.com with SMTP id h186so5486130vkh.13
        for <linux-crypto@vger.kernel.org>; Wed, 17 Oct 2018 22:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <fbcca5eb-a301-53f4-3faf-a36a3229300d@baylibre.com> <VI1PR0402MB3485278043D883A74ED7AEBD98FF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485278043D883A74ED7AEBD98FF0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From: Gilad Ben-Yossef <gilad@benyossef.com>
Date: Thu, 18 Oct 2018 08:35:11 +0300
Message-ID: <CAOtvUMditsPn90kVSjpkKKzweAnp-ywvt7hps407GmruEMmRCQ@mail.gmail.com>
Subject: Re: dm-integrity stalls with iMX6q CAAM
To: =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>
Cc: narmstrong@baylibre.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        aymen.sghaier@nxp.com,
        device-mapper development <dm-devel@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 17, 2018 at 4:35 PM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 9/21/2018 3:06 PM, Neil Armstrong wrote:
> > Hi,
> >
> > I recently configured dm-crypt + dm-integrity on an iMX6q platform with=
 CAAM Hash functions enabled using the following command lines :
> >
> > Linux 4.14.71
> >
> > cryptsetup luksFormat /dev/mmcblk1p3 --cipher aes-xts-plain64 --type lu=
ks2 --integrity hmac-sha256 --sector-size 512 --use-urandom
> > cryptsetup open /dev/mmcblk1p3 root
> > mkfs.ext4 -v -F /dev/mapper/root
> >
> > luksFormat and open finishes correctly, luksDump and status reports cor=
rect dm and luks properties.
> >
> > but when trying to access the /dev/mapper/root (mkfs, sha256sum or what=
ever), it blocks without any warning or errors reported by the kernel.
> > I can see a few (~170) interrupts on the jr0 interrupt then nothing.
> >
> > Is there a particular issue with hmac-sha256 with the linux CAAM driver=
 ?
> >
> > When disabling the CAAM hash functions or using another cipher & integr=
ity pair, it works like a charm.
> >
> The issue you are seeing is most probably related to CAAM driver not
> implementing correctly the crypto requests "backlogging".
> See commit c0403ec0bb5a ("Revert "dm crypt: fix deadlock when async crypt=
o
> algorithm returns -EBUSY"") for a detailed description.
>
> Historically, there have been several CAAM backlogging implementations pr=
oposed
> - but all were rejected:

hmmm... obviously the right solution is to implement backlogging but
you might want to consider changing the driver to
return -ENOSPC or -ENOSYS instead in the meantime. It should cause
dm-crypt to fail rather than hang... which is not necessarily better,
but at least more obvious by the user what is going on?

Gilad

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
