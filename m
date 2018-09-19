From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v5 20/20] net: WireGuard secure network tunnel
Date: Wed, 19 Sep 2018 04:04:01 +0200
Message-ID: <CAHmME9rwVLu+H88Nq+kGaVfZsZjoVUM_SdosjSRRpreUd2uGuQ@mail.gmail.com>
References: <20180918161646.19105-1-Jason@zx2c4.com> <20180918161646.19105-21-Jason@zx2c4.com>
 <20180918233411.GB17466@lunn.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Andrew Lunn <andrew@lunn.ch>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180918233411.GB17466@lunn.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Andrew,

On Wed, Sep 19, 2018 at 1:34 AM Andrew Lunn <andrew@lunn.ch> wrote:
> I see this BUG_ON() is still here. It really needs to be removed. It
> does not look like you need to crash the kernel here. Can you add in a
> test of len >= 128, do a WARN and then return. I think you then leak
> some memory, but i would much prefer that to a crashed machine.

Sure, I'll change it to that.

Regards,
Jason
