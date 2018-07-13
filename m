From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA usage for AHASH_REQUEST_ON_STACK
Date: Fri, 13 Jul 2018 12:14:16 +0200
Message-ID: <CAK8P3a3nk4-EewKTXcLENTb86r1+bJz_WrkJoJt+D1uTwcpxPA@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org> <20180711203619.1020-12-keescook@chromium.org>
 <CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
 <20180713004038.lwibdesz7ohhoind@gondor.apana.org.au> <CAGXu5jLYmC7U=bucFZCLsSXNX=T4WhCccR6hx9dwROYF+ZMt0Q@mail.gmail.com>
 <20180713034406.zwu2pkp3f2onybxs@gondor.apana.org.au> <CAGXu5jLR0zJ6b9axJuG_uvttNShNcN3rhQKGVjW37qPd9saY-Q@mail.gmail.com>
 <20180713052029.cfo24bsr5swtbdja@gondor.apana.org.au> <CAGXu5jLG4gE44z9cXL3-D1bjbZB1RgTnTsb3PWhU7B3NdRrwVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
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
To: Kees Cook <keescook@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLG4gE44z9cXL3-D1bjbZB1RgTnTsb3PWhU7B3NdRrwVg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 13, 2018 at 8:00 AM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jul 12, 2018 at 10:20 PM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
>> On Thu, Jul 12, 2018 at 10:17:29PM -0700, Kees Cook wrote:
>>> What is the correct value to use for AHASH_REQUEST_ON_STACK?
>>
>> As I said to arrive at a fixed value you should examine all sync
>> ahash algorithms (e.g., all shash ones plus ahash ones marked as
>> sync if there are any).
>
> The "value" for the ahash I understand: it has a request size
> (tfm->reqsize, as set by crypto_ahash_set_reqsize()) what should be
> used to measure the shash value? (And how does this relate to the
> value returned by crypto_ahash_reqsize()?) The closest clue I can find
> is this:
>
> crypto_init_shash_ops_async() does:
>         crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
>
> and that gets called from crypto_ahash_init_tfm(), so if it starts
> with the above reqsize and adds to it with a call to
> crypto_ahash_set_reqsize() later, we'll have that maximum?
>
> So, do I want to calculate this answer as:
>
> sizeof(struct shash_desc) + max(shash descsize) + max(ahash-sync reqsize) ?
> 16 + 360 + 0

I arrived at the same number, looking at all the sizes in shash,
The largest I found are sha3_state (360 bytes) and s390_sha_ctx
(336 bytes), everything else is way smaller.

> It's 0 above because if I look at all the callers of
> crypto_ahash_set_reqsize() that do wrapping, all are ASYNC.
>
> So, should this really just be 376? Where is best to validate this
> size, as it seems checking in crypto_ahash_set_reqsize() is
> inappropriate?

How about crypto_init_shash_ops_async()?

      Arnd
