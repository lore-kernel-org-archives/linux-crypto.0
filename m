From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 05/17] zinc: ChaCha20 x86_64 implementation
Date: Tue, 11 Sep 2018 15:12:14 -0600
Message-ID: <CAHmME9qPk7iOVspOJOhN0M+C=v+i6GNq9XkDnXXJ=puoFV0Gfg@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-6-Jason@zx2c4.com>
 <alpine.DEB.2.21.1809111021250.5110@nanos.tec.linutronix.de>
 <CAEX_ruFFWsW897DuFEbz9+6av02bMwDgiA9GxV+=SBtyKG7LJw@mail.gmail.com> <alpine.DEB.2.21.1809111106420.5110@nanos.tec.linutronix.de>
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
In-Reply-To: <alpine.DEB.2.21.1809111106420.5110@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hey Thomas,

On Tue, Sep 11, 2018 at 3:09 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> > This is covered on the 02/17 commit message, whose relevant paragraph follows:
> Well, being only cc'ed on only half of the patches does not really help.

Sorry about that. I'm happy to Cc you on the whole series for next
round if you want. Just let me know. In the meantime:

https://patchwork.ozlabs.org/project/netdev/list/?series=65056
https://lore.kernel.org/lkml/20180911010838.8818-1-Jason@zx2c4.com/T/

Regards,
Jason
