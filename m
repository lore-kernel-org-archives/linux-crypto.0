From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Thu, 12 Jul 2018 22:17:29 -0700
Message-ID: <CAGXu5jLR0zJ6b9axJuG_uvttNShNcN3rhQKGVjW37qPd9saY-Q@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
 <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au> <CAGXu5jLYmC7U=bucFZCLsSXNX=T4WhCccR6hx9dwROYF+ZMt0Q@mail.gmail.com>
 <20180713034406.zwu2pkp3f2onybxs@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Eric Biggers <ebiggers@google.com>,
        Alasdair Kergon <agk@redhat.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
        <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180713034406.zwu2pkp3f2onybxs@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 12, 2018 at 8:44 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Thu, Jul 12, 2018 at 08:33:24PM -0700, Kees Cook wrote:
>> On Thu, Jul 12, 2018 at 5:40 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>> > On Thu, Jul 12, 2018 at 06:02:26PM +0200, Arnd Bergmann wrote:
>> >>
>> >> Looking through some of the drivers, I found this interesting one:
>> >
>> > As I said before these patches are fundamentally broken.  Users
>> > of AHASH_REQUEST_ON_STACK can only use sync algorithm providers
>> > and therefore drivers are irrelevant.
>>
>> I don't understand what this means. Can you give an example of what
>> you want to see happen that will accomplish the VLA removals?
>
> Any algorithm that is async must be ignored when you're calculating
> the maximum on-stack size of the request.  For example, sha512-mb
> is marked as async and therefore must not be used in conjunction
> with AHASH_REQUEST_ON_STACK.

Then why does the instrumented tcrypt output show the huge size? Is
tcrypt doing something incorrectly?

What is the correct value to use for AHASH_REQUEST_ON_STACK?

-Kees

-- 
Kees Cook
Pixel Security
