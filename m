From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Fri, 5 Oct 2018 15:46:29 +0200
Message-ID: <CAHmME9rdkAG6mvkUMy9J5+8U9BQkrym7WmmtmK6o3nudykWLoA@mail.gmail.com>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com>
 <20181002033908.324yhwqaohfsq65d@gondor.apana.org.au> <CAHmME9piX1kbUhOBcUKVdecr45EjxuruxYuMTepfXVvRrkVmyg@mail.gmail.com>
 <CAKv+Gu8fr_qADiTJH05nVWF7Yi3U722nfKJsMaRE9CP3YjNBbg@mail.gmail.com>
 <CAHmME9r6-DHLwePQGBGcnPUZuZgZ2GtSUX9arsWzLqhKxd=uDA@mail.gmail.com>
 <20181003064951.GC745@sol.localdomain> <CAHmME9ogY=v2Le85+_=-m++RwAzwiUmKyNzx6N2y9Ht-J7xBcQ@mail.gmail.com>
 <CAFLxGvw154vyOziRKuFf5-XTa1NcQm5ZVmgUy3=F79k=Rw2dvA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard.weinberger@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFLxGvw154vyOziRKuFf5-XTa1NcQm5ZVmgUy3=F79k=Rw2dvA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 5, 2018 at 3:38 PM Richard Weinberger
<richard.weinberger@gmail.com> wrote:
> So we will have two competing crypo stacks in the kernel?
> Having a lightweight crypto API is a good thing but I really don't like the idea
> of having zinc parallel to the existing crypto stack.

No, as you've seen in this patchset, the dynamic dispatch crypto API
can trivially be done on top of Zinc. So each time we introduce a new
primitive to Zinc that's also in the dynamic dispatch API, we
reimplement the current crypto API in terms of Zinc. Check out the two
patches in this series that do this; it's quite clean and sleek.

> And I strongly vote that Herbert Xu shall remain the maintainer of the whole
> crypto system (including zinc!) in the kernel.

No, sorry, we intend to maintain the code we've written. But I am
amenable to taking a tree-route into upstream based on whatever makes
most sense with merge conflicts and such.
