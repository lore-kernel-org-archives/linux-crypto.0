From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v4 11/14] treewide: Prepare to remove VLA
	usage for AHASH_REQUEST_ON_STACK
Date: Sat, 14 Jul 2018 21:28:38 -0700
Message-ID: <CAGXu5j+Q_jc_f9VybyoJqmV7_Q-3hqnC-pOubfNsi7uyAROVrQ@mail.gmail.com>
References: <20180711203619.1020-1-keescook@chromium.org>
	<20180711203619.1020-12-keescook@chromium.org>
	<CAK8P3a3356dbruUfS_+fj9f+X-0jbNE8WMe5sWhJmuRY9Nvcbg@mail.gmail.com>
	<20180713004038.lwibdesz7ohhoind@gondor.apana.org.au>
	<CAGXu5jLYmC7U=bucFZCLsSXNX=T4WhCccR6hx9dwROYF+ZMt0Q@mail.gmail.com>
	<20180713034406.zwu2pkp3f2onybxs@gondor.apana.org.au>
	<CAGXu5jLR0zJ6b9axJuG_uvttNShNcN3rhQKGVjW37qPd9saY-Q@mail.gmail.com>
	<20180713052029.cfo24bsr5swtbdja@gondor.apana.org.au>
	<CAGXu5jLG4gE44z9cXL3-D1bjbZB1RgTnTsb3PWhU7B3NdRrwVg@mail.gmail.com>
	<CAK8P3a3nk4-EewKTXcLENTb86r1+bJz_WrkJoJt+D1uTwcpxPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Mike Snitzer <snitzer@redhat.com>, Eric Biggers <ebiggers@google.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>, qat-linux@intel.com,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Masahiro Yamada <yamada.masahiro@socionext.com>, dm-devel@redhat.com,
	"open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
	<linux-crypto@vger.kernel.org>, Lars Persson <larper@axis.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>, Alasdair Kergon <agk@redhat.com>,
	Rabin Vincent <rabinv@axis.com>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <CAK8P3a3nk4-EewKTXcLENTb86r1+bJz_WrkJoJt+D1uTwcpxPA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
List-Id: linux-crypto.vger.kernel.org

On Fri, Jul 13, 2018 at 3:14 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Fri, Jul 13, 2018 at 8:00 AM, Kees Cook <keescook@chromium.org> wrote:
>> On Thu, Jul 12, 2018 at 10:20 PM, Herbert Xu
>> <herbert@gondor.apana.org.au> wrote:
>>> On Thu, Jul 12, 2018 at 10:17:29PM -0700, Kees Cook wrote:
>>>> What is the correct value to use for AHASH_REQUEST_ON_STACK?
>>>
>>> As I said to arrive at a fixed value you should examine all sync
>>> ahash algorithms (e.g., all shash ones plus ahash ones marked as
>>> sync if there are any).
>>
>> The "value" for the ahash I understand: it has a request size
>> (tfm->reqsize, as set by crypto_ahash_set_reqsize()) what should be
>> used to measure the shash value? (And how does this relate to the
>> value returned by crypto_ahash_reqsize()?) The closest clue I can find
>> is this:
>>
>> crypto_init_shash_ops_async() does:
>>         crt->reqsize = sizeof(struct shash_desc) + crypto_shash_descsize(shash);
>>
>> and that gets called from crypto_ahash_init_tfm(), so if it starts
>> with the above reqsize and adds to it with a call to
>> crypto_ahash_set_reqsize() later, we'll have that maximum?
>>
>> So, do I want to calculate this answer as:
>>
>> sizeof(struct shash_desc) + max(shash descsize) + max(ahash-sync reqsize) ?
>> 16 + 360 + 0
>
> I arrived at the same number, looking at all the sizes in shash,
> The largest I found are sha3_state (360 bytes) and s390_sha_ctx
> (336 bytes), everything else is way smaller.

Excellent. Thanks for double-checking this. :)

>
>> It's 0 above because if I look at all the callers of
>> crypto_ahash_set_reqsize() that do wrapping, all are ASYNC.
>>
>> So, should this really just be 376? Where is best to validate this
>> size, as it seems checking in crypto_ahash_set_reqsize() is
>> inappropriate?
>
> How about crypto_init_shash_ops_async()?

Ah yes, that looks good. Nice find!

After my ahash to shash conversions, only ccm is left as an ahash
user, since it actually uses sg. But with the hard-coded value reduced
to 376, this doesn't trip the frame warnings any more. :)

I'll send an updated series soon.

-Kees

-- 
Kees Cook
Pixel Security
