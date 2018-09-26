From: Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v6 07/23] zinc: ChaCha20 ARM and ARM64
 implementations
Date: Wed, 26 Sep 2018 16:36:14 +0200
Message-ID: <20180926143614.GL1676@lunn.ch>
References: <20180925145622.29959-1-Jason@zx2c4.com>
 <20180925145622.29959-8-Jason@zx2c4.com>
 <CAKv+Gu9mVAfdBvOMCFqRJj+wBiWu3JVOgPZdkcdjzqSdQQ5Jrw@mail.gmail.com>
 <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHmME9r9KppoFwwNVpzpYbU+9dCPzb7Pit+4iRa4MY_ouJBWrA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> > Also, this still has unbounded worst case scheduling latency, given
> > that the outer library function passes its entire input straight into
> > the NEON routine.
> 
> The vast majority of crypto routines in arch/*/crypto/ follow this
> same exact pattern, actually. I realize a few don't -- probably the
> ones you had a hand in :) -- but I think this is up to the caller to
> handle. I made a change so that in chacha20poly1305.c, it calls
> simd_relax after handling each scatter-gather element, so a
> "construction" will handle this gracefully. But I believe it's up to
> the caller to decide on what sizes of information it wants to pass to
> primitives. Put differently, this also hasn't ever been an issue
> before -- the existing state of the tree indicates this -- and so I
> don't anticipate this will be a real issue now. And if it becomes one,
> this is something we can address *later*, but certainly there's no use
> of adding additional complexity to the initial patchset to do this
> now.

Hi Jason

This is not my area of expertise, so you should verify what i'm say
here...

My guess is, IPSEC will mostly ask the crypto code to work on 1500
byte full MTU packets and 64 byte TCP ACK packets. Disk encryption i
guess works on 4K blocks. So these requests are all quite small,
keeping the latency reasonably bounded.

The wireguard interface claims it is GSO capable. This means the
network stack will pass it big chunks of data and leave it to the
network interface to perform the segmentation into 1500 byte MTU
frames on the wire. I've not looked at how wireguard actually handles
these big chunks. But to get maximum performance, it should try to
keep them whole, just add a header and/or trailer. Will wireguard pass
these big chunks of data to the crypto code? Do we now have 64K blocks
being worked on? Does the latency jump from 4K to 64K? That might be
new, so the existing state of the tree does not help you here.

   Andrew
