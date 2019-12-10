Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77FC0C2D0BF
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 10:08:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A2E52073D
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 10:08:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qrDZOxKZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbfLJKIE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 05:08:04 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38040 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbfLJKIE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 05:08:04 -0500
Received: by mail-wr1-f65.google.com with SMTP id y17so19322233wrh.5
        for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2019 02:08:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1rtt+jT7d6WO4Gbdn46NFId1N1JwyRLGAD+od7Mfwss=;
        b=qrDZOxKZuKEZf9PQD5L3fQrQwUaMjBGohV3YtvMcCVDBZqjlCSLICU4Xe6pA2mjAVX
         fmADt0pPBW15Oo1ReMazyeNVnwEDb1dGDtXZ33qIXAB2CbOAys9tOWEUmFYPggS9wnM/
         V2OdCGUFaJ1H1Z0s41oShYYG3vLfYH1vUDudsSzcIBTDdn1PxAOxV0jaAeKArMr5FA1O
         snFOo9PLfjEQ+jw6NEKzo70HdvH/yieYNHwdtFMx7SXfK4tlMxVbz7bvfcokP5Hc0jrI
         u6fOi05gCg3oFTtSrqw9Ah/vpKRciUVaGEjq/YEgxdW+yFGGF3cN+/LW8qMtzYJN8HRv
         mY/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1rtt+jT7d6WO4Gbdn46NFId1N1JwyRLGAD+od7Mfwss=;
        b=NJW2obFwTSyartIcO+ubjrkuVVTdIh/yZ0ykjeGMSsZDV4LCtw2uRW1C+4nP/jph8E
         QfBAf1An6bGt0vC16eT/8CiXsPppdfGyXjo4v/Sgt5ytYdBvVRHv2BKYG5mHMSJ2FAot
         LT977Yzs1RpMNIls5urZBEOcOKNIg+622i/B4qqMGaQuVUfPbgJNKR2F7BiuXaOdHedg
         Ze0ZrZAUMHIYfbL2TU41i2GCuD4HHengrC4ZNXg4tggUuRCTVnqv1AMP7xYAfRIwMwjH
         2amdYvulr7OqML1EfhQXzlt64aGJAh0Q8Jyas1VPiZAP4dWvSCn0/pc2tqqz4ix9ObNO
         L7Gg==
X-Gm-Message-State: APjAAAWgbjt3zyVMsWVqmxEYouEcoFNheO43rtK0nfYhS9KaMAWMsqN9
        HYATsvv072Eu/ArewjQ+7IdCXT8Da6QAeDi6dcKHjQ==
X-Google-Smtp-Source: APXvYqy7HmVclbZfGBHoB9cc6eW+c5QwGf5IIQW/pQHNZ1EaECXNtszYC0owo2VFpwkroWPnapNxzqYab57L8E3k94M=
X-Received: by 2002:a5d:5345:: with SMTP id t5mr2343807wrv.0.1575972482308;
 Tue, 10 Dec 2019 02:08:02 -0800 (PST)
MIME-Version: 1.0
References: <de5768f5-8c56-bec0-0c73-04aa4805c749@ti.com> <CAKv+Gu-XNFE+=griwBJCNooyoV7BR81hkqQ9jV3PDb-P6ghYxg@mail.gmail.com>
 <82a75666-3cb7-e33d-d873-1aad5581a13c@ti.com>
In-Reply-To: <82a75666-3cb7-e33d-d873-1aad5581a13c@ti.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 10 Dec 2019 11:07:51 +0100
Message-ID: <CAKv+Gu9H9wFbAZwA5Gt6TaqBVEQheryP+kG+y5FsmNmf8FE5_Q@mail.gmail.com>
Subject: Re: aes_expandkey giving wrong expanded keys over crypto_aes_expand_key(older
 deprecated implementation under aes_generic)
To:     Keerthy <j-keerthy@ti.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, "Kristo, Tero" <t-kristo@ti.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 10 Dec 2019 at 11:06, Keerthy <j-keerthy@ti.com> wrote:
>
>
>
> On 10/12/19 3:31 pm, Ard Biesheuvel wrote:
> > Hello Keerthy,
> >
> > On Tue, 10 Dec 2019 at 10:35, Keerthy <j-keerthy@ti.com> wrote:
> >>
> >> Hi Ard,
> >>
> >> I am not sure if am the first one to report this. It seems like
> >> aes_expandkey is giving me different expansion over what i get with the
> >> older crypto_aes_expand_key which was removed with the below commit:
> >>
> >> commit 5bb12d7825adf0e80b849a273834f3131a6cc4e1
> >> Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >> Date:   Tue Jul 2 21:41:33 2019 +0200
> >>
> >>     crypto: aes-generic - drop key expansion routine in favor of library
> >> version
> >>
> >> The key that is being expanded is from the crypto aes(cbc) testsuite:
> >>
> >>   }, { /* From NIST SP800-38A */
> >>                 .key    = "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
> >>                           "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
> >>                           "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
> >>                 .klen   = 24,
> >>
> >>
> >> The older version crypto_aes_expand_key output that passes the cbc(aes)
> >> decryption test:
...
> >>
> >> The difference is between 52nd index through 59.
> >>
> >> Any ideas if this is expected?
> >>
> >
> > Yes, this is expected. This particular test vector uses a 192 bit key,
> > so those values are DC/ignored.
>
> Thanks for the quick response. However with the new implementation
> decryption test case fails for me with wrong result.

Can you share more details please? Platform, endianness, etc ...
