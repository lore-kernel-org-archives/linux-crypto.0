From: Kees Cook <keescook@chromium.org>
Subject: Re: [dm-devel] [PATCH v5 05/11] crypto: ahash: Remove VLA usage
Date: Wed, 18 Jul 2018 20:14:07 -0700
Message-ID: <CAGXu5jJUeMcVQDTd2JAYFTbTk0DcN84i1-4EOJcvLR9zNgyoOQ@mail.gmail.com>
References: <20180717042150.37761-1-keescook@chromium.org> <20180717042150.37761-6-keescook@chromium.org>
 <20180717163936.GB75957@gmail.com> <CAGXu5jKKD4hzeFEdvY5QdahEr4POd9ZM_B_5Z_iU-Qmx3AYSfQ@mail.gmail.com>
 <20180717231209.GJ75957@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Eric Biggers <ebiggers@google.com>, qat-linux@intel.com,
        LKML <linux-kernel@vger.kernel.org>, dm-devel@redhat.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        Lars Persson <larper@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Alasdair Kergon <agk@redhat.com>,
        Rabin Vincent <rabinv@axis.com>
To: Eric Biggers <ebiggers3@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717231209.GJ75957@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Jul 17, 2018 at 4:12 PM, Eric Biggers <ebiggers3@gmail.com> wrote:
> I just don't see why ahash algorithms would need such a huge maximum digest
> size.  Don't the 'ahash' algorithms all have 'shash' equivalents too?  Is there
> actually any hash algorithm, either shash or ahash, in the Linux kernel that has
> a digest size greater than 64 bytes (512 bits)?  Note that for a real
> cryptographic hash there isn't really any need for a digest size larger than
> that, since that already gives you 256-bit collision resistance; that's why
> SHA-2 and SHA-3 max out at that size.

Yup, it certainly looks that way on investigation. I'll adjust both
ahash and shash to use the same #define.

-Kees

-- 
Kees Cook
Pixel Security
