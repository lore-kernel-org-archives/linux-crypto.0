Return-Path: <SRS0=4UBR=VP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B2D4C76191
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 612CE21019
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Jul 2019 07:40:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q8RSszfw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbfGRHkP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Jul 2019 03:40:15 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]:44065 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbfGRHkP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Jul 2019 03:40:15 -0400
Received: by mail-wr1-f48.google.com with SMTP id p17so27466962wrf.11
        for <linux-crypto@vger.kernel.org>; Thu, 18 Jul 2019 00:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8Ets9DwLOZVAU6fNpoFk58BESPFJh1jtTqQh2d/rdgA=;
        b=Q8RSszfwbaBbTcKCdYB4rZi3IlzgC2nBGE4+cOKO37g6oLxfPfHR0yFvV51VyIaXV8
         dbe0496/B+HfIAgO/Q/HIgtV1GMya9jx8s5fYFl7IFhAC9+UvLch6tOduPB1G9atAFLA
         YZxrb6Wn/TFtbBj3TiOki4rRGf+pnRKulZcfQdoRTh5iIPztJU978326joEn8Pm9Zz5z
         2hXdIZ/ch1qo5haTon071iQ9oZteCR+BdW5yeesLajqQF9vA9H9cbsq8anMGDjmuyRho
         nu7mPghSn37t7sl8qeoRJ6phl01Ur84wrKmRax/DUdaapb3KzeihrVpXsU7HbM4bW5Ah
         eJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8Ets9DwLOZVAU6fNpoFk58BESPFJh1jtTqQh2d/rdgA=;
        b=eclKTaXk39CNhdoSgSomJGc4mrMpDsUSd71LJ38eMxgd6NCqsa66X0j26y/HUfleuu
         jQbPnOxJD2C6iFwedHpU71Wtkxf3bAJAbPAz8yamBKma/efJYfvnMh8tz8ds40m7uv0T
         imDSq8XEHO0IUC+nJSgMFZ6chiCC9zN7Hw+ZIKwAc8qTYKMec6qjePEG8V4sB0CEChv0
         i7KcHGBFNgjhIhjn81tUaAn/KBHWxKMGPvA5Z7caTaxBw9xFmYW1sTA2pM38sMUdgyf+
         /uHD8VeUJSxNCSO4ya1Y0YcxYtS5DgwbPMnIXHKaEkI3fT4E5xesq8iz7tSNWdPe/l97
         3q2A==
X-Gm-Message-State: APjAAAWNnN8tzgecgah7t89IBl1N7qvGvFhTYVpQXG0LjGKDAh7Mo/3l
        w+O5G5E6PQGC3JXAJaNtQfvu9wglJfQ=
X-Google-Smtp-Source: APXvYqxbf6KAe77UBX6m38X+WIIUli0ULfcoB5r6fTp/YzaSZZTCqbBLoWOjawnGl/CjeYCxOX2JXg==
X-Received: by 2002:adf:cd84:: with SMTP id q4mr40132324wrj.232.1563435613007;
        Thu, 18 Jul 2019 00:40:13 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id r14sm24128962wrx.57.2019.07.18.00.40.11
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 18 Jul 2019 00:40:12 -0700 (PDT)
Subject: Re: xts fuzz testing and lack of ciphertext stealing support
To:     Herbert Xu <herbert@gondor.apana.org.au>,
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
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
Date:   Thu, 18 Jul 2019 09:40:11 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 18/07/2019 09:21, Herbert Xu wrote:
> On Thu, Jul 18, 2019 at 09:15:39AM +0200, Ard Biesheuvel wrote:
>>
>> Not just the generic implementation: there are numerous synchronous
>> and asynchronous implementations of xts(aes) in the kernel that would
>> have to be fixed, while there are no in-kernel users that actually
>> rely on CTS. Also, in the cbc case, we support CTS by wrapping it into
>> another template, i.e., cts(cbc(aes)).
>>
>> So retroactively redefining what xts(...) means seems like a bad idea
>> to me. If we want to support XTS ciphertext stealing for the benefit
>> of userland, let's do so via the existing cts template, and add
>> support for wrapping XTS to it.
> 
> XTS without stealing should be renamed as XEX.  Sure you can then
> wrap it inside cts to form xts but the end result needs to be called
> xts.

While I fully agree here from the technical point of view,
academically XEX, XEX* is a different mode.
It would create even more confusion.

Couldn't resist, but this is a nice example of what happens when academic,
standardization, and reality meets in one place :)

XTS is already implemented in gcrypt and OpenSSL.
IMO all the implementation should be exactly the same.

I agree with Herbert that the proper way is to implement ciphertext stealing.
Otherwise, it is just incomplete implementation, not a redefining XTS mode!

See the reference in generic code - the 3rd line - link to the IEEE standard.
We do not implement it properly - for more than 12 years!

Reality check - nobody in block layer needs ciphertext stealing, we are always
aligned to block. AF_ALG is a different story, though.

Milan

