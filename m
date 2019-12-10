Return-Path: <SRS0=Ct60=2A=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E711C43603
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 10:01:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC0282073B
	for <linux-crypto@archiver.kernel.org>; Tue, 10 Dec 2019 10:01:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D4kfa6Op"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfLJKBT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 10 Dec 2019 05:01:19 -0500
Received: from mail-wr1-f49.google.com ([209.85.221.49]:42459 "EHLO
        mail-wr1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbfLJKBT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 10 Dec 2019 05:01:19 -0500
Received: by mail-wr1-f49.google.com with SMTP id a15so19251447wrf.9
        for <linux-crypto@vger.kernel.org>; Tue, 10 Dec 2019 02:01:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9gpuoldRRTzfjfPSLzMshkCJClSvAId4UMeobPeoJCQ=;
        b=D4kfa6OptMraTDJsDVaghtwYH3knsmO5Mx5HyJoIdltPg9pagnDZ7eMKhaRWMT+Dus
         ZWj/HHgVoalLs4a8ZNTAcitV/zh9MD5x5fJMXLDQJu6040Ptln8VvNBMh/rvlnjIzpMz
         1FiVcBIsTjPE83IvbAXY+HMIwBVldfRy0N879vLvQU09agKR2tOv0KI1g7Anx+OkTQXh
         x88pgMRMNn4ES6kX8VW7omWINfLCjNOKi+5ACXV3qzvjhmx04BrWQALpR/7vl1tGlQHh
         gLLodDaeHcvY4M96O9y8ZgWr6V/S+m71+oCweupg+o1ygJvW3Eq1qGZewfIpCnryOccf
         g4xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9gpuoldRRTzfjfPSLzMshkCJClSvAId4UMeobPeoJCQ=;
        b=t6i6pKgbbkowLot00ydDQeymfmvsiEkoNnknUaimpZAbSMgW5sAdQ/z1u1i1sjdIMn
         N2L1nCoJK/FGA4CuEuTNo/LPqXep4S+pS6uqa3SE2CCPbkYVqgnkTwo45l+BGLZ1aTrz
         jEf43hzkbXSkOYkRTLyYANTOeGrBSZrS1J0hToIh9TQsRm+duOEzhSDN44X+p3djUYhW
         95Pk1GaJx12a7pY+gDO4IdR4lMt1jX/06LJglcOCDb8wP9Jly7wjnHUceucTAo7wwqEP
         IXt2yg8vfBr0BjFyyKYPpyklRay+0BGGoYnM4OCBxGeUVka8oYwlvE4TAGBxSH+Wx+UK
         3sWw==
X-Gm-Message-State: APjAAAWjJ98+a2QWLsAxRccZqMkNDkiW6Wz+OoqUff21KOrbngy/WlOq
        gnw6kGBtBExx/b2bvrFoDGBegZm6MXOi2daQpbeHKFJI8TA=
X-Google-Smtp-Source: APXvYqx/SH0fGMfEHvatO4Z9HmBxBwy05HKYHUbGJ7qxqomE6oy6XnFbVdyBvXcs9kSrmPrbHQmkznd5jUUZyqWDHFk=
X-Received: by 2002:a5d:6652:: with SMTP id f18mr675480wrw.246.1575972075897;
 Tue, 10 Dec 2019 02:01:15 -0800 (PST)
MIME-Version: 1.0
References: <de5768f5-8c56-bec0-0c73-04aa4805c749@ti.com>
In-Reply-To: <de5768f5-8c56-bec0-0c73-04aa4805c749@ti.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 10 Dec 2019 11:01:04 +0100
Message-ID: <CAKv+Gu-XNFE+=griwBJCNooyoV7BR81hkqQ9jV3PDb-P6ghYxg@mail.gmail.com>
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

Hello Keerthy,

On Tue, 10 Dec 2019 at 10:35, Keerthy <j-keerthy@ti.com> wrote:
>
> Hi Ard,
>
> I am not sure if am the first one to report this. It seems like
> aes_expandkey is giving me different expansion over what i get with the
> older crypto_aes_expand_key which was removed with the below commit:
>
> commit 5bb12d7825adf0e80b849a273834f3131a6cc4e1
> Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Date:   Tue Jul 2 21:41:33 2019 +0200
>
>     crypto: aes-generic - drop key expansion routine in favor of library
> version
>
> The key that is being expanded is from the crypto aes(cbc) testsuite:
>
>   }, { /* From NIST SP800-38A */
>                 .key    = "\x8e\x73\xb0\xf7\xda\x0e\x64\x52"
>                           "\xc8\x10\xf3\x2b\x80\x90\x79\xe5"
>                           "\x62\xf8\xea\xd2\x52\x2c\x6b\x7b",
>                 .klen   = 24,
>
>
> The older version crypto_aes_expand_key output that passes the cbc(aes)
> decryption test:
>
> ctx.key_dec[0] = 0x6fa08be9 & ctx.key_enc[0] = 0xf7b0738e
> ctx.key_dec[1] = 0x3c778c44 & ctx.key_enc[1] = 0x52640eda
> ctx.key_dec[2] = 0x472cc8e & ctx.key_enc[2] = 0x2bf310c8
> ctx.key_dec[3] = 0x2220001 & ctx.key_enc[3] = 0xe5799080
> ctx.key_dec[4] = 0x441649ac & ctx.key_enc[4] = 0xd2eaf862
> ctx.key_dec[5] = 0xb71057e5 & ctx.key_enc[5] = 0x7b6b2c52
> ctx.key_dec[6] = 0x758ac046 & ctx.key_enc[6] = 0xf7910cfe
> ctx.key_dec[7] = 0xad2c9bc8 & ctx.key_enc[7] = 0xa5f50224
> ctx.key_dec[8] = 0xc29a97a3 & ctx.key_enc[8] = 0x8e0612ec
> ctx.key_dec[9] = 0xd8a65b8e & ctx.key_enc[9] = 0x6b7f826c
> ctx.key_dec[10] = 0xe6c92ce1 & ctx.key_enc[10] = 0xb9957a0e
> ctx.key_dec[11] = 0xba72b254 & ctx.key_enc[11] = 0xc2fe565c
> ctx.key_dec[12] = 0x5822b4f3 & ctx.key_enc[12] = 0xbdb4b74d
> ctx.key_dec[13] = 0x5cbb9eb5 & ctx.key_enc[13] = 0x1841b569
> ctx.key_dec[14] = 0xfe64fbf8 & ctx.key_enc[14] = 0x9647a785
> ctx.key_dec[15] = 0xf3061e49 & ctx.key_enc[15] = 0xfd3825e9
> ctx.key_dec[16] = 0xa2df654d & ctx.key_enc[16] = 0x44ad5fe7
> ctx.key_dec[17] = 0xd62e5b1 & ctx.key_enc[17] = 0x865309bb
> ctx.key_dec[18] = 0x319c89ea & ctx.key_enc[18] = 0x57f05a48
> ctx.key_dec[19] = 0x1a3ccc2d & ctx.key_enc[19] = 0x4fb1ef21
> ctx.key_dec[20] = 0x3cfe6c5b & ctx.key_enc[20] = 0xd9f648a4
> ctx.key_dec[21] = 0x2ba045c7 & ctx.key_enc[21] = 0x24ce6d4d
> ctx.key_dec[22] = 0x72a5b9f8 & ctx.key_enc[22] = 0x606332aa
> ctx.key_dec[23] = 0x4992a46 & ctx.key_enc[23] = 0xe6303b11
> ctx.key_dec[24] = 0xf8b7ddc5 & ctx.key_enc[24] = 0xd57e5ea2
> ctx.key_dec[25] = 0x763c93be & ctx.key_enc[25] = 0x9acfb183
> ctx.key_dec[26] = 0xa6464f0b & ctx.key_enc[26] = 0x4339f927
> ctx.key_dec[27] = 0xafbd80fc & ctx.key_enc[27] = 0x67f7946a
> ctx.key_dec[28] = 0xd07adcb5 & ctx.key_enc[28] = 0x794a6c0
> ctx.key_dec[29] = 0x9fbcff7 & ctx.key_enc[29] = 0xe1a49dd1
> ctx.key_dec[30] = 0x9343eca7 & ctx.key_enc[30] = 0xeb8617ec
> ctx.key_dec[31] = 0x175e299c & ctx.key_enc[31] = 0x7149a66f
> ctx.key_dec[32] = 0x9ab82350 & ctx.key_enc[32] = 0x32705f48
> ctx.key_dec[33] = 0x841dc53b & ctx.key_enc[33] = 0x5587cb22
> ctx.key_dec[34] = 0x37194bd0 & ctx.key_enc[34] = 0x52136de2
> ctx.key_dec[35] = 0x8e8b4e7b & ctx.key_enc[35] = 0xb3b7f033
> ctx.key_dec[36] = 0x4445b341 & ctx.key_enc[36] = 0x28ebbe40
> ctx.key_dec[37] = 0xb99205ab & ctx.key_enc[37] = 0x59a2182f
> ctx.key_dec[38] = 0x5ef192ce & ctx.key_enc[38] = 0x6bd24767
> ctx.key_dec[39] = 0xd9811342 & ctx.key_enc[39] = 0x3e558c45
> ctx.key_dec[40] = 0xe7639765 & ctx.key_enc[40] = 0x6c46e1a7
> ctx.key_dec[41] = 0x8770818c & ctx.key_enc[41] = 0xdff11194
> ctx.key_dec[42] = 0x43393012 & ctx.key_enc[42] = 0xa751f82
> ctx.key_dec[43] = 0x1ea5e66b & ctx.key_enc[43] = 0x53d707ad
> ctx.key_dec[44] = 0xc449b19e & ctx.key_enc[44] = 0x380540ca
> ctx.key_dec[45] = 0x5d9cd679 & ctx.key_enc[45] = 0x650cc8f
> ctx.key_dec[46] = 0x7ca2b4fe & ctx.key_enc[46] = 0x6a162d28
> ctx.key_dec[47] = 0xfdd7b6ea & ctx.key_enc[47] = 0xb5e73cbc
> ctx.key_dec[48] = 0xf7b0738e & ctx.key_enc[48] = 0x6fa08be9
> ctx.key_dec[49] = 0x52640eda & ctx.key_enc[49] = 0x3c778c44
> ctx.key_dec[50] = 0x2bf310c8 & ctx.key_enc[50] = 0x472cc8e
> ctx.key_dec[51] = 0xe5799080 & ctx.key_enc[51] = 0x2220001
> ctx.key_dec[52] = 0x105127e8 & ctx.key_enc[52] = 0x68342d29
> ctx.key_dec[53] = 0xffff8000 & ctx.key_enc[53] = 0xddd31195
> ctx.key_dec[54] = 0xffffffd0 & ctx.key_enc[54] = 0x109bb3b8
> ctx.key_dec[55] = 0x0 & ctx.key_enc[55] = 0xffff8000
> ctx.key_dec[56] = 0x11053870 & ctx.key_enc[56] = 0x13caf9f5
> ctx.key_dec[57] = 0xffff8000 & ctx.key_enc[57] = 0xffff8000
> ctx.key_dec[58] = 0x5f5e0ff & ctx.key_enc[58] = 0x93caf9e7
> ctx.key_dec[59] = 0x0 & ctx.key_enc[59] = 0xffff8000
>
> Newer aes_expandkey is failing the decryption test and the expansion:
>
> ctx.key_dec[0] = 0x6fa08be9 & ctx.key_enc[0] = 0xf7b0738e
> ctx.key_dec[1] = 0x3c778c44 & ctx.key_enc[1] = 0x52640eda
> ctx.key_dec[2] = 0x472cc8e & ctx.key_enc[2] = 0x2bf310c8
> ctx.key_dec[3] = 0x2220001 & ctx.key_enc[3] = 0xe5799080
> ctx.key_dec[4] = 0x441649ac & ctx.key_enc[4] = 0xd2eaf862
> ctx.key_dec[5] = 0xb71057e5 & ctx.key_enc[5] = 0x7b6b2c52
> ctx.key_dec[6] = 0x758ac046 & ctx.key_enc[6] = 0xf7910cfe
> ctx.key_dec[7] = 0xad2c9bc8 & ctx.key_enc[7] = 0xa5f50224
> ctx.key_dec[8] = 0xc29a97a3 & ctx.key_enc[8] = 0x8e0612ec
> ctx.key_dec[9] = 0xd8a65b8e & ctx.key_enc[9] = 0x6b7f826c
> ctx.key_dec[10] = 0xe6c92ce1 & ctx.key_enc[10] = 0xb9957a0e
> ctx.key_dec[11] = 0xba72b254 & ctx.key_enc[11] = 0xc2fe565c
> ctx.key_dec[12] = 0x5822b4f3 & ctx.key_enc[12] = 0xbdb4b74d
> ctx.key_dec[13] = 0x5cbb9eb5 & ctx.key_enc[13] = 0x1841b569
> ctx.key_dec[14] = 0xfe64fbf8 & ctx.key_enc[14] = 0x9647a785
> ctx.key_dec[15] = 0xf3061e49 & ctx.key_enc[15] = 0xfd3825e9
> ctx.key_dec[16] = 0xa2df654d & ctx.key_enc[16] = 0x44ad5fe7
> ctx.key_dec[17] = 0xd62e5b1 & ctx.key_enc[17] = 0x865309bb
> ctx.key_dec[18] = 0x319c89ea & ctx.key_enc[18] = 0x57f05a48
> ctx.key_dec[19] = 0x1a3ccc2d & ctx.key_enc[19] = 0x4fb1ef21
> ctx.key_dec[20] = 0x3cfe6c5b & ctx.key_enc[20] = 0xd9f648a4
> ctx.key_dec[21] = 0x2ba045c7 & ctx.key_enc[21] = 0x24ce6d4d
> ctx.key_dec[22] = 0x72a5b9f8 & ctx.key_enc[22] = 0x606332aa
> ctx.key_dec[23] = 0x4992a46 & ctx.key_enc[23] = 0xe6303b11
> ctx.key_dec[24] = 0xf8b7ddc5 & ctx.key_enc[24] = 0xd57e5ea2
> ctx.key_dec[25] = 0x763c93be & ctx.key_enc[25] = 0x9acfb183
> ctx.key_dec[26] = 0xa6464f0b & ctx.key_enc[26] = 0x4339f927
> ctx.key_dec[27] = 0xafbd80fc & ctx.key_enc[27] = 0x67f7946a
> ctx.key_dec[28] = 0xd07adcb5 & ctx.key_enc[28] = 0x794a6c0
> ctx.key_dec[29] = 0x9fbcff7 & ctx.key_enc[29] = 0xe1a49dd1
> ctx.key_dec[30] = 0x9343eca7 & ctx.key_enc[30] = 0xeb8617ec
> ctx.key_dec[31] = 0x175e299c & ctx.key_enc[31] = 0x7149a66f
> ctx.key_dec[32] = 0x9ab82350 & ctx.key_enc[32] = 0x32705f48
> ctx.key_dec[33] = 0x841dc53b & ctx.key_enc[33] = 0x5587cb22
> ctx.key_dec[34] = 0x37194bd0 & ctx.key_enc[34] = 0x52136de2
> ctx.key_dec[35] = 0x8e8b4e7b & ctx.key_enc[35] = 0xb3b7f033
> ctx.key_dec[36] = 0x4445b341 & ctx.key_enc[36] = 0x28ebbe40
> ctx.key_dec[37] = 0xb99205ab & ctx.key_enc[37] = 0x59a2182f
> ctx.key_dec[38] = 0x5ef192ce & ctx.key_enc[38] = 0x6bd24767
> ctx.key_dec[39] = 0xd9811342 & ctx.key_enc[39] = 0x3e558c45
> ctx.key_dec[40] = 0xe7639765 & ctx.key_enc[40] = 0x6c46e1a7
> ctx.key_dec[41] = 0x8770818c & ctx.key_enc[41] = 0xdff11194
> ctx.key_dec[42] = 0x43393012 & ctx.key_enc[42] = 0xa751f82
> ctx.key_dec[43] = 0x1ea5e66b & ctx.key_enc[43] = 0x53d707ad
> ctx.key_dec[44] = 0xc449b19e & ctx.key_enc[44] = 0x380540ca
> ctx.key_dec[45] = 0x5d9cd679 & ctx.key_enc[45] = 0x650cc8f
> ctx.key_dec[46] = 0x7ca2b4fe & ctx.key_enc[46] = 0x6a162d28
> ctx.key_dec[47] = 0xfdd7b6ea & ctx.key_enc[47] = 0xb5e73cbc
> ctx.key_dec[48] = 0xf7b0738e & ctx.key_enc[48] = 0x6fa08be9
> ctx.key_dec[49] = 0x52640eda & ctx.key_enc[49] = 0x3c778c44
> ctx.key_dec[50] = 0x2bf310c8 & ctx.key_enc[50] = 0x472cc8e
> ctx.key_dec[51] = 0xe5799080 & ctx.key_enc[51] = 0x2220001
> ctx.key_dec[52] = 0x13eaf950 & ctx.key_enc[52] = 0x13eaf850
> ctx.key_dec[53] = 0xffff8000 & ctx.key_enc[53] = 0xffff8000
> ctx.key_dec[54] = 0x105146b0 & ctx.key_enc[54] = 0x109ba1f8
> ctx.key_dec[55] = 0xffff8000 & ctx.key_enc[55] = 0xffff8000
> ctx.key_dec[56] = 0x13eaf950 & ctx.key_enc[56] = 0x13eaf9f5
> ctx.key_dec[57] = 0xffff8000 & ctx.key_enc[57] = 0xffff8000
> ctx.key_dec[58] = 0x105146c0 & ctx.key_enc[58] = 0x93eaf9e7
> ctx.key_dec[59] = 0xffff8000 & ctx.key_enc[59] = 0xffff8000
>
> The difference is between 52nd index through 59.
>
> Any ideas if this is expected?
>

Yes, this is expected. This particular test vector uses a 192 bit key,
so those values are DC/ignored.
