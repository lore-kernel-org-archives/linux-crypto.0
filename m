Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9F68C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:06:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9E9D720C01
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 17:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565370400;
	bh=CNz3UtQIBgBDTMTIa3VXIcCE8vp2caJ0yfSP5TrS5oE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=erj2YN1mkxXQTeOjZtqdrvglGQYb2FiO9q7oleu4agRB4KAASr5jWWf9x+9TjB0js
	 gZs2L3jpMsUh8FcgZRAnqlMoFvxPPGEWUDNudUBuaQHV6F0XF96vE83Fs3BUP4hCpv
	 Zh+1cGga/T7fGvOxWOiWL/9B+xl/FFZAsFFWFh+k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437086AbfHIRGj (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 13:06:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:60502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726528AbfHIRGj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 13:06:39 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECFCD20820;
        Fri,  9 Aug 2019 17:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565370398;
        bh=CNz3UtQIBgBDTMTIa3VXIcCE8vp2caJ0yfSP5TrS5oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gZrra8WjZTyZfoFKe+R1IBwM8ZcpZpR90qJaD6g8XpWiJDqZXJS031CAuBShgmOjm
         Ux1YvZWUPg/Umeqwot5g6mtlzfWGSwezr7RAdVqqGIEFPjnmmZ09EFHsp1Oea1C5D5
         egJgEBjfx7vxJd4zkxxIUhAo2braJXcQl0XTLWlU=
Date:   Fri, 9 Aug 2019 10:06:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: XTS template wrapping question
Message-ID: <20190809170636.GB658@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB29737E7D905FE0B9D3CE3A68CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973782AD2114D66B2A0807ECAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973782AD2114D66B2A0807ECAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 03:06:23PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Sent: Friday, August 9, 2019 4:18 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net; Eric Biggers <ebiggers@kernel.org>
> > Subject: RE: XTS template wrapping question
> > 
> > > -----Original Message-----
> > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf
> > Of
> > > Pascal Van Leeuwen
> > > Sent: Friday, August 9, 2019 1:39 PM
> > > To: linux-crypto@vger.kernel.org; herbert@gondor.apana.org.au; davem@davemloft.net; Eric
> > > Biggers <ebiggers@kernel.org>
> > > Subject: XTS template wrapping question
> > >
> > > Herbert, Eric,
> > >
> > > While working on the XTS template, I noticed that it is being used
> > > (e.g. from testmgr, but also when explictly exported from other drivers)
> > > as e.g. "xts(aes)", with the generic driver actually being
> > > "xts(ecb(aes-generic))".
> > >
> > > While what I would expect would be "xts(ecb(aes))", the reason being
> > > that plain "aes" is defined as a single block cipher while the XTS
> > > template actually efficiently wraps an skcipher (like ecb(aes)).
> > > The generic driver reference actually proves this point.
> > >
> > > The problem with XTS being used without the ecb template in between,
> > > is that hardware accelerators will typically advertise an ecb(aes)
> > > skcipher and the current approach makes it impossible to leverage
> > > that for XTS (while the XTS template *could* actually do that
> > > efficiently, from what I understand from the code ...).
> > > Advertising a single block "aes" cipher from a hardware accelerator
> > > unfortunately defeats the purpose of acceleration.
> > >
> > > I also wonder what happens if aes-generic is the only AES
> > > implementation available? How would the crypto API know it needs to
> > > do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> > > (And I don't see how xts(aes) would work directly, considering
> > > that only seems to handle single cipher blocks? Or ... will
> > > the crypto API actually wrap some multi-block skcipher thing
> > > around the single block cipher instance automatically??)
> > >
> > Actually, the above was based on observations from testmgr, which
> > doesn't seem to test xts(safexcel-ecb-aes) even though I gave that
> > a very high .cra_priority as well as that what is advertised under
> > /proc/crypto, which does not include such a thing either.
> > 
> > However, playing with tcrypt mode=600 shows some interesting
> > results:
> > 
> > WITHOUT the inside-secure driver loaded, both LRW encrypt and
> > decrypt run on top of ecb-aes-aesni as you would expect.
> > Both xts encrypt and decrypt give a "failed to load transform"
> > with an error code of -80. Strange ... -80 = ELIBBAD??
> > (Do note that the selftest of xts(aes) using xts-aesni worked
> > just fine according to /proc/crypto!)
> > 
> > WITH the inside-secure driver loaded, NOT advertising xts(aes)
> > itself and everything at cra_priority of 300: same (expected).
> > 
> > WITH the inside-secure driver loaded, NOT advertising xts(aes)
> > itself and everything safexcel at cra_priority of 2000:
> > LRW decrypt now runs on top of safexcel-ecb-aes, but LRW
> > encrypt now runs on top of aes-generic? This makes no sense as
> > the encrypt datapath structure is the same as for decrypt so
> > it should run just fine on top of safexcel-ecb-aes. And besides
> > that, why drop from aesni all the way down to aes-generic??
> > xts encrypt and decrypt still give the -80 error, while you
> > would expect that to now run using the xts wrapper around
> > safexcel-ecb-aes (but no way to tell if that's happening).
> > 
> > WITH the inside-secure driver loaded, advertising xts(aes)
> > itself and everything at cra_priority of 2000:
> > still the same LRW assymmetry as mentioned above, but
> > xts encrypt and decrypt now work fine using safexcel-aes-xts
> > 
> > Conclusions from the above:
> > 
> > - There's something fishy with the selection of the underlying
> >   AES cipher for LRW encrypt (but not for LRW decrypt).
> >
> Actually, this makes no sense at all as crypto_skcipher_alloc 
> does not even see the direction you're going to use in your 
> requests. Still, it is what I consistently see happening in 
> the tcrypt logging. Weird!

There's a known bug when the extra self-tests are enabled, where the first
allocation of an algorithm actually returns the generic implementation, not the
highest priority implementation.  See:
https://lkml.kernel.org/linux-crypto/20190409181608.GA122471@gmail.com/
Does that explain what you saw?

> 
> > - xts-aes-aesni (and the xts.c wrapper?) appear(s) broken in
> >   some way not detected by testmgr but affecting tcrypt use,
> >   while the inside-secure driver's local xts works just fine
> > 

Is this reproducible without any local patches?  If so, can you provide clear
reproduction steps?

- Eric
