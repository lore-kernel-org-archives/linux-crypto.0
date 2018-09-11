From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 05/17] zinc: ChaCha20 x86_64 implementation
Date: Tue, 11 Sep 2018 15:28:35 -0600
Message-ID: <CAHmME9rr=OtFTmNWPdSY2OtRkSvCPpkq_HuS3LO1dL4n96rzOQ@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-6-Jason@zx2c4.com>
 <alpine.DEB.2.21.1809111021250.5110@nanos.tec.linutronix.de>
 <CAEX_ruFFWsW897DuFEbz9+6av02bMwDgiA9GxV+=SBtyKG7LJw@mail.gmail.com>
 <alpine.DEB.2.21.1809111106420.5110@nanos.tec.linutronix.de>
 <CAHmME9qPk7iOVspOJOhN0M+C=v+i6GNq9XkDnXXJ=puoFV0Gfg@mail.gmail.com> <alpine.DEB.2.21.1809112322060.1427@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Samuel Neves <sneves@dei.uc.pt>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>, mingo@redhat.com,
        X86 ML <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809112322060.1427@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 3:27 PM Thomas Gleixner <tglx@linutronix.de> wrote:
> Na, all good. I'm fine with the answer and reviewing that ASM maze is way
> over my limited crypto knowledge anyway. I definitely would enjoy
> refreshing the math behind it, but that surely would be way outside of your
> envisioned time frame for getting this merged :)

Well, if you're at LPC, we can nerd out a bit on some crypto math if
you want. :-P
