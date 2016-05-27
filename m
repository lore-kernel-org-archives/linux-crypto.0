From: Baolin Wang <baolin.wang@linaro.org>
Subject: Re: [RFC 2/3] crypto: Introduce CRYPTO_ALG_BULK flag
Date: Fri, 27 May 2016 17:04:35 +0800
Message-ID: <CAMz4kuLmac=VQu=htEzQa3pnWmDBzresK-8bFjoG7n8LBgLuZQ@mail.gmail.com>
References: <cover.1464144790.git.baolin.wang@linaro.org>
	<7f0fef5fe473a451e352b2d42e1eed483fd28667.1464144791.git.baolin.wang@linaro.org>
	<5747E9CF.7010706@gmail.com>
	<CAMz4kuK2yFqtdNJBn1POOo9Y_4=Rk2q8BP8P1P+JdYJk2oLnFw@mail.gmail.com>
	<5747FD04.4090707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	"open list:DEVICE-MAPPER (LVM)" <dm-devel@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Miller <davem@davemloft.net>,
	Eric Biggers <ebiggers3@gmail.com>,
	Joonsoo Kim <js1304@gmail.com>, tadeusz.struk@intel.com,
	smueller@chronox.de, Masanari Iida <standby24x7@gmail.com>,
	Shaohua Li <shli@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sagi Grimberg <sagig@mellanox.com>,
	Kent Overstreet <kent.overstreet@gmail.com>,
	Keith Busch <keith.busch@intel.com>, Tejun Heo <tj@kernel.org>,
	Ming Lei <ming.lei@canonical.com>,
	Mark Brown <broonie@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
	"open list:SOFTWARE RAID (Multiple Disks) SUPPORT"
	<linux-raid@vg
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5747FD04.4090707@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 27 May 2016 at 15:53, Milan Broz <gmazyland@gmail.com> wrote:
> On 05/27/2016 09:04 AM, Baolin Wang wrote:
>> Hi Milan,
>>
>> On 27 May 2016 at 14:31, Milan Broz <gmazyland@gmail.com> wrote:
>>> On 05/25/2016 08:12 AM, Baolin Wang wrote:
>>>> Now some cipher hardware engines prefer to handle bulk block rather than one
>>>> sector (512 bytes) created by dm-crypt, cause these cipher engines can handle
>>>> the intermediate values (IV) by themselves in one bulk block. This means we
>>>> can increase the size of the request by merging request rather than always 512
>>>> bytes and thus increase the hardware engine processing speed.
>>>
>>> Hi,
>>>
>>> could you please elaborate how exactly you are processing independently
>>> encrypted sectors? For example with XTS mode. Do you play internally with
>>> tweak calculation? Does this keep 512 bytes sector encryption blocks independent?
>>>
>>> (If not, it is breaking compatibility everywhere and you are reinventing
>>> disk encryption logic here - just for performance reason for some hw
>>> not designed for this task... But that was said several times already.)
>>
>> These are what the cipher hardware engine and engine driver should do,
>> for software we just need send one initial IV and bulk data to crypto
>> layer, which is enough.
>
> Hi,
>
> Thanks for answer.
>
> So this is just doing some kind of batch processing optimization inside the driver?
> I still do not understand why it is not possible to "batch" these requests inside
> you driver (with async API) then and process them in one go without any changes
> to dmcrypt though. (But I am not familiar with these drivers.)

I think it is not only for the driver level, but also for cipher API.
If one cipher engine can support bulk mode, then we should send bulk
data to it, not only one sector, which need to be implemented at top
API level, such as:

skcipher_request_set_crypt(req, sgt_in.sgl, sgt_out.sgl, total_bytes,
iv); /* send sg table to crypt layer */

If move these optimization into driver, it means we need to merge
requests from dm-crypt together to be one big request for engine
driver, but it will be low efficiency and not help. Why we can not
send one bulk request at first in dm-crypt? We just need to set the
different parameters for skcipher_request_set_crypt() function
according to different cipher mode in dm-crypt.

>
> If I understand it correctly, subsequent IVs are calculated inside
> your driver just based on some initial value?

Yes, something like this.

> This can work only for sequential IVs (or, better said, for predictable
> IVs like plain64, implemented inside your hw/driver).
>
> It cannot work for IVs/tweaks that are randomized or keyed (like ESSIV).
> Yes, I know that using ESSIV for XTS is considered overkill but I do not
> see you are checking this condition anywhere in code (we can definitely
> configure such a mapping).

So if some ciphers (like: aes(cbc)) can not support bulk mode, then we
should not add the  CRYPTO_ALG_BULK flag for this cipher in the cipher
driver.

>
>>>> So introduce 'CRYPTO_ALG_BULK' flag to indicate this cipher can support bulk
>>>> mode.
>>>
>>> What exactly skcipher will do if this flag is set?
>>
>> I think that depends on how to implement the cipher engine driver.
>
> I do not care about implementation details, I just would like to see
> some high-level description for the new API flag.
> (Or at least read the code that implements it :)

I think for high-level description, we can use sg table to map one
bulk block and send to crypt layer by skcipher_request_set_crypt()
function.

>
>>> Which drivers it should use? I do not see any posted patch that uses this flag yet.
>>> How we can test it?
>>
>> Some cipher engine drivers which support bulk mode should use this
>> flag. Yeah, we need upstream one cipher driver with this flag for
>> testing.
>
> I think if you introduce new flag, you should also post drivers that uses it.
> Otherwise it is just unused code for mainline.

Yeah, that's right.

>
> And I definitely would like to test it somewhere and see real
> performance data (not just simple dd).

OK. Thanks.

>
> Thanks,
> Milan
>
>>
>>>
>>> Milan
>>>
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
>>>> ---
>>>>  include/crypto/skcipher.h |    7 +++++++
>>>>  include/linux/crypto.h    |    6 ++++++
>>>>  2 files changed, 13 insertions(+)
>>>>
>>>> diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
>>>> index 0f987f5..d89d29a 100644
>>>> --- a/include/crypto/skcipher.h
>>>> +++ b/include/crypto/skcipher.h
>>>> @@ -519,5 +519,12 @@ static inline void skcipher_request_set_crypt(
>>>>       req->iv = iv;
>>>>  }
>>>>
>>>> +static inline unsigned int skcipher_is_bulk_mode(struct crypto_skcipher *sk_tfm)
>>>> +{
>>>> +     struct crypto_tfm *tfm = crypto_skcipher_tfm(sk_tfm);
>>>> +
>>>> +     return crypto_tfm_alg_bulk(tfm);
>>>> +}
>>>> +
>>>>  #endif       /* _CRYPTO_SKCIPHER_H */
>>>>
>>>> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
>>>> index 6e28c89..a315487 100644
>>>> --- a/include/linux/crypto.h
>>>> +++ b/include/linux/crypto.h
>>>> @@ -63,6 +63,7 @@
>>>>  #define CRYPTO_ALG_DEAD                      0x00000020
>>>>  #define CRYPTO_ALG_DYING             0x00000040
>>>>  #define CRYPTO_ALG_ASYNC             0x00000080
>>>> +#define CRYPTO_ALG_BULK                      0x00000100
>>>>
>>>>  /*
>>>>   * Set this bit if and only if the algorithm requires another algorithm of
>>>> @@ -623,6 +624,11 @@ static inline u32 crypto_tfm_alg_type(struct crypto_tfm *tfm)
>>>>       return tfm->__crt_alg->cra_flags & CRYPTO_ALG_TYPE_MASK;
>>>>  }
>>>>
>>>> +static inline unsigned int crypto_tfm_alg_bulk(struct crypto_tfm *tfm)
>>>> +{
>>>> +     return tfm->__crt_alg->cra_flags & CRYPTO_ALG_BULK;
>>>> +}
>>>> +
>>>>  static inline unsigned int crypto_tfm_alg_blocksize(struct crypto_tfm *tfm)
>>>>  {
>>>>       return tfm->__crt_alg->cra_blocksize;
>>>>
>>>
>>
>>
>>



-- 
Baolin.wang
Best Regards
