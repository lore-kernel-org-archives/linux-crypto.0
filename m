From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [PATCH net-next v3 02/17] zinc: introduce minimal cryptography library
Date: Tue, 11 Sep 2018 15:22:13 -0600
Message-ID: <CAHmME9rTEFLaYmzFrc719LW2DWS2Ua_vL6by1UXZ9uDvMpbhYw@mail.gmail.com>
References: <20180911010838.8818-1-Jason@zx2c4.com> <20180911010838.8818-3-Jason@zx2c4.com>
 <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Lutomirski <luto@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Jean-Philippe Aumasson <jeanphilippe.aumasson@gmail.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu9nSeo4PFVrtjtqGQ32eqyxUp3xVCczZfu+dhFz5yLM0A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Ard,

I realize you've put a lot of good and hard work into the existing
crypto API, and that my writing in these commit messages might be a
bit too bristly and dismissive of that hard work. So I think in a
sense it's understandable that you've responded as such here. But
hopefully I can address your concerns. One thing to keep in mind is
that Zinc endeavors to provide the basis for simple and direct
functions to software algorithms. This is fairly modest goal. Just
some functions that do some stuff in software. Around these you'll
still be able to have complicated and impressive dynamic dispatch and
asynchronous mechanisms such as the present crypto API. Zinc is merely
getting the software implementation side done in a very simple and
direct way. So I don't think there's a good reason for so much
antagonism, despite a perhaps overbearing tone of my commit messages.
Rather, I expect that we'll wind up working together on this quite a
bit down the line.

> In spite of the wall of text, you fail to point out exactly why the
> existing AEAD API in unsuitable, and why fixing it is not an option.

I thought I had addressed this. Firstly, there's a need for more than
just AEAD, but ignoring that, the AEAD API is a big full API that does
lots of things, makes allocations, parses descriptors, and so forth.
I'm sure this kind of highly-engineered approach will continue to
improve over time in that highly engineered direction. Zinc is doing
something a bit different: it's providing a series of simple functions
for various cryptographic routines. This is a considerably different
goal -- perhaps even a complementary one -- to the AEAD API.

> I don't think you have
> convinced anyone else yet either.

Please only speak for yourself and refrain from rhetoric like this,
which is patently false.

> Please refrain from sending a v4 with just a couple of more tweaks on
> top

Sorry, no, I'm not going to stop working hard on this because you're
wary of a new approach. I will continue to improve the submission
until it is mergable, and I do not intend to stop.

Anyway, it sounds like this whole thing may have ruffled your feathers
a bit. Will you be at Linux Plumbers Conference in November? I'm
planning on attending, and perhaps we could find some time there to
sit down and talk one on one a bit.

Regards,
Jason
