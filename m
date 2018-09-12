From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Wed, 12 Sep 2018 20:19:21 +0200
Message-ID: <CAKv+Gu9ZjX3A4bHHgRAkJtr+SKwti+d3dwE0fhGtmeQB_refqw@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
 <20180911220849.GC81235@gmail.com> <CAHmME9rxrC+CAR-xoXd-bZO1HYZ+TjvT_K4xgQwWXE53zi61xQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Eric Biggers <ebiggers@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rxrC+CAR-xoXd-bZO1HYZ+TjvT_K4xgQwWXE53zi61xQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 12 September 2018 at 20:16, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hi Eric,
>
> On Wed, Sep 12, 2018 at 12:08 AM Eric Biggers <ebiggers@kernel.org> wrote:
>> I'd strongly prefer the assembly to be readable too.  Jason, I'm not sure if
>> you've actually read through the asm from the OpenSSL implementations, but the
>> generated .S files actually do lose a lot of semantic information that was in
>> the original .pl scripts.
>
> The thing to keep in mind is that the .S was not directly and blindly
> generated from the .pl. We started with the output of the .pl, and
> then, particularly in the case of x86_64, worked with it a lot, and
> now it's something a bit different. We've definitely spent a lot of
> time reading that assembly.
>

Can we please have those changes as a separate patch? Preferably to
the .pl file rather than the .S file, so we can easily distinguish the
code from upstream from the code that you modified.

> I'll see if I can improve the readability with some register name
> remapping on ARM. No guarantees, but I'll play a bit and see if I can
> make it a bit better.
>
> Jason
