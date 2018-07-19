From: Yu Chen <yu.c.chen@intel.com>
Subject: Re: [PATCH 3/4][RFC v2] PM / Hibernate: Encrypt the snapshot pages
 before submitted to the block device
Date: Thu, 19 Jul 2018 13:32:19 +0800
Message-ID: <20180719053219.GA24405@sandybridge-desktop>
References: <cover.1531924968.git.yu.c.chen@intel.com>
 <edf92acf665b928f02104bb1835fd50723ab9980.1531924968.git.yu.c.chen@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Rui Zhang <rui.zhang@intel.com>,
        "Gu, Kookoo" <kookoo.gu@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        "Lee, Chun-Yi" <jlee@suse.com>, Eric Biggers <ebiggers@google.com>,
        Theodore Ts'o <tytso@mit.edu>,
        Stephan Mueller <smueller@chronox.de>,
        Denis Kenzior <denkenz@gmail.com>,
        Crypto <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: linux-pm@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <edf92acf665b928f02104bb1835fd50723ab9980.1531924968.git.yu.c.chen@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Cc linux-kernel@vger.kernel.org and linux-crypto@vger.kernel.org

On Thu, Jul 19, 2018 at 12:40:14AM +0800, Chen Yu wrote:
> This is the core modification to encrypt the hibernation image.
> It leverages the helper functions to encrypt the page data before
> they are submitted to the block device. Besides, for the case of
> hibernation compression, the data are firstly compressed and
> then encrypted, and vice versa for the resume process.
> 
> There is also another solution suggested by Lee, Chun-Yi to
> re-traverse the snapshot image at one time and write them either
> to disk or exposed to user space.  In that way if the snapshot
> image can be encrypted and authentication, then the uswsusp
> interface is available for userspace, kernel does not need to lock
> it down. The only disadvantages are re-traversing large number of
> pages in snapshot might bring overhead and makes snapshot logic
> a little coupling with crypto logic.
> 
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: Pavel Machek <pavel@ucw.cz>
> Cc: Len Brown <len.brown@intel.com>
> Cc: "Lee, Chun-Yi" <jlee@suse.com>
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Stephan Mueller <smueller@chronox.de>
> Cc: Denis Kenzior <denkenz@gmail.com>
> Cc: linux-pm@vger.kernel.org
> Signed-off-by: Chen Yu <yu.c.chen@intel.com>
> ---
>  kernel/power/power.h |  23 +++++++
>  kernel/power/swap.c  | 182 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  2 files changed, 197 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index ba3b24c..b8ddc05 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -109,8 +109,30 @@ struct hibernation_crypto {
>  
>  extern void hibernation_set_crypto_ops(
>  	const struct hibernation_crypto_ops *ops);
> +
> +/**
> + * get_crypto_cmd - Get the crypto command.
> + * @suspend: In suspend.
> + * @last_page: If this is the last page. For signature's
> + * 	       hash update/final checking.
> + */
> +static inline unsigned int get_crypto_cmd(bool suspend,
> +		bool last_page)
> +{
> +	/* TODO: signature support */
> +	if (suspend) {
> +		return CMD_ENCRYPT;
> +	} else {
> +		return CMD_DECRYPT;
> +	}
> +}
>  #else
>  #define HIBERNATE_MAX_SALT_BYTES	0
> +static inline unsigned int get_crypto_cmd(bool suspend,
> +		bool last_page)
> +{
> +	return -EINVAL;
> +}
>  #endif
>  
>  #else /* !CONFIG_HIBERNATION */
> @@ -214,6 +236,7 @@ extern int swsusp_swap_in_use(void);
>  #define SF_PLATFORM_MODE	1
>  #define SF_NOCOMPRESS_MODE	2
>  #define SF_CRC32_MODE	        4
> +#define SF_CRYPTO_MODE		8
>  
>  /* kernel/power/hibernate.c */
>  extern int swsusp_check(void);
> diff --git a/kernel/power/swap.c b/kernel/power/swap.c
> index c2bcf97..4b36fb7 100644
> --- a/kernel/power/swap.c
> +++ b/kernel/power/swap.c
> @@ -102,14 +102,16 @@ struct swap_map_handle {
>  	unsigned int k;
>  	unsigned long reqd_free_pages;
>  	u32 crc32;
> +	bool crypto;
>  };
>  
>  struct swsusp_header {
>  	char reserved[PAGE_SIZE - 20 - sizeof(sector_t) - sizeof(int) -
> -	              sizeof(u32)];
> +			sizeof(u32) - HIBERNATE_MAX_SALT_BYTES];
>  	u32	crc32;
>  	sector_t image;
>  	unsigned int flags;	/* Flags to pass to the "boot" kernel */
> +	char salt[HIBERNATE_MAX_SALT_BYTES];
>  	char	orig_sig[10];
>  	char	sig[10];
>  } __packed;
> @@ -318,6 +320,10 @@ static int mark_swapfiles(struct swap_map_handle *handle, unsigned int flags)
>  		swsusp_header->flags = flags;
>  		if (flags & SF_CRC32_MODE)
>  			swsusp_header->crc32 = handle->crc32;
> +		if (handle->crypto) {
> +			swsusp_header->flags |= SF_CRYPTO_MODE;
> +			hibernation_crypto_save((void *)swsusp_header->salt);
> +		}
>  		error = hib_submit_io(REQ_OP_WRITE, REQ_SYNC,
>  				      swsusp_resume_block, swsusp_header, NULL);
>  	} else {
> @@ -536,10 +542,12 @@ static int save_image(struct swap_map_handle *handle,
>  	unsigned int m;
>  	int ret;
>  	int nr_pages;
> +	int crypto_page_idx;
>  	int err2;
>  	struct hib_bio_batch hb;
>  	ktime_t start;
>  	ktime_t stop;
> +	void *tmp = NULL, *crypt_buf = NULL;
>  
>  	hib_init_batch(&hb);
>  
> @@ -549,12 +557,36 @@ static int save_image(struct swap_map_handle *handle,
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> +	crypto_page_idx = 0;
> +	/* Allocate temporary buffer for crypto. */
> +	if (handle->crypto) {
> +		crypt_buf = (void *)get_zeroed_page(GFP_KERNEL);
> +		if (!crypt_buf)
> +			return -ENOMEM;
> +	}
> +
>  	start = ktime_get();
>  	while (1) {
>  		ret = snapshot_read_next(snapshot);
>  		if (ret <= 0)
>  			break;
> -		ret = swap_write_page(handle, data_of(*snapshot), &hb);
> +		tmp = data_of(*snapshot);
> +		if (handle->crypto) {
> +			/* Encryption before submit_io.*/
> +			ret = hibernation_crypto_data(data_of(*snapshot),
> +				PAGE_SIZE,
> +				crypt_buf,
> +				PAGE_SIZE,
> +				get_crypto_cmd(true,
> +				 (crypto_page_idx ==
> +				  (nr_to_write - 1))),
> +				crypto_page_idx);
> +			if (ret)
> +				goto out;
> +			crypto_page_idx++;
> +			tmp = crypt_buf;
> +		}
> +		ret = swap_write_page(handle, tmp, &hb);
>  		if (ret)
>  			break;
>  		if (!(nr_pages % m))
> @@ -569,6 +601,9 @@ static int save_image(struct swap_map_handle *handle,
>  	if (!ret)
>  		pr_info("Image saving done\n");
>  	swsusp_show_speed(start, stop, nr_to_write, "Wrote");
> + out:
> +	if (crypt_buf)
> +		free_page((unsigned long)crypt_buf);
>  	return ret;
>  }
>  
> @@ -672,6 +707,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  	unsigned int m;
>  	int ret = 0;
>  	int nr_pages;
> +	int crypto_page_idx;
>  	int err2;
>  	struct hib_bio_batch hb;
>  	ktime_t start;
> @@ -767,6 +803,7 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> +	crypto_page_idx = 0;
>  	start = ktime_get();
>  	for (;;) {
>  		for (thr = 0; thr < nr_threads; thr++) {
> @@ -835,7 +872,28 @@ static int save_image_lzo(struct swap_map_handle *handle,
>  			for (off = 0;
>  			     off < LZO_HEADER + data[thr].cmp_len;
>  			     off += PAGE_SIZE) {
> -				memcpy(page, data[thr].cmp + off, PAGE_SIZE);
> +				if (handle->crypto) {
> +					/*
> +					 * Encrypt the compressed data
> +					 * before we write them to the
> +					 * block device.
> +					 */
> +					ret = hibernation_crypto_data(
> +							data[thr].cmp + off,
> +							PAGE_SIZE,
> +							page,
> +							PAGE_SIZE,
> +							get_crypto_cmd(true,
> +							 (crypto_page_idx ==
> +							 (nr_to_write - 1))),
> +							crypto_page_idx);
> +					if (ret)
> +						goto out_finish;
> +					crypto_page_idx++;
> +				} else {
> +					memcpy(page, data[thr].cmp + off,
> +						PAGE_SIZE);
> +				}
>  
>  				ret = swap_write_page(handle, page, &hb);
>  				if (ret)
> @@ -909,6 +967,7 @@ int swsusp_write(unsigned int flags)
>  	int error;
>  
>  	pages = snapshot_get_image_size();
> +	memset(&handle, 0, sizeof(struct swap_map_handle));
>  	error = get_swap_writer(&handle);
>  	if (error) {
>  		pr_err("Cannot get swap writer\n");
> @@ -922,6 +981,9 @@ int swsusp_write(unsigned int flags)
>  		}
>  	}
>  	memset(&snapshot, 0, sizeof(struct snapshot_handle));
> +	if (!hibernation_crypto_init(true))
> +		/* The image needs to be encrypted or signature. */
> +		handle.crypto = true;
>  	error = snapshot_read_next(&snapshot);
>  	if (error < PAGE_SIZE) {
>  		if (error >= 0)
> @@ -1060,6 +1122,8 @@ static int load_image(struct swap_map_handle *handle,
>  	struct hib_bio_batch hb;
>  	int err2;
>  	unsigned nr_pages;
> +	unsigned int crypto_page_idx;
> +	void *crypt_buf = NULL;
>  
>  	hib_init_batch(&hb);
>  
> @@ -1069,18 +1133,46 @@ static int load_image(struct swap_map_handle *handle,
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> +	crypto_page_idx = 0;
> +	/* Allocate temporary buffer for crypto. */
> +	if (handle->crypto) {
> +		crypt_buf = (void *)get_zeroed_page(GFP_KERNEL);
> +		if (!crypt_buf)
> +			return -ENOMEM;
> +	}
>  	start = ktime_get();
>  	for ( ; ; ) {
>  		ret = snapshot_write_next(snapshot);
>  		if (ret <= 0)
>  			break;
> -		ret = swap_read_page(handle, data_of(*snapshot), &hb);
> +		if (handle->crypto)
> +			ret = swap_read_page(handle, crypt_buf, &hb);
> +		else
> +			ret = swap_read_page(handle, data_of(*snapshot), &hb);
>  		if (ret)
>  			break;
> -		if (snapshot->sync_read)
> +		/* If encryption is enabled, disable async io. */
> +		if (handle->crypto || snapshot->sync_read)
>  			ret = hib_wait_io(&hb);
>  		if (ret)
>  			break;
> +		if (handle->crypto) {
> +			/*
> +			 * Need a decryption for the
> +			 * data read from the block
> +			 * device.
> +			 */
> +			ret = hibernation_crypto_data(crypt_buf, PAGE_SIZE,
> +					  data_of(*snapshot),
> +					  PAGE_SIZE,
> +					  get_crypto_cmd(false,
> +					   (crypto_page_idx ==
> +					   (nr_to_read - 1))),
> +					  crypto_page_idx);
> +			if (ret)
> +				break;
> +			crypto_page_idx++;
> +		}
>  		if (!(nr_pages % m))
>  			pr_info("Image loading progress: %3d%%\n",
>  				nr_pages / m * 10);
> @@ -1097,6 +1189,8 @@ static int load_image(struct swap_map_handle *handle,
>  			ret = -ENODATA;
>  	}
>  	swsusp_show_speed(start, stop, nr_to_read, "Read");
> +	if (crypt_buf)
> +		free_page((unsigned long)crypt_buf);
>  	return ret;
>  }
>  
> @@ -1165,6 +1259,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  	ktime_t start;
>  	ktime_t stop;
>  	unsigned nr_pages;
> +	unsigned int crypto_page_idx;
>  	size_t off;
>  	unsigned i, thr, run_threads, nr_threads;
>  	unsigned ring = 0, pg = 0, ring_size = 0,
> @@ -1173,6 +1268,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  	unsigned char **page = NULL;
>  	struct dec_data *data = NULL;
>  	struct crc_data *crc = NULL;
> +	void *first_page = NULL;
>  
>  	hib_init_batch(&hb);
>  
> @@ -1278,6 +1374,18 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  	}
>  	want = ring_size = i;
>  
> +	/*
> +	 * The first page of data[thr] contains the length of
> +	 * compressed data, this page should not mess up the
> +	 * read buffer, so we allocate a separate page for it.
> +	 */
> +	if (handle->crypto) {
> +		first_page = (void *)get_zeroed_page(GFP_KERNEL);
> +		if (!first_page) {
> +			ret = -ENOMEM;
> +			goto out_clean;
> +		}
> +	}
>  	pr_info("Using %u thread(s) for decompression\n", nr_threads);
>  	pr_info("Loading and decompressing image data (%u pages)...\n",
>  		nr_to_read);
> @@ -1285,6 +1393,7 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  	if (!m)
>  		m = 1;
>  	nr_pages = 0;
> +	crypto_page_idx = 0;
>  	start = ktime_get();
>  
>  	ret = snapshot_write_next(snapshot);
> @@ -1336,7 +1445,26 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  		}
>  
>  		for (thr = 0; have && thr < nr_threads; thr++) {
> -			data[thr].cmp_len = *(size_t *)page[pg];
> +			if (handle->crypto) {
> +				/*
> +				 * Need to decrypt the first page
> +				 * of each data[thr], which contains
> +				 * the compressed data length.
> +				 */
> +				ret = hibernation_crypto_data(page[pg],
> +						  PAGE_SIZE,
> +						  first_page,
> +						  PAGE_SIZE,
> +						  get_crypto_cmd(false,
> +						   (crypto_page_idx ==
> +						   (nr_to_read - 1))),
> +						  crypto_page_idx);
> +				if (ret)
> +					goto out_finish;
> +				data[thr].cmp_len = *(size_t *)first_page;
> +			} else {
> +				data[thr].cmp_len = *(size_t *)page[pg];
> +			}
>  			if (unlikely(!data[thr].cmp_len ||
>  			             data[thr].cmp_len >
>  			             lzo1x_worst_compress(LZO_UNC_SIZE))) {
> @@ -1358,8 +1486,29 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  			for (off = 0;
>  			     off < LZO_HEADER + data[thr].cmp_len;
>  			     off += PAGE_SIZE) {
> -				memcpy(data[thr].cmp + off,
> -				       page[pg], PAGE_SIZE);
> +				if (handle->crypto) {
> +					/*
> +					 * Decrypt the compressed data
> +					 * and leverage the decompression
> +					 * threads to get it done.
> +					 */
> +					ret = hibernation_crypto_data(
> +							page[pg],
> +							PAGE_SIZE,
> +							data[thr].cmp + off,
> +							PAGE_SIZE,
> +							get_crypto_cmd(false,
> +							 (crypto_page_idx ==
> +							 (nr_to_read - 1))),
> +							crypto_page_idx);
> +					if (ret)
> +						goto out_finish;
> +					crypto_page_idx++;
> +				} else {
> +					memcpy(data[thr].cmp + off,
> +						page[pg], PAGE_SIZE);
> +
> +				}
>  				have--;
>  				want++;
>  				if (++pg >= ring_size)
> @@ -1452,6 +1601,8 @@ static int load_image_lzo(struct swap_map_handle *handle,
>  out_clean:
>  	for (i = 0; i < ring_size; i++)
>  		free_page((unsigned long)page[i]);
> +	if (first_page)
> +		free_page((unsigned long)first_page);
>  	if (crc) {
>  		if (crc->thr)
>  			kthread_stop(crc->thr);
> @@ -1482,6 +1633,7 @@ int swsusp_read(unsigned int *flags_p)
>  	struct swsusp_info *header;
>  
>  	memset(&snapshot, 0, sizeof(struct snapshot_handle));
> +	memset(&handle, 0, sizeof(struct swap_map_handle));
>  	error = snapshot_write_next(&snapshot);
>  	if (error < PAGE_SIZE)
>  		return error < 0 ? error : -EFAULT;
> @@ -1489,6 +1641,16 @@ int swsusp_read(unsigned int *flags_p)
>  	error = get_swap_reader(&handle, flags_p);
>  	if (error)
>  		goto end;
> +	if (*flags_p & SF_CRYPTO_MODE) {
> +		error = hibernation_crypto_init(false);
> +		if (!error) {
> +			/* The image has been encrypted. */
> +			handle.crypto = true;
> +		} else {
> +			pr_err("Failed to init cipher during resume.\n");
> +			goto end;
> +		}
> +	}
>  	if (!error)
>  		error = swap_read_page(&handle, header, NULL);
>  	if (!error) {
> @@ -1526,6 +1688,10 @@ int swsusp_check(void)
>  
>  		if (!memcmp(HIBERNATE_SIG, swsusp_header->sig, 10)) {
>  			memcpy(swsusp_header->sig, swsusp_header->orig_sig, 10);
> +			/* Read salt passed from previous kernel. */
> +			if (swsusp_header->flags & SF_CRYPTO_MODE)
> +				hibernation_crypto_restore(
> +						(void *)&swsusp_header->salt);
>  			/* Reset swap signature now */
>  			error = hib_submit_io(REQ_OP_WRITE, REQ_SYNC,
>  						swsusp_resume_block,
> -- 
> 2.7.4
> 
