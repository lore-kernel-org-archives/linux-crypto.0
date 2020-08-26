Return-Path: <SRS0=MfKA=CE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FAA4C433E1
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 12:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6F8D32087C
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Aug 2020 12:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729796AbgHZMIx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Aug 2020 08:08:53 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33072 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729538AbgHZMIv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Aug 2020 08:08:51 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kAuEC-0003TM-Nd; Wed, 26 Aug 2020 22:08:33 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Aug 2020 22:08:32 +1000
Date:   Wed, 26 Aug 2020 22:08:32 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Issue with iwd + Linux 5.8.3 + WPA Enterprise
Message-ID: <20200826120832.GA2996@gondor.apana.org.au>
References: <20200826055150.2753.90553@ml01.vlan13.01.org>
 <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au>
 <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 26, 2020 at 01:59:53PM +0200, Ard Biesheuvel wrote:
> On Wed, 26 Aug 2020 at 13:50, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Aug 26, 2020 at 12:40:14PM +0200, Ard Biesheuvel wrote:
> > >
> > > It would be helpful if someone could explain for the non-mac80211
> > > enlightened readers how iwd's EAP-PEAPv0 + MSCHAPv2 support relies on
> > > the algif_aead socket interface, and which AEAD algorithms it uses. I
> > > assume this is part of libell?
> >
> > I see the problem.  libell/ell/checksum.c doesn't clear the MSG_MORE
> > flag before doing the recv(2).
> 
> But that code uses a hash not an aead, afaict.

Good point.  In that case can we please get a strace with a -s
option that's big enough to capture the crypto data?

Comparing the working strace and the non-working one should be
sufficient to identify the problem.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
