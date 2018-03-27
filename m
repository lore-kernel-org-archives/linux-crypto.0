From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: [dm-devel] [PATCH 2/2] md: dm-verity: allow parallel processing
 of bio blocks
Date: Mon, 26 Mar 2018 23:55:19 -0700
Message-ID: <20180327065519.GA745@sol.localdomain>
References: <1522003290-27243-1-git-send-email-yael.chemla@foss.arm.com>
 <1522003290-27243-2-git-send-email-yael.chemla@foss.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, ofir.drang@gmail.com,
        Yael Chemla <yael.chemla@arm.com>,
        linux-crypto@vger.kernel.org, gilad@benyossef.com
To: Yael Chemla <yael.chemla@foss.arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1522003290-27243-2-git-send-email-yael.chemla@foss.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

[+Cc linux-crypto]

Hi Yael,

On Sun, Mar 25, 2018 at 07:41:30PM +0100, Yael Chemla wrote:
>  Allow parallel processing of bio blocks by moving to async. completion
>  handling. This allows for better resource utilization of both HW and
>  software based hash tfm and therefore better performance in many cases,
>  depending on the specific tfm in use.
>  
>  Tested on ARM32 (zynq board) and ARM64 (Juno board).
>  Time of cat command was measured on a filesystem with various file sizes.
>  12% performance improvement when HW based hash was used (ccree driver).
>  SW based hash showed less than 1% improvement.
>  CPU utilization when HW based hash was used presented 10% less context
>  switch, 4% less cycles and 7% less instructions. No difference in
>  CPU utilization noticed with SW based hash.
>  
> Signed-off-by: Yael Chemla <yael.chemla@foss.arm.com>

Okay, I definitely would like to see dm-verity better support hardware crypto
accelerators, but these patches were painful to read.

There are lots of smaller bugs, but the high-level problem which you need to
address first is that on every bio you are always allocating all the extra
memory to hold a hash request and scatterlist for every data block.  This will
not only hurt performance when the hashing is done in software (I'm skeptical
that your performance numbers are representative of that case), but it will also
fall apart under memory pressure.  We are trying to get low-end Android devices
to start using dm-verity, and such devices often have only 1 GB or even only 512
MB of RAM, so memory allocations are at increased risk of failing.  In fact I'm
pretty sure you didn't do any proper stress testing of these patches, since the
first thing they do for every bio is try to allocate a physically contiguous
array that is nearly as long as the full bio data itself (n_blocks *
sizeof(struct dm_verity_req_data) = n_blocks * 3264, at least on a 64-bit
platform, mostly due to the 'struct dm_verity_fec_io'), so potentially up to
about 1 MB; that's going to fail a lot even on systems with gigabytes of RAM...

(You also need to verify that your new code is compatible with the forward error
correction feature, with the "ignore_zero_blocks" option, and with the new
"check_at_most_once" option.  From my reading of the code, all of those seemed
broken; the dm_verity_fec_io structures, for example, weren't even being
initialized...)

I think you need to take a close look at how dm-crypt handles async crypto
implementations, since it seems to do it properly without hurting the common
case where the crypto happens synchronously.  What it does, is it reserves space
in the per-bio data for a single cipher request.  Then, *only* if the cipher
implementation actually processes the request asynchronously (as indicated by
-EINPROGRESS being returned) is a new cipher request allocated dynamically,
using a mempool (not kmalloc, which is prone to fail).  Note that unlike your
patches it also properly handles the case where the hardware crypto queue is
full, as indicated by the cipher implementation returning -EBUSY; in that case,
dm-crypt waits to start another request until there is space in the queue.

I think it would be possible to adapt dm-crypt's solution to dm-verity.

Thanks,

Eric

> ---
>  drivers/md/dm-verity-fec.c    |  10 +-
>  drivers/md/dm-verity-fec.h    |   7 +-
>  drivers/md/dm-verity-target.c | 215 +++++++++++++++++++++++++++++++-----------
>  drivers/md/dm-verity.h        |   4 +-
>  4 files changed, 173 insertions(+), 63 deletions(-)
> 
> diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
> index e13f908..bcea307 100644
> --- a/drivers/md/dm-verity-fec.c
> +++ b/drivers/md/dm-verity-fec.c
> @@ -203,13 +203,12 @@ static int fec_is_erasure(struct dm_verity *v, struct dm_verity_io *io,
>   */
>  static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
>  			 u64 rsb, u64 target, unsigned block_offset,
> -			 int *neras)
> +			 int *neras, struct dm_verity_fec_io *fio)
>  {
>  	bool is_zero;
>  	int i, j, target_index = -1;
>  	struct dm_buffer *buf;
>  	struct dm_bufio_client *bufio;
> -	struct dm_verity_fec_io *fio = fec_io(io);
>  	u64 block, ileaved;
>  	u8 *bbuf, *rs_block;
>  	u8 want_digest[v->digest_size];
> @@ -265,7 +264,7 @@ static int fec_read_bufs(struct dm_verity *v, struct dm_verity_io *io,
>  
>  		/* locate erasures if the block is on the data device */
>  		if (bufio == v->fec->data_bufio &&
> -		    verity_hash_for_block(v, io, block, want_digest,
> +		    verity_hash_for_block(v, io, block, want_digest, fio,
>  					  &is_zero) == 0) {
>  			/* skip known zero blocks entirely */
>  			if (is_zero)
> @@ -374,7 +373,7 @@ static int fec_decode_rsb(struct dm_verity *v, struct dm_verity_io *io,
>  		fec_init_bufs(v, fio);
>  
>  		r = fec_read_bufs(v, io, rsb, offset, pos,
> -				  use_erasures ? &neras : NULL);
> +				  use_erasures ? &neras : NULL, fio);
>  		if (unlikely(r < 0))
>  			return r;
>  
> @@ -419,10 +418,9 @@ static int fec_bv_copy(struct dm_verity *v, struct dm_verity_io *io, u8 *data,
>   */
>  int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
>  		      enum verity_block_type type, sector_t block, u8 *dest,
> -		      struct bvec_iter *iter)
> +		      struct bvec_iter *iter, struct dm_verity_fec_io *fio)
>  {
>  	int r;
> -	struct dm_verity_fec_io *fio = fec_io(io);
>  	u64 offset, res, rsb;
>  
>  	if (!verity_fec_is_enabled(v))
> diff --git a/drivers/md/dm-verity-fec.h b/drivers/md/dm-verity-fec.h
> index bb31ce8..46c2f47 100644
> --- a/drivers/md/dm-verity-fec.h
> +++ b/drivers/md/dm-verity-fec.h
> @@ -73,7 +73,9 @@ extern bool verity_fec_is_enabled(struct dm_verity *v);
>  
>  extern int verity_fec_decode(struct dm_verity *v, struct dm_verity_io *io,
>  			     enum verity_block_type type, sector_t block,
> -			     u8 *dest, struct bvec_iter *iter);
> +			     u8 *dest, struct bvec_iter *iter,
> +			     struct dm_verity_fec_io *fio);
> +
>  
>  extern unsigned verity_fec_status_table(struct dm_verity *v, unsigned sz,
>  					char *result, unsigned maxlen);
> @@ -104,7 +106,8 @@ static inline int verity_fec_decode(struct dm_verity *v,
>  				    struct dm_verity_io *io,
>  				    enum verity_block_type type,
>  				    sector_t block, u8 *dest,
> -				    struct bvec_iter *iter)
> +				    struct bvec_iter *iter,
> +				    struct dm_verity_fec_io *fio)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index a281b83..30512ee 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -38,7 +38,35 @@
>  /* only two elements in static scatter list: salt and data */
>  #define SG_FIXED_ITEMS	2
>  
> +struct dm_ver_io_data {
> +	atomic_t expected_reqs;
> +	atomic_t err;
> +	int total_reqs;
> +	struct dm_ver_req_data *reqdata_arr;
> +	struct dm_verity_io *io;
> +};
> +
> +#define MAX_DIGEST_SIZE 64 /* as big as sha512 digest size */
> +
> +struct dm_ver_req_data {
> +	u8 want_digest[MAX_DIGEST_SIZE];
> +	u8 real_digest[MAX_DIGEST_SIZE];
> +	struct dm_verity_fec_io fec_io;
> +	unsigned int iblock;	// block index in the request
> +	unsigned int digest_size;
> +	struct scatterlist *sg;
> +	struct dm_ver_io_data *iodata;
> +	/* req field is the last on purpose since it's not fixed in size and
> +	 *  its size if calucluated using ahash_request_alloc or an addition of
> +	 *  the required size is done with +crypto_ahash_reqsize(v->tfm)
> +	 */
> +	struct ahash_request *req;
> +};
> +
>  static unsigned dm_verity_prefetch_cluster = DM_VERITY_DEFAULT_PREFETCH_SIZE;
> +static void verity_finish_io(struct dm_verity_io *io, blk_status_t status);
> +static void verity_release_req(struct dm_ver_io_data *iodata);
> +
>  
>  module_param_named(prefetch_cluster, dm_verity_prefetch_cluster, uint, S_IRUGO | S_IWUSR);
>  
> @@ -102,7 +130,7 @@ static sector_t verity_position_at_level(struct dm_verity *v, sector_t block,
>  
>  /*
>   * verity_is_salt_required - check if according to verity version and
> - * verity salt's size if there's a need to insert a salt.
> + * verity salt's size there's a need to insert a salt.
>   * note: salt goes last for 0th version and first for all others
>   * @where - START_SG - before buffer / END_SG - after buffer
>   */
> @@ -247,7 +275,7 @@ static int verity_handle_err(struct dm_verity *v, enum verity_block_type type,
>   */
>  static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  			       sector_t block, int level, bool skip_unverified,
> -			       u8 *want_digest)
> +			       u8 *want_digest, struct dm_verity_fec_io *fec_io)
>  {
>  	struct dm_buffer *buf;
>  	struct buffer_aux *aux;
> @@ -281,7 +309,7 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>  			aux->hash_verified = 1;
>  		else if (verity_fec_decode(v, io,
>  					   DM_VERITY_BLOCK_TYPE_METADATA,
> -					   hash_block, data, NULL) == 0)
> +					   hash_block, data, NULL, fec_io) == 0)
>  			aux->hash_verified = 1;
>  		else if (verity_handle_err(v,
>  					   DM_VERITY_BLOCK_TYPE_METADATA,
> @@ -305,7 +333,9 @@ static int verity_verify_level(struct dm_verity *v, struct dm_verity_io *io,
>   * of the hash tree if necessary.
>   */
>  int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
> -			  sector_t block, u8 *digest, bool *is_zero)
> +			  sector_t block, u8 *digest,
> +			  struct dm_verity_fec_io *fec_io,
> +			  bool *is_zero)
>  {
>  	int r = 0, i;
>  
> @@ -317,7 +347,7 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
>  		 * function returns 1 and we fall back to whole
>  		 * chain verification.
>  		 */
> -		r = verity_verify_level(v, io, block, 0, true, digest);
> +		r = verity_verify_level(v, io, block, 0, true, digest, fec_io);
>  		if (likely(r <= 0))
>  			goto out;
>  	}
> @@ -325,7 +355,7 @@ int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
>  	memcpy(digest, v->root_digest, v->digest_size);
>  
>  	for (i = v->levels - 1; i >= 0; i--) {
> -		r = verity_verify_level(v, io, block, i, false, digest);
> +		r = verity_verify_level(v, io, block, i, false, digest, fec_io);
>  		if (unlikely(r))
>  			goto out;
>  	}
> @@ -436,39 +466,118 @@ static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
>  	return 0;
>  }
>  
> +
> +static void verity_cb_complete(struct dm_ver_io_data *iodata, int err)
> +{
> +	struct dm_verity_io *io = iodata->io;
> +
> +	/* save last error occurred */
> +	if (err)
> +		atomic_set(&iodata->err, err);
> +	if (atomic_dec_and_test(&iodata->expected_reqs)) {
> +		verity_release_req(iodata);
> +		verity_finish_io(io, errno_to_blk_status(err));
> +	}
> +}
> +
> +static void __single_block_req_done(struct dm_ver_req_data *req_data,
> +					int err, struct dm_verity_io *io)
> +{
> +	struct dm_verity *v = io->v;
> +
> +	if (err == -EINPROGRESS)
> +		return;
> +
> +	WARN_ON((err != 0) || (req_data == NULL) || (req_data->iodata == NULL));
> +	if ((err != 0) || (req_data == NULL) || (req_data->iodata == NULL))
> +		goto complete;
> +
> +	kfree(req_data->sg);
> +
> +	if (likely(memcmp(req_data->real_digest,
> +			req_data->want_digest, req_data->digest_size) == 0))
> +		goto complete;
> +	else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
> +			io->block + req_data->iblock, NULL, &io->iter,
> +			&req_data->fec_io) == 0){
> +		goto complete;
> +	} else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
> +		req_data->iodata->io->block + req_data->iblock)){
> +		err = -EIO;
> +		goto complete;
> +	}
> +
> +complete:
> +	ahash_request_free(req_data->req);
> +	verity_cb_complete(req_data->iodata, err);
> +}
> +
> +static void single_block_req_done(struct crypto_async_request *req, int err)
> +{
> +	struct dm_ver_req_data *req_data = req->data;
> +
> +	__single_block_req_done(req_data, err, req_data->iodata->io);
> +}
> +
> +static void verity_release_req(struct dm_ver_io_data *iodata)
> +{
> +	kfree(iodata->reqdata_arr);
> +	kfree(iodata);
> +}
>  /*
>   * Verify one "dm_verity_io" structure.
>   */
> -static int verity_verify_io(struct dm_verity_io *io)
> +static void verity_verify_io(struct dm_verity_io *io)
>  {
>  	bool is_zero;
>  	struct dm_verity *v = io->v;
> -	struct bvec_iter start;
> -	unsigned b;
> -	struct crypto_wait wait;
> -	struct scatterlist *sg;
> -	int r;
> +	unsigned int b = 0, blocks = 0;
> +	struct dm_ver_io_data *iodata = NULL;
> +	struct dm_ver_req_data *reqdata_arr = NULL;
> +	struct scatterlist *sg = NULL;
> +	int res;
> +
> +	iodata = kmalloc(sizeof(*iodata), GFP_KERNEL);
> +	reqdata_arr = kmalloc_array(io->n_blocks,
> +			sizeof(struct dm_ver_req_data), GFP_KERNEL);
> +	if (unlikely((iodata == NULL) || (reqdata_arr == NULL))) {
> +		WARN_ON((iodata == NULL) || (reqdata_arr == NULL));
> +		goto err_memfree;
> +	}
> +	atomic_set(&iodata->expected_reqs, io->n_blocks);
> +	iodata->reqdata_arr = reqdata_arr;
> +	iodata->io = io;
> +	iodata->total_reqs = blocks = io->n_blocks;
> +
>  
> -	for (b = 0; b < io->n_blocks; b++) {
> +	for (b = 0; b < blocks; b++) {
>  		unsigned int nents;
>  		unsigned int total_len = 0;
>  		unsigned int num_of_buffs = 0;
> -		struct ahash_request *req = verity_io_hash_req(v, io);
>  
> -		/* an extra one for the salt buffer */
> +		reqdata_arr[b].req = ahash_request_alloc(v->tfm, GFP_KERNEL);
> +
> +		if (unlikely(reqdata_arr[b].req == NULL))
> +			goto err_memfree;
> +		/* +1 for the salt buffer */
> +		ahash_request_set_tfm(reqdata_arr[b].req, v->tfm);
>  		num_of_buffs = verity_calc_buffs_for_bv(v, io, io->iter) + 1;
>  		WARN_ON(num_of_buffs < 1);
>  
>  		sg = kmalloc_array(num_of_buffs, sizeof(struct scatterlist),
>  				     GFP_KERNEL);
> -		if (!sg)
> -			return -ENOMEM;
> +		if (!sg) {
> +			DMERR("%s kmalloc_array failed", __func__);
> +			goto err_memfree;
> +		}
> +
>  		sg_init_table(sg, num_of_buffs);
>  
> -		r = verity_hash_for_block(v, io, io->block + b,
> -					  verity_io_want_digest(v, io),
> -					  &is_zero);
> -		if (unlikely(r < 0))
> +		res = verity_hash_for_block(v, io, io->block + b,
> +					    reqdata_arr[b].want_digest,
> +					    &reqdata_arr[b].fec_io,
> +					    &is_zero);
> +		if (unlikely(res < 0))
>  			goto err_memfree;
>  
>  		if (is_zero) {
> @@ -476,56 +585,54 @@ static int verity_verify_io(struct dm_verity_io *io)
>  			 * If we expect a zero block, don't validate, just
>  			 * return zeros.
>  			 */
> -			r = verity_for_bv_block(v, io, &io->iter,
> +			res = verity_for_bv_block(v, io, &io->iter,
>  						verity_bv_zero);
> -			if (unlikely(r < 0))
> +			if (unlikely(res < 0))
>  				goto err_memfree;
> -
> +			verity_cb_complete(reqdata_arr[b].iodata, res);
>  			continue;
>  		}
>  
> -		ahash_request_set_tfm(req, v->tfm);
> -		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP |
> -					CRYPTO_TFM_REQ_MAY_BACKLOG,
> -					crypto_req_done, (void *)&wait);
>  		nents = 0;
>  		total_len = 0;
>  		if (verity_is_salt_required(v, START_SG))
>  			verity_add_salt(v, sg, &nents, &total_len);
>  
> -		start = io->iter;
> -		verity_for_io_block(v, io, &io->iter, sg, &nents, &total_len);
> +		verity_for_io_block(v, io, &io->iter, sg, &nents,
> +				&total_len);
>  		if (verity_is_salt_required(v, END_SG))
>  			verity_add_salt(v, sg, &nents, &total_len);
> -		/*
> -		 * need to mark end of chain, since we might have allocated
> -		 * more than we actually use
> +		reqdata_arr[b].iodata = iodata;
> +		reqdata_arr[b].sg = sg;
> +		reqdata_arr[b].digest_size = v->digest_size;
> +		reqdata_arr[b].iblock = b;
> +		/* need to mark end of chain,
> +		 * since we might have allocated more than we actually use
>  		 */
>  		sg_mark_end(&sg[nents-1]);
> -		ahash_request_set_crypt(req, sg, verity_io_real_digest(v, io),
> -				total_len);
> -		crypto_init_wait(&wait);
> -		r = crypto_wait_req(crypto_ahash_digest(req), &wait);
>  
> -		if (unlikely(r < 0))
> -			goto err_memfree;
> -		kfree(sg);
> -		if (likely(memcmp(verity_io_real_digest(v, io),
> -				  verity_io_want_digest(v, io), v->digest_size) == 0))
> -			continue;
> -		else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
> -					   io->block + b, NULL, &start) == 0)
> -			continue;
> -		else if (verity_handle_err(v, DM_VERITY_BLOCK_TYPE_DATA,
> -					   io->block + b))
> -			return -EIO;
> -	}
> +		ahash_request_set_tfm(reqdata_arr[b].req, v->tfm);
> +		ahash_request_set_callback(reqdata_arr[b].req,
> +			CRYPTO_TFM_REQ_MAY_SLEEP | CRYPTO_TFM_REQ_MAY_BACKLOG,
> +			single_block_req_done, (void *)&reqdata_arr[b]);
>  
> -	return 0;
> +		ahash_request_set_crypt(reqdata_arr[b].req, sg,
> +			reqdata_arr[b].real_digest, total_len);
> +		res = crypto_ahash_digest(reqdata_arr[b].req);
> +		/* digest completed already, callback won't be called. */
> +		if (res == 0)
> +			__single_block_req_done(&reqdata_arr[b], res, io);
> +
> +	}
> +	return;
>  
>  err_memfree:
> -	kfree(sg);
> -	return r;
> +	DMERR("%s: error occurred", __func__);
> +	/* reduce expected requests by the number of
> +	 * unsent requests, -1 accounting for the current block
> +	 */
> +	atomic_sub(blocks-b-1, &iodata->expected_reqs);
> +	verity_cb_complete(iodata, -EIO);
>  }
>  
>  /*
> @@ -548,7 +655,7 @@ static void verity_work(struct work_struct *w)
>  {
>  	struct dm_verity_io *io = container_of(w, struct dm_verity_io, work);
>  
> -	verity_finish_io(io, errno_to_blk_status(verity_verify_io(io)));
> +	verity_verify_io(io);
>  }
>  
>  static void verity_end_io(struct bio *bio)
> diff --git a/drivers/md/dm-verity.h b/drivers/md/dm-verity.h
> index b675bc0..0e407f6 100644
> --- a/drivers/md/dm-verity.h
> +++ b/drivers/md/dm-verity.h
> @@ -30,6 +30,7 @@ enum verity_block_type {
>  };
>  
>  struct dm_verity_fec;
> +struct dm_verity_fec_io;
>  
>  struct dm_verity {
>  	struct dm_dev *data_dev;
> @@ -124,6 +125,7 @@ extern int verity_hash(struct dm_verity *v, struct ahash_request *req,
>  		       const u8 *data, size_t len, u8 *digest);
>  
>  extern int verity_hash_for_block(struct dm_verity *v, struct dm_verity_io *io,
> -				 sector_t block, u8 *digest, bool *is_zero);
> +				 sector_t block, u8 *digest,
> +				 struct dm_verity_fec_io *fio, bool *is_zero);
>  
>  #endif /* DM_VERITY_H */
> -- 
> 2.7.4
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
