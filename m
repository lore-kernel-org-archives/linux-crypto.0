From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Sat, 29 Sep 2018 09:56:01 +0200
Message-ID: <20180929075601.GA11115@zn.tnic>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-5-Jason@zx2c4.com>
 <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
 <CAHmME9rc5zgN4HhBy0_oq+EbEXdS8nePzA7qW39nocx_y4ay1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        X86 ML <x86@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9rc5zgN4HhBy0_oq+EbEXdS8nePzA7qW39nocx_y4ay1Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Sep 29, 2018 at 04:01:53AM +0200, Jason A. Donenfeld wrote:
> I was wondering about the ordering of these, actually. I've seen s-o-b
> on top and s-o-b on bottom of the cc list in lots of commits and
> haven't yet divined the One True Position.

Documentation/process/submitting-patches.rst

section 12, first sentence.

The SOB chain needs to clearly express the path of the patch from
author(s) to the upstream kernel.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
