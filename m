Return-Path: <SRS0=38jD=AY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43A0C433E0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 05:59:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7AFA2073A
	for <linux-crypto@archiver.kernel.org>; Mon, 13 Jul 2020 05:59:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725830AbgGMF7y (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 13 Jul 2020 01:59:54 -0400
Received: from vmicros1.altlinux.org ([194.107.17.57]:54044 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgGMF7y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 13 Jul 2020 01:59:54 -0400
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 1136F72CCF1;
        Mon, 13 Jul 2020 08:59:51 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id EEB6A4A4AEE;
        Mon, 13 Jul 2020 08:59:50 +0300 (MSK)
Date:   Mon, 13 Jul 2020 08:59:50 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
Subject: Re: [PATCH v2 5/5] crypto: ECDH SP800-56A rev 3 local public key
 validation
Message-ID: <20200713055950.ibvzogkdwhqxcduc@altlinux.org>
Mail-Followup-To: Stephan Mueller <smueller@chronox.de>,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        ard.biesheuvel@linaro.org, nhorman@redhat.com, simo@redhat.com
References: <2543601.mvXUDI8C0e@positron.chronox.de>
 <3168469.44csPzL39Z@positron.chronox.de>
 <20200712180613.dkzaklumuxndpgfw@altlinux.org>
 <5856902.DvuYhMxLoT@tauon.chronox.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5856902.DvuYhMxLoT@tauon.chronox.de>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 13, 2020 at 07:04:39AM +0200, Stephan Mueller wrote:
> Am Sonntag, 12. Juli 2020, 20:06:13 CEST schrieb Vitaly Chikunov:
> 
> Hi Vitaly,
> 
> > Stephan,
> > 
> > On Sun, Jul 12, 2020 at 06:42:14PM +0200, Stephan Müller wrote:
> > > After the generation of a local public key, SP800-56A rev 3 section
> > > 5.6.2.1.3 mandates a validation of that key with a full validation
> > > compliant to section 5.6.2.3.3.
> > > 
> > > Only if the full validation passes, the key is allowed to be used.
> > > 
> > > The patch adds the full key validation compliant to 5.6.2.3.3 and
> > > performs the required check on the generated public key.
> > > 
> > > Signed-off-by: Stephan Mueller <smueller@chronox.de>
> > > ---
> > > 
> > >  crypto/ecc.c | 31 ++++++++++++++++++++++++++++++-
> > >  crypto/ecc.h | 14 ++++++++++++++
> > >  2 files changed, 44 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/crypto/ecc.c b/crypto/ecc.c
> > > index 52e2d49262f2..7308487e7c55 100644
> > > --- a/crypto/ecc.c
> > > +++ b/crypto/ecc.c
> > > @@ -1404,7 +1404,9 @@ int ecc_make_pub_key(unsigned int curve_id, unsigned
> > > int ndigits,> 
> > >  	}
> > >  	
> > >  	ecc_point_mult(pk, &curve->g, priv, NULL, curve, ndigits);
> > > 
> > > -	if (ecc_point_is_zero(pk)) {
> > > +
> > > +	/* SP800-56A rev 3 5.6.2.1.3 key check */
> > > +	if (ecc_is_pubkey_valid_full(curve, pk)) {
> > > 
> > >  		ret = -EAGAIN;
> > >  		goto err_free_point;
> > >  	
> > >  	}
> > > 
> > > @@ -1452,6 +1454,33 @@ int ecc_is_pubkey_valid_partial(const struct
> > > ecc_curve *curve,> 
> > >  }
> > >  EXPORT_SYMBOL(ecc_is_pubkey_valid_partial);
> > > 
> > > +/* SP800-56A section 5.6.2.3.3 full verification */
> > 
> > Btw, 5.6.2.3.3 is partial validation, 5.6.2.3.2 is full validation
> > routine.
> 
> Looking at SP800-56A revision 3 from April 2018 I see:
> 
> "5.6.2.3.3 ECC Full Public-Key Validation Routine"

You are right. I looked at

  https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-56Ar2.pdf

which is Rev 2. And in Rev 3 they inserted `5.6.2.3.2 FFC Partial Public-Key
Validation Routine', so ECC paragraph numbers are shifted up.

Thanks,


> 
> Thanks for the review.
> 
> Ciao
> Stephan
> 
