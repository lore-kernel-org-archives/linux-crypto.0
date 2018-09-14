From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v4 00/20] WireGuard: Secure Network Tunnel
Date: Fri, 14 Sep 2018 19:47:18 +0200
Message-ID: <CAHmME9phjkOuODQEUXp=ZZLGDg3ypUPRr6YYPsMDgfvAdNcznA@mail.gmail.com>
References: <20180914161954.7325-1-Jason@zx2c4.com> <CAKv+Gu_LYsNs88uF4+G1xfOtWvNPOjiiYZKqZf7qSBkvn6iEoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu_LYsNs88uF4+G1xfOtWvNPOjiiYZKqZf7qSBkvn6iEoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Sep 14, 2018 at 7:40 PM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> >   - Move away from makefile ifdef maze and instead prefer kconfig values,
> >     which also makes the design a bit more modular too, which could help
> >     in the future.
>
> Could you elaborate on this? From the patches, it is not clear to me
> how this has improved.

Feature detection was prior done as a confusing set of ifeq and
ifdefs. Instead, I've now put the logic for this into the kconfig,
which makes the makefiles and header files a bit simpler. This also
makes it easier to later on modularize Zinc itself if deemed
necessary.
