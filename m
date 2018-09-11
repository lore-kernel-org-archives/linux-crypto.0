From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 05/17] zinc: ChaCha20 x86_64 implementation
Date: Tue, 11 Sep 2018 16:04:16 -0600
Message-ID: <CAHmME9r_Lw_nQAF9-dsWtJ3-Jx3pspsp0M2KUztRVfrgJYVMZA@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-6-Jason@zx2c4.com>
 <alpine.DEB.2.21.1809111021250.5110@nanos.tec.linutronix.de>
 <CAEX_ruFFWsW897DuFEbz9+6av02bMwDgiA9GxV+=SBtyKG7LJw@mail.gmail.com>
 <alpine.DEB.2.21.1809111106420.5110@nanos.tec.linutronix.de>
 <CAHmME9qPk7iOVspOJOhN0M+C=v+i6GNq9XkDnXXJ=puoFV0Gfg@mail.gmail.com> <20180911214837.GB81235@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Samuel Neves <sneves@dei.uc.pt>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Andy Polyakov <appro@openssl.org>, mingo@redhat.com,
        X86 ML <x86@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180911214837.GB81235@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Sep 11, 2018 at 3:48 PM Eric Biggers <ebiggers@kernel.org> wrote:
> Please Cc linux-crypto on the whole patch series, including the cover letter.

Ack.
