From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH net-next v5 04/20] zinc: ChaCha20 x86_64 implementation
Date: Wed, 19 Sep 2018 08:13:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809190802160.1468@nanos.tec.linutronix.de>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-5-Jason@zx2c4.com> <alpine.DEB.2.21.1809190017050.1468@nanos.tec.linutronix.de> <CAHmME9oARODJsrDbcNK7A22KrTRJP945hj9+oCJtQM6OjGF4Ag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>, mingo@redhat.com,
        X86 ML <x86@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9oARODJsrDbcNK7A22KrTRJP945hj9+oCJtQM6OjGF4Ag@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Jason,

On Wed, 19 Sep 2018, Jason A. Donenfeld wrote:
> On Wed, Sep 19, 2018 at 12:30 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > > +++ b/lib/zinc/chacha20/chacha20-x86_64-glue.h
> > > @@ -0,0 +1,100 @@
> > > +/* SPDX-License-Identifier: MIT
> >
> > Please put that into a separate one liner comment. Also this should be
> > 'GPL-2.0[+] or MIT' I think.
> 
> I had that originally, but changed it to just MIT, since MIT is a
> subset of GPL-2.0. And looking at tree repo, it appears this is what
> others do too.

Subset? Not really. Both MIT and BSD3-Clause are GPL2.0 compatible
licenses. And if your intention is to have those files MIT/BSD only, yes
then the single license identifier is the right thing. If you want it dual
licensed then it should be expressed there clearly.

Thanks,

	tglx
