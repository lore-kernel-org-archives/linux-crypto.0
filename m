From: Andrew Morton <akpm@osdl.org>
Subject: Re: crypto: Add support for the Geode AES engine (v2)
Date: Thu, 28 Sep 2006 15:06:09 -0700
Message-ID: <20060928150609.dd6e4493.akpm@osdl.org>
References: <20060927193147.GA21043@cosmic.amd.com>
	<20060928102337.GB23342@2ka.mipt.ru>
	<20060928214750.GM25387@cosmic.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Evgeniy Polyakov" <johnpol@2ka.mipt.ru>,
	linux-crypto@vger.kernel.org, info-linux@ldcmail.amd.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55767 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1161318AbWI1WGW (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Sep 2006 18:06:22 -0400
To: "Jordan Crouse" <jordan.crouse@amd.com>
In-Reply-To: <20060928214750.GM25387@cosmic.amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, 28 Sep 2006 15:47:50 -0600
"Jordan Crouse" <jordan.crouse@amd.com> wrote:

> > As far as I can see, register access is not protected, how can your
> > driver handle the case when dm-crypt and IPsec simultaneously try to
> > encrypt/decrypt some data, it can happen even around 
> > preemt_disable/enable calls and actually crypto processing can happen 
> > in interrupt context too (although it is not the best thing to do).
> 
> I was sitting there trying to architect some grand scheme, and then it
> occured to me that we should just turn off the interrupts all together
> in the critical area.  Its not optimal for performance, but it
> avoids lots of crazy if statements.
> 
> > You added timeout for the broken hardware condition, I think it is
> > better to return some error from _crypt() in that case, and, btw, that
> > name is not very good choice.
> 
> Fixed the name and I return the error.  I don't propagate it through the
> whole chain, because quite frankly, if the crypto engine fails, then its
> a good bet the processor is on fire. :)
> 
> ...
>



> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index adb5541..e816535 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -51,4 +51,17 @@ config CRYPTO_DEV_PADLOCK_SHA
>  	  If unsure say M. The compiled module will be
>  	  called padlock-sha.ko
>  
> +config CRYPTO_DEV_GEODE
> +	tristate "Support for the Geode LX AES engine"
> +	depends on CRYPTO && X86_32

Does it depend on GEODE in some fashion too?

> +	select CRYPTO_ALGAPI
> +	select CRYPTO_BLKCIPHER
> +	default m
> +	help
> +	  Say 'Y' here to use the AMD Geode LX processor on-board AES
> +	  engine for the CryptoAPI AES alogrithm.
> +
> +	  To compile this driver as a module, choose M here: the module
> +	  will be called geode-aes.
> +
>  endmenu
> 
> ...
>
> +
> +/* Useful macros */
> +
> +#define SET_KEY(key) _writefield(AES_WRITEKEY0_REG, key)
> +#define SET_IV(iv)   _writefield(AES_WRITEIV0_REG, iv)
> +#define GET_IV(iv)   _readfield(AES_WRITEIV0_REG, iv)
> +#define AWRITE(val, reg) (iowrite32(val, _iobase + reg))
> +#define AREAD(reg)  (ioread32(_iobase + reg))

lower-case static-inlines are nicer...

Or just remove them and open-code it all.

> +/* Static structures */
> +
> +static void __iomem * _iobase;
> +
> +/* Write a 128 bit field (either a writable key or IV) */
> +static inline void
> +_writefield(u32 offset, void *value)
> +{
> +	int i;
> +	for(i = 0; i < 4; i++)
> +		AWRITE(((u32 *) value)[i], offset + (i * 4));
> +}
>
> +/* Read a 128 bit field (either a writable key or IV) */
> +static inline void
> +_readfield(u32 offset, void *value)
> +{
> +	int i;
> +	for(i = 0; i < 4; i++)
> +		((u32 *) value)[i] = AREAD(offset + (i * 4));
> +}
> +
> ...
>
> +unsigned int
> +geode_aes_crypt(struct geode_aes_op *op)
> +{
> +	u32 flags = 0;
> +	int iflags;
> +
> +	if (op->len == 0 || op->src == op->dst)
> +		return 0;
> +
> +	if (op->flags & AES_FLAGS_COHERENT)
> +		flags |= (AES_CTRL_DCA | AES_CTRL_SCA);
> +
> +	if (op->dir == AES_DIR_ENCRYPT)
> +		flags |= AES_CTRL_ENCRYPT;
> +
> +	/* Start the critical section */
> +
> +	spin_lock_irqsave(&lock, iflags);
> +
> +	if (op->mode == AES_MODE_CBC) {
> +		flags |= AES_CTRL_CBC;
> +		SET_IV(op->iv);
> +	}
> +
> +	if (op->flags & AES_FLAGS_USRKEY) {
> +		flags |= AES_CTRL_WRKEY;
> +		SET_KEY(op->key);
> +	}
> +
> +	do_crypt(op->src, op->dst, op->len, flags);
> +
> +	if (op->mode == AES_MODE_CBC)
> +		GET_IV(op->iv);
> +
> +	spin_lock_irqrestore(&lock, iflags);
> +
> +	return op->len;
> +}

Running do_crypt() under spin_lock_irqsave() seems a bit sad from a latency
POV.

> +/* CRYPTO-API Functions */
> +
> +#define blk_ctx(tfm) ((struct geode_aes_op *) crypto_blkcipher_ctx(tfm))
> +#define ctx(tfm) ((struct geode_aes_op *) crypto_tfm_ctx(tfm))

Both crypto_blkcipher_ctx() and crypto_tfm_ctx() return a nice void*. 
There's no need for the typecast and hence there's really no need for these
macros at all.  Simply open-code the crypto_blkcipher_ctx() and
crypto_tfm_ctx() calls.

> +static int
> +geode_setkey(struct crypto_tfm *tfm, const u8 *key, unsigned int len)
> +{
> +	struct geode_aes_op *op = ctx(tfm);
> +
> +	if (len != AES_KEY_LENGTH) {
> +		tfm->crt_flags |= CRYPTO_TFM_RES_BAD_KEY_LEN;
> +		return -EINVAL;
> +	}
> +
> +	memcpy(op->key, key, len);
> +	return 0;
> +}
> +
> +static void
> +geode_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +{
> +	struct geode_aes_op *op = ctx(tfm);
> +
> +	if ((out == NULL) || (in == NULL))
> +		return;
> +
> +	op->src = (void *) in;
> +	op->dst = (void *) out;

Unneeded casts

> +	op->mode = AES_MODE_ECB;
> +	op->flags = 0;
> +	op->len = AES_MIN_BLOCK_SIZE;
> +	op->dir = AES_DIR_ENCRYPT;
> +
> +	geode_aes_crypt(op);
> +}
> +
> +
> +static void
> +geode_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
> +{
> +	struct geode_aes_op *op = ctx(tfm);
> +
> +	if ((out == NULL) || (in == NULL))
> +		return;
> +
> +	op->src = (void *) in;
> +	op->dst = (void *) out;

Unneeded casts

> +static int
> +geode_cbc_decrypt(struct blkcipher_desc *desc,
> +		  struct scatterlist *dst, struct scatterlist *src,
> +		  unsigned int nbytes)
> +{
> +	struct geode_aes_op *op = blk_ctx(desc->tfm);
> +	struct blkcipher_walk walk;
> +	int err, ret;
> +
> +	blkcipher_walk_init(&walk, dst, src, nbytes);
> +	err = blkcipher_walk_virt(desc, &walk);
> +
> +	while((nbytes = walk.nbytes)) {
> +		op->src = (void *) walk.src.virt.addr,
> +		op->dst = (void *) walk.dst.virt.addr;

Unneeded cast

> +		op->mode = AES_MODE_CBC;
> +		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);
> +		op->dir = AES_DIR_DECRYPT;
> +
> +		memcpy(op->iv, walk.iv, AES_IV_LENGTH);
> +
> +		ret = geode_aes_crypt(op);
> +
> +		memcpy(walk.iv, op->iv, AES_IV_LENGTH);
> +		nbytes -= ret;
> +
> +		err = blkcipher_walk_done(desc, &walk, nbytes);
> +	}
> +
> +	return err;
> +}
>
> ...
>

> +		op->src = (void *) walk.src.virt.addr,
> +		op->dst = (void *) walk.dst.virt.addr;

Unneeded cast.  Please review whole patchset.

> +struct pci_device_id geode_aes_tbl[] = {
> +	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_LX_AES, PCI_ANY_ID, PCI_ANY_ID} ,
> +	{ 0, }
> +};

static?

> +static struct pci_driver geode_aes_driver = {
> +	name:      "Geode LX AES",
> +	id_table:  geode_aes_tbl,
> +	probe:     geode_aes_probe,
> +	remove:    __devexit_p(geode_aes_remove)
> +};

Please use `.name = value'

> +static int __devinit
> +geode_aes_init(void)
> +{
> +	return pci_module_init(&geode_aes_driver);
> +}
> +
> +static void __devexit
> +geode_aes_exit(void)
> +{
> +	pci_unregister_driver(&geode_aes_driver);
> +}

These should be __init and __exit, I think?

> +struct geode_aes_op {
> +
> +  void *src;
> +  void *dst;
> +
> +  u32 mode;
> +  u32 dir;
> +  u32 flags;
> +  int len;
> +
> +  u8 key[AES_KEY_LENGTH];
> +  u8 iv[AES_IV_LENGTH];
> +};

tabs, please.


