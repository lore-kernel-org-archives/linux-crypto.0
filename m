From: Andrzej Zaborowski <andrew.zaborowski@intel.com>
Subject: Re: [PATCH v3 3/4] crypto: akcipher: add akcipher declarations useful
 for templates.
Date: Tue, 24 Nov 2015 21:54:57 +0100
Message-ID: <CAOq732LT4JoBzHv3Jd=ZXzWkU+LMc1Zmqv4WvM4K4X5LRps3ow@mail.gmail.com>
References: <1447989215-523-3-git-send-email-andrew.zaborowski@intel.com>
	<20151124095408.GA315@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34172 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbbKXUy7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Nov 2015 15:54:59 -0500
Received: by wmvv187 with SMTP id v187so228500885wmv.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2015 12:54:57 -0800 (PST)
In-Reply-To: <20151124095408.GA315@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 24 November 2015 at 10:54, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
>> Expose crypto_akcipher_type like other crypto types are exposed to be
>> used from outside akcipher.c.  Add a struct akcipher_instance similar to
>> aead_instance with just the right size for an akcipher template
>> instance, and two macros for converting to/from crypto_instance.
>
> You're still doing some things in the old way.  With new templates,
> you shouldn't need to export the crypto type at all.  Please look
> at how AEAD does it.

It doesn't need to export crypto_aead_type but instead needs to export
crypto_aead_grab and aead_register_instance.  I'll add those for
akcipher and resend then.  Would there be any point defining a
crypto_akcipher_spawn following the AEAD pattern?

Best regards
