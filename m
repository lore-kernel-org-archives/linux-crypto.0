From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Fri, 28 Sep 2018 17:04:29 +0200
Message-ID: <CAHmME9oO1kYP7e1RMz5xm8-bKBJY4vutQ3NROBqhb_GzOJaVBw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <20180927011526.GB1193@lunn.ch> <CAHmME9q7WRGF3TTRhhy0i_EB4ad2DaSD=tnHM92zfV4Cckyw=A@mail.gmail.com>
 <20180928150117.GA19396@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180928150117.GA19396@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 28, 2018 at 5:01 PM Andrew Lunn <andrew@lunn.ch> wrote:
> The namespace is more than just about the linker. I see an Opps stack
> trace with wg_ symbols, i know i need to talk to Jason. Without any
> prefix, i have to go digging into the code to find out who i need to
> talk to. This is one reason why often every symbol has the prefix, not
> just the global scope ones.

Good point. I'll see what the wg_ prefixing looks like for all the
static functions too.
