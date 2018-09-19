From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 04/20] zinc: ChaCha20 x86_64 implementation
Date: Wed, 19 Sep 2018 13:33:24 +0200
Message-ID: <CAHmME9qEBz3bz0i5hENwSzGy5M+UVjYXGRnWcQtVpmjEUrMNZQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-5-Jason@zx2c4.com>
 <alpine.DEB.2.21.1809190017050.1468@nanos.tec.linutronix.de>
 <CAHmME9oARODJsrDbcNK7A22KrTRJP945hj9+oCJtQM6OjGF4Ag@mail.gmail.com> <alpine.DEB.2.21.1809190802160.1468@nanos.tec.linutronix.de>
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
        X86 ML <x86@kernel.org>,
        Kate Stewart <kstewart@linuxfoundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809190802160.1468@nanos.tec.linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Thomas,

On Wed, Sep 19, 2018 at 8:13 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> Subset? Not really. Both MIT and BSD3-Clause are GPL2.0 compatible
> licenses. And if your intention is to have those files MIT/BSD only, yes
> then the single license identifier is the right thing. If you want it dual
> licensed then it should be expressed there clearly.

I always thought "GPL2 compatible" was the same as "subset" because of
the restrictions clause of GPL2. But IANAL, so for the avoidance of
doubt I'll take your advice and put both.

Jason
