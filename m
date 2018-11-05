Return-Path: <SRS0=IFNk=NQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24355C0044C
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 12:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D39A520819
	for <linux-crypto@archiver.kernel.org>; Mon,  5 Nov 2018 12:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="HDAFC3eC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D39A520819
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbeKEVed (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 5 Nov 2018 16:34:33 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:34073 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbeKEVed (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 5 Nov 2018 16:34:33 -0500
Received: by mail-io1-f66.google.com with SMTP id d80-v6so6324460iof.1
        for <linux-crypto@vger.kernel.org>; Mon, 05 Nov 2018 04:15:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Y1q5v58v/6Ck2XolErxmYzdO5X/qMLyw5rYY/tQh7Gs=;
        b=HDAFC3eCS3hE6oq/z8TEQfC5OFHR/+lDNCyVYoNLfjIoONYqrvpfidJiLZERRPUXB9
         w6557ROFXo8GLrAV3OaVxpbH/Re2gKTXWGZU1piDB3Cjn8FxnNB0zb7VDvDZEfFtj7yf
         a32XR+PRTNiXvqd0xKLKKwfTWTJLgXRJVdr70=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=Y1q5v58v/6Ck2XolErxmYzdO5X/qMLyw5rYY/tQh7Gs=;
        b=JAXd03MNEiUwcB50259ouZdhK+yTfYG5AHHIxSIMs2OgYliGBL2VMK5Mr5Z+AlYOzS
         ojqOOZlBYtQT3N/gy0moJbG9bnwY7vArq30hhHuXYNYtbklCJO3d/Rj6vOHnN2HcxnBl
         HCQuaOtZs6haGyudBuAgW5/Lq/sPdGgxKHoY404B1j0OyJ8LrnRe9nyCFkDarNvuFgqG
         sFIsV0zMAWi7tgJ0Tsl+2lBu00QEKu8nHwCQIAmtBiC3Cd+GAiza43aivyOhGJ2Emn/w
         a5lXiVudcLrDfrMChPFdSyzXQDTDMACNCfVLkiDCnzZlbW6Y//s9Ddz8veRqRlzknsnt
         yjXQ==
X-Gm-Message-State: AGRZ1gIPDAmur4ml6uY82IHQ8qj7Y7C1NHhMxE4MJ4RdUbivf9mm3On4
        J/ieTBWafB2UKid5E9hBcUG2YpjUUU5fUlp+YljVVQ==
X-Google-Smtp-Source: AJdET5ei82Y/UDnCjuvtV5Mc+gtreeV7ELfKWfWDZ1tRuQr2z1J8rqTvnsyYAIggajkCiE73SHcqN00blGh6dHdn90A=
X-Received: by 2002:a6b:5d18:: with SMTP id r24-v6mr16986228iob.170.1541420105082;
 Mon, 05 Nov 2018 04:15:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Mon, 5 Nov 2018 04:15:04 -0800 (PST)
In-Reply-To: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
References: <1541419502-7286-1-git-send-email-gilad@benyossef.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Mon, 5 Nov 2018 13:15:04 +0100
Message-ID:
 <CAKv+Gu8cmGbJVCe4HJ0Jsyh4bB=X0psk02cFkq9e20ev9C-Opg@mail.gmail.com>
Subject: Re: [PATCH] crypto: cts: document NIST standard status
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <Ofir.Drang@arm.com>,
        Yael Chemla <Yael.Chemla@arm.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181105121504.Q26PzvCfkaehXB65KCqlI8Mo87teRWFEFdzl-rjSwIQ@z>

On 5 November 2018 at 13:05, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> cts(cbc(aes)) as used in the kernel has been added to NIST
> standard as CBC-CS3. Document it as such.
>
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Suggested-by: Stephan Mueller <smueller@chronox.de>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  crypto/Kconfig | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index f7a235d..9176023 100644
> --- a/crypto/Kconfig
> +++ b/crypto/Kconfig
> @@ -430,11 +430,14 @@ config CRYPTO_CTS
>         help
>           CTS: Cipher Text Stealing
>           This is the Cipher Text Stealing mode as described by
> -         Section 8 of rfc2040 and referenced by rfc3962.
> -         (rfc3962 includes errata information in its Appendix A)
> +         Section 8 of rfc2040 and referenced by rfc3962
> +         (rfc3962 includes errata information in its Appendix A) or
> +         CBC-CS3 as defined by NIST in Sp800-38A addendum from Oct 2010.
>           This mode is required for Kerberos gss mechanism support
>           for AES encryption.
>
> +         See: https://csrc.nist.gov/publications/detail/sp/800-38a/addendum/final
> +
>  config CRYPTO_ECB
>         tristate "ECB support"
>         select CRYPTO_BLKCIPHER
> --
> 2.7.4
>
