From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64 implementations
Date: Wed, 26 Sep 2018 17:25:48 +0200
Message-ID: <CAHmME9pm0tsW7ou-M811nsoN0pk2Tb49pH2b0Fzzq_ae6zHR4g@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com> <20180926143614.GL1676@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Samuel Neves <sneves@dei.uc.pt>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926143614.GL1676@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 26, 2018 at 4:36 PM Andrew Lunn <andrew@lunn.ch> wrote:
> The wireguard interface claims it is GSO capable. This means the
> network stack will pass it big chunks of data and leave it to the
> network interface to perform the segmentation into 1500 byte MTU
> frames on the wire. I've not looked at how wireguard actually handles
> these big chunks. But to get maximum performance, it should try to
> keep them whole, just add a header and/or trailer. Will wireguard pass
> these big chunks of data to the crypto code? Do we now have 64K blocks
> being worked on? Does the latency jump from 4K to 64K? That might be
> new, so the existing state of the tree does not help you here.

No, it only requests GSO superpackets so that it can group the pieces
and encrypt them on the same core. But they're each encrypted
separately (broken up immediately after ndo_start_xmit), and so they
wind up being ~1420 bytes each to encrypt. I spoke about this at
netdev2.2 if you're interested in the architecture; there's a paper:

https://www.wireguard.com/papers/wireguard-netdev22.pdf
https://www.youtube.com/watch?v=54orFwtQ1XY
https://www.wireguard.com/talks/netdev2017-slides.pdf
