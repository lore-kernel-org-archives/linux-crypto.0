From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v3] crypto: s5p-sss: Add HASH support for Exynos
Date: Tue, 03 Oct 2017 16:57:43 +0200
Message-ID: <77ef8f3f-a686-0043-c55d-761033a11956@partner.samsung.com>
References: <CGME20170927122551eucas1p2ce5b868e59bfa99941672936ba3c7bed@eucas1p2.samsung.com>
        <fddf226a-b0d8-fd68-3713-347ac3a0de20@partner.samsung.com>
        <20170930195044.kyhiit2nqmjgcwtl@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20170930195044.kyhiit2nqmjgcwtl@kozik-lap>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 30.09.2017 21:50, Krzysztof Kozlowski wrote:
> On Wed, Sep 27, 2017 at 02:25:50PM +0200, Kamil Konieczny wrote:
>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>> It uses the crypto framework asynchronous hash api.
>> It is based on omap-sham.c driver.
>> S5P has some HW differencies and is not implemented.
>>
>> Modifications in s5p-sss:
>>[...]

>> +/*
>> + * HASH bit numbers, used by device, setting in dev->hash_flags with
>> + * functions set_bit(), clear_bit() or tested with test_bit() or BIT(),
>> + * to keep HASH state BUSY or FREE, or to signal state from irq_handler
>> + * to hash_tasklet. SGS keep track of allocated memory for scatterlist
>> + */
>> +#define HASH_FLAGS_BUSY		0
>> +#define HASH_FLAGS_FINAL	1
>> +#define HASH_FLAGS_DMA_ACTIVE	2
>> +#define HASH_FLAGS_OUTPUT_READY	3
>> +#define HASH_FLAGS_DMA_READY	4
>> +#define HASH_FLAGS_SGS_COPIED	5
>> +#define HASH_FLAGS_SGS_ALLOCED	6
>> +
>> +/*
>> + * HASH bit numbers used in request context
>> + * FINUP mark last hash operation
>> + */
>> +#define HASH_FLAGS_FINUP	7
>> +#define HASH_FLAGS_ERROR	8
> 
> I spent some time on s5p_hash_finish_req() and other code around flags,
> confused by two different flags (ctx->flags, device->hash_flags) and
> different API used to play with them next to each other (once test_bit,
> line later just |=).
> 
> This is just confusing. AFAIU, you use only two bits in ctx->flags, so
> just convert it to two bools. This will remove the confuse:
> 1. between the defines before and here,
> 2. around mixing xxx_bit() and regular |= operations.
> 

Good point, I will rewrite them into two bool vars.

>> +
>> +/* HASH op codes */
>> +#define HASH_OP_UPDATE		1
>> +#define HASH_OP_FINAL		2
>> +
>> +/* HASH HW constants */
>> +#define BUFLEN			HASH_BLOCK_SIZE
>> +
>> +#define SSS_DMA_ALIGN		16
>> +#define SSS_ALIGNED		__attribute__((aligned(SSS_DMA_ALIGN)))
>> +#define SSS_DMA_ALIGN_MASK	(SSS_DMA_ALIGN - 1)
> 
> No changes here... I asked for making this consistent with current code
> so please bring a patch which introduces new macro to existing code and
> then re-use it for new code.
> 
> Dropping inconsistent code and then promising "I will fix it up later"
> does not work.

This align stuff was again taken from omap driver. AES code does not need
any DMA_ALIGN, it sets ".cra_align = 0x0f", but it is not needed, it can be
simple zero 0x00, as AES operate on blocks of 64 bytes long, and SecSS DMA
engine can operate on non-aligned addresses. I am not sure how CPU will
handle HASH corner case at last update, when input data will point to last
byte of page, length will be 1, and FeedControl will round up length to 8,
so DMA will try (?) reading bytes after page.
To sum it up, AES code needs cleanup ".cra_align = 0", but I do not think
it is so critical to make it before HASH.

You have good point here, as the names are confusing, so I will remove
SSS_ALIGNED from HASH struct definitions, and change SSS_DMA_ALIGN into
SSS_HASH_DMA_LEN_ALIGN, and SSS_DMA_ALIGN_MASK into SSS_HASH_DMA_ALIGN_MASK.

>> [...]
>>   * @lock:	Lock for protecting both access to device hardware registers
>> - *		and fields related to current request (including the busy field).
>> + *		and fields related to current request (including the busy
>> + *		field).
> 
> Why wrapping this line?

Sorry, I will remove this cleanup (line is 81 bytes long).

>> + * @res:	Resources for hash.
>> + * @io_hash_base: Per-variant offset for HASH block IO memory.
>> + * @hash_lock:	Lock for protecting hash_req, hash_queue and hash_flags
>> + *		variable.
>> + * @hash_tasklet: New HASH request scheduling job.
>> + * @xmit_buf:	Buffer for current HASH request transfer into SSS block.
>> + * @hash_flags:	Flags for current HASH op.
>> + * @hash_queue:	Async hash queue.
>> + * @hash_req:	Current request sending to SSS HASH block.
>> + * @hash_sg_iter: Scatterlist transferred through DMA into SSS HASH block.
>> + * @hash_sg_cnt: Counter for hash_sg_iter.
>> + *
>> +/**
>> + * s5p_hash_rx - get next hash_sg_iter
>> + * @dev:	device
>> + *
>> + * Return:
>> + * 2	if there is no more data and it is UPDATE op
>> + * 1	if new receiving (input) data is ready and can be written to
>> + *	device
> 
> Why wrapping so early?

OK, I will reformat comments up to 80 bytes per line, this one and following
ones.

>>[...]
>> +
>> +	if (final) {
>> +		/* number of bytes for last part */
>> +		low = length; high = 0;
> 
> No multiple assignments in one line.
> 
>> +		/* total number of bits prev hashed */
>> +		tmplen = ctx->digcnt * 8;
>> +		prelow = (u32)tmplen;
>> +		prehigh = (u32)(tmplen >> 32);
>> +	} else {
>> +		prelow = 0; prehigh = 0;
>> +		low = 0; high = BIT(31);
> 
> No multiple assignments in one line.
> 

OK, I will rewrite this.

>> [...]
>> +static struct ahash_alg algs_sha256[] = {
>> +{
>> +	.init		= s5p_hash_init,
>> +	.update		= s5p_hash_update,
>> +	.final		= s5p_hash_final,
>> +	.finup		= s5p_hash_finup,
>> +	.digest		= s5p_hash_digest,
>> +	.halg.digestsize	= SHA256_DIGEST_SIZE,
>> +	.halg.base	= {
>> +		.cra_name		= "sha256",
>> +		.cra_driver_name	= "exynos-sha256",
>> +		.cra_priority		= 100,
>> +		.cra_flags		= CRYPTO_ALG_TYPE_AHASH |
>> +					  CRYPTO_ALG_KERN_DRIVER_ONLY |
>> +					  CRYPTO_ALG_ASYNC |
>> +					  CRYPTO_ALG_NEED_FALLBACK,
>> +		.cra_blocksize		= HASH_BLOCK_SIZE,
>> +		.cra_ctxsize		= sizeof(struct s5p_hash_ctx),
>> +		.cra_alignmask		= SSS_DMA_ALIGN_MASK,
>> +		.cra_module		= THIS_MODULE,
>> +		.cra_init		= s5p_hash_cra_init,
>> +		.cra_exit		= s5p_hash_cra_exit,
>> +	}
>> +}
>> +
>> +};
>> +
>> +static struct sss_hash_algs_info exynos_hash_algs_info[] = {
> 
> You have warnings in your code. Please be sure that all compiler,
> Smatch, Sparse, checkpatch and coccicheck warnings are fixed.
> 
> ../drivers/crypto/s5p-sss.c:1896:34: warning: ‘exynos_hash_algs_info’ defined but not used [-Wunused-variable]
>  static struct sss_hash_algs_info exynos_hash_algs_info[] = {
> 
> Probably this should be __maybe_unused.

You are right, I did not check this with EXYNOS_HASH disabled, I will
rewrite it.

> Also this should be const. I do not understand why you have to add one
> more static variable (which sticks the driver to only one instance...)
> and then modify it during runtime. Everything should be stored in device
> state container (s5p_aes_dev) - directly or through some other pointers.

There is .registered field which is incremented with each algo register.
I can move assignes to fields .import, .export and .statesize into struct.
When I tried add const, I got compiler warn:
drivers/crypto/s5p-sss.c: In function ‘s5p_aes_remove’:
drivers/crypto/s5p-sss.c:2397:6: warning: passing argument 1 of ‘crypto_unregister_ahash’ discards ‘const’ qualifier from pointer target type [-Wdiscarded-qualifiers]
      &hash_algs_i[i].algs_list[j]);
so it was not designed to be const (in crypto framework).
In AES code the alg struct is also static:
static struct crypto_alg algs[] = {

What you mean by 'stick the driver to only one instance' ? In Exynos 4412 there
is only one SecSS block, in some other Exynos there is SlimSS, but it is not
the same (it has lower capabilities and other io addresses), so there should not
be two s5p_aes_dev drivers loaded at the same time. 

>> +	{
>> +		.algs_list	= algs_sha1_md5,
>> +		.size		= ARRAY_SIZE(algs_sha1_md5),
>> +	},
>> +	{
>> +		.algs_list	= algs_sha256,
>> +		.size		= ARRAY_SIZE(algs_sha256),
>> +	},
>> +};
>> +
>>  static void s5p_set_aes(struct s5p_aes_dev *dev,
>>  			uint8_t *key, uint8_t *iv, unsigned int keylen)
>>  {
>> @@ -826,9 +2218,12 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>  {
>>  	struct device *dev = &pdev->dev;
>>  	int i, j, err = -ENODEV;
>> +	int hash_algs_size = 0;
>> +	struct sss_hash_algs_info *hash_algs_i;
>>  	struct samsung_aes_variant *variant;
>>  	struct s5p_aes_dev *pdata;
>>  	struct resource *res;
>> +	int hash_i;
>>  
>>  	if (s5p_dev)
>>  		return -EEXIST;
>> @@ -837,12 +2232,38 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>  	if (!pdata)
>>  		return -ENOMEM;
>>  
>> +	variant = find_s5p_sss_version(pdev);
>>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> -	pdata->ioaddr = devm_ioremap_resource(&pdev->dev, res);
>> -	if (IS_ERR(pdata->ioaddr))
>> -		return PTR_ERR(pdata->ioaddr);
>> +	/* Note: HASH and PRNG uses the same registers in secss,
> 
> Comment style.

OK, I will change it.
 
>> +	 * avoid overwrite each other. This will drop HASH when
>> +	 * CONFIG_EXYNOS_RNG is enabled in config.
>> +	 * We need larger size for HASH registers in secss, current
>> +	 * describe only AES/DES
>> +	 */
>> +	if (variant == &exynos_aes_data) {
>> +#ifdef CONFIG_CRYPTO_DEV_EXYNOS_HASH
> 
> Use IS_ENABLED(), code is more readable then with ifdefs.

OK, I will use it.

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
