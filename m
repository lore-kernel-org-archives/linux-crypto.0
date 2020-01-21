Return-Path: <SRS0=kzJ7=3K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F205CC3F68F
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 12:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74FE22314
	for <linux-crypto@archiver.kernel.org>; Tue, 21 Jan 2020 12:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="vfQgaOaL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbgAUMDb (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 21 Jan 2020 07:03:31 -0500
Received: from mail-vs1-f68.google.com ([209.85.217.68]:43243 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729009AbgAUMDb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Jan 2020 07:03:31 -0500
Received: by mail-vs1-f68.google.com with SMTP id s16so1540108vsc.10
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jan 2020 04:03:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=zFf4dMyDozEW3IOrzotkvaUe/JQt5lueh29UH6I3hws=;
        b=vfQgaOaLZtpo33lDwt40fN1I3RHm4sLamOHLsoay0xylpktnfLHDGxkj5O+J342auS
         NNnN+/sERomOnu5HQ6Y3CMDGtHWIZY+R9XnT6X63JtHZ784bTBkoqK7nLU0PwRJWmAIz
         iSOYYssI/R5vhmyCzMhelFVjqMab9lNcxMSQT2phofYoueo3ue2rU9cPB9qqi9Z5/tpi
         GXdTqQwnxVAKIacXLuBA8q1/5jTXDx3Y7PhgbV+++uVqR4+c3Vhi4isvRefL+v4bf9Mc
         H+I2FL31af3mb6ezQGXEgxeHNSI9ckP7qo8nMI+DjN9ri9+LdfMje+nb4DNQZPJPCkZz
         7NKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=zFf4dMyDozEW3IOrzotkvaUe/JQt5lueh29UH6I3hws=;
        b=kWJWv0dH1oEpyE6ZXgoSPPJLjeyDhlwDs9GmwDpk0xdUqxNy2hqmbpv2j7yq2agYjR
         epGM2Jg+GnhR+/btS5ftlw0mSUSuDE9hrXBBg+ft1ZB0k4vJplnjP7vRAcKsTp9hJgBL
         jIN7MR5Pfu+NDCGsIhLcEg0AjjnSwH+Xqtz0GnVxLXKlBhLh7oLNnz5DEaP2atMCuBIu
         v99MxozZ7CtEm/4kSTivDVdU3DgFP46grfGxqDxyUWn5AoPWVjhJoO9EDdgx1ZT//JTD
         lki9WaUO49fBvB4z4TNgNhaTWxzg/J5HmM3+kNnrPCfelMh1spUwOeMhqBFU2igFbXUD
         Dh9w==
X-Gm-Message-State: APjAAAWGOrNBxhdzLXofAjEuSBtIQOVUdiDE+azrNpHK1lTN9+pD/QyK
        aBjK/xoRPZ9vLzjU7fEyfUbI28dvoTv6wkJpXGGozXB8rYMnKw==
X-Google-Smtp-Source: APXvYqwNpegnjdQXWB57I9+MexzU6SpifsJySjzeGDMhcylmgvPG2z9xw60aRjIViHzYT1LNqFAhv2P6stEMRo7zERI=
X-Received: by 2002:a67:6746:: with SMTP id b67mr2173195vsc.193.1579608210362;
 Tue, 21 Jan 2020 04:03:30 -0800 (PST)
MIME-Version: 1.0
References: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
 <9fd07805-8e2e-8c3f-6e5e-026ad2102c5a@chelsio.com> <c8d64068-a87b-36dd-910d-fb98e09c7e4b@asicdesigners.com>
 <20200117062300.qfngm2degxvjskkt@gondor.apana.org.au> <20d97886-e442-ed47-5685-ff5cd9fcbf1c@asicdesigners.com>
 <20200117070431.GE23018@gauss3.secunet.de> <318fd818-0135-8387-6695-6f9ba2a6f28e@asicdesigners.com>
 <20200117121722.GG26283@gauss3.secunet.de> <179f6f7e-f361-798b-a1c6-30926d8e8bf5@asicdesigners.com>
 <20200120093712.GM23018@gauss3.secunet.de> <b0b4ba4b-1cdd-ad0b-32e4-2bc9610ff3e1@asicdesigners.com>
In-Reply-To: <b0b4ba4b-1cdd-ad0b-32e4-2bc9610ff3e1@asicdesigners.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 21 Jan 2020 14:03:16 +0200
Message-ID: <CAOtvUMdfxx=-XQMv=aFFjzSnLCL3b5UuvVOMzJVc2odSCZGtXg@mail.gmail.com>
Subject: Re: Advertise maximum number of sg supported by driver in single request
To:     Ayush Sawal <ayush.sawal@asicdesigners.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        manojmalviya@chelsio.com, Ayush Sawal <ayush.sawal@chelsio.com>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 20, 2020 at 2:35 PM Ayush Sawal
<ayush.sawal@asicdesigners.com> wrote:

> As we have a crypto accelarator as device when the request is send to
> the crypto driver from esp_output ,
> the aead_request has all the fragments in its src sg and the problem
> which we are facing is when this
> src sg nents becomes greater than 15 ,15 is our crypto driver's max sg
> limit to handle the request in one shot.
>
> Does it make sense for a crypto driver to advertise the maximum amount
> of sg it can handle for a single
> request and then handling this in crypto framework while forming the
> crypto request?
>

As I maintain the driver of another crypto accelerator I sympathize
with the need but I question the proposed solution.
Consider: your specific driver is limited by the number of
scattergather entries. Another implementation might be limited
by something else such as the total overall size of the request buffer
and probably half a dozen other considerations.
Should we now be passing all this capability information to the crypto
API core? and what happens if a new driver
has a limitation in a different quality?

So no, the solution to advertise the specific capability limitation of
each implementation does not seem to be a good one.
We already have a solution to the problem - initiate a fallback TFM
request and use it if you cannot fulfill the request on your own.

I do agree however that having each implementation registering and
keeping their own fallback tfm request just for these cases has some
overhead and a redundancy.

Maybe a better solution would be to allow implementation to return to
the Crypto API core a special return value (maybe -EAGAIN?) that tells
it that although the request is a valid one, this specific
implementation cannot fulfil it and let the crypto API core do the
fallback?

It sounds like it can be simpler to the implementation providers AND
save some redundant code...

--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
