From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH 1/9] kernel: add support for patchable function pointers
Date: Fri, 5 Oct 2018 19:37:44 +0200
Message-ID: <CAHmME9pgJ_2GGDUVsbQXcNRfh3yACqFG+5uemFRMZkb8LdH95g@mail.gmail.com>
References: <20181005081333.15018-1-ard.biesheuvel@linaro.org>
 <20181005081333.15018-2-ard.biesheuvel@linaro.org> <20181005141433.GS19272@hirez.programming.kicks-ass.net>
 <9E0E08C8-0DFC-4E50-A4FA-73208835EF9E@amacapital.net> <CAKv+Gu9z503ZJXcsG+9Ys240BZiB-+GB=kNY4VGWpjvdzN4JtA@mail.gmail.com>
 <CALCETrWaewXsdJsf3SocgZ0ggnvZk86L+5-LWPRbjdnG2mB7jw@mail.gmail.com>
 <CAKv+Gu-oHBtgGbWXJu6+z4+BNhBZyY5VvF_v6cJJUGk_5YX1eQ@mail.gmail.com>
 <CALCETrU=fm+ZG4WZJfG-5GwL7kv5_GS1aZYu=L42d5BuSbhJDQ@mail.gmail.com>
 <CAKv+Gu8eHPEsUbkhN=61z9FvhdCo2e3VOdemp4g0bzdO1EJFYQ@mail.gmail.com> <CALCETrVMBULVP9qEQDVuisxAMzdheM1qQ97AZFs-xcO0eaXiiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
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
        l
To: Andrew Lutomirski <luto@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrVMBULVP9qEQDVuisxAMzdheM1qQ97AZFs-xcO0eaXiiA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Oct 5, 2018 at 7:29 PM Andy Lutomirski <luto@kernel.org> wrote:
> (None of this is to say that I disagree with Jason, though -- I'm not
> entirely convinced that this makes sense for Zinc.  But maybe it can
> be done in a way that makes everyone happy.)

Zinc indeed will continue to push in the simpler and more minimal
direction. Down the line I'm open to trying and benching a few
different ways of going about it with dynamic patching -- something
that will be pretty easy to experiment with given the lean structure
of Zinc -- but for the initial merge I intend to do it the way it is,
which is super fast and pretty straightforward to follow.

Jason
