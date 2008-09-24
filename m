From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [PATCH 1/1 v6] Add CryptoAPI User Interface Support Patch v6
Date: Wed, 24 Sep 2008 21:12:20 +0400
Message-ID: <20080924171220.GB5190@2ka.mipt.ru>
References: <DB599F406D04E34389140B7D99C71B1B061D6209@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.80.65]:42411 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYIXRN1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Sep 2008 13:13:27 -0400
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B061D6209@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Sep 22, 2008 at 03:40:23PM -0700, Shasi Pulijala (spulijala@amcc.com) wrote:
>  This is Linux CryptoAPI user space interface support patch v6. This version adds:
> -Adds a reference count for checking the inappropriate deletion of allocated data in synchronous operations.
> -Also some minor changes like removal of double pointers etc.

Couple of comments inline.

> From: Shasi Pulijala <spulijala@amcc.com>
> 
> 
> Signed-off-by: Shasi Pulijala <spulijala@amcc.com>
> Acked-by: Loc Ho <lho@amcc.com>

> diff --git a/crypto/Kconfig b/crypto/Kconfig
> index 69f1be6..0cd97c2 100644

> diff --git a/crypto/Makefile b/crypto/Makefile
> index 7cf3625..4ed5634 100644

This two constantly hangs to be applied. Please rebase against vanilla
tree. There are also number of trailing whitespaces in the patch.

> +
> +static int cryptodev_run_acipher(struct csession *ses_ptr,
> +				struct crypto_item_op *cop,
> +				struct kiocb *iocb);
> +static int cryptodev_run_ahash(struct csession *ses_ptr,
> +				struct crypto_item_op *cop,
> +				struct kiocb *iocb);
> +static int cryptodev_run_aead(struct csession *ses_ptr,
> +				struct crypto_item_op *cop,
> +				struct kiocb *iocb);
> +static void cryptodev_async_aio_complete(struct crypto_async_request *req,
> +					 int err);

Please drop forward declarations. They confuse readers and automatic
tools.

> +static int cryptodev_set_user_pages(char __user *src, struct scatterlist *sg,
> +					struct page **pages, size_t bufsize,
> +					int *nr_pages, char **null_buf)
> +{
> +	unsigned long offset;
> +	struct page *page = NULL;
> +	int x;
> +	int rop;
> +	int err;
> +
> +	if (!src) {
> +		*nr_pages = 0;
> +		CDPRINTK(1, KERN_INFO, "Case of null buffer\n");
> +		*null_buf = kzalloc(bufsize, GFP_KERNEL);
> +		if (!*null_buf)
> +			return -ENOMEM;
> +		sg_init_one(&sg[0], *null_buf, bufsize);
> +		return 0;
> +	}
> +
> +	offset = (unsigned long) src & ~PAGE_MASK;
> +	if (!pages) {
> +		printk(KERN_ERR PFX "pages memory allocation failed\n");
> +		return -ENOMEM;
> +	}
> +
> +	down_read(&current->mm->mmap_sem);
> +	err = get_user_pages(current, current->mm,
> +			((unsigned long) src) & PAGE_MASK,
> +			*nr_pages, 1, 0, /* read, force */ pages, NULL);
> +	up_read(&current->mm->mmap_sem);
> +
> +	if (err != *nr_pages) {
> +		printk(KERN_ERR PFX "pages requested[%d] !="
> +			" pages granted[%d]\n", *nr_pages, err);
> +		return err < 0 ? err : -EINVAL;
> +
> +	}
> +
> +	if (sg_single) {
> +		page = pages[0];
> +		CDPRINTK(2, KERN_INFO, "single buffer implementation\n");
> +		sg_set_page(&sg[0], page, bufsize, offset);
> +		return 0;
> +	}
> +
> +	sg_init_table(sg, *nr_pages);
> +	for (x = 0; x < *nr_pages; x++) {
> +		page = pages[x] ;
> +		if (!page || IS_ERR(page)) {
> +			printk(KERN_ERR PFX "missing page in "
> +				"DumpUserPages %d\n", x);
> +			return -EFAULT;
> +		}
> +		sg_set_page(&sg[x], page, bufsize, offset);
> +		rop = PAGE_SIZE - sg[x].offset;
> +		if (bufsize > rop) {
> +			sg[x].length = rop;
> +			bufsize = bufsize - rop;
> +		}
> +		offset = 0;

What if bufsize is smaller than 'rop', but there are several pages?
This will initialize wrong buffers, but probably there is a check somewhere
above this layer.

> +	if (cop->eop == COP_ENCRYPT)
> +		ret = crypto_aead_encrypt(req);
> +	else
> +		ret = crypto_aead_decrypt(req);
> +
> +	switch (ret) {
> +	case 0:
> +		if (!iocb)
> +			atomic_dec(&result->opcnt);
> +		break;
> +	case -EINPROGRESS:
> +	case -EBUSY:
> +		if (iocb) {
> +			CDPRINTK(2, KERN_INFO,
> +				"Async Call AEAD:Returning Now\n");
> +			return -EIOCBQUEUED;
> +		}
> +		ret = wait_for_completion_interruptible(
> +					&result->crypto_completion);
> +		if (!ret)
> +			ret = result->err;
> +		if (!ret) {
> +			INIT_COMPLETION(result->crypto_completion);
> +			break;
> +		}
> +		/* fall through */
> +	default:
> +		printk(KERN_ERR PFX "sid %p enc/dec failed error %d\n",
> +			ses_ptr, -ret);
> +		if (!iocb)
> +			atomic_dec(&result->opcnt);
> +		break;
> +	}
> +
> +	if (nopin && !ret) {
> +		if (copy_to_user(dst, data, enc ? bufsize + authsize :
> +						bufsize - authsize))
> +			printk(KERN_ERR PFX
> +				"failed to copy encrypted data "
> +				"to user space\n");
> +		CD_HEXDUMP(data, enc ? bufsize + authsize :
> +					bufsize - authsize);
> +	}
> +
> +	/* Check if last reference */
> +	if (atomic_dec_and_test(&ses_ptr->refcnt))
> +		cryptodev_destroy_session(ses_ptr);
> +	if (dst_flag)
> +		cryptodev_release_pages(result->dpages, nr_dpages);
> +out_spages:
> +	cryptodev_release_pages(result->spages, nr_spages);
> +
> +out_tmp:
> +	if (atomic_dec_and_test(&result->opcnt))
> +		cryptodev_destroy_res(result);
> +	return ret;
> +}

Still this is not an async crypto.

Is it what you expect it to be? Since it is protected by the per-ctx
lock and waits for the crypto operation completion. Also, since waiting
is interruptible, it is possible to destroy session and/or release
pages, so actual crypto processing will crash the system.

Are there any benchmark of this approach?

-- 
	Evgeniy Polyakov
