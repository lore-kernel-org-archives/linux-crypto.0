From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 19/23] zinc: Curve25519 ARM implementation
Date: Wed, 3 Oct 2018 05:10:56 +0200
Message-ID: <CAHmME9ojGATK+AcFLL2Fij_7XCW-=HBzjtkRqiitCH=p5=8KEA@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-20-Jason@zx2c4.com>
 <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
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
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Oct 2, 2018 at 6:59 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> Could you elaborate on what qhasm is exactly? And, as with the other
> patches, I would prefer it if we could have your changes as a separate
> patch (although having the qhasm base would be preferred)

By the way, as of a few minutes ago, if you look in the development
tree at the commit called "zinc: Curve25519 ARM implementation", that
now shows the diffs to the original, as you requested. I'll probably
obsess over that a little bit more before v7, but if you see anything
gnarly there beforehand, I'd be happy to hear.

Jason
