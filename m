Return-Path: <SRS0=C5/f=BG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDCCC433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 15:08:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEBD32064B
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Jul 2020 15:08:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgG0PI3 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jul 2020 11:08:29 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:36443
        "EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729507AbgG0PI3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jul 2020 11:08:29 -0400
X-IronPort-AV: E=Sophos;i="5.75,402,1589234400"; 
   d="scan'208";a="355409930"
Received: from 89-156-101-160.rev.numericable.fr (HELO [192.168.0.67]) ([89.156.101.160])
  by mail3-relais-sop.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jul 2020 17:08:27 +0200
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [PATCH] crypto: x86/curve25519 - Remove unused carry variables
From:   Karthik Bhargavan <karthikeyan.bhargavan@inria.fr>
In-Reply-To: <CAHmME9rg-_2-Zj19zSZa6sujgfJcOdm6=L1N07Dif9aWJE7eQQ@mail.gmail.com>
Date:   Mon, 27 Jul 2020 17:08:25 +0200
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <4DE9D3CD-E934-49CE-A122-F536721ADF72@inria.fr>
References: <20200723075048.GA10966@gondor.apana.org.au>
 <CAHmME9rg-_2-Zj19zSZa6sujgfJcOdm6=L1N07Dif9aWJE7eQQ@mail.gmail.com>
To:     "Jason A. Donenfeld" <jason@zx2c4.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Removing unused variables is harmless. (GCC would do this automaticelly.)
So this change seems fine.

-Karthik

> On 23 Jul 2020, at 12:05, Jason A. Donenfeld <jason@zx2c4.com> wrote:
> 
> Hi Herbert,
> 
> On Thu, Jul 23, 2020 at 9:51 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> 
>> The carry variables are assigned but never used, which upsets
>> the compiler.  This patch removes them.
>> 
>> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>> 
>> diff --git a/arch/x86/crypto/curve25519-x86_64.c b/arch/x86/crypto/curve25519-x86_64.c
>> index 8a17621f7d3a..8acbb6584a37 100644
>> --- a/arch/x86/crypto/curve25519-x86_64.c
>> +++ b/arch/x86/crypto/curve25519-x86_64.c
>> @@ -948,10 +948,8 @@ static void store_felem(u64 *b, u64 *f)
>> {
>>        u64 f30 = f[3U];
>>        u64 top_bit0 = f30 >> (u32)63U;
>> -       u64 carry0;
>>        u64 f31;
>>        u64 top_bit;
>> -       u64 carry;
>>        u64 f0;
>>        u64 f1;
>>        u64 f2;
>> @@ -970,11 +968,11 @@ static void store_felem(u64 *b, u64 *f)
>>        u64 o2;
>>        u64 o3;
>>        f[3U] = f30 & (u64)0x7fffffffffffffffU;
>> -       carry0 = add_scalar(f, f, (u64)19U * top_bit0);
>> +       add_scalar(f, f, (u64)19U * top_bit0);
>>        f31 = f[3U];
>>        top_bit = f31 >> (u32)63U;
>>        f[3U] = f31 & (u64)0x7fffffffffffffffU;
>> -       carry = add_scalar(f, f, (u64)19U * top_bit);
>> +       add_scalar(f, f, (u64)19U * top_bit);
>>        f0 = f[0U];
>>        f1 = f[1U];
>>        f2 = f[2U];
>> --
> 
> That seems obvious and reasonable, and so I'm inclined to ack this,
> but I first wanted to give Karthik (CC'd) a chance to chime in here,
> as it's his HACL* project that's responsible, and he might have some
> curious insight.
> 
> Jason

