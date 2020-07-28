Return-Path: <SRS0=t+Y3=BH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59802C433F1
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 11:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28B3E206F5
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jul 2020 11:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595937578;
	bh=n9yve1nnu2Jqk6bebpXwS0vu2kbEgkdgNYApdDOHBw8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=ecEpFOSRkXP9U/EjitLbevN9cq60uG3Phd6lIviKHMMmfrswpCViTpa5zE0FOirYh
	 tkH8DHHtw5RwWAGRvDbZB5FSlvEgnySKTfAci0u3YTthdYjx7eSwz1pRTAreb8z0I8
	 Z3V9yOrEB2eAOEOxFWpeUTJv/yguyFxBLEFAxBnE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgG1L7h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 28 Jul 2020 07:59:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbgG1L7h (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Jul 2020 07:59:37 -0400
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A78512070A
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 11:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595937576;
        bh=n9yve1nnu2Jqk6bebpXwS0vu2kbEgkdgNYApdDOHBw8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=rrJSg+6xQ3CdLvNnbwfIfONfJ9Vk3UsBA2CHgexE4Eg1ByKNz/5uM21sddRWZcHCT
         qYVQjJVm3cd8H/BT4g0lH/v8lHZ2OUMQhhZSVKXhJmCxk69CRx7Cp/XvHdgjwdUtoY
         hTYc12knzxUm8OwdUOtcV5eP4gzVZ45UQXjLhAaQ=
Received: by mail-oi1-f178.google.com with SMTP id q4so5470979oia.1
        for <linux-crypto@vger.kernel.org>; Tue, 28 Jul 2020 04:59:36 -0700 (PDT)
X-Gm-Message-State: AOAM532EQANGAgO4rrGyhIVOu7YNtOjO2R4ig3X3XJUi81kIRisz8VwO
        +uPgjo4NErMumfMzXCSL7cR/C5F02eiUt8gJxrQ=
X-Google-Smtp-Source: ABdhPJw3EGaWZOwCzZODnPBzD/nvbxENeio43ftCX0JGNbnt2uYm/dm4LFkipfsxZelCxe4tI+biL/OMozMKOhV3ABs=
X-Received: by 2002:aca:afd0:: with SMTP id y199mr331321oie.47.1595937576072;
 Tue, 28 Jul 2020 04:59:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200728071746.GA22352@gondor.apana.org.au> <E1k0Jsq-0006I8-1l@fornost.hmeau.com>
 <CAMj1kXHoKQhMjHxsGk55xEu+FF87Bu2CGqFWPcp-G6RLUFFAHg@mail.gmail.com> <20200728115351.GA30933@gondor.apana.org.au>
In-Reply-To: <20200728115351.GA30933@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 28 Jul 2020 14:59:24 +0300
X-Gmail-Original-Message-ID: <CAMj1kXGuOiWmctpCak0beMONGAjbW=QG8tLMi+=9pTxbgX0nWQ@mail.gmail.com>
Message-ID: <CAMj1kXGuOiWmctpCak0beMONGAjbW=QG8tLMi+=9pTxbgX0nWQ@mail.gmail.com>
Subject: Re: [v3 PATCH 3/31] crypto: cts - Add support for chaining
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Stephan Mueller <smueller@chronox.de>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 28 Jul 2020 at 14:53, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Tue, Jul 28, 2020 at 02:05:58PM +0300, Ard Biesheuvel wrote:
> >
> > But isn't the final chunksize a function of cryptlen? What happens if
> > i try to use cts(cbc(aes)) to encrypt 16 bytes with the MORE flag, and
> > <16 additional bytes as the final chunk?
>
> The final chunksize is an attribute that the caller has to act on.
> So for cts it tells the caller that it must withhold at least two
> blocks (32 bytes) of data unless it is the final chunk.
>
> Of course the implementation should not crash when given malformed
> input like the ones you suggested but the content of the output will
> be undefined.
>

How is it malformed? Between 16 and 31 bytes of input is perfectly
valid for cts(cbc(aes)), and splitting it up after the first chunk
should be as well, no?
