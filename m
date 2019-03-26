Return-Path: <SRS0=ouVC=R5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7B6FC43381
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 09:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B97E420830
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Mar 2019 09:51:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbfCZJvo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 26 Mar 2019 05:51:44 -0400
Received: from stretch.kos.to ([51.15.203.87]:56032 "EHLO pilvi.kos.to"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725776AbfCZJvo (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 26 Mar 2019 05:51:44 -0400
X-Greylist: delayed 338 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Mar 2019 05:51:43 EDT
Received: from 08efd375aeba (unknown [172.17.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pilvi.kos.to (Postfix) with ESMTPSA id B0AE62411D2;
        Tue, 26 Mar 2019 09:46:03 +0000 (UTC)
Received: (nullmailer pid 32707 invoked by uid 1000);
        Tue, 26 Mar 2019 09:46:03 -0000
Date:   Tue, 26 Mar 2019 09:46:03 +0000
From:   Riku Voipio <riku.voipio@iki.fi>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/17] Add zinc using existing algorithm implementations
Message-ID: <20190326094603.nyfi2dsnt6a6u57f@08efd375aeba>
References: <20190322062740.nrwfx2rvmt7lzotj@gondor.apana.org.au>
 <CAKv+Gu_mgyzqUCeb+wke--8Gn8YbjOb8jyrSgFr3-tcNP8ccEQ@mail.gmail.com>
 <CAHk-=wg2LJ5qQ0B2y+_6Ue62SBP4h9MLxLvn89bfcP7Cp2ac6A@mail.gmail.com>
 <AM5PR0901MB1155FD05113D6DC79A6274CED25E0@AM5PR0901MB1155.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM5PR0901MB1155FD05113D6DC79A6274CED25E0@AM5PR0901MB1155.eurprd09.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 25, 2019 at 09:10:08AM +0000, Pascal Van Leeuwen wrote:
> As someone who has been working on crypto acceleration hardware for the better
> part of the past 20 years, I feel compelled to respond to this, in defence of
> the crypto API (which we're really happy with ...).

Thanks for joining in.

> We have done plenty of measurements, on both power and performance, to prove
> you wrong there. Typically our HW needs *at least* a full order of a magnitude
> less power to do the actual work. The CPU load for handing the interrupts etc.
> tends to be around 20%. So assuming the CPU goes to sleep for the other 80%
> of the time,  the combined solution would need about 1/3rd of the power of a
> CPU only solution. It's one of our biggest selling points.

I actually have the kind of (relatively) low-power system with your crypto
accelerator IP. But it doesn't matter how great performance or energy saving
I would get from using crypto offloading. I will continue to use CPU only
solution for the foreseeable future.

Because of one tiny problem:

The firmware files for eip197(?) crypto accelerator are secrets we are not
allowed download anywhere from.

> Pascal van Leeuwen,
> Silicon IP Architect @ Inside Secure

Riku
