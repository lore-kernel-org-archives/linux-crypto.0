Return-Path: <SRS0=vxh5=N7=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34424 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbeKTQOV (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 20 Nov 2018 11:14:21 -0500
Received: by mail-wr1-f65.google.com with SMTP id j2so593528wrw.1
        for <linux-crypto@vger.kernel.org>; Mon, 19 Nov 2018 21:47:02 -0800 (PST)
Date: Tue, 20 Nov 2018 06:46:59 +0100
From: LABBE Corentin <clabbe@baylibre.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Biggers <ebiggers@kernel.org>, nhorman@tuxdriver.com,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/11] crypto: move crypto_alg_get/crypto_alg_put to
 linux/crypto.h
Message-ID: <20181120054659.GA12679@Red>
References: <1542657210-37739-1-git-send-email-clabbe@baylibre.com>
 <1542657210-37739-2-git-send-email-clabbe@baylibre.com>
 <CAKv+Gu80ArVHwBOmD3qjKUEP=LsbOEfZrCyO-rPDtpX3AbykoA@mail.gmail.com>
 <20181120031047.diqgmbluclbbkhav@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120031047.diqgmbluclbbkhav@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Nov 20, 2018 at 11:10:47AM +0800, Herbert Xu wrote:
> On Mon, Nov 19, 2018 at 12:25:10PM -0800, Ard Biesheuvel wrote:
> > On Mon, 19 Nov 2018 at 11:53, Corentin Labbe <clabbe@baylibre.com> wrote:
> > >
> > > Since we will need crypto_alg_get/crypto_alg_put for "locking"
> > > crypto_alg when updating stats, we need it to be via linux/crypto.h
> > >
> > 
> > This seems backwards to me. Surely, crypto stats are permitted to use
> > the internal crypto API?
> 
> I agree.
> 

I dont understand what is backwards ? moving or using ?
What do you suggest for "locking" crypto_alg ?

Regards
