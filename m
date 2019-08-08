Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E7E2C0650F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 04:35:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D51B21743
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 04:35:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N2OTy1Y1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726106AbfHHEfh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 00:35:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:41353 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfHHEfg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 00:35:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id c2so90241961wrm.8
        for <linux-crypto@vger.kernel.org>; Wed, 07 Aug 2019 21:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ngm09LcMWzK5Dpc9mQ1Xk+4OLg15tMcivduX4L7QMO0=;
        b=N2OTy1Y1W5JEwy50H3DYwWXRE1DG6Zz4YMq0BRiabmlp83mWlQ0niuBPZKD+5rcfjQ
         3nvU6mw7vLOHTupA6v0h/NMirWqtWbfOZ17E/oGoUIjvTWOCS3+lhJAINaaLPnveBVw7
         neX6K329hVRE80GCDTX7fOe22JramM4Pwo7pBaVU3Yg7TEaTENlKKKprKvTku6w8ccnU
         zs7XAXDIq08HqPqLpZt/SW3V9Vq5p+QZ+dWo/YXNixx+YNhejwPDjMv02SUVvE5rXKGg
         Uu9dDXfgDkpvPDJc/8c2MjRliteNhLaZVNNs2h1lVM2ZHfpkw/JLbKa5Nm0MXUPpMKZi
         r9WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ngm09LcMWzK5Dpc9mQ1Xk+4OLg15tMcivduX4L7QMO0=;
        b=L2IQmOIoeTaHVafZ0cSacm8Jy7/KrZadlJyU2tKgxoh0Xjo8D2DrCeklWDvgDH37Sq
         zebHBHbfhH5lWl+VAwj03hWuSAHXtvERXJ6kqTG6tPpuXtftFDE8XVMFuHpoPGkUpz+f
         Q7nGmwq1Bpl09RARfcw1m53yGoRbxSfWIusj+G+CmPeH95laRGNQWIpsRnq6Cn/wwHQf
         q5urvwgmk+qj7BE5oHRh/XYhhtKcXtE6Ba5xZQTgmpjzsFz8CLZKhwAieC3hvaYrNqst
         plHxKmAH98On8fmW4V55QwamI9tgpuSS15n1qHKzACo9s5Q6tZJd9ZO+qWeFLJ5WNztx
         foZw==
X-Gm-Message-State: APjAAAX79Tia9fpOtCfnd1blIBdFf9J5KNtGWS4wtcro8YktK6TC3nuP
        NUaeiyfprQ/8VZ/uivVWK7U=
X-Google-Smtp-Source: APXvYqzkdeImeQ2ZII/p/z1QPMwTwTN9r8z0sz3/k18Z4407VxqjxihlE06NeP/y8hQTOeiaFrVC5Q==
X-Received: by 2002:adf:f2c4:: with SMTP id d4mr13928897wrp.3.1565238934782;
        Wed, 07 Aug 2019 21:35:34 -0700 (PDT)
Received: from [192.168.2.28] (39.35.broadband4.iol.cz. [85.71.35.39])
        by smtp.gmail.com with ESMTPSA id z7sm1001192wmg.22.2019.08.07.21.35.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Aug 2019 21:35:34 -0700 (PDT)
Subject: Re: [PATCH] crypto: xts - Add support for Cipher Text Stealing
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        =?UTF-8?B?T25kcmVqIE1vc27DocSNZWs=?= <omosnacek@gmail.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "rsnel@cube.dyndns.org" <rsnel@cube.dyndns.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1565074510-8480-1-git-send-email-pvanleeuwen@verimatrix.com>
 <5bf9d0be-3ba4-8903-f1b9-93aa32106274@gmail.com>
 <MN2PR20MB29734CFE2795639436C3CC91CAD50@MN2PR20MB2973.namprd20.prod.outlook.com>
 <MN2PR20MB2973A38A300804281CA6A109CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <a0e3ce44-3e47-b8d9-2152-3fd8ba99f09a@gmail.com>
 <MN2PR20MB297333F0024F94C647D71AA2CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <52a11506-0047-a7e7-4fa0-ba8d465b843c@gmail.com>
 <MN2PR20MB2973C4EAF89D158B779CDBDACAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <46f76b06-004e-c08a-3ef3-4ba9fdc61d91@gmail.com>
 <CAAUqJDuMUHqd4J7TNRbMiEDNeb_GCJPhJUQJoOJo5zXKmL72nQ@mail.gmail.com>
 <MN2PR20MB297367EE650DBA3308ADD134CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fcf6c4b2-b871-6fdc-7803-f94134148299@gmail.com>
Date:   Thu, 8 Aug 2019 06:35:33 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <MN2PR20MB297367EE650DBA3308ADD134CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 07/08/2019 23:13, Pascal Van Leeuwen wrote:
>> It is a bit confusing, but it is the only reasonable way to support
>> variably sized context and at the same time keep the whole request in
>> a single allocation.

Yes, and the reason here it was detected only for aesni_intel is that
it is submitted though more layers, these depends on variable context length
(at least it run through crypt_simd layer).

I think all other implementations on this 32bit machine were called directly,
so no corruption seen there.

> Ah, ok, I did not know anything about that ... so there's really no way
> I could've done this correctly or to have found the problem myself really.
> Good that it's resolved now, though.
> 
> I fixed a couple of other minor things already, is it OK if I roll this
> into an update to my original patch?

Sure, feel free to fold in my change in v2 patch.
I'll test it and provide Tested-by later.

Maybe it would be good to also include /* must be the last */ comment
to the req in struct, though.

Also, maybe this req should have CRYPTO_MINALIGN_ATTR attribute also?

I expect req can be run through exotic hw accelerators later with some
memory alignment requirements. Ondra will know better here, though ;-)

Thanks!
Milan
