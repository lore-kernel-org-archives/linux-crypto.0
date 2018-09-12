From: Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography
 library
Date: Wed, 12 Sep 2018 11:34:44 -0700
Message-ID: <20180912183444.GB222557@gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com>
 <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911220849.GC81235@gmail.com>
 <CAHmME9rxrC+CAR-xoXd-bZO1HYZ+TjvT_K4xgQwWXE53zi61xQ@mail.gmail.com>
 <CAKv+Gu9ZjX3A4bHHgRAkJtr+SKwti+d3dwE0fhGtmeQB_refqw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9ZjX3A4bHHgRAkJtr+SKwti+d3dwE0fhGtmeQB_refqw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Sep 12, 2018 at 08:19:21PM +0200, Ard Biesheuvel wrote:
> On 12 September 2018 at 20:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> > Hi Eric,
> >
> > On Wed, Sep 12, 2018 at 12:08 AM Eric Biggers <ebiggers@kernel.org> wrote:
> >> I'd strongly prefer the assembly to be readable too.  Jason, I'm not sure if
> >> you've actually read through the asm from the OpenSSL implementations, but the
> >> generated .S files actually do lose a lot of semantic information that was in
> >> the original .pl scripts.
> >
> > The thing to keep in mind is that the .S was not directly and blindly
> > generated from the .pl. We started with the output of the .pl, and
> > then, particularly in the case of x86_64, worked with it a lot, and
> > now it's something a bit different. We've definitely spent a lot of
> > time reading that assembly.
> >
> 
> Can we please have those changes as a separate patch? Preferably to
> the .pl file rather than the .S file, so we can easily distinguish the
> code from upstream from the code that you modified.
> 
> > I'll see if I can improve the readability with some register name
> > remapping on ARM. No guarantees, but I'll play a bit and see if I can
> > make it a bit better.
> >
> > Jason

FWIW, yesterday I made a modified version of poly1305-armv4.pl that generates an
asm file that works in kernel mode.  The changes are actually pretty small, and
I think we can get them upstream into OpenSSL like they were for sha256-armv4.pl
and sha512-armv4.pl.  I'll start a thread with Andy Polyakov and you two.

But I don't have time to help with all the many OpenSSL asm files Jason is
proposing, just maybe poly1305-armv4 and chacha-armv4 for now.

- Eric
