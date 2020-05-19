Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB10C433E0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 18:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7A1D20674
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 18:11:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="jpBMnXcI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727911AbgESSLg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 14:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726510AbgESSLf (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 14:11:35 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772AAC08C5C0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 11:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589911893;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=BVJ986S46z5eMMgU9ShpvE8/hjf/iG5QeOVuCq4HVNM=;
        b=jpBMnXcIVdTzZg7oSXTuoS+rMVfcmU5JvaG/MxSq+q7aiCOhOn/3gJM1SMQ5uG3mQ/
        7lbVc96ZA7n+jdo3RFWEE8v7erJrmMkUkwPzxBvsw0HknqYMARWQdezl5BOZjmkPQBOq
        hzUMkdNRlCvB1TVAs4iQFLpc42xC2iAA7B1KmyOS2mb0IsDF3+x7HIuGDsAeZtUXtZSR
        mFdfqE/P8hUWX/9ELClQsLAzTSVxj6QBN/9DjrWuSE36CESCWOc0aKiGd7/GAJGtF0Ha
        ASfcNFo3/Npm4P6brkpNdhTIQb5fO/Ocd2NKuwG8tfOiadaHNbbfVd8CaqYBGji8QsYl
        2ZnA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4JIBX127
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 19 May 2020 20:11:33 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: ARM CE: CTS IV handling
Date:   Tue, 19 May 2020 20:11:33 +0200
Message-ID: <1997915.ptA6GT1cFu@tauon.chronox.de>
In-Reply-To: <CAMj1kXEiijbgq=P53+qKjEzuneiinDbwyBacpMWtcN2YwEKWKA@mail.gmail.com>
References: <4311723.JCXmkh6OgN@tauon.chronox.de> <CAMj1kXFfY+1LcJPGw7P8RPAN+Rts2ZJQwO6++WZSTFm3qbwaww@mail.gmail.com> <CAMj1kXEiijbgq=P53+qKjEzuneiinDbwyBacpMWtcN2YwEKWKA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 19. Mai 2020, 19:53:57 CEST schrieb Ard Biesheuvel:

Hi Ard,

> On Tue, 19 May 2020 at 19:50, Ard Biesheuvel <ardb@kernel.org> wrote:
> > On Tue, 19 May 2020 at 19:35, Stephan Mueller <smueller@chronox.de> wrote:
> > > Am Dienstag, 19. Mai 2020, 18:21:01 CEST schrieb Ard Biesheuvel:
> > > 
> > > Hi Ard,
> > > 
> > > > To be honest, this looks like the API is being used incorrectly. Is
> > > > this a similar issue to the one Herbert spotted recently with the CTR
> > > > code?
> > > > 
> > > > When you say 'leaving the TFM untouched' do you mean the skcipher
> > > > request? The TFM should not retain any per-request state in the first
> > > > place.
> > > > 
> > > > The skcipher request struct is not meant to retain any state either -
> > > > the API simply does not support incremental encryption if the input is
> > > > not a multiple of the chunksize.
> > > > 
> > > > Could you give some sample code on how you are using the API in this
> > > > case?
> > > 
> > > What I am doing technically is to allocate a new tfm and request at the
> > > beginning and then reuse the TFM and request. In that sense, I think I
> > > violate that constraint.
> > > 
> > > But in order to implement such repetition, I can surely clear / allocate
> > > a new TFM. But in order to get that right, I need the resulting IV
> > > after the cipher operation.
> > > 
> > > This IV that I get after the cipher operation completes is different
> > > between C and CE.
> > 
> > So is the expected output IV simply the last block of ciphertext that
> > was generated (as usual), but located before the truncated block in
> > the output?
> 
> If so, does the below fix the encrypt case?

I think it is.

But, allow me to take that patch to my test system for verification.
> 
> index cf618d8f6cec..22f190a44689 100644
> --- a/arch/arm64/crypto/aes-modes.S
> +++ b/arch/arm64/crypto/aes-modes.S
> @@ -275,6 +275,7 @@ AES_FUNC_START(aes_cbc_cts_encrypt)
>         add             x4, x0, x4
>         st1             {v0.16b}, [x4]                  /* overlapping
> stores */ st1             {v1.16b}, [x0]
> +       st1             {v1.16b}, [x5]
>         ret
>  AES_FUNC_END(aes_cbc_cts_encrypt)


Ciao
Stephan


