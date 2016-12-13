From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Tue, 13 Dec 2016 08:40:00 -0800
Message-ID: <CALCETrWsTKq0NOpwiJtB50OU7w99-m82NhPG_Uxs2Fqbpz0LLA@mail.gmail.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org> <063D6719AE5E284EB5DD2968C1650D6DB023CA99@AcuExch.aculab.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: David Laight <David.Laight@aculab.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6DB023CA99@AcuExch.aculab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[add some people who might know]

On Tue, Dec 13, 2016 at 4:20 AM, David Laight <David.Laight@aculab.com> wrote:
> From: Andy Lutomirski
>> Sent: 12 December 2016 20:53
>> The driver put a constant buffer of all zeros on the stack and
>> pointed a scatterlist entry at it in two places.  This doesn't work
>> with virtual stacks.  Use a static 16-byte buffer of zeros instead.
> ...
>
> I didn't think you could dma from static data either.

According to lib/dma-debug.c, you can't dma to or from kernel text or
rodata, but you can dma to or from kernel bss or data.  So
empty_zero_page should be okay, because it's not rodata right now.

But I think this is rather silly.  Joerg, Linus, etc: would it be okay
to change lib/dma-debug.c to allow DMA *from* rodata?  After all,
rodata is ordinary memory, is backed by struct page, etc.  And DMA
from the zero page had better be okay because I think it happens if
you mmap some zeros, don't write to them, and then direct I/O them to
a device.  Then I could also move empty_zero_page to rodata.

--Andy
