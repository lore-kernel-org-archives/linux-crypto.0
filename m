From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 20/20] net: WireGuard secure network tunnel
Date: Sun, 16 Sep 2018 01:14:56 +0200
Message-ID: <CAHmME9oHC-DZqC8RQnboFyTDwL+bZX4KFX9JJkV1KiRgdeOQ8A@mail.gmail.com>
References: <20180914162240.7925-21-Jason@zx2c4.com> <201809160630.4PzV0pYM%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: kbuild-all@01.org, LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201809160630.4PzV0pYM%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Mr. Ro Bot,

On Sun, Sep 16, 2018 at 12:19 AM kbuild test robot <lkp@intel.com> wrote:
>    drivers/net/wireguard/send.c: In function 'packet_encrypt_worker':
> >> drivers/net/wireguard/send.c:320:1: warning: the frame size of 1136 bytes is larger than 1024 bytes [-Wframe-larger-than=]
>     }

Thanks, fixed for v5.

Jason
