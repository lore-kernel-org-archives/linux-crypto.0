From: Abel Vesa <abelvesa@linux.com>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Sat, 29 Sep 2018 11:27:29 +0300
Message-ID: <20180929082729.GA22116@ryzen>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-5-Jason@zx2c4.com>
 <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
 <CAHmME9rc5zgN4HhBy0_oq+EbEXdS8nePzA7qW39nocx_y4ay1Q@mail.gmail.com>
 <20180929075601.GA11115@zn.tnic>
 <CAKv+Gu_jawg7R1n0qz75=H16J+WNx4aRhEsAt2WMNUkPAhD2og@mail.gmail.com>
 <20180929081118.GB11115@zn.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, X86 ML <x86@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180929081118.GB11115@zn.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 18-09-29 10:11:18, Borislav Petkov wrote:
> On Sat, Sep 29, 2018 at 10:00:29AM +0200, Ard Biesheuvel wrote:
> > Note that this is the author of the *patch* not necessarily the author
> > of the code.
> > 
> > Anyone is free to submit patches adding code authored by others as
> > long as the author has made it available under a suitable license, and
> > this is actually the whole point of the S-o-B: you are stating to the
> > next guy that the code included in your patch was made available to
> > you under a compatible license.
> 
> ... and the actual author could be named with Originally-by or
> Co-Developed-by:, and even in free text in the commit message.

Or you could just put the original author as the first S-o-b and then
another (second) S-o-b line where you put yourself as a submitter.

AFAIK, that's how people usually do it.

> 
> But the correct SOB chain denoting who handled the patch on its way up,
> is important.
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> Good mailing practices for 400: avoid top-posting and trim the reply.
