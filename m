From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 23/23] net: WireGuard secure network tunnel
Date: Fri, 28 Sep 2018 03:09:56 +0200
Message-ID: <CAHmME9q72YbkM5FsZMf-KR32pOXa6n=pHVYGnRmkxYk19tZ4CQ@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-24-Jason@zx2c4.com>
 <20180927011526.GB1193@lunn.ch> <CAHmME9q7WRGF3TTRhhy0i_EB4ad2DaSD=tnHM92zfV4Cckyw=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9q7WRGF3TTRhhy0i_EB4ad2DaSD=tnHM92zfV4Cckyw=A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 28, 2018 at 12:37 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Will do. v7 will include the wg_ prefix.

$ nm *.o | while read a b c; do [[ $b == T ]] && echo $c; done | grep -v ^wg_
cleanup_module
init_module

Success.
