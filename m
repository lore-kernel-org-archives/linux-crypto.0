From: Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH net-next v6 19/23] zinc: Curve25519 ARM implementation
Date: Tue, 2 Oct 2018 23:35:35 +0200
Message-ID: <CAFLxGvwUP6+tfOr0NrM6vFs6NGepDz+MKPNnQWA+gO2k2mdPqw@mail.gmail.com>
References: <20180925145622.29959-1-Jason@zx2c4.com> <20180925145622.29959-20-Jason@zx2c4.com>
 <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>, sneves@dei.uc.pt,
        Andy Lutomirski <luto@kernel.org>,
        jeanphilippe.aumasson@gmail.com,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9FLDRLxHReKcveZYHNYerR5Y2pZd9gn-hWrU0jb2KgfA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ard,

On Tue, Oct 2, 2018 at 7:06 PM Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> I guess qhasm means generated code, right?

Yes.
Please see: http://cr.yp.to/qhasm.html

It generates code from a q-file (the "template").
Actually it is a rather powerful tool, but as you noticed, sometimes
the code is not perfect.

-- 
Thanks,
//richard
