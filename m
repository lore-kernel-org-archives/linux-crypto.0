From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 04/20] zinc: ChaCha20 x86_64 implementation
Date: Wed, 19 Sep 2018 04:14:31 +0200
Message-ID: <CAHmME9oARODJsrDbcNK7A22KrTRJP945hj9+oCJtQM6OjGF4Ag@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-5-Jason@zx2c4.com>
 <alpine.DEB.2.21.1809190017050.1468@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>, mingo@redhat.com,
        X86 ML <x86@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809190017050.1468@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Thomas,

On Wed, Sep 19, 2018 at 12:30 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> I'm a bit confused by this SOB chain. So above you write that it's from
> Andy Polakovs implementation and Samuel did the changes. But here it seems
> you are the main author. If Samuel just did some modifications then you
> want to use the Co-developed-by tag along with his SOB.

Thanks, I'll use that tag.

>
> Also I'd recommend to add a Originally-by or Based-on-code-from: Andy
> Polyakov tag. Both are not formal tags but widely in use for attributions.

Great idea.

>
> > +++ b/lib/zinc/chacha20/chacha20-x86_64-glue.h
> > @@ -0,0 +1,100 @@
> > +/* SPDX-License-Identifier: MIT
>
> Please put that into a separate one liner comment. Also this should be
> 'GPL-2.0[+] or MIT' I think.

I had that originally, but changed it to just MIT, since MIT is a
subset of GPL-2.0. And looking at tree repo, it appears this is what
others do too.

Jason
