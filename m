Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88C3FC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC02D206C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 17:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="CDv9RkUP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgESRf0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 13:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729001AbgESRf0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 13:35:26 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5304C08C5C0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 10:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1589909722;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=wmPnuRb8wgLctMH02vVbbie34eu8rrlWcgiQCxWFX7M=;
        b=CDv9RkUPD6+j1oJIQz9/5PVSQsYcOAc/NuDaDH1DgnL3eLyb54ezBJbjLH4GccsLGe
        9s8zFH0sPB891CTMzRcKk6wPOtLmUTOIx+wlXyS6g0abBf7Skne/6tetAY4ThwE1/zUl
        0+dBV32XUFMmh/F42J5qUHfWNmCoLZkbn8taB7ZI8XzmNObM44R68dEaxsHAx596WAiP
        CSKtHgxycKlYHkDG1ooK783TVhkOeNHkHpvygw8mhKricCb4OQNFhdLHXs3BTmJBanfb
        YywYPGE+DPzL4XZCvU0kfgLgEfQV9ZD1sGIm481DtizOiZ4ymzfNQN0dEtzPFaXaQz2D
        o26g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbI/Sc5g=="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.7.0 DYNA|AUTH)
        with ESMTPSA id k09005w4JHZM0wa
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 19 May 2020 19:35:22 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: ARM CE: CTS IV handling
Date:   Tue, 19 May 2020 19:35:22 +0200
Message-ID: <8691076.XE7dyB1q2z@tauon.chronox.de>
In-Reply-To: <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
References: <4311723.JCXmkh6OgN@tauon.chronox.de> <CAMj1kXHscmtLq=tA7zUgiNqZYgTFjfREL5EK6ZnoDCFp52GWGw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 19. Mai 2020, 18:21:01 CEST schrieb Ard Biesheuvel:

Hi Ard,

> 
> To be honest, this looks like the API is being used incorrectly. Is
> this a similar issue to the one Herbert spotted recently with the CTR
> code?
> 
> When you say 'leaving the TFM untouched' do you mean the skcipher
> request? The TFM should not retain any per-request state in the first
> place.
> 
> The skcipher request struct is not meant to retain any state either -
> the API simply does not support incremental encryption if the input is
> not a multiple of the chunksize.
> 
> Could you give some sample code on how you are using the API in this case?

What I am doing technically is to allocate a new tfm and request at the 
beginning and then reuse the TFM and request. In that sense, I think I violate 
that constraint.

But in order to implement such repetition, I can surely clear / allocate a new 
TFM. But in order to get that right, I need the resulting IV after the cipher 
operation.

This IV that I get after the cipher operation completes is different between C 
and CE.

Ciao
Stephan


