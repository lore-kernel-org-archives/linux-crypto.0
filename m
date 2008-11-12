From: Tobias Geiger <tobias.geiger@vido.info>
Subject: Re: dm-crypt using hifn_795x - still broken
Date: Wed, 12 Nov 2008 23:36:49 +0100
Message-ID: <200811122336.49835.tobias.geiger@vido.info>
References: <200811121710.41666.tobias.geiger@vido.info> <200811122043.06790.tobias.geiger@vido.info> <20081112205121.GB7854@ioremap.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Evgeniy Polyakov <zbr@ioremap.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www.vido.info ([78.47.43.171]:52516 "EHLO mail.vido.info"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750933AbYKLWg7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 12 Nov 2008 17:36:59 -0500
In-Reply-To: <20081112205121.GB7854@ioremap.net>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Evgeniy

it works! for the first time i have this card, it actually does something 
useful ;) Thanks a lot so far!

Problem now is, it eates up all my cpu somehow - i.e. my system now generates 
hi/si 98% of the time, everything feels ~200% slower than "normal"

Greetings and many thanks for your efforts
Tobias

Am Mittwoch, 12. November 2008 schrieb Evgeniy Polyakov:
> On Wed, Nov 12, 2008 at 08:43:06PM +0100, Tobias Geiger 
(tobias.geiger@vido.info) wrote:
> > Hello Evgeniy,
> >
> > i tried that, know it just hangs while mounting the decrypted device. No
> > special dmesg error or anything.:
>
> Please try attached patch against vanilla driver.
> Likely I messed up with ring size.
>
> diff --git a/drivers/crypto/hifn_795x.c b/drivers/crypto/hifn_795x.c
> index 4d22b21..c743cfc 100644
> --- a/drivers/crypto/hifn_795x.c
> +++ b/drivers/crypto/hifn_795x.c
> @@ -38,9 +38,6 @@
>
>  #include <asm/kmap_types.h>
...
