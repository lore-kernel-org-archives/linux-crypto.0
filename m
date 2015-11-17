From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH 3/4] crypto: akcipher: add crypto_akcipher_type methods
 needed by templates.
Date: Tue, 17 Nov 2015 22:47:11 +0100
Message-ID: <CAOq732JGbGmHeBKX39ZRRdKvrqDhO6H7DinVBY8dGxvqqaUJ0A@mail.gmail.com>
References: <1447412495-4370-3-git-send-email-andrew.zaborowski@intel.com>
	<20151117134251.GA9363@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37712 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbbKQVrM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 17 Nov 2015 16:47:12 -0500
Received: by wmww144 with SMTP id w144so45708380wmw.0
        for <linux-crypto@vger.kernel.org>; Tue, 17 Nov 2015 13:47:11 -0800 (PST)
In-Reply-To: <20151117134251.GA9363@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

On 17 November 2015 at 14:42, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>> Add two dummy methods that are required by the crypto API internals:
>> .ctxsize and .init
>> (just because the framework calls them without checking if they were
>> provided).  They're only required by the complicated code path needed to
>> instantiate a template algorithm.  Also expose crypto_akcipher_type like
>> other crypto types are exposed to be used from outside modules.
>>
>> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>
>
> Nack.  They are only required if you use obsolete methods of creating
> a tfm.

Will you then accept a patch to add a cra_u.akcipher to struct
crypto_alg?  I see shash/ahash use one method to create instances and
blkcipher use another.  I have no way to know which of them is
"obsolete" (possibly both) and that was the reason for sending an RFC
first.

Best regards
