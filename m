From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: generic/cts - fix regression in iv handling
Date: Tue, 17 Jan 2017 17:37:29 +0800
Message-ID: <20170117093729.GA1830@gondor.apana.org.au>
References: <1484558195-14522-1-git-send-email-ard.biesheuvel@linaro.org>
 <20170117091152.GA31379@gondor.apana.org.au>
 <CAKv+Gu_8dkkMUpd5FoNqXoPM-1LQcALWYxZ5c-Er9xWBFmMJgQ@mail.gmail.com>
 <20170117092519.GB31379@gondor.apana.org.au>
 <CAKv+Gu-KdLk4XB_W8OHSJ5jHMXT0J70FUJN=Bjuq3yhOURzSxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45167 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751051AbdAQJhh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 17 Jan 2017 04:37:37 -0500
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-KdLk4XB_W8OHSJ5jHMXT0J70FUJN=Bjuq3yhOURzSxA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 17, 2017 at 09:30:30AM +0000, Ard Biesheuvel wrote:
>
> Got a link?

http://lkml.iu.edu/hypermail/linux/kernel/1506.2/00346.html

> OK, so that means chaining skcipher_set_crypt() calls, where req->iv
> is passed on between requests? Are there chaining modes beyond
> cts(cbc) encryption that rely on this?

I think algif_skcipher relies on this too.

> It is easily fixed in the chaining mode code, so I'm perfectly happy
> to fix it there instead, but I'd like to understand the requirements
> exactly before doing so

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
