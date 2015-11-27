From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH v5 3/4] crypto: akcipher: add akcipher declarations needed
 by templates.
Date: Fri, 27 Nov 2015 16:10:41 +0100
Message-ID: <CAOq732K-A3-ypsLavOJrT_ENuSM=zuriJo0F5bS1dNuhbeRTDA@mail.gmail.com>
References: <1448574808-11320-1-git-send-email-andrew.zaborowski@intel.com>
	<20151127131213.GA29590@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:35419 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbbK0PKm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 27 Nov 2015 10:10:42 -0500
Received: by wmuu63 with SMTP id u63so58915094wmu.0
        for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2015 07:10:41 -0800 (PST)
In-Reply-To: <20151127131213.GA29590@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 27 November 2015 at 14:12, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>>
>> @@ -75,9 +76,22 @@ static int crypto_akcipher_init_tfm(struct crypto_tfm *tfm)
>>        return 0;
>> }
>>
>> +static void crypto_akcipher_free_instance(struct crypto_instance *inst)
>> +{
>> +       struct akcipher_instance *akcipher = akcipher_instance(inst);
>> +
>> +       if (!akcipher->free) {
>> +               inst->tmpl->free(inst);
>> +               return;
>> +       }
>
> You don't need this bit.  AEAD has it because there were legacy
> templates but you are starting from a clean slate.

You're right there aren't any users that need this now but again is
there any reason you prefer the inst->free approach?

BTW note the lines that assign inst->free in crypto/gcm.c end with
commas which could lead to confusion.

Best regards
