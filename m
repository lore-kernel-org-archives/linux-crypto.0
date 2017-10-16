From: Kamil Konieczny <k.konieczny@partner.samsung.com>
Subject: Re: [PATCH v5] crypto: s5p-sss: Add HASH support for Exynos
Date: Mon, 16 Oct 2017 18:19:28 +0200
Message-ID: <128035b0-e92c-406e-fa5b-3a8f901277a1@partner.samsung.com>
References: <CGME20171009111232eucas1p1d17afaae66931a7dd234dbfa1d5a193f@eucas1p1.samsung.com>
        <afa6482f-dc1e-6aab-5754-fa86f554e0b2@partner.samsung.com>
        <4e9717c5-43d1-46d1-60ed-ea8168a91cc4@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
To: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <4e9717c5-43d1-46d1-60ed-ea8168a91cc4@mentor.com>
Content-language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Vladimir,

thank you for review. I will apply most of your suggestions,
in a few places it is not possible, see comments below.
Your review helped me to improve two functions.

On 12.10.2017 13:45, Vladimir Zapolskiy wrote:
> Hello Kamil,
> 
> thank you for the change, please find below a number of minor
> review comments.
> 
> On 10/09/2017 02:12 PM, Kamil Konieczny wrote:
>> Add support for MD5, SHA1, SHA256 hash algorithms for Exynos HW.
>> It uses the crypto framework asynchronous hash api.
>> It is based on omap-sham.c driver.
>> S5P has some HW differencies and is not implemented.
>>
> 
> [snip]
> 
>>  
>>  /* Feed control registers */
>>  #define SSS_REG_FCINTSTAT               0x0000
>> +#define SSS_FCINTSTAT_HPARTINT		BIT(7)
>> +#define SSS_FCINTSTAT_HDONEINT		BIT(5)
> 
>                                       ^^^^^^^^^
> Please use the same style of whitespaces as it is found around.
> 
> Generally I do agree that the tabs are better here, please feel free
> to send a preceding change, which changes the spacing to tabs, otherwise
> use space symbols in this change.

ok, I will break this patch into two, first one change spaces into tabs.

>>  #define SSS_FCINTSTAT_BRDMAINT          BIT(3)
>>  #define SSS_FCINTSTAT_BTDMAINT          BIT(2)
>>  #define SSS_FCINTSTAT_HRDMAINT          BIT(1)
>>  #define SSS_FCINTSTAT_PKDMAINT          BIT(0)
>>  
>>  #define SSS_REG_FCINTENSET              0x0004
>> +#define SSS_FCINTENSET_HPARTINTENSET	BIT(7)
>> +#define SSS_FCINTENSET_HDONEINTENSET	BIT(5)
> 
> Same as above.

ok with this one and following

>> [skip]
> [snip]
> 
>>  struct s5p_aes_reqctx {
>> @@ -195,6 +284,19 @@ struct s5p_aes_ctx {
>>   *		protects against concurrent access to these fields.
>>   * @lock:	Lock for protecting both access to device hardware registers
>>   *		and fields related to current request (including the busy field).
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
>> + * @use_hash:	true if HASH algs enabled
> 
> You may want to reorder the lines to get the same order as in the struct.

ok

>>   */
>>  struct s5p_aes_dev {
>>  	struct device			*dev;
>> @@ -215,16 +317,88 @@ struct s5p_aes_dev {
>>  	struct crypto_queue		queue;
>>  	bool				busy;
>>  	spinlock_t			lock;
>> +
>> +	struct resource			*res;
>> +	void __iomem			*io_hash_base;
>> +
>> +	spinlock_t			hash_lock; /* protect hash_ vars */
>> +	unsigned long			hash_flags;
>> +	struct crypto_queue		hash_queue;
>> +	struct tasklet_struct		hash_tasklet;
>> +
>> +	u8				xmit_buf[BUFLEN];
>> +	struct ahash_request		*hash_req;
>> +	struct scatterlist		*hash_sg_iter;
>> +	int				hash_sg_cnt;
> 
> Please change the type to 'unsigned int'.
> 
>> +
>> +	bool				use_hash;
>>  };
>>  
>> -static struct s5p_aes_dev *s5p_dev;
>> +enum hash_op {
>> +	HASH_OP_UPDATE = 1,
>> +	HASH_OP_FINAL = 2
>> +};
> 
> If this type is not going to be extended, then I'd rather suggest to
> use a boolean correspondent field in the struct s5p_hash_reqctx instead
> of a new introduced type.
> 

I will change this into 'bool op_final'.

>> +
>> +/**
>> + * struct s5p_hash_reqctx - HASH request context
>> + * @dev:	Associated device
>> + * @op:		Current request operation (OP_UPDATE or OP_FINAL)
> 
> See a comment above.
> 
>> + * @digcnt:	Number of bytes processed by HW (without buffer[] ones)
>> + * @digest:	Digest message or IV for partial result
>> + * @bufcnt:	Number of bytes holded in buffer[]
>> + * @nregs:	Number of HW registers for digest or IV read/write
>> + * @engine:	Bits for selecting type of HASH in SSS block
>> + * @sg:		sg for DMA transfer
>> + * @sg_len:	Length of sg for DMA transfer
>> + * @sgl[]:	sg for joining buffer and req->src scatterlist
>> + * @skip:	Skip offset in req->src for current op
>> + * @total:	Total number of bytes for current request
>> + * @finup:	Keep state for finup or final.
>> + * @error:	Keep track of error.
>> + * @buffer[]:	For byte(s) from end of req->src in UPDATE op
>> + */
>> +struct s5p_hash_reqctx {
>> +	struct s5p_aes_dev	*dd;
>> +	enum hash_op		op;
> 
> See a comment above.
> 
>> +
>> +	u64			digcnt;
>> +	u8			digest[SHA256_DIGEST_SIZE];
>> +	u32			bufcnt;
>> +
>> +	int			nregs; /* digest_size / sizeof(reg) */
> 
> It should be "unsigned int nregs", please change the type.

ok (this one and following).

>> +	u32			engine;
>> +
>> +	struct scatterlist	*sg;
>> +	int			sg_len;
> 
> It should be "unsigned int sg_len", please change the type.
> 
>> +	struct scatterlist	sgl[2];
>> +	int			skip;
> 
> It should be "unsigned int skip", please change the type.
> 
>> +	unsigned int		total;
>> +	bool			finup;
>> +	bool			error;
>> +
>> +	u8			buffer[0];
> 
> IMHO here
> 
> 	u8 *buffer;
> or
> 	void *buffer;
> 
> is good enough, if I didn't miss something.

There is reason for it to be buffer[0], it must be last var in struct and
it should _not_ be allocated as separate buffer by user, but with alloc 
for request context from crypto framework.

> Also you may want to move it up closer to "bufcnt".

ok, I will move bufcnt at end of struct, just before buffer[0].

> [snip]
> 
>> +/**
>> + * s5p_hash_rx() - get next hash_sg_iter
>> + * @dev:	device
>> + *
>> + * Return:
>> + * 2	if there is no more data and it is UPDATE op
>> + * 1	if new receiving (input) data is ready and can be written to device
>> + * 0	if there is no more data and it is FINAL op
>> + */
>> +static int s5p_hash_rx(struct s5p_aes_dev *dev)
>> +{
>> +	int ret;
>> +
>> +	if (dev->hash_sg_cnt > 0) {
>> +		dev->hash_sg_iter = sg_next(dev->hash_sg_iter);
>> +		ret = 1;
>> +	} else {
>> +		set_bit(HASH_FLAGS_DMA_READY, &dev->hash_flags);
>> +		if (test_bit(HASH_FLAGS_FINAL, &dev->hash_flags))
>> +			ret = 0;
>> +		else
>> +			ret = 2;
>> +	}
>> +
>> +	return ret;
>> +}
> 
> Let's reduce the level of indentation. Please reuse a version below,
> which is shorter and more comprehensible in my opinion:
> 
> static unsigned int s5p_hash_rx(struct s5p_aes_dev *dev)
> {
> 	if (dev->hash_sg_cnt) {
> 		dev->hash_sg_iter = sg_next(dev->hash_sg_iter);
> 		return 1;
> 	}
> 
> 	set_bit(HASH_FLAGS_DMA_READY, &dev->hash_flags);
> 	if (test_bit(HASH_FLAGS_FINAL, &dev->hash_flags))
> 		return 0;
> 
> 	return 2;
> }

ok

> 
> [snip]
> 
>> +/**
>> + * s5p_hash_read_msg() - read message or IV from HW
>> + * @req:	AHASH request
>> + */
>> +static void s5p_hash_read_msg(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct s5p_aes_dev *dd = ctx->dd;
>> +	u32 *hash = (u32 *)ctx->digest;
>> +	int i;
> 
> Please use 'unsigned int i';

ok

>> +
>> +	for (i = 0; i < ctx->nregs; i++)
>> +		hash[i] = s5p_hash_read(dd, SSS_REG_HASH_OUT(i));
>> +}
>> +
>> +/**
>> + * s5p_hash_write_ctx_iv() - write IV for next partial/finup op.
>> + * @dd:		device
>> + * @ctx:	request context
>> + */
>> +static void s5p_hash_write_ctx_iv(struct s5p_aes_dev *dd,
>> +				  struct s5p_hash_reqctx *ctx)
>> +{
>> +	u32 *hash = (u32 *)ctx->digest;
>> +	int i;
> 
> Please use 'unsigned int i;'
> 
>> +
>> +	for (i = 0; i < ctx->nregs; i++)
>> +		s5p_hash_write(dd, SSS_REG_HASH_IV(i), hash[i]);
>> +}
>> +
>> +/**
>> + * s5p_hash_write_iv() - write IV for next partial/finup op.
>> + * @req:	AHASH request
>> + */
>> +static void s5p_hash_write_iv(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct s5p_aes_dev *dd = ctx->dd;
>> +
>> +	s5p_hash_write_ctx_iv(dd, ctx);
> 
> s5p_hash_write_ctx_iv(ctx->dd, ctx) and drop one line of code?

ok

>> +}
>> +
>> +/**
>> + * s5p_hash_copy_result() - copy digest into req->result
>> + * @req:	AHASH request
>> + */
>> +static void s5p_hash_copy_result(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	int d = ctx->nregs;
> 
> Please define it as 'unsigned int'. And in fact I'd rather suggest
> to remove this local variable completely.

ok

>> +
>> +	if (!req->result)
>> +		return;
>> +
>> +	memcpy(req->result, (u8 *)ctx->digest, d * HASH_REG_SIZEOF);
> 
> And (u8 *) cast above is not needed, remove it, please.

ok

> [snip]
> 
>> +/**
>> + * s5p_hash_set_flow() - set flow inside SecSS AES/DES with/without HASH
>> + * @dev:	secss device
>> + * @hashflow:	HASH stream flow with/without crypto AES/DES
>> + */
>> +static void s5p_hash_set_flow(struct s5p_aes_dev *dev, u32 hashflow)
>> +{
>> +	unsigned long flags;
>> +	u32 flow;
>> +
>> +	spin_lock_irqsave(&dev->lock, flags);
>> +
>> +	flow = SSS_READ(dev, FCFIFOCTRL);
>> +	hashflow &= SSS_HASHIN_MASK;
>> +	flow &= ~SSS_HASHIN_MASK;
>> +	flow |= hashflow;
> 
> I would suggest to do
> 
> 	s5p_hash_set_flow(dev, hashflow & SSS_HASHIN_MASK)
> 
> on caller's side at s5p_ahash_dma_init(), then you can drop
> one line above, which uses "hashflow" as a local variable.
> 

ok

>> +	SSS_WRITE(dev, FCFIFOCTRL, flow);
>> +
>> +	spin_unlock_irqrestore(&dev->lock, flags);
>> +}
>> +
> 
> [snip]
> 
>> +/**
>> + * s5p_hash_write_ctrl() - prepare HASH block in SecSS for processing
>> + * @dd:		secss device
>> + * @length:	length for request
>> + * @final:	0=not final
>> + *
>> + * Prepare SSS HASH block for processing bytes in DMA mode. If it is called
>> + * after previous updates, fill up IV words. For final, calculate and set
>> + * lengths for HASH so SecSS can finalize hash. For partial, set SSS HASH
>> + * length as 2^63 so it will be never reached and set to zero prelow and
>> + * prehigh.
>> + *
>> + * This function does not start DMA transfer.
>> + */
>> +static void s5p_hash_write_ctrl(struct s5p_aes_dev *dd, size_t length,
>> +				int final)
> 
> Please change the type, it should be "bool final".

ok

> [snip]
> 
>> +
>> +/**
>> + * s5p_hash_xmit_dma() - start DMA hash processing
>> + * @dd:		secss device
>> + * @length:	length for request
>> + * @final:	0=not final
>> + *
>> + * Update digcnt here, as it is needed for finup/final op.
>> + */
>> +static int s5p_hash_xmit_dma(struct s5p_aes_dev *dd, size_t length,
>> +			     int final)
> 
> Please change the type, it should be "bool final".

ok

>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
>> +	int cnt;
> 
> 'unsigned int cnt' might be preferred here.

ok
 
>> +
>> +	cnt = dma_map_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE);
>> +	if (!cnt) {
>> +		dev_err(dd->dev, "dma_map_sg error\n");
>> +		ctx->error = true;
>> +		return -EINVAL;
>> +	}
>> +
>> +	set_bit(HASH_FLAGS_DMA_ACTIVE, &dd->hash_flags);
>> +	dd->hash_sg_iter = ctx->sg;
>> +	dd->hash_sg_cnt = cnt;
>> +	s5p_hash_write_ctrl(dd, length, final);
>> +	ctx->digcnt += length;
>> +	ctx->total -= length;
> 
> Please add an empty line right here.

ok

>> +	/* catch last interrupt */
>> +	if (final)
>> +		set_bit(HASH_FLAGS_FINAL, &dd->hash_flags);
>> +
>> +	s5p_set_dma_hashdata(dd, dd->hash_sg_iter); /* DMA starts */
>> +
>> +	return -EINPROGRESS;
>> +}
>> +
>> +/**
>> + * s5p_hash_copy_sgs() - copy request's bytes into new buffer
>> + * @ctx:	request context
>> + * @sg:		source scatterlist request
>> + * @new_len:	number of bytes to process from sg
>> + *
>> + * Allocate new buffer, copy data for HASH into it. If there was xmit_buf
>> + * filled, copy it first, then copy data from sg into it. Prepare one sgl[0]
>> + * with allocated buffer.
>> + *
>> + * Set bit in dd->hash_flag so we can free it after irq ends processing.
>> + */
>> +static int s5p_hash_copy_sgs(struct s5p_hash_reqctx *ctx,
>> +			     struct scatterlist *sg, int new_len)
> 
> Please change the type, it should be
> 
> 	unsigned int new_len
> 
>> +{
>> +	int pages;
>> +	void *buf;
>> +	int len;
> 
> It should be
> 
> 	unsigned int pages, len;
> 	void *buf;
> 

ok

>> +
>> +	len = new_len + ctx->bufcnt;
>> +	pages = get_order(len);
>> +
>> +	buf = (void *)__get_free_pages(GFP_ATOMIC, pages);
>> +	if (!buf) {
>> +		dev_err(ctx->dd->dev, "alloc pages for unaligned case.\n");
>> +		ctx->error = true;
>> +		return -ENOMEM;
>> +	}
>> +
>> +	if (ctx->bufcnt)
>> +		memcpy(buf, ctx->dd->xmit_buf, ctx->bufcnt);
>> +
>> +	scatterwalk_map_and_copy(buf + ctx->bufcnt, sg, ctx->skip,
>> +				 new_len, 0);
>> +	sg_init_table(ctx->sgl, 1);
>> +	sg_set_buf(ctx->sgl, buf, len);
>> +	ctx->sg = ctx->sgl;
>> +	ctx->sg_len = 1;
>> +	ctx->bufcnt = 0;
>> +	ctx->skip = 0;
>> +	set_bit(HASH_FLAGS_SGS_COPIED, &ctx->dd->hash_flags);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * s5p_hash_copy_sg_lists() - copy sg list and make fixes in copy
>> + * @rctx:	request context
>> + * @sg:		source scatterlist request
>> + * @new_len:	number of bytes to process from sg
>> + *
>> + * Allocate new scatterlist table, copy data for HASH into it. If there was
>> + * xmit_buf filled, prepare it first, then copy page, length and offset from
>> + * source sg into it, adjusting begin and/or end for skip offset and
>> + * hash_later value.
>> + *
>> + * Resulting sg table will be assigned to ctx->sg. Set flag so we can free
>> + * it after irq ends processing.
>> + */
>> +static int s5p_hash_copy_sg_lists(struct s5p_hash_reqctx *ctx,
>> +				  struct scatterlist *sg, int new_len)
> 
> unsigned int new_len
> 

ok

>> +{
>> +	int offset = ctx->skip;
>> +	int n = sg_nents(sg);
> 
> unsigned int offset = ctx->skip, n = sg_nents(sg);
> 

ok

>> +	struct scatterlist *tmp;
>> +
>> +	if (ctx->bufcnt)
>> +		n++;
>> +
>> +	ctx->sg = kmalloc_array(n, sizeof(*sg), GFP_KERNEL);
>> +	if (!ctx->sg) {
>> +		ctx->error = true;
>> +		return -ENOMEM;
>> +	}
>> +
>> +	sg_init_table(ctx->sg, n);
>> +
>> +	tmp = ctx->sg;
>> +
>> +	ctx->sg_len = 0;
>> +
>> +	if (ctx->bufcnt) {
>> +		sg_set_buf(tmp, ctx->dd->xmit_buf, ctx->bufcnt);
>> +		tmp = sg_next(tmp);
>> +		ctx->sg_len++;
>> +	}
>> +
>> +	while (sg && new_len) {
>> +		int len = sg->length - offset;
> 
> unsigned int len
> 
>> +
>> +		if (offset) {
>> +			offset -= sg->length;
>> +			if (offset < 0)
>> +				offset = 0;
>> +		}
> 
> if (offset >= sg->length)
> 	offset -= sg->length;
> else
> 	offset = 0;
> 
> is equal, please use this shorter version.

offset will be zero after skip bytes, then this will execute 'offset=0'
for the rest of while loop, not optimal

In sg there are bytes +--skip--+--data--+--rest_tail--+
while loop skips sg elements until 'data', the pointers into 'data' will be filled
in allocated sg. Problem here was using 'offset' var, but this is better to
be named as 'skip'.
I will rewrite this loop, cause now I think it is broken.

unsigned int len, skip = ctx->skip;
[...]
	while (sg && skip >= sg->length) {
		skip -= sg->length;
		sg = sg_next(sg);
	}

	if (skip) {
		len = sg->length - skip;
		if (new_len < len)
			len = new_len;

		new_len -= len;
		sg_set_page(tmp, sg_page(sg), len, sg->offset + skip);
		if (new_len == 0)
			sg_mark_end(tmp);

		tmp = sg_next(tmp);
		ctx->sg_len++;
		sg = sg_next(sg);
	}

	while (sg && new_len) {
		len = sg->length;
		if (new_len < len)
			len = new_len;

		new_len -= len;
		sg_set_page(tmp, sg_page(sg), len, sg->offset);
		if (new_len <= 0)
			sg_mark_end(tmp);

		tmp = sg_next(tmp);
		ctx->sg_len++;
		sg = sg_next(sg);
	}

'if (skip) {...}' body can be moved inside second while loop, so code will be shorter,
but it will have some non-needed add zero operations (one -0 and one +0).

>> +
>> +		if (new_len < len)
>> +			len = new_len;
>> +
>> +		if (len > 0) {
>> +			new_len -= len;
>> +			sg_set_page(tmp, sg_page(sg), len, sg->offset);
>> +			if (new_len <= 0)
>> +				sg_mark_end(tmp);
>> +			tmp = sg_next(tmp);
>> +			ctx->sg_len++;
>> +		}
>> +
>> +		sg = sg_next(sg);
>> +	}
>> +
>> +	set_bit(HASH_FLAGS_SGS_ALLOCED, &ctx->dd->hash_flags);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * s5p_hash_prepare_sgs() - prepare sg for processing
>> + * @sg:		source scatterlist request
>> + * @nbytes:	number of bytes to process from sg
>> + * @bs:		block size
> 
> bs argument of the function is not found at all.
> 

removed

>> + * @final:	final flag
>> + * @rctx:	request context
> 
> In your change sometimes you use 'rctx' and sometimes 'ctx' name
> of a pointer to "struct s5p_hash_reqctx" type of storage.
> 
> Please select just one name and use it everywhere, there should be
> no name conflicts, I believe.
> 

You are right, I will use ctx.

>> + *
>> + * Check two conditions: (1) if buffers in sg have len aligned data, and (2)
>> + * sg table have good aligned elements (list_ok). If one of this checks fails,
>> + * then either (1) allocates new buffer for data with s5p_hash_copy_sgs, copy
>> + * data into this buffer and prepare request in sgl, or (2) allocates new sg
>> + * table and prepare sg elements.
>> + *
>> + * For digest or finup all conditions can be good, and we may not need any
>> + * fixes.
>> + */
>> +static int s5p_hash_prepare_sgs(struct scatterlist *sg,
>> +				int nbytes, bool final,
> 
> unsigned int nbytes

ok

>> +				struct s5p_hash_reqctx *rctx)
> 
> Can you please reorder the arguments by placing rctx as the first one?

ok
 
>> +{
>> +	int n = 0;
>> +	bool aligned = true;
>> +	bool list_ok = true;
>> +	struct scatterlist *sg_tmp = sg;
>> +	int offset = rctx->skip;
>> +	int new_len;
> 
> Please use the 'reverse Christmas tree' order and put declarations on
> a single line when it is possible:
> 
> 	unsigned int offset = rctx->skip, new_len = nbytes, n = 0;
> 	bool aligned = true, list_ok = true;
> 	struct scatterlist *sg_tmp = sg;
 
ok

>> +
>> +	if (!sg || !sg->length || !nbytes)
>> +		return 0;
>> +
>> +	new_len = nbytes;
>> +
>> +	if (offset)
>> +		list_ok = false;
>> +
>> +	if (!final)
>> +		list_ok = false;
> 
> if (offset || !final)
> 	list_ok = false;

ok

>> +
>> +	while (nbytes > 0 && sg_tmp) {
>> +		n++;
>> +
>> +		if (offset < sg_tmp->length) {
>> +			if (!IS_ALIGNED(sg_tmp->length - offset, BUFLEN)) {
>> +				aligned = false;
>> +				break;
>> +			}
>> +		}
>> +
>> +		if (!sg_tmp->length) {
>> +			aligned = false;
>> +			break;
>> +		}
>> +
>> +		if (offset) {
>> +			offset -= sg_tmp->length;
>> +			if (offset < 0) {
>> +				nbytes += offset;
>> +				offset = 0;
>> +			}
>> +		} else {
>> +			nbytes -= sg_tmp->length;
>> +		}
>> +
>> +		sg_tmp = sg_next(sg_tmp);
>> +
>> +		if (nbytes < 0) { /* when hash_later is > 0 */
>> +			list_ok = false;
>> +			break;
>> +		}
> 
> Huh, please use an alternative version, which works with unsigned integers
> (and a bit more faster):
> 
> 	if (offset >= sg_tmp->length) {
> 		offset -= sg_tmp->length;
> 	} else {
> 		if (offset)
> 			offset = 0;
> 
> 		if (nbytes + offset < sg_tmp->length) {
> 			list_ok = false;
> 			break;
> 		}
> 
> 		nbytes += offset - sg_tmp->length;
> 	}
> 
> 	sg_tmp = sg_next(sg_tmp);
> 

I will rewrite this and simplify, replace 'offset' with 'skip'.


>> +	}
>> +
> 
> [snip]
> 
>> +/**
>> + * s5p_hash_update_dma_stop() - unmap DMA
>> + * @dd:		secss device
>> + *
>> + * Unmap scatterlist ctx->sg.
>> + */
>> +static int s5p_hash_update_dma_stop(struct s5p_aes_dev *dd)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(dd->hash_req);
>> +
>> +	dma_unmap_sg(dd->dev, ctx->sg, ctx->sg_len, DMA_TO_DEVICE);
>> +	clear_bit(HASH_FLAGS_DMA_ACTIVE, &dd->hash_flags);
>> +
>> +	return 0;
> 
> static void s5p_hash_update_dma_stop(struct s5p_aes_dev *dd) then?
> 

ok

>> +}
>> +
>> +/**
>> + * s5p_hash_finish() - copy calculated digest to crypto layer
>> + * @req:	AHASH request
>> + *
>> + * Returns 0 on success and negative values on error.
>> + */
>> +static int s5p_hash_finish(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct s5p_aes_dev *dd = ctx->dd;
>> +	int err = 0;
>> +
>> +	if (ctx->digcnt)
>> +		s5p_hash_copy_result(req);
>> +
>> +	dev_dbg(dd->dev, "hash_finish digcnt: %lld\n", ctx->digcnt);
>> +
>> +	return err;
> 
> return 0, err is unused. And please consider to change the return
> type of the function to void as well.

ok

> [snip]
> 
>> +static int s5p_hash_handle_queue(struct s5p_aes_dev *dd,
>> +				 struct ahash_request *req)
>> +{
>> +	struct crypto_async_request *async_req, *backlog;
>> +	struct s5p_hash_reqctx *ctx;
>> +	unsigned long flags;
>> +	int err = 0, ret = 0;
>> +
>> +retry:
>> +	spin_lock_irqsave(&dd->hash_lock, flags);
>> +	if (req)
>> +		ret = ahash_enqueue_request(&dd->hash_queue, req);
>> +	if (test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
>> +		spin_unlock_irqrestore(&dd->hash_lock, flags);
>> +		return ret;
>> +	}
> 
> Please add an empty line after the closing bracket.

ok

>> +	backlog = crypto_get_backlog(&dd->hash_queue);
>> +	async_req = crypto_dequeue_request(&dd->hash_queue);
>> +	if (async_req)
>> +		set_bit(HASH_FLAGS_BUSY, &dd->hash_flags);
>> +	spin_unlock_irqrestore(&dd->hash_lock, flags);
>> +
>> +	if (!async_req)
>> +		return ret;
>> +
>> +	if (backlog)
>> +		backlog->complete(backlog, -EINPROGRESS);
>> +
>> +	req = ahash_request_cast(async_req);
>> +	dd->hash_req = req;
>> +	ctx = ahash_request_ctx(req);
>> +
>> +	err = s5p_hash_prepare_request(req, ctx->op == HASH_OP_UPDATE);
>> +	if (err || !ctx->total)
>> +		goto out;
>> +
>> +	dev_dbg(dd->dev, "handling new req, op: %u, nbytes: %d\n",
>> +		ctx->op, req->nbytes);
>> +
>> +	s5p_ahash_dma_init(dd, SSS_HASHIN_INDEPENDENT);
>> +	if (ctx->digcnt)
>> +		s5p_hash_write_iv(req); /* restore hash IV */
>> +
>> +	if (ctx->op == HASH_OP_UPDATE) {
>> +		err = s5p_hash_xmit_dma(dd, ctx->total, ctx->finup);
>> +		if (err != -EINPROGRESS && ctx->finup)
>> +			/* no final() after finup() */
>> +			err = s5p_hash_xmit_dma(dd, ctx->total, 1);
>> +	} else if (ctx->op == HASH_OP_FINAL) {
>> +		err = s5p_hash_xmit_dma(dd, ctx->total, 1);
>> +	}
>> +out:
>> +	if (err != -EINPROGRESS) {
>> +		/* hash_tasklet_cb will not finish it, so do it here */
>> +		s5p_hash_finish_req(req, err);
>> +		req = NULL;
>> +
>> +		/*
>> +		 * Execute next request immediately if there is anything
>> +		 * in queue.
>> +		 */
>> +		goto retry;
>> +	}
>> +
>> +	return ret;
>> +}
>> +
>> +/**
>> + * s5p_hash_tasklet_cb() - hash tasklet
>> + * @data:	ptr to s5p_aes_dev
>> + */
>> +static void s5p_hash_tasklet_cb(unsigned long data)
>> +{
>> +	struct s5p_aes_dev *dd = (struct s5p_aes_dev *)data;
>> +	int err = 0;
>> +
>> +	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags)) {
>> +		s5p_hash_handle_queue(dd, NULL);
>> +		return;
>> +	}
>> +
>> +	if (test_bit(HASH_FLAGS_DMA_READY, &dd->hash_flags)) {
>> +		if (test_and_clear_bit(HASH_FLAGS_DMA_ACTIVE,
>> +				       &dd->hash_flags)) {
>> +			s5p_hash_update_dma_stop(dd);
>> +		}
>> +
>> +		if (test_and_clear_bit(HASH_FLAGS_OUTPUT_READY,
>> +				       &dd->hash_flags)) {
>> +			/* hash or semi-hash ready */
>> +			clear_bit(HASH_FLAGS_DMA_READY, &dd->hash_flags);
>> +				goto finish;
>> +		}
>> +	}
>> +
>> +	return;
>> +
>> +finish:
>> +	/* finish curent request */
>> +	s5p_hash_finish_req(dd->hash_req, err);
> 
> s5p_hash_finish_req(dd->hash_req, 0);
> 

ok

>> +
>> +	/* If we are not busy, process next req */
>> +	if (!test_bit(HASH_FLAGS_BUSY, &dd->hash_flags))
>> +		s5p_hash_handle_queue(dd, NULL);
>> +}
>> +
>> +/**
>> + * s5p_hash_enqueue() - enqueue request
>> + * @req:	AHASH request
>> + * @op:		operation UPDATE or FINAL
>> + *
>> + * Returns: see s5p_hash_final below.
>> + */
>> +static int s5p_hash_enqueue(struct ahash_request *req, enum hash_op op)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(req->base.tfm);
>> +	struct s5p_aes_dev *dd = tctx->dd;
>> +
>> +	ctx->op = op;
>> +
>> +	return s5p_hash_handle_queue(dd, req);
> 
> return s5p_hash_handle_queue(tctx->dd, req) and drop a local variable.
 
ok

> [snip]
> 
>> +/**
>> + * s5p_hash_finup() - process last req->src and calculate digest
>> + * @req:	AHASH request containing the last update data
>> + *
>> + * Return values: see s5p_hash_final above.
>> + */
>> +static int s5p_hash_finup(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	int err1, err2;
>> +
>> +	ctx->finup = true;
>> +
>> +	err1 = s5p_hash_update(req);
>> +	if (err1 == -EINPROGRESS || err1 == -EBUSY)
>> +		return err1;
> 
> Please add an empty line before the comment block.

ok

>> +	/*
>> +	 * final() has to be always called to cleanup resources even if
>> +	 * update() failed, except EINPROGRESS or calculate digest for small
>> +	 * size
>> +	 */
>> +	err2 = s5p_hash_final(req);
>> +
>> +	return err1 ?: err2;
>> +}
>> +
>> +/**
>> + * s5p_hash_init() - initialize AHASH request contex
>> + * @req:	AHASH request
>> + *
>> + * Init async hash request context.
>> + */
>> +static int s5p_hash_init(struct ahash_request *req)
>> +{
>> +	struct s5p_hash_reqctx *ctx = ahash_request_ctx(req);
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> +	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
>> +	struct s5p_aes_dev *dd = tctx->dd;
>> +
>> +	ctx->dd = dd;
> 
> ctx->dd = tctx->dd and drop a local variable;

ok

>> +	ctx->error = false;
>> +	ctx->finup = false;
>> +
>> +	dev_dbg(dd->dev, "init: digest size: %d\n",
>> +		crypto_ahash_digestsize(tfm));
>> +
>> +	switch (crypto_ahash_digestsize(tfm)) {
>> +	case MD5_DIGEST_SIZE:
>> +		ctx->engine = SSS_HASH_ENGINE_MD5;
>> +		ctx->nregs = HASH_MD5_MAX_REG;
>> +		break;
>> +	case SHA1_DIGEST_SIZE:
>> +		ctx->engine = SSS_HASH_ENGINE_SHA1;
>> +		ctx->nregs = HASH_SHA1_MAX_REG;
>> +		break;
>> +	case SHA256_DIGEST_SIZE:
>> +		ctx->engine = SSS_HASH_ENGINE_SHA256;
>> +		ctx->nregs = HASH_SHA256_MAX_REG;
>> +		break;
>> +	}
>> +
>> +	ctx->bufcnt = 0;
>> +	ctx->digcnt = 0;
>> +	ctx->total = 0;
>> +	ctx->skip = 0;
>> +
>> +	return 0;
> 
> The function can be void.
 
No, it can not, because it is part of struct passed to crypto framework,
and should return error code. I will add default to switch-case with error path.
This function is used in struct ahash_alg algs_sha1_md5_sha256[].

>> +}
>> +
>> +/**
>> + * s5p_hash_digest - calculate digest from req->src
>> + * @req:	AHASH request
>> + *
>> + * Return values: see s5p_hash_final above.
>> + */
>> +static int s5p_hash_digest(struct ahash_request *req)
>> +{
>> +	return s5p_hash_init(req) ?: s5p_hash_finup(req);
> 
> Hmm, missing 0?
> 
> return s5p_hash_init(req) ? 0 : s5p_hash_finup(req);

No, it is intentional, if _init(req) returns error (non-zero), it is passed
as return value from function. In case of zero, _finup(req) is called and
used as return value. This saves some space and vars:

err = _init(req);
if(err) return err;

return _finup(req);

>> +}
>> +
>> +/**
>> + * s5p_hash_cra_init_alg - init crypto alg transformation
>> + * @tfm:	crypto transformation
>> + */
>> +static int s5p_hash_cra_init_alg(struct crypto_tfm *tfm)
>> +{
>> +	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(tfm);
>> +	const char *alg_name = crypto_tfm_alg_name(tfm);
>> +
>> +	tctx->dd = s5p_dev;
>> +	/* Allocate a fallback and abort if it failed. */
>> +	tctx->fallback = crypto_alloc_shash(alg_name, 0,
>> +					    CRYPTO_ALG_NEED_FALLBACK);
>> +	if (IS_ERR(tctx->fallback)) {
>> +		pr_err("fallback alloc fails for '%s'\n", alg_name);
>> +		return PTR_ERR(tctx->fallback);
>> +	}
>> +
>> +	crypto_ahash_set_reqsize(__crypto_ahash_cast(tfm),
>> +				 sizeof(struct s5p_hash_reqctx) + BUFLEN);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * s5p_hash_cra_init - init crypto tfm
>> + * @tfm:	crypto transformation
>> + */
>> +static int s5p_hash_cra_init(struct crypto_tfm *tfm)
>> +{
>> +	return s5p_hash_cra_init_alg(tfm);
>> +}
>> +
>> +/**
>> + * s5p_hash_cra_exit - exit crypto tfm
>> + * @tfm:	crypto transformation
>> + *
>> + * free allocated fallback
>> + */
>> +static void s5p_hash_cra_exit(struct crypto_tfm *tfm)
>> +{
>> +	struct s5p_hash_ctx *tctx = crypto_tfm_ctx(tfm);
>> +
>> +	crypto_free_shash(tctx->fallback);
>> +	tctx->fallback = NULL;
>> +}
>> +
>> +/**
>> + * s5p_hash_export - export hash state
>> + * @req:	AHASH request
>> + * @out:	buffer for exported state
>> + */
>> +static int s5p_hash_export(struct ahash_request *req, void *out)
> 
> static void s5p_hash_export(struct ahash_request *req, void *out)

This one also is part of crypto framework struct and cannot be void.

>> +{
>> +	struct s5p_hash_reqctx *rctx = ahash_request_ctx(req);
>> +
>> +	memcpy(out, rctx, sizeof(*rctx) + rctx->bufcnt);
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * s5p_hash_import - import hash state
>> + * @req:	AHASH request
>> + * @in:		buffer with state to be imported from
>> + */
>> +static int s5p_hash_import(struct ahash_request *req, const void *in)
>> +{
>> +	struct s5p_hash_reqctx *rctx = ahash_request_ctx(req);
>> +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
>> +	struct s5p_hash_ctx *tctx = crypto_ahash_ctx(tfm);
>> +	const struct s5p_hash_reqctx *ctx_in = in;
>> +
>> +	memcpy(rctx, in, sizeof(*rctx) + BUFLEN);
>> +	if ((ctx_in->bufcnt < 0) || (ctx_in->bufcnt > BUFLEN)) {
> 
> Here checkpatch fairly complains that two pairs of parentheses are
> unnecessary, plese remove them.

ok

>> +		rctx->error = true;
>> +		return -EINVAL;
>> +	}
>> +
>> +	rctx->dd = tctx->dd;
>> +	rctx->error = false;
>> +
>> +	return 0;
>> +}
> 
> [snip]
> 
>>  static void s5p_set_aes(struct s5p_aes_dev *dev,
>>  			uint8_t *key, uint8_t *iv, unsigned int keylen)
>>  {
>> @@ -829,6 +2190,7 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>  	struct samsung_aes_variant *variant;
>>  	struct s5p_aes_dev *pdata;
>>  	struct resource *res;
>> +	int hash_i;
> 
> unsigned int hash_i;

ok

>>  
>>  	if (s5p_dev)
>>  		return -EEXIST;
>> @@ -837,12 +2199,33 @@ static int s5p_aes_probe(struct platform_device *pdev)
>>  	if (!pdata)
>>  		return -ENOMEM;
> 
> [snip]
> 
> --
> With best wishes,
> Vladimir
> 
> 
> 

-- 
Best regards,
Kamil Konieczny
Samsung R&D Institute Poland
