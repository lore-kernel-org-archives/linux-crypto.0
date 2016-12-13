From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH] keys/encrypted: Fix two crypto-on-the-stack bugs
Date: Tue, 13 Dec 2016 09:02:07 -0800
Message-ID: <CALCETrVbEhxRWFmgrePeLriQU5J6ZZaN15tTAYja1hJwYFrRpg@mail.gmail.com>
References: <8c273c9c41f51b34bb3115086f1d776895580637.1481575835.git.luto@kernel.org>
 <e958f214e8885968be8045ffde813ac339b81178.1481575835.git.luto@kernel.org>
 <063D6719AE5E284EB5DD2968C1650D6DB023CA99@AcuExch.aculab.com>
 <CALCETrWsTKq0NOpwiJtB50OU7w99-m82NhPG_Uxs2Fqbpz0LLA@mail.gmail.com> <2661.1481647538@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Laight <David.Laight@aculab.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andy Lutomirski <luto@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        Eric Biggers <ebiggers3@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Stephan Mueller <smueller@chronox.de>
To: David Howells <dhowells@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2661.1481647538@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 13, 2016 at 8:45 AM, David Howells <dhowells@redhat.com> wrote:
> Andy Lutomirski <luto@amacapital.net> wrote:
>
>> After all, rodata is ordinary memory, is backed by struct page, etc.
>
> Is that actually true?  I thought some arches excluded the kernel image from
> the page struct array to make the array consume less memory.

I don't know whether you're right, but that sounds a bit silly to me.
This is a *tiny* amount of memory.

But there's yet another snag.  Alpha doesn't have empty_zero_page --
it only has ZERO_PAGE.  I could do page_address(ZERO_PAGE(0))...

--Andy
