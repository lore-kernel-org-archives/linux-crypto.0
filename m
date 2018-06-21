From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 04/11] dm verity fec: Remove VLA usage
Date: Thu, 21 Jun 2018 13:19:42 -0700
Message-ID: <CAGXu5j+nMXYL6F7A218yfu+AqroqcdMU-J3ibozaK=Nzza0Y8Q@mail.gmail.com>
References: <20180620190408.45104-1-keescook@chromium.org> <20180620190408.45104-5-keescook@chromium.org>
 <20180621023054.5jx5s3jzap3soe6e@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alasdair Kergon <agk@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Lars Persson <larper@axis.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Rabin Vincent <rabinv@axis.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto <linux-crypto@vger.kernel.org>, qat-linux@intel.com,
        dm-devel@redhat.com, LKML <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180621023054.5jx5s3jzap3soe6e@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jun 20, 2018 at 7:30 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Wed, Jun 20, 2018 at 12:04:01PM -0700, Kees Cook wrote:
>> In the quest to remove all stack VLA usage from the kernel[1], this
>> uses the newly defined max digest size macro. Also adds a sanity-check
>> at use-time.
>>
>> [1] https://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> ---
>>  drivers/md/dm-verity-fec.c | 5 ++++-
>>  1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
>> index 684af08d0747..0dfcc52835bc 100644
>> --- a/drivers/md/dm-verity-fec.c
>> +++ b/drivers/md/dm-verity-fec.c
>> @@ -212,12 +212,15 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
>>       struct dm_verity_fec_io *fio = fec_io(io);
>>       u64 block, ileaved;
>>       u8 *bbuf, *rs_block;
>> -     u8 want_digest[v->digest_size];
>> +     u8 want_digest[AHASH_MAX_DIGESTSIZE];
>>       unsigned n, k;
>>
>>       if (neras)
>>               *neras = 0;
>>
>> +     if (WARN_ON(v->digest_size < sizeof(want_digest)))
>> +             return -EINVAL;
>
> How about verifying digest_size in the ahash API when algorithms
> are registered?

That happens already in ahash_prepare_alg() (and see the tweak in
patch 3 "crypto: ahash: Remove VLA usage"), but I wanted to keep these
run-time checks to avoid any problems in the future of things change.
As it's marked as "unlikely" internal to WARN_ON, this shouldn't have
a performance impact.

-Kees

-- 
Kees Cook
Pixel Security
