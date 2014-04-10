From: Marek Vasut <marex@denx.de>
Subject: Re: [PATCH 1/2] crypto: bfin_crc: ignore duplicated registration of the same algorithm
Date: Thu, 10 Apr 2014 14:33:50 +0200
Message-ID: <201404101433.50925.marex@denx.de>
References: <1397119259-20638-1-git-send-email-sonic.adi@gmail.com> <201404101059.21811.marex@denx.de> <CAJxxZ0MVmpY-stBGJbXGAxiXPOGJWtbOEOEHtdPook-1v-EWGA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org,
	adi-buildroot-devel@lists.sourceforge.net,
	Sonic Zhang <sonic.zhang@analog.com>
To: Sonic Zhang <sonic.adi@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-out.m-online.net ([212.18.0.10]:37600 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030371AbaDJMdv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 10 Apr 2014 08:33:51 -0400
In-Reply-To: <CAJxxZ0MVmpY-stBGJbXGAxiXPOGJWtbOEOEHtdPook-1v-EWGA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thursday, April 10, 2014 at 11:51:29 AM, Sonic Zhang wrote:
> Hi Marek,
> 
> On Thu, Apr 10, 2014 at 4:59 PM, Marek Vasut <marex@denx.de> wrote:
> > On Thursday, April 10, 2014 at 10:40:58 AM, Sonic Zhang wrote:
> >> From: Sonic Zhang <sonic.zhang@analog.com>
> >> 
> >> in case of multiple crc devices are probed.
> >> 
> >> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> >> ---
> >> 
> >>  drivers/crypto/bfin_crc.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> >> 
> >> diff --git a/drivers/crypto/bfin_crc.c b/drivers/crypto/bfin_crc.c
> >> index cea3e8c..5f5f427 100644
> >> --- a/drivers/crypto/bfin_crc.c
> >> +++ b/drivers/crypto/bfin_crc.c
> >> @@ -672,7 +672,7 @@ static int bfin_crypto_crc_probe(struct
> >> platform_device *pdev) platform_set_drvdata(pdev, crc);
> > 
> > Rant: Reading through the code a little, the platform_set_drvdata()
> > should happen before you add the new CRC device into the list (above
> > this code).
> 
> OK
> 
> >>       ret = crypto_register_ahash(&algs);
> >> 
> >> -     if (ret) {
> >> +     if (ret && ret != -EEXIST) {
> > 
> > Uh oh, how is this supposed to work ? Does blackfin have multiple crc32
> > processing units ? Can you simply not check if the crc_list is not empty
> > and avoid calling crypto_register_ahash() for subsequent crc32 units at
> > all ?
> 
> Yes, Blackfin has 2 crc32 units CRC0 and CRC1.
> I will have a try to see if it works.

Thank you !

Best regards,
Marek Vasut
