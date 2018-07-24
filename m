From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v6 17/18] crypto: ccm: Remove VLA usage
Date: Tue, 24 Jul 2018 10:51:27 -0700
Message-ID: <CAGXu5j+-AwHdGZ7Be854WyEQoK2p57JPuTgSXcFq7GOzUtJGEA@mail.gmail.com>
References: <20180724164936.37477-1-keescook@chromium.org> <20180724164936.37477-18-keescook@chromium.org>
 <CAKv+Gu-D9FrOrFU0EmkPA52vrywCGZkFP9vUsyEovdby9dLj0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Greg Kroah-Hartman <gregk
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAKv+Gu-D9FrOrFU0EmkPA52vrywCGZkFP9vUsyEovdby9dLj0g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 24, 2018 at 9:57 AM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 24 July 2018 at 18:49, Kees Cook <keescook@chromium.org> wrote:
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> In the quest to remove all stack VLA usage from the kernel[1], this
>> drops AHASH_REQUEST_ON_STACK by preallocated the ahash request area
>> with the skcipher area (which are not used at the same time).
>>
>
> -EGRAMMAR

Whoops. Will fix my poor sentence merging. :)

-Kees

-- 
Kees Cook
Pixel Security
