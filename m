From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function pointers
Date: Fri, 5 Oct 2018 21:13:08 +0200
Message-ID: <E75F755E-E447-4302-BFBD-095FC45B991E@linaro.org>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org> <20181005081333.15018-2-ard.biesheuvel@linaro.org> <20181005141433.GS19272@hirez.programming.kicks-ass.net> <9E0E08C8-0DFC-4E50-A4FA-73208835EF9E@amacapital.net> <CAKv+Gu9z503ZJXcsG+9Ys240BZiB-+GB=kNY4VGWpjvdzN4JtA@mail.gmail.com> <CALCETrWaewXsdJsf3SocgZ0ggnvZk86L+5-LWPRbjdnG2mB7jw@mail.gmail.com> <CAKv+Gu-oHBtgGbWXJu6+z4+BNhBZyY5VvF_v6cJJUGk_5YX1eQ@mail.gmail.com> <CALCETrU=fm+ZG4WZJfG-5GwL7kv5_GS1aZYu=L42d5BuSbhJDQ@mail.gmail.com> <CAKv+Gu8eHPEsUbkhN=61z9FvhdCo2e3VOdemp4g0bzdO1EJFYQ@mail.gmail.com> <CALCETrVMBULVP9qEQDVuisxAMzdheM1qQ97AZFs-xcO0eaXiiA@mail.gmail.com> <CAHmME9pgJ_2GGDUVsbQXcNRfh3yACqFG+5uemFRMZkb8LdH95g@mail.gmail.com> <CALCETrWjCY2Wceiqu99C+g5RdnrZuRujYO_+jBvuJFRB1LTG4w@mail.gmail.com> <CAHmME9pcQF=FvKRuxnqrJ
 5R1pvtUVbx3DXvXiUX5HywS2Xgj3A@mail.gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Cc: Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, benh@kernel.crashing.org,
        paulus@samba.org, Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com,
        Kees Cook <keescook@chromium.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, richard@nod.at,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-ar
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHmME9pcQF=FvKRuxnqrJ5R1pvtUVbx3DXvXiUX5HywS2Xgj3A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



> On 5 Oct 2018, at 20:28, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>=20
> Hey Andy,
>=20
>> On Fri, Oct 5, 2018 at 7:44 PM Andy Lutomirski <luto@kernel.org> wrote:
>> I *think* the only change to Zinc per se would be that the calls like
>> chacha20_simd() would be static calls or patchable functions or
>> whatever we want to call them.  And there could be a debugfs to
>> override the default selection.
>=20
> Yea, right, exactly. It turns out this is really easy to do with the
> way it's structured now. I'd actually experimented considerably with
> using the static keys a while back, but couldn't find any performance
> difference on any platform at all (four ARM microarchitectures, three
> MIPS, various random intel, an old powerpc), so went with the simplest
> solution. But we can certainly play with more elaborate patching
> mechanisms later on and see how those turn out. Also, even with the
> simple bools as we have now, it's quite easy to make all the
> parameters toggle-able.
>=20
>> Ard, I don't think that sticking this in udev rules makes sense.  The
>> kernel has bascially complete information as to what the right choice
>> is, and that will change over time as the implementation gets tuned,
>> and the udev rules will never get updated in sync.
>=20
> Yes, I agree with this.
>=20
>=20

I am not referring to udev rules. I just mean the current way that udev auto=
loads modules based on CPU features.=
