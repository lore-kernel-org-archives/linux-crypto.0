From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Doing crypto in small stack buffers (bluetooth vs vmalloc-stack
 crash, etc)
Date: Tue, 21 Jun 2016 17:52:23 -0700
Message-ID: <CALCETrUnzasc+c5Dxmw+g6U07dTNU4RF0ug1bHj8j2en+7Xj1A@mail.gmail.com>
References: <CALCETrVJzzKkRsSbgsUmVd_+ArKEgoRSVdG1tVp7CXzFoPyVgA@mail.gmail.com>
 <20160622004214.GA27134@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>, linux-bluetooth@vger.kernel.org,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Gustavo Padovan <gustavo@padovan.org>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:36093 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbcFVA6A (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 20:58:00 -0400
Received: by mail-vk0-f46.google.com with SMTP id u64so42850908vkf.3
        for <linux-crypto@vger.kernel.org>; Tue, 21 Jun 2016 17:58:00 -0700 (PDT)
In-Reply-To: <20160622004214.GA27134@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jun 21, 2016 at 5:42 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jun 21, 2016 at 10:43:40AM -0700, Andy Lutomirski wrote:
>>
>> Is there a straightforward way that bluetooth and, potentially, other
>> drivers can just do synchronous crypto in a small buffer specified by
>> its virtual address?  The actual cryptography part of the crypto code
>> already works this way, but I can't find an API for it.
>
> Yes, single block users should use crypto_cipher_encrypt_one, an
> example would be drivers/md/dm-crypt.c.
>

Aha!  I expected something like that to exist, but I couldn't find it.
I'll change the two offenders I've found so far to use it.

--Andy
