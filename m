Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B025FC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 22:28:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D3BA21873
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 22:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551220106;
	bh=6wiAA0plAefmA23D7uz9DQFUSxyjIU0oRPBZogV54fM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=SmXU0VfEiTx9NZ30odry6iirqa5E1W01RJG/IBKe9lhjYpKdbVCCWD6h2tRGiQXGE
	 CPrgBiU8t37kzvMdmiIngD9drXDVj91g+2epmXgkml+sIGllnmppNN8zZu/W/sa2i9
	 Lf0jF0umjfusBEuEbsRvS9RVzet+Qne585LlSnwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfBZW2Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Feb 2019 17:28:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:47086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728791AbfBZW2Z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Feb 2019 17:28:25 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1F21F2186A;
        Tue, 26 Feb 2019 22:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551220104;
        bh=6wiAA0plAefmA23D7uz9DQFUSxyjIU0oRPBZogV54fM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=atvh7ygBj06fUfwtSDhF4/rJxiBQ4N8V0h96ZYJ0b2bKetInAuvmt9plwWV1oXh88
         9EXHYved2Ve595MndIHcFieJRQ+sQxG8MJZvM1QET2y9DF8rAmN3GFHXJrCVivKWcF
         zVUq5ZTDk1dh3ZL9gQdFNDmNz417JUU6SlrXJ67E=
Date:   Tue, 26 Feb 2019 14:28:22 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jan Glauber <jglauber@marvell.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mahipal Challa <mahipalreddy2006@gmail.com>
Subject: Re: [PATCH] crypto: cavium/zip - fix collision with generic
 cra_driver_name
Message-ID: <20190226222821.GD218103@gmail.com>
References: <20190223082323.4126-1-ebiggers@kernel.org>
 <20190226075545.GB15176@hc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190226075545.GB15176@hc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 26, 2019 at 07:55:54AM +0000, Jan Glauber wrote:
> On Sat, Feb 23, 2019 at 12:23:23AM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > The cavium/zip implementation of the deflate compression algorithm is
> > incorrectly being registered under the generic driver name, which
> > prevents the generic implementation from being registered with the
> > crypto API when CONFIG_CRYPTO_DEV_CAVIUM_ZIP=y.  Similarly the lzs
> > algorithm (which does not currently have a generic implementation...)
> > is incorrectly being registered as lzs-generic.
> > 
> > Fix the naming collision by adding a suffix "-cavium" to the
> > cra_driver_name of the cavium/zip algorithms.
> 
> The patch is fine, basically the same as:
> https://marc.info/?l=linux-crypto-vger&m=152968599829763&w=2
> 
> Shouldn't we also rename deflate to deflate generic?
> 
> --Jan
> 

It is already deflate-generic.  Since cra_driver_name is unset,
crypto_set_driver_name() in crypto/algapi.c appends "-generic" to
cra_name = "deflate", forming cra_driver_name = "deflate-generic".

Personally I think that should be gotten rid of and the crypto API should
require that cra_driver_name always be set, but that's what it does now.

> > Fixes: 640035a2dc55 ("crypto: zip - Add ThunderX ZIP driver core")
> > Cc: Mahipal Challa <mahipalreddy2006@gmail.com>
> > Cc: Jan Glauber <jglauber@cavium.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  drivers/crypto/cavium/zip/zip_main.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/crypto/cavium/zip/zip_main.c b/drivers/crypto/cavium/zip/zip_main.c
> > index e6b09e784e666..a8447a3cf3665 100644
> > --- a/drivers/crypto/cavium/zip/zip_main.c
> > +++ b/drivers/crypto/cavium/zip/zip_main.c
> > @@ -351,6 +351,7 @@ static struct pci_driver zip_driver = {
> > 
> >  static struct crypto_alg zip_comp_deflate = {
> >         .cra_name               = "deflate",
> > +       .cra_driver_name        = "deflate-cavium",
> >         .cra_flags              = CRYPTO_ALG_TYPE_COMPRESS,
> >         .cra_ctxsize            = sizeof(struct zip_kernel_ctx),
> >         .cra_priority           = 300,
> > @@ -365,6 +366,7 @@ static struct crypto_alg zip_comp_deflate = {
> > 
> >  static struct crypto_alg zip_comp_lzs = {
> >         .cra_name               = "lzs",
> > +       .cra_driver_name        = "lzs-cavium",
> >         .cra_flags              = CRYPTO_ALG_TYPE_COMPRESS,
> >         .cra_ctxsize            = sizeof(struct zip_kernel_ctx),
> >         .cra_priority           = 300,
> > @@ -384,7 +386,7 @@ static struct scomp_alg zip_scomp_deflate = {
> >         .decompress             = zip_scomp_decompress,
> >         .base                   = {
> >                 .cra_name               = "deflate",
> > -               .cra_driver_name        = "deflate-scomp",
> > +               .cra_driver_name        = "deflate-scomp-cavium",
> >                 .cra_module             = THIS_MODULE,
> >                 .cra_priority           = 300,
> >         }
> > @@ -397,7 +399,7 @@ static struct scomp_alg zip_scomp_lzs = {
> >         .decompress             = zip_scomp_decompress,
> >         .base                   = {
> >                 .cra_name               = "lzs",
> > -               .cra_driver_name        = "lzs-scomp",
> > +               .cra_driver_name        = "lzs-scomp-cavium",
> >                 .cra_module             = THIS_MODULE,
> >                 .cra_priority           = 300,
> >         }
> > --
> > 2.20.1
