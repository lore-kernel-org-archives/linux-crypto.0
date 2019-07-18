Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E53C76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 11:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6ACD121019
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 11:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fiRi2Hl+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbfGRLTp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 07:19:45 -0400
Received: from mail-wm1-f42.google.com ([209.85.128.42]:37922 "EHLO
        mail-wm1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727670AbfGRLTp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 07:19:45 -0400
Received: by mail-wm1-f42.google.com with SMTP id s15so3907809wmj.3
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 04:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dVSqJxHc4hCvBMkoZU5D2dsbrzY2xQ+hZ5J9LTcwpq0=;
        b=fiRi2Hl+UrQDj+8dcNWYCnG1fNGF8sOVkl4NDNgxWp93/6q89O2hkW7pxrD6eahVWr
         hqWNLJNJJpenvEAcVSNdoN94+FnBvRFhqS+S223Vl+KHhXZKCwKGxi1L3wv7yQMgqyT6
         xd16JL6y4iBZImcqbChMkiqlWBrur1IhVHxGeMlVJM4aecueogn54AHZLPT1AXWYjfJK
         gN5YRzdt5sgRfRMhjmAZL/m/Ux/jGWf56/jtJg5dpUW8zp8JsqJl3nA+rHX2XLFCxhuR
         LJiia4/RTQFD3POvLh9V5nn2gTs3xQlB3W5s4hbpC1lMOq8Cxyf4MmT9GRfbJEb3NHLA
         tdHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dVSqJxHc4hCvBMkoZU5D2dsbrzY2xQ+hZ5J9LTcwpq0=;
        b=JNWh54KMwVUFxIPINb2vXf0Ag/uSDAeCscMMqoWDoBp497vQNXMDgwOthXqHGC24Ff
         8Ursm1QgDPt3ZkqYpXmbRJJxIkZGBtDnD3mkDQ+GPoOVGLV8xPnXm4EaFk69wAMyFXgd
         kQcHCGfN92+SuQoJ8gcCUgQCQ74/ID7ImnjDX9cRNpFvQwAAUO6lDY0CAmnjbt6b8Mgb
         +jpWVOcTpDfpzY2IZEqFU/K3jo8gMBusdRPVqA8tcT9alQQRvf00/PHytx0PKjX0Q9gv
         +7416AcF0OwapDlZnK9UyJAlvJPhKx9LV/uFFal6/b3cqiHYyS3kgfltQOa6TDoH2wbe
         tl3g==
X-Gm-Message-State: APjAAAWhQ0NUUiRyR3hek2tnkA27U9xnv17411gs1XwdQquPXD6gFOJZ
        NaWHXwkp6uAuWHcMypA3jDg5OjMcqXg=
X-Google-Smtp-Source: APXvYqzoS0Ffmm8deRB6JwC01KjMLES3GLEqqD/hHGxw/p+yQnzvsULFfXSROWTJvD3KsbAEkR/TJg==
X-Received: by 2002:a1c:35c2:: with SMTP id c185mr41379998wma.58.1563448783085;
        Thu, 18 Jul 2019 04:19:43 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id v15sm27046226wrt.25.2019.07.18.04.19.42
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 04:19:42 -0700 (PDT)
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
References: <VI1PR0402MB34858E4EF0ACA7CDB446FF5798CE0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <b042649c-db98-9710-b063-242bdf520252@gmail.com>
Date:   Thu, 18 Jul 2019 13:19:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/07/2019 12:40, Pascal Van Leeuwen wrote:
...
>> See the reference in generic code - the 3rd line - link to the IEEE standard.
>> We do not implement it properly - for more than 12 years!
>>
> 
> Full XTS is XEX-TCB-CTS so the proper terminology for "XTS without CTS" would be XEX-TCB.
> But the problem there is that TCB and CTS are generic terms that do not imply a specific 
> implementation for generating the tweak -or- performing the ciphertext stealing.
> Only the *full* XTS operation is standardized (as IEEE Std P1619).

Yes. Also XTS is allowed in FIPS now. Because the current code cannot submit
anything else than aligned blocks, we are ok.
(I hope. Speaking for disk encryption, dm-crypt, only).

> In fact, using the current cts template around the current xts template actually does NOT
> implement standards compliant XTS at all, as the CTS *implementation* for XTS is 
> different from the one for CBC as implemented by the current CTS template.
> The actual implementation of the ciphertext stealing has (or may have) a security impact,
> so the *combined* operation must be cryptanalyzed and adding some random CTS scheme
> to some random block cipher mode would be a case of "roll your own crypto" (i.e. bad).

> From that perspective - to prevent people from doing cryptographically stupid things -
> IMHO it would be better to just pull the CTS into the XTS implementation i.e. make
> xts natively support blocks that are not a multiple of (but >=) the cipher blocksize ...

I would definitely prefer adding CTS directly to XTS (as it is in gcrypt or OpenSSL now)
instead of some new compositions.

Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)

(That said, I will try to find some volunteer to help with CTS in XTS implementation, if needed.)

>> Reality check - nobody in block layer needs ciphertext stealing, we are always
>> aligned to block. AF_ALG is a different story, though.
> 
> So you don't support odd sector sizes like 520 , 528, 4112, 4160 or 4224 bytes?

No. Dm-crypt supports only power of two blocks, up to 4k (IOW: 512, 1024, 2048, 4096 bytes).
(Not more, because of compatible page size - this could be fixed in future though.)

The 520 hw sector is usually 512 + 8 bytes for DIF (data integrity field).
We can emulate something similar with dm-integrity, but the data section (input to encryption)
must be always as specified above (rest is in integrity bio section).

Milan
