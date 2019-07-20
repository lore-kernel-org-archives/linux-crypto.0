Return-Path: <SRS0=kkja=VR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F2E9C76195
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 07:35:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 116E72084C
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 07:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N98VZMUn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbfGTHfa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Jul 2019 03:35:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:44410 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726681AbfGTHfa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Jul 2019 03:35:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id p17so34256624wrf.11
        for <linux-crypto@vger.kernel.org>; Sat, 20 Jul 2019 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aTgqFuUx+iLi6PHQcMOEzebXL2+OwnsPRMPIdzzMI50=;
        b=N98VZMUn7EWiC0MbiNP40BvMrQe6p/Gx2mE8wmrMIVNtjMd+JpagvU0arbPSWEYp81
         z7mvzLbLjYXz8BkgtHt5Ul+GRXesG4W/QYbuM/TxkcbADf571wVtIlD90aAuJRkjxHhh
         7s2l6XXzn57y0zimmCg1VTQxeVT7NRp/Fa/SmC6JbknLplEVj6oF/bvRKdm1AVa/Ydkh
         QpcXz5yiyOF4NUDCfpzc1a17PAgr5+RuxaGj5v8UjqSFR8kTAFO4HkzA5MLHYBZFFQqZ
         3QJTUEqSRDhXMuodbt0PgyPjfFiRZofYaHaeT/KM3iDpxcsPU3M6MY4vOZgLieHdV3bX
         cpCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aTgqFuUx+iLi6PHQcMOEzebXL2+OwnsPRMPIdzzMI50=;
        b=CzINJ3wbky8/9HCPkp2TUg+aa4X8Yc+dWSaw4UkwvocWUhs0JnD2PhnIt+cvqtFhso
         7Y4mCah5NWRWnzvk3k/vcw68vp1DA2gAillqJUzt1P7eR6YDVUPYi2KOzhX0BUUE7QAf
         oafx4Fz687pHwkTfZV/ZB7jo0cz3ihh2pUlWuGN6suhn5188VV275bJhkfRB2YEiHT2/
         ASRPQs50dzzibVl7St7J28cMc/IKHHwD3EoW6UaHgf79wj7Rllbg/gQHyYAvg+8M9TCx
         3MB+63Fo+/XZI5m/J7FygCidO+5kYiAVHpQKHGI9KVC77hWd4euQCZCcvcqFudHHvqER
         jCQA==
X-Gm-Message-State: APjAAAXZoYczZQazuv1JULT6q67d8K9MTy9KEW0gZ1vpmYsA7cRWuiYD
        cJCODxPIYnLR/p45crWz+cs=
X-Google-Smtp-Source: APXvYqzvUhh9TQTW84Wl2D2uGdpRQNZAqbHpd8XnY5c27KNJo7o336kxlMhwPJAFaXL7/TxXbySorQ==
X-Received: by 2002:adf:dd8e:: with SMTP id x14mr59960579wrl.344.1563608128567;
        Sat, 20 Jul 2019 00:35:28 -0700 (PDT)
Received: from [192.168.8.100] (37-48-49-65.nat.epc.tmcz.cz. [37.48.49.65])
        by smtp.gmail.com with ESMTPSA id p14sm27232138wrx.17.2019.07.20.00.35.27
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 00:35:27 -0700 (PDT)
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
 <20190720065807.GA711@sol.localdomain>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <0d4d6387-777c-bfd3-e54a-e7244fde0096@gmail.com>
Date:   Sat, 20 Jul 2019 09:35:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190720065807.GA711@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 20/07/2019 08:58, Eric Biggers wrote:
> On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
>> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
>> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
>> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
>> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
>>
> 
> Can't the "missing modules in initramfs" issue be solved by using a
> MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?
> 
> (There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
> but that was simply a bug, which was fixed.)

Sure, and it is solved now. (Some systems with a hardcoded list of modules
have to be manually updated etc., but that is just bad design).
It can be done properly from the beginning.

I just want to say that that switching to XEX looks like wasting time to me
for no additional benefit.

Fully implementing XTS does make much more sense for me, even though it is long-term
the effort and the only user, for now, would be testmgr.

So, there are no users because it does not work. It makes no sense
to implement it, because there are no users... (sorry, sounds like catch 22 :)

(Maybe someone can use it for keyslot encryption for keys not aligned to
block size, dunno. Actually, some filesystem encryption could have use for it.) 

> Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
> this a non-issue.

If it is not available for users, I really see no reason to introduce XEX when
it is just XTS with full blocks.

If it is visible to users, it needs some work in userspace - XEX (as XTS) need two keys,
people are already confused enough that 256bit key in AES-XTS means AES-128...
So the examples, hints, man pages need to be updated, at least.

Milan
