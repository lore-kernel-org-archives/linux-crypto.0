Return-Path: <SRS0=1/ZA=UZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457DAC4646B
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 165742086D
	for <linux-crypto@archiver.kernel.org>; Wed, 26 Jun 2019 07:00:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JUU87IIe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbfFZHAP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 26 Jun 2019 03:00:15 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34517 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726416AbfFZHAO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 26 Jun 2019 03:00:14 -0400
Received: by mail-wr1-f65.google.com with SMTP id k11so1358037wrl.1
        for <linux-crypto@vger.kernel.org>; Wed, 26 Jun 2019 00:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e3Z/KCZGJbZCcUAhA2zcyvXwSSyOURC9+Ab4uJaPD3E=;
        b=JUU87IIe4wtSYb4o442979V7xaHwnNR00YSFXb2NgCZjhpRaf0t7DuNrL/OYAFSV+L
         XjhvH+4crGMM0I/H+73rVfonQPpsX5oOKmY9WQxpkulvcF4RPUhdmQUB39JEVLDS7vpm
         kWBzD1Lc8h89Bghcyxlmd/o1ELfQoDl9nSIzTldBrKwK8OR6P3vjlMLnJk4ty8l2ZQRW
         E47a3mpzdZPh6IIPfttc8ZngnqI3YaS5mId1oiRwLCd29vMYI4z1gchv9WBMGutsjsgH
         WGyASgWq5eQMSpTEQRDKs3mN+UBLiKrbo4jfzxIXXpiZdUr2FLliuZfAK+F9M7b2j9hg
         3row==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e3Z/KCZGJbZCcUAhA2zcyvXwSSyOURC9+Ab4uJaPD3E=;
        b=CWoB44K3Mse8s++tv/khrQZrkuatF0agdS47RuWuy8EeCilpk8vft6yAvyFdIiVadL
         D1e643eIrvk+gLwwYvGUielW4ff/7NNo8P1oc/fn3ZieYZOIo+ZpQGugF9LQTGNdBfJz
         9P4zJY29+zri2E0OQtBi5K5hxXBwvXfRtBlYZiyY47Oik9vQz0kiN82XIkSitFjL/NXH
         Q5vCL7c7ng5EXA1bfeaveehe2FM+f/VrbXLjKH7fDY6jLl//ImDQ6eLnt6DltlbjIjM7
         JwOUGF29jFHyeI8hPjbhxUhX93ozpCaxAw+D6UQPaYumW08S6H3yKYO1iJ6WGwEJ/w5b
         DJ+g==
X-Gm-Message-State: APjAAAXj9YnGRDkDuP4yOOa/nz9o3/Ncyz+FEprGtZMtd2tPd+Z6ysy8
        yU71ne//mi6/Ht+KlyV00bA=
X-Google-Smtp-Source: APXvYqxnOwPXeOC++RaZK1yHzB3PADODM2rq3BwLcFsyBEpSASG3NgZYyR4W35gIxBA5ChSd1ZEMJg==
X-Received: by 2002:a5d:4b43:: with SMTP id w3mr2186019wrs.166.1561532411941;
        Wed, 26 Jun 2019 00:00:11 -0700 (PDT)
Received: from [10.43.17.24] (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id f12sm35131641wrg.5.2019.06.26.00.00.10
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Jun 2019 00:00:11 -0700 (PDT)
Subject: Re: [PATCH] crypto: morus - remove generic and x86 implementations
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
References: <20190625145254.28510-1-ard.biesheuvel@linaro.org>
 <20190625171234.GB81914@gmail.com>
 <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ca908099-3305-9764-dbf2-adc7a256ad59@gmail.com>
Date:   Wed, 26 Jun 2019 09:00:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CAKv+Gu8P4AUNbf636d=h=RDFV+CPEZCoPi9EZ+OtKEd5cBky5g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On 25/06/2019 20:37, Ard Biesheuvel wrote:
> On Tue, 25 Jun 2019 at 19:12, Eric Biggers <ebiggers@kernel.org> wrote:
>>
>> [+Cc Milan]

I was discussing this with Ondra before he sent the reply, anyway comments below:

>> On Tue, Jun 25, 2019 at 04:52:54PM +0200, Ard Biesheuvel wrote:
>>> MORUS was not selected as a winner in the CAESAR competition, which
>>> is not surprising since it is considered to be cryptographically
>>> broken. (Note that this is not an implementation defect, but a flaw
>>> in the underlying algorithm). Since it is unlikely to be in use
>>> currently, let's remove it before we're stuck with it.
>>>
>>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

...
>>
>> Maybe include a link to the cryptanalysis paper
>> https://eprint.iacr.org/2019/172.pdf in the commit message, so people seeing
>> this commit can better understand the reasoning?
>>
> 
> Sure.

Yes, definitely include the link please.

>> Otherwise this patch itself looks fine to me, though I'm a little concerned
>> we'll break someone actually using MORUS.  An alternate approach would be to
>> leave just the C implementation, and make it print a deprecation warning for a
>> year or two before actually removing it.  But I'm not sure that's needed, and it
>> might be counterproductive as it would allow more people to start using it.
>>
> 
> Indeed. 'Breaking userspace' is permitted if nobody actually notices,
> and given how broken MORUS is, anyone who truly cares about security
> wouldn't have chosen it to begin with. And if it does turn out to be a
> real issue, we can always put the C version back where it was.

> 
>> From a Google search I don't see any documentation floating around specifically
>> telling people to use MORUS with cryptsetup, other than an email on the dm-crypt
>> mailing list (https://www.spinics.net/lists/dm-crypt/msg07763.html) which
>> mentioned it alongside other options.  So hopefully there are at most a couple
>> odd adventurous users, who won't mind migrating their data to a new LUKS volume.

Yes, there are perhaps some users.

TL;DR: Despite it, I am for completely removing the MORUS cipher now form the kernel.
Cryptsetup integrity extension (authenticated encryption) is still marked experimental.


Long story (beware, a rant below:)

We were very strict in backward support of almost everything in cryptsetup/dm-crypt
(including unreleased versions) for the last 10 years.

But I think we need to change the approach in some specific cases.

For the last years (this topic was a part of my Ph.D. study) I was trying to help
to investigate new practical approaches to the sector level encryption, and apparently,
not everything is a success.

I truly believe that we have to start to use authenticated encryption in future (in general).

Unfortunately, once we are trying to talk to academic people, I found quite strict
resistance (or even ignorance) regarding practical applications.
Maybe it is just my perception, but once papers are published, nobody cares what
happens next.

In the time we need to experiment with new AEAD algorithms, the CAESAR crypto
competition was in an almost-final state for months.
Maybe post-quantum was more important at the time, maybe the practitioners
and researchers time scale differs here in order of magnitude...

So we have decided to take a risk to implement some AEAD ciphers (where the theoretic
background looked good - at that time) and use them and investigate all the "engineering"
problems around it.
Everything was designed to be algorithm-agnostic, precisely to be able to switch it later.

Yes, we can be conservative and wait for years. The risk is that if nobody uses it,
nobody analyzes it. And even then the best algorithms are being broken later, we need
just to deal with it.

So my point is:

Let's try to use state-of-the-art things, but let's be prepared to also retract
it quickly if it becomes apparent that this is not secure or the goal was not met.

We will break some systems from time to time, but it is still better than keeping
an army of known flawed algorithms in the kernel.
With help from academic research people, it can happen very rarely though.

There is always a conservative selection of crypto (with all the certifications
theatre around), I am *not* talking about this - IMO here the compatibility is a must.

Milan

p.s.
We planned to be able to use the reencryption feature to switch to different
ciphers on existing devices in such cases, but unfortunately, for now, it works
only for length-preserving modes.
Authenticated encryption will be supported later (and not in all cases).
It will improve, though.
