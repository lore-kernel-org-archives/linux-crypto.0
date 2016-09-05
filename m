From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/2] crypto: arm/ghash-ce - add missing async
 import/export
Date: Mon, 5 Sep 2016 17:41:09 +0800
Message-ID: <20160905094109.GA30927@gondor.apana.org.au>
References: <1472469594-27315-1-git-send-email-ard.biesheuvel@linaro.org>
 <20160831144135.GB26616@gondor.apana.org.au>
 <CAKv+Gu8tr3kq9gYpJjNeKvt-PDsnBUb1FZqxOeNBfuF+J6hCzA@mail.gmail.com>
 <CAKv+Gu8yEDbQS651Q3-GbQw+AwJfqvH1WHKa-LUE4=43NwyWSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:48872 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932413AbcIEJlP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Sep 2016 05:41:15 -0400
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8yEDbQS651Q3-GbQw+AwJfqvH1WHKa-LUE4=43NwyWSw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Sep 01, 2016 at 04:14:22PM +0100, Ard Biesheuvel wrote:
>
> The culprit appears to be that the .cra_name of the internal shash is
> "ghash", (and not "__ghash" like in the x86 case) which causes the
> test code to run the test on not only the public ahash, but also on
> the internal cryptd() encapsulated shash, and also on the internal
> shash itself.

Hmm that's not good.  The test code is not meant to process these
internal algorithms.  I recently added a check to automatically
filter out internal algorithms when testing.  But we should still
change its name to __ghash just to avoid confusion.

> However, that does not answer the question whether .init() must be
> called before .import() [which the test code does not do]. If not,
> then please disregard my v2, and I will followup with a patch that
> renames ghash to __ghash (but .import() will still require the .init()
> bits as well). Given that these internal shashes/ahashes are in fact
> callable, and calling .import() will result in a crash, I suppose
> duplicating some of the init() code in .import() makes sense
> regardless.

Right.  This is definitely a bug and I will take your patches.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
