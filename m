From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH v6 3/4] crypto: akcipher: add akcipher declarations needed
 by templates.
Date: Sat, 5 Dec 2015 16:41:23 +0100
Message-ID: <CAOq732Ld5ydZdJ=eVSrPx3MyqekQtVh2ud8Rcee42u18-bWzYQ@mail.gmail.com>
References: <1448798541-17580-1-git-send-email-andrew.zaborowski@intel.com>
	<20151204142821.GA17533@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:34519 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbbLEPlY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Dec 2015 10:41:24 -0500
Received: by wmvv187 with SMTP id v187so112632146wmv.1
        for <linux-crypto@vger.kernel.org>; Sat, 05 Dec 2015 07:41:23 -0800 (PST)
In-Reply-To: <20151204142821.GA17533@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 4 December 2015 at 15:28, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>>
>> +static inline struct crypto_akcipher *crypto_spawn_akcipher(
>> +               struct crypto_akcipher_spawn *spawn)
>> +{
>> +       return crypto_spawn_tfm2(&spawn->base);
>> +}
>> +
>> +static inline void crypto_drop_akcipher(struct crypto_akcipher_spawn *spawn)
>> +{
>> +       crypto_drop_spawn(&spawn->base);
>> +}
>> +
>> +static inline struct akcipher_alg *crypto_spawn_akcipher_alg(
>> +               struct crypto_akcipher_spawn *spawn)
>> +{
>> +       return container_of(spawn->base.alg, struct akcipher_alg, base);
>> +}
>> +
>> +static inline struct crypto_akcipher *crypto_spawn_akcipher(
>> +       struct crypto_akcipher_spawn *spawn)
>> +{
>> +       return crypto_spawn_tfm2(&spawn->base);
>> +}
>
> You're defining crypto_spawn_akcipher twice.  This also means that
> you didn't even bother compiling it.

The chunk that removed crypto_spawn_akcipher ended up in patch 4/4
because I messed up the rebase, oops.  I'll fix this.

I did compile and test.

Best regards
