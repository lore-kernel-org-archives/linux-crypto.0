Return-Path: <SRS0=IUQn=NU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEA85C43441
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 09:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9B0820827
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Nov 2018 09:46:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=linaro.org header.i=@linaro.org header.b="iPKLFiw9"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9B0820827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbeKIT0O (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Nov 2018 14:26:14 -0500
Received: from mail-it1-f196.google.com ([209.85.166.196]:36887 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727560AbeKIT0N (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Nov 2018 14:26:13 -0500
Received: by mail-it1-f196.google.com with SMTP id j79-v6so2339289itb.2
        for <linux-crypto@vger.kernel.org>; Fri, 09 Nov 2018 01:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=/7wFQG10rMKnmRnMJ/i6/nhAPYbr707z2zNGwX7KZps=;
        b=iPKLFiw9kiNwhYztXJh2eKWU8lXKBY604LdXifTX6TkVuf/b6gJcoj9vrfHZzVt7Vj
         6BOuRtNkVleRGEnPpc637ofnbryfjgl/ZeHqUJByMQM/N87d86Vd3qF/7wrOyMCg1fo6
         YV+G1sazntEl16a0sKTRFXtsAaizQy7v+Rrzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=/7wFQG10rMKnmRnMJ/i6/nhAPYbr707z2zNGwX7KZps=;
        b=UOfIaeM3Wnz+69YtWbCoE5peWeocy5qCfFgNtnGB/UhxhFjxPJsw2oHJcyuVnXOC6Z
         TB6WuAi1mn7CIdiXH9+Ew6wo33NWo/DAutygriyQd3+YZogRRiObUZkrKiXdLiSfrssZ
         Bq0H3NOcV3mjjzOMce5U2LYg10jPw/tbtJq1gI++qXPCyuxF6XTt3UDfrsKW/shyI3mL
         IVjPRla7IIlrP5POGfmriBrTRYGs7U6mU/u6Eh38ihrHzPdoBmmzCXIa7g9p7YW1OSHj
         YG3+TtV9S9Z5qfarr1B/3F9dKyh6wLSPjgoQ1fKbrjtlgc7r9+oWLHX+R7STrU4Iv6bt
         /pDg==
X-Gm-Message-State: AGRZ1gJFkXQc378OGQQUJIRlq07cs4EFpDPiRA+CVzdDwjpI87/FZIlM
        itc05wThEg4450MyyLPAvhaoYZyU3qsfz/Qh/YDVYg==
X-Google-Smtp-Source: AJdET5c+ZW74Xhi+QEOpWil7qfyH0URy2aJDPB/ni5jmOcWSjJWU0LDTosvW9VuO8Wos8Tr22jIJKJc6WiViDvGR6ME=
X-Received: by 2002:a24:7d8d:: with SMTP id b135-v6mr1406823itc.121.1541756786449;
 Fri, 09 Nov 2018 01:46:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a6b:4f16:0:0:0:0:0 with HTTP; Fri, 9 Nov 2018 01:46:25 -0800 (PST)
In-Reply-To: <20181109094525.3shpcmj4uqxfx33z@gondor.apana.org.au>
References: <20181108225516.9967-1-ard.biesheuvel@linaro.org>
 <CAKv+Gu_7M+A5OiCOsOd7_e5+GH7VkrOZ33iSexd2oacyzUNKEA@mail.gmail.com>
 <20181109094447.v4fqirpmx7owayr7@gondor.apana.org.au> <20181109094525.3shpcmj4uqxfx33z@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 9 Nov 2018 10:46:25 +0100
Message-ID:
 <CAKv+Gu_iNsRCK31aGnb3F=y63WqKLXg=NskWkZ7VYGHEB0NRAg@mail.gmail.com>
Subject: Re: [PATCH] crypto/simd: correctly take reqsize of wrapped skcipher
 into account
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Qian Cai <cai@gmx.us>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181109094625.om8z14gyC6jyHluAESe_ThrdLOYHlqFUtTYsbDheHo8@z>

On 9 November 2018 at 10:45, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Fri, Nov 09, 2018 at 05:44:47PM +0800, Herbert Xu wrote:
>> On Fri, Nov 09, 2018 at 12:33:23AM +0100, Ard Biesheuvel wrote:
>> >
>> > This should be
>> >
>> > reqsize += max(crypto_skcipher_reqsize(&cryptd_tfm->base);
>> >        crypto_skcipher_reqsize(cryptd_skcipher_child(cryptd_tfm)));
>> >
>> > since the cryptd path in simd still needs some space in the subreq for
>> > the completion.
>>
>> OK this is what I applied to the cryptodev tree, please double-check
>> to see if I did anything silly:
>
> I meant the crypto tree rather than cryptodev.
>

That looks fine. Thanks Herbert.
