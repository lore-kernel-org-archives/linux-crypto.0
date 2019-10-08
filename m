Return-Path: <SRS0=AFir=YB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B8DC4360C
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:38:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68E7720673
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Oct 2019 11:38:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cryptogams.org header.i=@cryptogams.org header.b="EHsaVef7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730690AbfJHLin (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Oct 2019 07:38:43 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35668 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbfJHLim (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Oct 2019 07:38:42 -0400
Received: by mail-ed1-f67.google.com with SMTP id v8so15340306eds.2
        for <linux-crypto@vger.kernel.org>; Tue, 08 Oct 2019 04:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cryptogams.org; s=gmail;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E0w6kl3R1ZHB2CAUvXr+VflLYCvARCAbvltXdlAInKk=;
        b=EHsaVef7VY9FmLzaZBPtiviWYFsXPScBumrIAFYiN5iUmzIvdeC+P314lWdhoyQmBo
         +DHKjSpLlmKEhovGscI9FF7oi5PelcBySsMWUcHRDzgYfy7luzEEqFL4cmPz6B9KldJN
         oabn6ZSi86osLECYxS4kBD+4ZqBgg+Dn5M8AcN5/xmTDY7y3njs6jK/C9ykm6Z1CyVfi
         BjfXhoJlfJ717VIDR7+h78wAWcreDDXSshRYQrFScECj388EbyZ3Gjbk+yBL/NIypGXM
         xJ4AKXg4t4alizS0NOAI1X3a6DpGvT7iPB0YAR5AXTEfQpaahn8hbwd0wondzm5NbuDo
         5rjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E0w6kl3R1ZHB2CAUvXr+VflLYCvARCAbvltXdlAInKk=;
        b=p6SYCz4n2Xz8NE2UspwOcKMqfhswP8Tb+IFgHXB2Hyh5jbasK3c+L9MCxwaGWOh8Le
         qYgyRsKfXFR3+NB2qM9ZMItK4NWmnk+VjsPr3wdt42nRa9AeKFMrp3l25ZhgWHnRxMdk
         dgePz3Wt6ZuKFFaMjZmruvcenAn/XIJO2oW+sBK8gY7DCu8JPnC0ydKkIHT3fBME2nM1
         eJ0PIUKMkASpHZ4gQxvSonU0Mwcl3EvCQHDOg47qbO4fItSMl+as43s0liA+MySVIfnD
         8cjISvimC7V6BOMDxLmhvczm5EYEMxM9fjBj57vyktlwAkLCD+/LJQUCUw4QNsFXbBPU
         5ECw==
X-Gm-Message-State: APjAAAXXz4PUXO7eUOzvabkyrLeBcsH6dymZzf3kURCO+G2r36QNAG+O
        6BKvYf+ycrDET0Ts4SxJw2QZ8Q==
X-Google-Smtp-Source: APXvYqz/tE6h6MunCn1tNNk1Xn3tNIlcLGf6sPQoINMvqTk1Om7el9VSkD1ZyH8DctGIx5XB5D49Fg==
X-Received: by 2002:aa7:d698:: with SMTP id d24mr33865221edr.32.1570534721209;
        Tue, 08 Oct 2019 04:38:41 -0700 (PDT)
Received: from ?IPv6:2001:6b0:2:2f1a:d6be:d9ff:feb7:f247? ([2001:6b0:2:2f1a:d6be:d9ff:feb7:f247])
        by smtp.gmail.com with ESMTPSA id b16sm2273358eju.74.2019.10.08.04.38.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 04:38:40 -0700 (PDT)
Subject: Re: [PATCH v3 19/29] crypto: mips/poly1305 - incorporate
 OpenSSL/CRYPTOGAMS optimized implementation
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>
References: <20191007164610.6881-1-ard.biesheuvel@linaro.org>
 <20191007164610.6881-20-ard.biesheuvel@linaro.org>
 <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
From:   Andy Polyakov <appro@cryptogams.org>
Message-ID: <a1c1ade1-f62a-3422-c161-a1d62ea67203@cryptogams.org>
Date:   Tue, 8 Oct 2019 13:38:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191007210242.Horde.FiSEhRSAuhKHgFx9ROLFIco@www.vdorst.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

On 10/7/19 11:02 PM, René van Dorst wrote:
> Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:
> 
>> This is a straight import of the OpenSSL/CRYPTOGAMS Poly1305
>> implementation
>> for MIPS authored by Andy Polyakov, and contributed by him to the OpenSSL
>> project.

Formally speaking this is a little bit misleading statement. Cryptogams
poly1305-mips module implements both 64- and 32-bit code paths, while
what you'll find in OpenSSL is 64-only implementation. But in either case...

>> <snip>
> 
> Hi Ard,
> 
> Is it also an option to include my mip32r2 optimized poly1305 version?
> 
> Below the results which shows a good improvement over the Andy Polyakov
> version.
> I swapped the poly1305 assembly file and rename the function to
> <func_name>_mips
> Full WireGuard source with the changes [0]
> 
> bytes |  RvD | openssl | delta | delta / openssl
>  ...
>  4096 | 9160 | 11755   | -2595 | -22,08%

I assume that the presented results depict regression after switch to
cryptogams module. Right? RvD implementation distinguishes itself in two
ways:

1. some of additions in inner loop are replaced with multiply-by-1-n-add;
2. carry chain at the end of the inner loop is effectively fused with
beginning of the said loop/taken out of the loop.

I recall attempting 1. and chosen not to do it with following rationale.
On processor I have access to, Octeon II, it made no significant
difference. It was better, but only marginally. And it's understandable,
because Octeon II should have lesser difficulty pairing those additions
with multiply-n-add instructions. But since multiplication is an
expensive operation, it can be pretty slow, I reckoned that on processor
less potent than Octeon II it might be more appropriate to minimize
amount of multiplication-n-add instructions. In other words idea is not
(and never has been) to get fixated on specific processor at hand, but
try to find a sensible compromise that would produce reasonable
performance on a range of processors. Of course problem is that it's
just an assumption I made here, and it could turn wrong in practice:-)
So I wonder which processor do you run on, René? For reference I measure
>70MB/sec for 1KB blocks for chacha20poly1305 on 1GHz Octeon II. You
report ~34MB/sec, so it ought to be something different. Given second
data point it might be appropriate to reconsider and settle for
multiply-by-1-n-add.

As for 2. I haven't considered it. Since it's a back-to-back dependency
chain, if fused with top of the loop, it actually has more promising
potential than 1. And it would improve all results, not only MISP32R2.
Would you trust me with adopting it to my module? Naturally with due credit.

Cheers.

