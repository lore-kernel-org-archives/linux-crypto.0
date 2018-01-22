From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH 3/7] crypto: ccree: add ablkcipher support
Date: Mon, 22 Jan 2018 09:07:24 +0200
Message-ID: <CAOtvUMd6usy9smZUE_d8hKf91-CvfZppo6KXd7WR-hmAzR5UCw@mail.gmail.com>
References: <1515662239-1714-1-git-send-email-gilad@benyossef.com>
 <1515662239-1714-4-git-send-email-gilad@benyossef.com>
 <20180111100137.GA15690@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Herbert Xu <herbert@gondor.apana.org.au>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 "David S. Miller" <davem@davemloft.net>, Ofir Drang <ofir.drang@arm.com>
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20180111100137.GA15690@Red>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
List-Id: linux-crypto.vger.kernel.org

Hi Corentin,


On Thu, Jan 11, 2018 at 12:01 PM, Corentin Labbe
<clabbe.montjoie@gmail.com> wrote:
> On Thu, Jan 11, 2018 at 09:17:10AM +0000, Gilad Ben-Yossef wrote:
>> Add CryptoCell ablkcipher support
>>
>
> Hello
>
> I have some minor comments:
>
> ablkcipher is deprecated, so you need to use skcipher instead.

Fixed in v2.

>
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>  drivers/crypto/ccree/Makefile        |    2 +-
>>  drivers/crypto/ccree/cc_buffer_mgr.c |  125 ++++
>>  drivers/crypto/ccree/cc_buffer_mgr.h |   10 +
>>  drivers/crypto/ccree/cc_cipher.c     | 1167 ++++++++++++++++++++++++++++++++++
>>  drivers/crypto/ccree/cc_cipher.h     |   74 +++
>>  drivers/crypto/ccree/cc_driver.c     |   11 +
>>  drivers/crypto/ccree/cc_driver.h     |    2 +
>>  7 files changed, 1390 insertions(+), 1 deletion(-)
>>  create mode 100644 drivers/crypto/ccree/cc_cipher.c
>>  create mode 100644 drivers/crypto/ccree/cc_cipher.h
>>
> [...]
>> +
>> +struct tdes_keys {
>> +     u8      key1[DES_KEY_SIZE];
>> +     u8      key2[DES_KEY_SIZE];
>> +     u8      key3[DES_KEY_SIZE];
>> +};
>> +
>> +static const u8 zero_buff[] = {      0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> +                             0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> +                             0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0,
>> +                             0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
>> +
>
> This constant is used nowhere.

Fixed in v2.

>
>> +/* The function verifies that tdes keys are not weak.*/
>> +static int cc_verify_3des_keys(const u8 *key, unsigned int keylen)
>> +{
>> +     struct tdes_keys *tdes_key = (struct tdes_keys *)key;
>> +
>> +     /* verify key1 != key2 and key3 != key2*/
>> +     if ((memcmp((u8 *)tdes_key->key1, (u8 *)tdes_key->key2,
>> +                 sizeof(tdes_key->key1)) == 0) ||
>> +         (memcmp((u8 *)tdes_key->key3, (u8 *)tdes_key->key2,
>> +                 sizeof(tdes_key->key3)) == 0)) {
>> +             return -ENOEXEC;
>> +     }
>> +
>> +     return 0;
>> +}
>
> All driver testing 3des key also use des_ekey()

Well, the weak key test which is part of des_ekey() are not needed
AFAIK for 3des
as per RFC2451 and the HW does 3des key expansion so that function is not useful
here.

>
> [...]
>> +static void cc_cipher_complete(struct device *dev, void *cc_req, int err)
>> +{
>> +     struct ablkcipher_request *areq = (struct ablkcipher_request *)cc_req;
>> +     struct scatterlist *dst = areq->dst;
>> +     struct scatterlist *src = areq->src;
>> +     struct blkcipher_req_ctx *req_ctx = ablkcipher_request_ctx(areq);
>> +     struct crypto_ablkcipher *tfm = crypto_ablkcipher_reqtfm(areq);
>> +     unsigned int ivsize = crypto_ablkcipher_ivsize(tfm);
>> +     struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>> +
>> +     cc_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>> +     kfree(req_ctx->iv);
>
> kzfree for all stuff with IV/key

Fixed in v2.
>
> [...]
>> +
>> +#ifdef CRYPTO_TFM_REQ_HW_KEY
>> +
>> +static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
>> +{
>> +     return (crypto_tfm_get_flags(tfm) & CRYPTO_TFM_REQ_HW_KEY);
>> +}
>> +
>> +#else
>> +
>> +struct arm_hw_key_info {
>> +     int hw_key1;
>> +     int hw_key2;
>> +};
>> +
>> +static inline bool cc_is_hw_key(struct crypto_tfm *tfm)
>> +{
>> +     return false;
>> +}
>> +
>> +#endif /* CRYPTO_TFM_REQ_HW_KEY */
>
> I see nowhere any use/documentation of CRYPTO_TFM_REQ_HW_KEY, so a cleaning could be done

You are right. It's a badly implemented stub function. I'll drop the
ifdef as it is useless right now.

Many thanks for the review!

Gilad

-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
