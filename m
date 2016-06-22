From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Doing crypto in small stack buffers (bluetooth vs vmalloc-stack
 crash, etc)
Date: Wed, 22 Jun 2016 16:45:46 -0700
Message-ID: <CALCETrXJAvtty-zrjZR0URyT92rMZ4HhiTLtd4r5CzFjZOj=-Q@mail.gmail.com>
References: <CALCETrVJzzKkRsSbgsUmVd_+ArKEgoRSVdG1tVp7CXzFoPyVgA@mail.gmail.com>
 <20160622004214.GA27134@gondor.apana.org.au> <CALCETrUnzasc+c5Dxmw+g6U07dTNU4RF0ug1bHj8j2en+7Xj1A@mail.gmail.com>
 <CALCETrUWyNz91WO6O3dNb+YELeZy5q4+oTo6dLRR67P2WvBB8g@mail.gmail.com>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUWyNz91WO6O3dNb+YELeZy5q4+oTo6dLRR67P2WvBB8g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 22, 2016 at 2:48 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Jun 21, 2016 at 5:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Jun 21, 2016 at 5:42 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>>> On Tue, Jun 21, 2016 at 10:43:40AM -0700, Andy Lutomirski wrote:
>>>>
>>>> Is there a straightforward way that bluetooth and, potentially, other
>>>> drivers can just do synchronous crypto in a small buffer specified by
>>>> its virtual address?  The actual cryptography part of the crypto code
>>>> already works this way, but I can't find an API for it.
>>>
>>> Yes, single block users should use crypto_cipher_encrypt_one, an
>>> example would be drivers/md/dm-crypt.c.
>>>
>>
>> Aha!  I expected something like that to exist, but I couldn't find it.
>> I'll change the two offenders I've found so far to use it.
>>
>
> Before I do this, can you explain what the difference is between
> crypto_cipher and crypto_skcipher?  net/bluetooth/smp.c currently uses
> crypto_alloc_skcipher, which you added in:
>
> commit 71af2f6bb22a4bf42663e10f1d8913d4967ed07f
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sun Jan 24 21:18:30 2016 +0800
>
>     Bluetooth: Use skcipher and hash
>
> Am I just supposed to replace "skcipher" with "cipher" everywhere?

It looks like I'm supposed to that and to use "aes" instead of "ebc(aes)".

*However*, the other offender I've found (net/rxrpc/rxkad.c) uses
"pcbc(fcrypt)", which doesn't appear to be usable with this API.  Is
there no way to say "I want synchronous crypto on this VA range" using
the skcipher API?

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
