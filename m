Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2395CC43441
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 05:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF29E20685
	for <linux-crypto@archiver.kernel.org>; Tue, 20 Nov 2018 05:48:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF29E20685
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gondor.apana.org.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731740AbeKTQP7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 20 Nov 2018 11:15:59 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:45340 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731701AbeKTQP7 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 11:15:59 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gOytk-00005T-R9; Tue, 20 Nov 2018 13:48:32 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gOyti-0005HF-GC; Tue, 20 Nov 2018 13:48:30 +0800
Date:   Tue, 20 Nov 2018 13:48:30 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] crypto: move crypto_alg_get/crypto_alg_put to
 linux/crypto.h
Message-ID: <20181120054830.rfgoaz37iogqk3sg@gondor.apana.org.au>
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
 <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
 <CAKv+Gu80ArVHwBOmD3qjKUEP=LsbOEfZrCyO-rPDtpX3AbykoA@mail.gmail.com>
 <20181120031047.diqgmbluclbbkhav@gondor.apana.org.au>
 <20181120054659.GA12679@Red>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <20181120054659.GA12679@Red>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181120054830.aru953ms4GXGze6l1kvBUcr53ajYXtfZxKo5Cbi8myw@z>

On Tue, Nov 20, 2018 at 06:46:59AM +0100, LABBE Corentin wrote:
> On Tue, Nov 20, 2018 at 11:10:47AM +0800, Herbert Xu wrote:
> > On Mon, Nov 19, 2018 at 12:25:10PM -0800, Ard Biesheuvel wrote:
> > > On Mon, 19 Nov 2018 at 11:53, Corentin Labbe <clabbe@baylibre.com> wrote:
> > > >
> > > > Since we will need crypto_alg_get/crypto_alg_put for "locking"
> > > > crypto_alg when updating stats, we need it to be via linux/crypto.h
> > > >
> > > 
> > > This seems backwards to me. Surely, crypto stats are permitted to use
> > > the internal crypto API?
> > 
> > I agree.
> > 
> 
> I dont understand what is backwards ? moving or using ?
> What do you suggest for "locking" crypto_alg ?

You should include "crypto/internal.h" directly in your code rather
than exporting these functions for wider usage outside of the API
code.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
