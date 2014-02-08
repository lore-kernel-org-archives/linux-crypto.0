From: Kim Phillips <kim.phillips@linaro.org>
Subject: Re: [PATCH] crypto: caam - fix ERA retrieval function
Date: Fri, 7 Feb 2014 19:36:42 -0600
Message-ID: <20140207193642.a4c76876a569ec678bfac525@linaro.org>
References: <1391675239-11289-1-git-send-email-alexandru.porosanu@freescale.com>
	<52F358C8.2020105@freescale.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: alexandru.porosanu@freescale.com, linux-crypto@vger.kernel.org,
	herbert@gondor.apana.org.au, vakul@freescale.com,
	ruchika.gupta@freescale.com
To: horia.geanta@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:63244 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaBHBgp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Feb 2014 20:36:45 -0500
Received: by mail-ob0-f180.google.com with SMTP id wp4so4927471obc.11
        for <linux-crypto@vger.kernel.org>; Fri, 07 Feb 2014 17:36:44 -0800 (PST)
In-Reply-To: <52F358C8.2020105@freescale.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 6 Feb 2014 11:41:28 +0200
Horia Geant=C4=83 <horia.geanta@freescale.com> wrote:

> On 2/6/2014 10:27 AM, Alex Porosanu wrote:
> > Signed-off-by: Alex Porosanu <alexandru.porosanu@freescale.com>
> > ---
> >   drivers/crypto/caam/ctrl.c | 36 ++++++++++-----------------------=
---
> >   drivers/crypto/caam/ctrl.h |  2 +-
> >   2 files changed, 11 insertions(+), 27 deletions(-)
>=20
> Reviewed-by: Horia Geanta <horia.geanta@freescale.com>
>=20
> "fsl, sec-era" has been in u-boot and in dt bindings for over a year.

yours maybe.  It's an optional property.

Kim
