From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH v4 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Thu, 19 Oct 2017 15:47:08 +0200
Message-ID: <e11bd8d2-da0a-d296-c949-96bb5df5ba54@baylibre.com>
References: <1508403839-14131-1-git-send-email-fabien.dessenne@st.com>
 <1508403839-14131-3-git-send-email-fabien.dessenne@st.com>
 <20171019103454.GA26877@Red> <0359a8aa-5d91-6284-76cb-44bbd7865a0f@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Alexandre TORGUE <alexandre.torgue@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lionel DEBIEVE <lionel.debieve@st.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Benjamin GAIGNARD <benjamin.gaignard@st.com>,
        Ludovic BARRE <ludovic.barre@st.com>,
        "David S . Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Fabien DESSENNE <fabien.dessenne@st.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0359a8aa-5d91-6284-76cb-44bbd7865a0f@st.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 19/10/2017 15:01, Fabien DESSENNE wrote:
> Hi Corentin
> 
> 
> Thank you for your comments. I will fix according to them. See also me 
> answers/questions below
> 
> While we are at it, do you plan to deliver a new version of the 
> crypto_engine update? (I had to remove the AEAD part of this new driver 
> since it depends on that pending update)
> 
> BR
> 
> Fabien
> 
> 
> On 19/10/17 12:34, Corentin Labbe wrote:
>> Hello
>>
>> I have some minor comment below
>>
>> On Thu, Oct 19, 2017 at 11:03:59AM +0200, Fabien Dessenne wrote:
>>> This module registers block cipher algorithms that make use of the
>>> STMicroelectronics STM32 crypto "CRYP1" hardware.
>>> The following algorithms are supported:
>>> - aes: ecb, cbc, ctr
>>> - des: ecb, cbc
>>> - tdes: ecb, cbc
>>>
>>> Signed-off-by: Fabien Dessennie <fabien.dessenne@st.com>
>>> ---
>>>   drivers/crypto/stm32/Kconfig      |    9 +
>>>   drivers/crypto/stm32/Makefile     |    3 +-
>>>   drivers/crypto/stm32/stm32-cryp.c | 1188 +++++++++++++++++++++++++++++++++++++
>>>   3 files changed, 1199 insertions(+), 1 deletion(-)
>>>   create mode 100644 drivers/crypto/stm32/stm32-cryp.c
>>>
>>> diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
>>> index 602332e..61ef00b 100644
>>> --- a/drivers/crypto/stm32/Kconfig
>>> +++ b/drivers/crypto/stm32/Kconfig
>> [...]
>>> +/* Bit [0] encrypt / decrypt */
>>> +#define FLG_ENCRYPT             BIT(0)
>>> +/* Bit [8..1] algo & operation mode */
>>> +#define FLG_AES                 BIT(1)
>>> +#define FLG_DES                 BIT(2)
>>> +#define FLG_TDES                BIT(3)
>>> +#define FLG_ECB                 BIT(4)
>>> +#define FLG_CBC                 BIT(5)
>>> +#define FLG_CTR                 BIT(6)
>>> +/* Mode mask = bits [15..0] */
>>> +#define FLG_MODE_MASK           GENMASK(15, 0)
>>> +
>>> +/* Registers */
>>> +#define CRYP_CR                 0x00000000
>>> +#define CRYP_SR                 0x00000004
>>> +#define CRYP_DIN                0x00000008
>>> +#define CRYP_DOUT               0x0000000C
>>> +#define CRYP_DMACR              0x00000010
>>> +#define CRYP_IMSCR              0x00000014
>>> +#define CRYP_RISR               0x00000018
>>> +#define CRYP_MISR               0x0000001C
>>> +#define CRYP_K0LR               0x00000020
>>> +#define CRYP_K0RR               0x00000024
>>> +#define CRYP_K1LR               0x00000028
>>> +#define CRYP_K1RR               0x0000002C
>>> +#define CRYP_K2LR               0x00000030
>>> +#define CRYP_K2RR               0x00000034
>>> +#define CRYP_K3LR               0x00000038
>>> +#define CRYP_K3RR               0x0000003C
>>> +#define CRYP_IV0LR              0x00000040
>>> +#define CRYP_IV0RR              0x00000044
>>> +#define CRYP_IV1LR              0x00000048
>>> +#define CRYP_IV1RR              0x0000004C
>>> +
>>> +/* Registers values */
>>> +#define CR_DEC_NOT_ENC          0x00000004
>>> +#define CR_TDES_ECB             0x00000000
>>> +#define CR_TDES_CBC             0x00000008
>>> +#define CR_DES_ECB              0x00000010
>>> +#define CR_DES_CBC              0x00000018
>>> +#define CR_AES_ECB              0x00000020
>>> +#define CR_AES_CBC              0x00000028
>>> +#define CR_AES_CTR              0x00000030
>>> +#define CR_AES_KP               0x00000038
>>> +#define CR_AES_UNKNOWN          0xFFFFFFFF
>>> +#define CR_ALGO_MASK            0x00080038
>>> +#define CR_DATA32               0x00000000
>>> +#define CR_DATA16               0x00000040
>>> +#define CR_DATA8                0x00000080
>>> +#define CR_DATA1                0x000000C0
>>> +#define CR_KEY128               0x00000000
>>> +#define CR_KEY192               0x00000100
>>> +#define CR_KEY256               0x00000200
>>> +#define CR_FFLUSH               0x00004000
>>> +#define CR_CRYPEN               0x00008000
>> Why not using BIT(x) ?
> 
> Some values are not only 1 bit (then we may use BIT and BITGEN but this 
> would be less readable), so I prefer to keep this values.

You can use GENMASK and the corresponding FIELD_PREP() and FIELD_GET().
It avoids manipulating the bits directly.

> 
>> Why not using also directly FLG_XX since CR_XX are arbitray values ? like using instead CR_AES_CBC = FLG_AES | FLG_CBC
> 
> The CR_ values are used to write in the registers. FLG_ are arbitraty 
> values, so we cannot mix them.
> 
>>
>> [...]
>>> +static inline void stm32_cryp_wait_enable(struct stm32_cryp *cryp)
>>> +{
>>> +	while (stm32_cryp_read(cryp, CRYP_CR) & CR_CRYPEN)
>>> +		cpu_relax();
>>> +}
>> This function is not used, so you could remove it
>>
>>> +
>>> +static inline void stm32_cryp_wait_busy(struct stm32_cryp *cryp)
>>> +{
>>> +	while (stm32_cryp_read(cryp, CRYP_SR) & SR_BUSY)
>>> +		cpu_relax();
>>> +}
>> No timeout ?
>>
>>
>>> +
>>> +static inline void stm32_cryp_wait_output(struct stm32_cryp *cryp)
>>> +{
>>> +	while (!(stm32_cryp_read(cryp, CRYP_SR) & SR_OFNE))
>>> +		cpu_relax();
>>> +}
>> This function is not used, so you could remove it
>>
>> [...]
>>> +static int stm32_cryp_check_aligned(struct scatterlist *sg, size_t total,
>>> +				    size_t align)
>>> +{
>>> +	int len = 0;
>>> +
>>> +	if (!total)
>>> +		return 0;
>>> +
>>> +	if (!IS_ALIGNED(total, align))
>>> +		return -EINVAL;
>>> +
>>> +	while (sg) {
>>> +		if (!IS_ALIGNED(sg->offset, sizeof(u32)))
>>> +			return -1;
>> -1 is not a good return value, prefer any -Exxxx
>>
>>> +
>>> +		if (!IS_ALIGNED(sg->length, align))
>>> +			return -1;
>>> +
>>> +		len += sg->length;
>>> +		sg = sg_next(sg);
>>> +	}
>>> +
>>> +	if (len != total)
>>> +		return -1;
>> [...]
>>> +static int stm32_cryp_copy_sgs(struct stm32_cryp *cryp)
>>> +{
>>> +	void *buf_in, *buf_out;
>>> +	int pages, total_in, total_out;
>>> +
>>> +	if (!stm32_cryp_check_io_aligned(cryp)) {
>>> +		cryp->sgs_copied = 0;
>>> +		return 0;
>>> +	}
>>> +
>>> +	total_in = ALIGN(cryp->total_in, cryp->hw_blocksize);
>>> +	pages = total_in ? get_order(total_in) : 1;
>>> +	buf_in = (void *)__get_free_pages(GFP_ATOMIC, pages);
>>> +
>>> +	total_out = ALIGN(cryp->total_out, cryp->hw_blocksize);
>>> +	pages = total_out ? get_order(total_out) : 1;
>>> +	buf_out = (void *)__get_free_pages(GFP_ATOMIC, pages);
>>> +
>>> +	if (!buf_in || !buf_out) {
>>> +		pr_err("Couldn't allocate pages for unaligned cases.\n");
>> You must use dev_err() instead. without it, it will be hard to know which subsystem said that error message.
>>
>> [...]
>>> +static int stm32_cryp_cra_init(struct crypto_tfm *tfm)
>>> +{
>>> +	tfm->crt_ablkcipher.reqsize = sizeof(struct stm32_cryp_reqctx);
>>> +
>>> +	return 0;
>>> +}
>> You could simply remove this function
> 
> I am not sure we can. Here we set reqsize.
> Most of the other drivers do the same, but maybe this is wrong everywhere.
> Could you give more details?
> 
>>
>> [...]
>>> +
>>> +static void stm32_cryp_cra_exit(struct crypto_tfm *tfm)
>>> +{
>>> +}
>>> +
>>> +static int stm32_cryp_crypt(struct ablkcipher_request *req, unsigned long mode)
>>> +{
>>> +	struct stm32_cryp_ctx *ctx = crypto_ablkcipher_ctx(
>>> +			crypto_ablkcipher_reqtfm(req));
>>> +	struct stm32_cryp_reqctx *rctx = ablkcipher_request_ctx(req);
>>> +	struct stm32_cryp *cryp = stm32_cryp_find_dev(ctx);
>>> +
>>> +	if (!cryp)
>>> +		return -ENODEV;
>>> +
>>> +	rctx->mode = mode;
>>> +
>>> +	return crypto_transfer_cipher_request_to_engine(cryp->engine, req);
>>> +}
>>> +
>>> +static int stm32_cryp_setkey(struct crypto_ablkcipher *tfm, const u8 *key,
>>> +			     unsigned int keylen)
>>> +{
>>> +	struct stm32_cryp_ctx *ctx = crypto_ablkcipher_ctx(tfm);
>>> +
>>> +	memcpy(ctx->key, key, keylen);
>>> +	ctx->keylen = keylen;
>> You never zeroize the key after request.
>>
>> [...]
>>> +static const struct of_device_id stm32_dt_ids[] = {
>>> +	{ .compatible = "st,stm32f756-cryp", },
>>> +	{},
>>> +};
>>> +MODULE_DEVICE_TABLE(of, sti_dt_ids);
>>> +
>>> +static int stm32_cryp_probe(struct platform_device *pdev)
>>> +{
>>> +	struct device *dev = &pdev->dev;
>>> +	struct stm32_cryp *cryp;
>>> +	struct resource *res;
>>> +	struct reset_control *rst;
>>> +	const struct of_device_id *match;
>>> +	int irq, ret;
>>> +
>>> +	cryp = devm_kzalloc(dev, sizeof(*cryp), GFP_KERNEL);
>>> +	if (!cryp)
>>> +		return -ENOMEM;
>>> +
>>> +	match = of_match_device(stm32_dt_ids, dev);
>>> +	if (!match)
>>> +		return -ENODEV;
>> I think this test is unnecessary, at least it should be before the devm_kzalloc
>>
>> Regards
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
