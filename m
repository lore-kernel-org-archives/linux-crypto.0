From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v1 2/3] zinc: Introduce minimal cryptography library
Date: Tue, 7 Aug 2018 12:43:35 -0700
Message-ID: <CALCETrWo-vCt_bHMBPAEHEr3P4=AJq-95Bf=00aAEAcE839wLw@mail.gmail.com>
References: <20180801072246.GA15677@sol.localdomain> <CALCETrXD_VyoyW5C1U34o-ySJ4nFcO6PQ+ZNBVYxCpJ-f65CHw@mail.gmail.com>
 <CAHmME9oThR-dE3gTW0UyqAGZO80qu19ktG4YTb4iL6CNpzNNaw@mail.gmail.com>
 <CALCETrVziUpAU4nTaZ=t5ct=1jsWswWOy7KDNxXGPD1L=tMTGQ@mail.gmail.com>
 <CAHmME9pt3PxKQmc8E-arA-W0p2tp9z_oJ-uXQwis3qD=Zvpnsg@mail.gmail.com> <CAHmME9rA_nb9Le4VQhtcqCfNSuHpFjZVOV6=vE12FydJD9CmAQ@mail.gmail.com>
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
To: "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arch <linux-arch@vger.kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CAHmME9rA_nb9Le4VQhtcqCfNSuHpFjZVOV6=vE12FydJD9CmAQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 7, 2018 at 11:54 AM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> Hey Andy, Eric, & all,
>
> I've started the work of separating this out into 16 individual
> commits, have addressed numerous other things brought up like the
> ifdef maze, and have begun rewriting (parts of) the original commit
> message. It's still a work in progress, and I still have some work to
> do, but if you want to follow along, things are happening here:
>
> https://git.zx2c4.com/linux-dev/log/?h=jd/wireguard
>
> I'll be rebasing and reworking this continuously, but that's how it's
> shaping up.
>
> As I'm still working on it, I won't be submitting v2 today, but if you
> have suggestions or concerns or want to poke me while I'm working on
> v2, don't hesitate to send me private email or ping me in IRC (I'm
> "zx2c4" there) to chat.
>
> Regards,
> Jason

For "zinc: add simd helper", I think it should be in include/linux,
and include/linux/simd.h should (immediately or maybe in the future)
include <asm/simd.h> to pick up arch-specific stuff.  And the patch
should get sent to linux-arch@vger.kernel.org.

In your blake2s_arch() implementation, you're not passing in a
simd_context_t.  Is that still a work in progress?  I thought the plan
was to pass it in rather than doing the check in the _arch()
functions.
