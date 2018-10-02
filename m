From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 04/23] zinc: ChaCha20 x86_64 implementation
Date: Tue, 2 Oct 2018 03:07:45 +0200
Message-ID: <CAHmME9pGBnCFCd-dTi932FwR49fRyKt7fdBH9YixbhRQ1a+nhw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-5-Jason@zx2c4.com>
 <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
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
        Andy Polyakov <appro@openssl.org>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        X86 ML <x86@kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9aOiYdEzHHrHFHUFK=hNfeS=zEsvMe9OWD8hEdAYkffg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Ard,

On Fri, Sep 28, 2018 at 5:47 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> > While this is CRYPTOGAMS code, the originating code for this happens to
> > be the same as OpenSSL's commit cded951378069a478391843f5f8653c1eb5128da
> >
>
> I'd still prefer the kernel side changes to be presented as a separate
> followup patch

I've restructured things for the MIPS64 and x86_64 and it will be as
you've asked for v7.

Jason
