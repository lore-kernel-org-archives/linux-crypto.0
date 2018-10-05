From: Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH net-next v6 00/23] WireGuard: Secure Network Tunnel
Date: Fri, 05 Oct 2018 15:53:07 +0200
Message-ID: <7854782.OKhPC64esT@blindfold>
References: <CAKv+Gu-ZMR7zEAKv6_2tyD3OqnjVugOzKHzBEXW3pQs5W-SvLw@mail.gmail.com> <CAFLxGvw154vyOziRKuFf5-XTa1NcQm5ZVmgUy3=F79k=Rw2dvA@mail.gmail.com> <CAHmME9rdkAG6mvkUMy9J5+8U9BQkrym7WmmtmK6o3nudykWLoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rdkAG6mvkUMy9J5+8U9BQkrym7WmmtmK6o3nudykWLoA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Freitag, 5. Oktober 2018, 15:46:29 CEST schrieb Jason A. Donenfeld:
> On Fri, Oct 5, 2018 at 3:38 PM Richard Weinberger
> <richard.weinberger@gmail.com> wrote:
> > So we will have two competing crypo stacks in the kernel?
> > Having a lightweight crypto API is a good thing but I really don't like the idea
> > of having zinc parallel to the existing crypto stack.
> 
> No, as you've seen in this patchset, the dynamic dispatch crypto API
> can trivially be done on top of Zinc. So each time we introduce a new
> primitive to Zinc that's also in the dynamic dispatch API, we
> reimplement the current crypto API in terms of Zinc. Check out the two
> patches in this series that do this; it's quite clean and sleek.

This is why I was asking. Your statement and the code didn't match for me.
 
> > And I strongly vote that Herbert Xu shall remain the maintainer of the whole
> > crypto system (including zinc!) in the kernel.
> 
> No, sorry, we intend to maintain the code we've written. But I am
> amenable to taking a tree-route into upstream based on whatever makes
> most sense with merge conflicts and such.
 
So, you will be a sub-maintainer below Herbert's crypto, that's fine.
What you wrote sounded like a parallel world...

Thanks,
//richard
