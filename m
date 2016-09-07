From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] hwrng: core - Allocate memory during module init
Date: Wed, 7 Sep 2016 21:16:56 +0800
Message-ID: <20160907131656.GD17176@gondor.apana.org.au>
References: <1472977778-23996-1-git-send-email-prasannatsmkumar@gmail.com>
 <20160907125350.GB17176@gondor.apana.org.au>
 <CANc+2y6ywn-9E0Cv5io6=ZWRFW8Q+GTnubFH31p0y1-WQsGbYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: mpm@selenic.com, jslaby@suse.cz, peter@korsgaard.com,
        Lee Jones <lee.jones@linaro.org>, linux-crypto@vger.kernel.org
To: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35763 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757409AbcIGNRT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 7 Sep 2016 09:17:19 -0400
Content-Disposition: inline
In-Reply-To: <CANc+2y6ywn-9E0Cv5io6=ZWRFW8Q+GTnubFH31p0y1-WQsGbYQ@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Sep 07, 2016 at 06:44:32PM +0530, PrasannaKumar Muralidharan wrote:
>
> Ah, yes! I can send a revised patch.
> Do you think allocating rng_buffer, rng_fillbuf in module init useful?
> If not there is no point in sending a new patch with fix.

Yes I think it makes sense.  Those who want to save a few bytes
by keeping the RNGs as modules can always build core HWRNG as a
module too.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
