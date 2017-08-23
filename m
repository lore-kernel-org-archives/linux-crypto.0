From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [BUGFIX PATCH v2] staging: ccree: save ciphertext for CTS IV
Date: Wed, 23 Aug 2017 13:47:36 +0300
Message-ID: <CAOtvUMe-Z1r0Lr-AszyYZONod53+hA42gvy7UihRNwZTDCTwkA@mail.gmail.com>
References: <1503479525-23947-1-git-send-email-gilad@benyossef.com>
 <4515717.kZM3QcrMqT@tauon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driverdev-devel@linuxdriverproject.org,
 Linux kernel mailing list <linux-kernel@vger.kernel.org>,
 Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Ofir Drang <ofir.drang@arm.com>
To: Stephan Mueller <smueller@chronox.de>
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <4515717.kZM3QcrMqT@tauon.chronox.de>
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

On Wed, Aug 23, 2017 at 1:03 PM, Stephan Mueller <smueller@chronox.de> wrote:
> Am Mittwoch, 23. August 2017, 11:12:05 CEST schrieb Gilad Ben-Yossef:
>
> Hi Gilad,
>
>> The crypto API requires saving the last blocks of ciphertext
>> in req->info for use as IV for CTS mode. The ccree driver
>> was not doing this. This patch fixes that.
>>
>> The bug was manifested with cts(cbc(aes)) mode in tcrypt tests.
>>
>> Fixes: 302ef8ebb4b2 ("Add CryptoCell skcipher support")
>> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
>> ---
>>
>> Changes from v1:
>> - Free memory on error path, as pointed out by Stephan Mueller.
>>
>>  drivers/staging/ccree/ssi_cipher.c | 40
>> ++++++++++++++++++++++++++++++++++---- 1 file changed, 36 insertions(+), 4
>> deletions(-)
>>
>> diff --git a/drivers/staging/ccree/ssi_cipher.c
>> b/drivers/staging/ccree/ssi_cipher.c index af9afea..8d31a93 100644
>> --- a/drivers/staging/ccree/ssi_cipher.c
>> +++ b/drivers/staging/ccree/ssi_cipher.c
>> @@ -24,6 +24,7 @@
>>  #include <crypto/ctr.h>
>>  #include <crypto/des.h>
>>  #include <crypto/xts.h>
>> +#include <crypto/scatterwalk.h>
>>
>>  #include "ssi_config.h"
>>  #include "ssi_driver.h"
>> @@ -697,6 +698,7 @@ static int ssi_blkcipher_complete(struct device *dev,
>>  {
>>       int completion_error = 0;
>>       u32 inflight_counter;
>> +     struct ablkcipher_request *req = (struct ablkcipher_request *)areq;
>>
>>       ssi_buffer_mgr_unmap_blkcipher_request(dev, req_ctx, ivsize, src, dst);
>>
>> @@ -707,6 +709,22 @@ static int ssi_blkcipher_complete(struct device *dev,
>>               ctx_p->drvdata->inflight_counter--;
>>
>>       if (areq) {
>> +             /*
>> +              * The crypto API expects us to set the req->info to the last
>> +              * ciphertext block. For encrypt, simply copy from the result.
>> +              * For decrypt, we must copy from a saved buffer since this
>> +              * could be an in-place decryption operation and the src is
>> +              * lost by this point.
>> +              */
>> +             if (req_ctx->gen_ctx.op_type == DRV_CRYPTO_DIRECTION_DECRYPT)  {
>> +                     memcpy(req->info, req_ctx->backup_info, ivsize);
>> +                     kfree(req_ctx->backup_info);
>> +             } else {
>> +                     scatterwalk_map_and_copy(req->info, req->dst,
>> +                                              (req->nbytes - ivsize),
>> +                                              ivsize, 0);
>
> Sorry to be persistent, but what about this code path? Here you do not free
> it, yet it is allocated.

Thank you for your persistence. It is appreciated :-)

If I understood correctly what you are referring to than the buffer is not
allocated in this code path (unless I've missed something):

The buffer is allocated in ssi_ablkcipher_decrypt() which sets
req_ctx->gen_ctx.op_type
to DRV_CRYPTO_DIRECTION_DECRYPT.

The buffer is not allocated in the parallel function
(ssi_ablkcipher_encrypt) which matches
the else clause of this if statement.



>> +             }
>> +
>>               ablkcipher_request_complete(areq, completion_error);
>>               return 0;
>>       }
>> @@ -739,11 +757,13 @@ static int ssi_blkcipher_process(
>>       if (unlikely(validate_data_size(ctx_p, nbytes))) {
>>               SSI_LOG_ERR("Unsupported data size %d.\n", nbytes);
>>               crypto_tfm_set_flags(tfm, CRYPTO_TFM_RES_BAD_BLOCK_LEN);
>> -             return -EINVAL;
>> +             rc = -EINVAL;
>> +             goto exit_process;
>>       }
>>       if (nbytes == 0) {
>>               /* No data to process is valid */
>> -             return 0;
>> +             rc = 0;
>> +             goto exit_process;
>>       }
>>       /*For CTS in case of data size aligned to 16 use CBC mode*/
>>       if (((nbytes % AES_BLOCK_SIZE) == 0) && (ctx_p->cipher_mode ==
>> DRV_CIPHER_CBC_CTS)) { @@ -818,6 +838,9 @@ static int
>> ssi_blkcipher_process(
>>       if (cts_restore_flag != 0)
>>               ctx_p->cipher_mode = DRV_CIPHER_CBC_CTS;
>>
>> +     if (rc != -EINPROGRESS)
>> +             kfree(req_ctx->backup_info);
>> +
>>       return rc;
>>  }
>>
>> @@ -858,7 +881,6 @@ static int ssi_ablkcipher_encrypt(struct
>> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
>> ablkcipher_request_ctx(req); unsigned int ivsize =
>> crypto_ablkcipher_ivsize(ablk_tfm);
>>
>> -     req_ctx->backup_info = req->info;
>>       req_ctx->is_giv = false;
>>
>>       return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
>> req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_ENCRYPT);
>> @@ -871,8 +893,18 @@ static int ssi_ablkcipher_decrypt(struct
>> ablkcipher_request *req) struct blkcipher_req_ctx *req_ctx =
>> ablkcipher_request_ctx(req); unsigned int ivsize =
>> crypto_ablkcipher_ivsize(ablk_tfm);
>>
>> -     req_ctx->backup_info = req->info;
>> +     /*
>> +      * Allocate and save the last IV sized bytes of the source, which will
>> +      * be lost in case of in-place decryption and might be needed for CTS.
>> +      */
>> +     req_ctx->backup_info = kmalloc(ivsize, GFP_KERNEL);
>> +     if (!req_ctx->backup_info)
>> +             return -ENOMEM;
>> +
>> +     scatterwalk_map_and_copy(req_ctx->backup_info, req->src,
>> +                              (req->nbytes - ivsize), ivsize, 0);
>>       req_ctx->is_giv = false;
>> +
>>       return ssi_blkcipher_process(tfm, req_ctx, req->dst, req->src,
>> req->nbytes, req->info, ivsize, (void *)req, DRV_CRYPTO_DIRECTION_DECRYPT);
>> }
>
>
>
> Ciao
> Stephan

Thanks
Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
