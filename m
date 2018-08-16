From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Wed, 15 Aug 2018 23:31:11 -0700
Message-ID: <CAHmME9rtrnaU1LHM_dZ1WNw-Td4UhOz0kjmqb-e-0ykOnW7XyA@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain> <CAHmME9pbwj0RaX4YM9epGOSgDRNUt=GA4UzO_iKcW=Md7kG6JQ@mail.gmail.com>
 <20180814211229.GB24575@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers3@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lutomirski <luto@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        "Daniel J . Bernstein" <djb@cr.yp.to>,
        Tanja Lange <tanja@hyperelliptic.org>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Karthikeyan Bhargavan <karthik.bhargavan@gmail.com>
To: Eric Biggers <ebiggers@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180814211229.GB24575@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Eric,

On Tue, Aug 14, 2018 at 2:12 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On ARM Cortex-A7, OpenSSL's ChaCha20 implementation is 13.9 cpb (cycles per
> byte), whereas Linux's is faster: 11.9 cpb.
>
> The reason Linux's ChaCha20 NEON implementation is faster than OpenSSL's
>
> I understand there are tradeoffs, and different implementations can be faster on
> different CPUs.
>
> So if your proposal goes in, I'd likely need to write a patch
> to get the old performance back, at least on Cortex-A7...

Yes, absolutely. Different CPUs behave differently indeed, but if you
have improvements for hardware that matters to you, we should
certainly incorporate these, and also loop Andy Polyakov in (I've
added him to the CC for the WIP v2). ChaCha is generally pretty
obvious, but for big integer algorithms -- like Poly1305 and
Curve25519 -- I think it's all the more important to involve Andy and
the rest of the world in general, so that Linux benefits from bug
research and fuzzing in places that are typically and classically
prone to nasty issues. In other words, let's definitely incorporate
your improvements after the patchset goes in, and at the same time
we'll try to bring Andy and others into the fold, where our
improvements can generally track each others.

> Also, I don't know whether Andy P. considered the 4xNEON implementation
> technique.  It could even be fastest on other ARM CPUs too, I don't know.

After v2, when he's CC'd in, let's plan to start discussing this with him.

Jason
