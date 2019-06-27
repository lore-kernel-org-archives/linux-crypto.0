Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8D5C48BD6
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E23620828
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 07:58:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SU2J0uAC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfF0H6h (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 03:58:37 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39955 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725954AbfF0H6g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 03:58:36 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so1354255wre.7
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jun 2019 00:58:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9bMGMQmkyNJZ8WTvrsbnryrvWL7S1X7zj5iWDngaFnA=;
        b=SU2J0uACStCXUsPdpnyzh0A7OKOtIDPzfUmgEQdVSAkocxNVICUX+uS/BUZ5ZJNqHu
         o4yAQDOsueXFp/9sfmJEOM+34XC9DUXxSefzKvPwqYUGr2b1guLErH2/zK1gHWmCPlav
         RfxeaFzI0pf/i/qfbjvQ7poqH/9ITGEYP/8Fi1D7x8biVIEc/IYn2bIYQcMe7cjcvr3t
         3pJhnovbRlwrh4h5MOrQ4sHI2UbFB5f+7W4ED4I1/Tm6n7qMkwW2GSpwKn8PBy00qrMu
         kFY3IQELI+tleBgwr90hZuam1gNyReYiJpAKfE1JdGmHfVFENf/HsPstrBUAx0QNSyIy
         Ncxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9bMGMQmkyNJZ8WTvrsbnryrvWL7S1X7zj5iWDngaFnA=;
        b=GglJpZRYTxvdcBk1vEkG370PuOTwT/ipWmCDkI1/wu8a9qd5Id+8m61GiSA2sODSTF
         dV5czfpLsEfhfBMayFrqvL2n/W6jPNdvdp+3kFgyYEv7OKJy9pTpjlrJq5c5mUiFVJwL
         AqdySGod4v4IYA22v5Pk8ZLu7acQ4XqKWyQdOQih2FVY/dKhxnrjOLaypcRn7qinTONS
         YsIf7G0ZSysP0TYrufjkAkpeGeRGB+1Af3er8gwu+SbmGsNpsv80sZVVhlBHpH7UI+Xm
         c/tl880kcj/6V9kCAqAkBULbRpMO54BdcyaJ+bNbPECe1sZVMpsyKXhXNs1rE1HNMcH3
         xA0Q==
X-Gm-Message-State: APjAAAUvVQNLwc9JMsONgDCCccQTrqoDnaoob6J+7thWOQTos1JtHQE8
        MQ6mRMRioxx6m9UxVZEBKwM=
X-Google-Smtp-Source: APXvYqxiORiFNbBkpXd56+xPTHVO6OMHZijGh9azPSYXMOw+2x10gVcQM1f+cfwNByHSZFcA45xGBg==
X-Received: by 2002:a5d:4812:: with SMTP id l18mr1522692wrq.176.1561622314242;
        Thu, 27 Jun 2019 00:58:34 -0700 (PDT)
Received: from [10.43.17.24] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id x3sm1051871wrp.78.2019.06.27.00.58.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Jun 2019 00:58:33 -0700 (PDT)
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Samuel Neves <samuel.c.p.neves@gmail.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com>
 <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
 <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com>
 <CAKv+Gu9jAqGAYg8f_rBVbve=L3AQb_xKnpmnsqrZ3m7VLnaz1g@mail.gmail.com>
 <e9d045c6-f6e2-a0d2-b1f2-bebee5d027f4@gmail.com>
 <CAEX_ruEDA9ZG+6aA_jTBSq-MM=pOrdxoJA2x0LPF3dkYk76kCQ@mail.gmail.com>
 <CAKv+Gu_W9sMrSyqBQv0pZZwgJzCgpSv7CAR6mdH-sJTdMExbHA@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <2101a0ba-bf10-45f1-95ba-ed53907c02dc@gmail.com>
Date:   Thu, 27 Jun 2019 09:58:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu_W9sMrSyqBQv0pZZwgJzCgpSv7CAR6mdH-sJTdMExbHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 27/06/2019 09:42, Ard Biesheuvel wrote:
> On Wed, 26 Jun 2019 at 23:11, Samuel Neves <samuel.c.p.neves@gmail.com> wrote:
>>
>> , On Wed, Jun 26, 2019 at 8:40 AM Milan Broz <gmazyland@gmail.com> wrote:
>>>
>>> On 26/06/2019 09:15, Ard Biesheuvel wrote:
>>>
>>>> Thanks for the insight. So I guess we have consensus that MORUS should
>>>> be removed. How about aegis128l and aegis256, which have been
>>>> disregarded in favor of aegis128 by CAESAR (note that I sent an
>>>> accelerated ARM/arm64 version of aegis128 based on the ARMv8 crypto
>>>> instructions, in case you missed it)
>>>
>>> Well, there are similar cases, see that Serpent supports many keysizes, even 0-length key (!),
>>> despite the AES finalists were proposed only for 128/192/256 bit keys.
>>> (It happened to us several times during tests that apparent mistype in Serpent key length
>>> was accepted by the kernel...)
>>
>> I'm not sure the Serpent case is comparable. In Serpent, the key can
>> be any size below 256 bits, but internally the key is simply padded to
>> 256 bits and the algorithm is fundamentally the same. There are no
>> speed differences between different keys sizes.
>>
>> On the other hand, AEGIS128, AEGIS256, and AEGIS128L are different
>> algorithms, with different state sizes and state update functions. The
>> existing cryptanalysis of AEGIS consists solely of [1] (which is the
>> paper that directly inspired the MORUS cryptanalysis), which does not
>> look at AEGIS128L at all. In effect, to my knowledge there are no
>> known cryptanalytic results on AEGIS128L, which I imagine to be one of
>> the main reasons why it did not end up in the CAESAR portfolio. But
>> AEGIS128L is by far the fastest option, and a user is probably going
>> to be naturally tempted to use it instead of the other variants.
>>
> 
> Indeed. So that would actually argue for removing the optimized x86
> implementation, but tbh, I'd rather remove aegis128l and aegis256
> entirely, given that no recommendations exist for its use in any
> particular context, and given the CAESAR outcome, that is unlikely to
> change in the future.

ok, for me (to keep only recommended variants and completely remove the rest).

There should be no in-kernel users, and we have to deal with algorithms removal
in userspace anyway.

Milan
