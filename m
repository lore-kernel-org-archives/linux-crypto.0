Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793045548;
	b=n/f83kc9HmtCbLovv0MY+obmeHI7qLK+hTYunAfSIGTwgxS8yKvrRVnlnhX2rFrdeP25
	 k/QQTV6S2pAe+/oFU4dbe0vYePWoKKztVeoRW8T2BMm838mQkQyjzjSunETeTuGTDTBqm
	 PfluEZ/hzwnPzplmRc+tIZid3UDWoCxU8MNC3qCdYx/tbXa5tFPBifvYfZ88H3fuy7Lbx
	 TlBcKA6D6QgiG0KaMRgUxoaFA4fxYYYO4bVnwdSA7Xjzt57xV/NJO3YKn4D4NECsJyOLm
	 Z/TrLc6nhSou3aEoGmqlU2azNzmgh+GkQ08Tv6JV5VVtwbc4cB66tag0HXWyv0I9gSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793045548;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=e+Bc8KHQE8rMEzWoywREWT5GUovCbYoRe672a/CVLd0=;
	b=Z2Qg8NF9GqoDkaATLYNvgbyvGdHBHoKU6loG34k4W495lbtxN868H4OBmuYeCVWabTR7
	 EDaPdG51zvQgGPWJIYZzpxIkwAaI2eTar1DwC+syLg2u5aV43TgTW4oqthyCfoiXTuaxX
	 +G12dAkhEtPRRxuQ3Qo1VcelXKUf2vgW3wVMK6kPuggOIJxgdfdRg9OfjIajlk2dLfN/s
	 lgxGxRa3ynSvSwKbIvWSTjvKl/tjltohBnIWm6WMVhJVYGUqcEH3swUxLpl763/i1BdNH
	 gYYQYi3INkRMUq5BnhS5wm0Uhba29MdJCUDwhuZE3DN/biUeUM+69FyiLutIZHBSg+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnFKTJaL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445E3606A31D;
	Mon, 26 Oct 2026 20:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnFKTJaL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B3E1F01825;
	Mon, 26 Oct 2026 20:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793045548;
	bh=e+Bc8KHQE8rMEzWoywREWT5GUovCbYoRe672a/CVLd0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bnFKTJaLJhEDWcrruV92tEkz3hw8S9A+ykr1J6QWA5CRPOntCzVsDg1q4bJtoCGgh
	 TCVIv/G1L9mplQZYMhIBpiDf+aW/LpLX2q0fjKTeVh59cXMu3l7EJIZ6YcmrpnQahF
	 jcfmZux6PH27mDW7qg8jLG2xve7AGrMIt9EJRuY2LXkR+Nh0GIE3hpvaiQh5d9X1cT
	 ONXvuVdORAVH2LTUFK8CcoJhRRVzZ7t8oJvJOW48dy9pLvhufbkJVI5ZMxzyEQj+6W
	 7kyxNDuI5L76AKXvGJgFi1g+nNBOu/FyQYVsDdz+0xqtTrA3Y2WOZug798eYTmZ5Rj
	 hpd8XwRYjg75g==
Message-ID: <sashiko-outbox-185704@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v7 4/5] crypto: cmh - add AES skcipher/aead/cmac
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alex Ousherovitch" <aousherovitch@rambus.com>, "Saravanakrishnan
 Krishnamoorthy" <skrishnamoorthy@rambus.com>, "Joel Wittenauer" <Joel.Wittenauer@cryptography.com>, "Thi
 Nguyen" <thin@rambus.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David
 S. Miller" <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20261026-cmh-b4-a-v7-v7-4-500a83faf500@rambus.com>
References: <20261026-cmh-b4-a-v7-v7-0-500a83faf500@rambus.com>
 <20261026-cmh-b4-a-v7-v7-4-500a83faf500@rambus.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 26 Oct 2026 20:12:26 +0000
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Critical] crypto: cmh: stack overflow via missing tfm->fb in cmh_aes_cma=
c_init_tfm()
- [High] crypto: cmh: spurious -EINPROGRESS in cmh_aes_complete() for CTR c=
hunk 2
- [Medium] crypto: cmh - missing CCM payload length check for L=3D2 in cmh_=
aes_aead_crypt()
--

commit c8ce92a98ef076c53f07cde35dc9d8f4e53da1f5
Author: Alex Ousherovitch <aousherovitch@rambus.com>

crypto: cmh - add AES skcipher/aead/cmac

This commit registers AES skcipher (ECB, CBC, CTR, CFB, XTS), AEAD (GCM,
CCM), and ahash (CMAC) algorithms using the CMH AES core, along with
software fallbacks for unsupported hardware corner cases and incremental
CMAC operations.

> diff --git a/drivers/crypto/cmh/cmh_aes.c b/drivers/crypto/cmh/cmh_aes.c
> new file mode 100644
> index 0000000000000..d4352caf771f6
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_aes.c
[ ... ]
> +static int cmh_aes_ctr_submit_chunk2(struct skcipher_request *req)
> +{
> +	struct crypto_skcipher *tfm =3D crypto_skcipher_reqtfm(req);
> +	struct cmh_aes_tfm_ctx *tctx =3D crypto_skcipher_ctx(tfm);
> +	struct cmh_aes_reqctx *rctx =3D skcipher_request_ctx(req);
> +	struct vcq_cmd cmds[CMH_AES_MAX_PAYLOAD];
> +	u32 chunk1 =3D rctx->ctr_chunk1_len;
> +	u32 chunk2 =3D rctx->cryptlen - chunk1;
> +	u64 key_ref;
> +	u32 keylen;
> +	u32 idx =3D 0;
> +
> +	/* Clear split flag so next completion is final */
> +	rctx->ctr_chunk1_len =3D 0;
> +
> +	vcq_add_sys_write(&cmds[idx++], SYS_REF_TEMP,
> +			  (u64)rctx->key_dma, SYS_REF_NONE,
> +			  tctx->key.raw.len,
> +			  tctx->key.raw.sys_type);
> +	key_ref =3D SYS_REF_TEMP;
> +	keylen =3D tctx->key.raw.len;
> +
> +	vcq_add_aes_init(&cmds[idx++], rctx->core_id, key_ref,
> +			 (u64)rctx->iv2_dma, keylen, rctx->ivsize,
> +			 rctx->aes_mode, rctx->aes_op, 0);
> +	vcq_add_aes_final(&cmds[idx++], rctx->core_id,
> +			  (u64)(rctx->in_dma + chunk1),
> +			  (u64)(rctx->out_dma + chunk1), chunk2);
> +	vcq_add_flush(&cmds[idx++], rctx->core_id);
> +
> +	return cmh_vcq_pack_and_submit_async(cmds, idx, rctx->packed,
> +					     CMH_AES_MAX_PACKED,
> +					     rctx->target_mbx,
> +					     cmh_aes_complete, req,
> +					     !!(req->base.flags &
> +						CRYPTO_TFM_REQ_MAY_BACKLOG),
> +					     cmh_tm_async_timeout_jiffies());
> +}
> +
> +/*
> + * Async completion callback -- fires from RH threaded IRQ context.
> + *
> + * Unmaps DMA buffers, copies output to req->dst scatterlist,
> + * updates the IV state, frees temporaries, and completes the request.
> + *
> + * For CTR counter-wrap splits, the first chunk completion chains
> + * into a second VCQ submission rather than finalizing immediately.
> + */
> +static void cmh_aes_complete(void *data, int error)
> +{
> +	struct skcipher_request *req =3D data;
> +	struct cmh_aes_reqctx *rctx =3D skcipher_request_ctx(req);
> +
> +	if (error =3D=3D -EINPROGRESS) {
> +		cmh_complete(&req->base, error);
> +		return;
> +	}
> +
> +	/*
> +	 * CTR counter-wrap: first chunk completed, submit second.
> +	 * DMA mappings remain valid (they cover the full buffer).
> +	 *
> +	 * Recursion depth bounded: chunk2 clears ctr_chunk1_len before
> +	 * submission, so the second cmh_aes_complete invocation sees 0
> +	 * and finalizes (max depth =3D 2).
> +	 */
> +	if (rctx->ctr_chunk1_len && !error) {
> +		int ret;
> +
> +		ret =3D cmh_aes_ctr_submit_chunk2(req);
> +
> +		if (!ret || ret =3D=3D -EBUSY)
> +			return;
> +		/* Submission failed; clean up below */
> +		error =3D ret;
> +	}

[Severity: High]
Can this deliver a spurious or duplicate -EINPROGRESS notification to the
outer skcipher_request caller when CTR chunk 2 is backlogged?

When an AES-CTR request with CRYPTO_TFM_REQ_MAY_BACKLOG crosses the 64-bit
counter wrap boundary in cmh_aes_crypt(), chunk 1 is submitted first. At
that point, either cmh_aes_crypt() returned -EINPROGRESS directly, or chunk
1 was backlogged (-EBUSY) and already triggered the single allowed
-EINPROGRESS callback when cmh_tm_thread() promoted it.

When chunk 1 finishes in hardware, cmh_aes_complete() calls
cmh_aes_ctr_submit_chunk2(), which submits chunk 2 with backlog_ok enabled
and cmh_aes_complete as the callback. If tm.cmq is full when chunk 2 is
submitted, cmh_tm_post_command() places chunk 2 on tm.backlog and returns
-EBUSY.

When cmh_tm_thread() later promotes chunk 2 from tm.backlog to tm.cmq:

drivers/crypto/cmh/cmh_txn.c:cmh_tm_thread() {
    ...
		if (bl_promoted && bl_promoted->complete)
			bl_promoted->complete(bl_promoted->completion_data,
					      -EINPROGRESS);
    ...
}

cmh_aes_complete() receives -EINPROGRESS for chunk 2 and forwards it to
cmh_complete(&req->base, -EINPROGRESS), invoking req->base.complete() with
-EINPROGRESS even though the initial submission returned -EINPROGRESS (or
already fired -EINPROGRESS once for chunk 1).

> diff --git a/drivers/crypto/cmh/cmh_aes_aead.c b/drivers/crypto/cmh/cmh_a=
es_aead.c
> new file mode 100644
> index 0000000000000..ed2a0b9449bc0
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_aes_aead.c
[ ... ]
> +static int cmh_aes_aead_crypt(struct aead_request *req, u32 aes_op)
> +{
[ ... ]
> +	if (aes_op =3D=3D AES_OP_ENCRYPT) {
> +		cryptlen =3D req->cryptlen;
> +	} else {
> +		if (req->cryptlen < authsize)
> +			return -EINVAL;
> +		cryptlen =3D req->cryptlen - authsize;
> +	}
> +
> +	/*
> +	 * Validate CCM IV format early -- the empty-input fallback and
> +	 * nonce extraction both depend on iv[0] being in range [1,7].
> +	 */
> +	if (info->type =3D=3D CMH_AES_AEAD_CCM) {
> +		if (req->iv[0] < 1 || req->iv[0] > 7)
> +			return -EINVAL;
> +	}
> +
> +	/*
> +	 * The CMH eSW rejects GCM/CCM when both aadlen and iolen are zero.
> +	 * For GCM, the tag is simply E(K, J0) -- handle with ECB fallback.
> +	 * For CCM, compute tag =3D E(K,B0) XOR E(K,A0) in software.
> +	 */
> +	if (cryptlen =3D=3D 0 && req->assoclen =3D=3D 0) {
> +		if (info->type =3D=3D CMH_AES_AEAD_GCM)
> +			return cmh_aes_gcm_empty(req, aes_op);
> +		return cmh_aes_ccm_empty(req, aes_op);
> +	}
> +
> +	/*
> +	 * HW does not support authsize=3D10 for CCM.  Forward the entire
> +	 * request to the generic CCM implementation.
> +	 */
> +	if (info->type =3D=3D CMH_AES_AEAD_CCM && authsize =3D=3D 10)
> +		return cmh_aes_ccm_fallback(req, aes_op);
> +
> +	/*
> +	 * HW uses a proprietary LLI scatter-gather format that is
> +	 * incompatible with struct scatterlist, so the payload is
> +	 * linearised into contiguous buffers for DMA.  Cap total
> +	 * size to prevent excessive memory consumption.
> +	 */
> +	if ((u64)cryptlen + req->assoclen > SZ_1M)
> +		return -EINVAL;

[Severity: Medium]
Should cmh_aes_aead_crypt() check that cryptlen fits within L =3D req->iv[0=
] + 1
bytes for CCM, returning -EOVERFLOW when req->iv[0] =3D=3D 1 and cryptlen >=
 0xffff?

Per RFC 3610 section 2.1, when req->iv[0] =3D=3D 1 (L =3D 2, 13-byte nonce)=
, the
maximum representable payload length is 65535 bytes (as checked in
crypto/ccm.c:set_msg_len() and lib/crypto/aes.c:aes_ccm_init()). Because
cmh_aes_aead_crypt() allows cryptlen up to SZ_1M without checking whether it
exceeds 0xffff for L =3D 2, an oversized L =3D 2 request is sent to the har=
dware
instead of failing with -EOVERFLOW.

If the eSW rejects the command, cmh_aes_aead_complete() returns -EIO on
encrypt and maps -EIO to -EBADMSG on decrypt instead of -EOVERFLOW; on 64K
page systems with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled,
test_aead_vs_generic_impl() generates vectors above 64 KiB and expects
-EOVERFLOW to match the generic CCM implementation.

> diff --git a/drivers/crypto/cmh/cmh_aes_cmac.c b/drivers/crypto/cmh/cmh_a=
es_cmac.c
> new file mode 100644
> index 0000000000000..586150505d017
> --- /dev/null
> +++ b/drivers/crypto/cmh/cmh_aes_cmac.c
[ ... ]
> +/*
> + * .digest() -- compute the CMAC over the whole message in a single
> + * hardware transaction:
> + *   SYS_CMD_WRITE(key) + AES_CMD_INIT(CMAC) + AES_CMD_AAD_FINAL_AUTH +
> + *   FLUSH.
> + * The message is linearised into one DMA-mapped buffer.  The crypto core
> + * routes virtual-address requests to the software fallback before this
> + * op runs, so req->src is an ordinary scatterlist here.
> + */
> +static int cmh_aes_cmac_digest(struct ahash_request *req)
> +{
[ ... ]
> +	if (data_len) {
> +		rctx->buf =3D kmalloc(data_len, gfp | __GFP_NOWARN);
> +		if (!rctx->buf)
> +			return -ENOMEM;
> +		if (req->base.flags & CRYPTO_AHASH_REQ_VIRT)
> +			memcpy(rctx->buf, req->svirt, data_len);
> +		else
> +			scatterwalk_map_and_copy(rctx->buf, req->src, 0,
> +						 data_len, 0);
> +		rctx->data_len =3D data_len;
> +	}
[ ... ]
> +static int cmh_aes_cmac_init_tfm(struct crypto_ahash *tfm)
> +{
> +	struct cmh_aes_cmac_tfm_ctx *tctx =3D crypto_ahash_ctx(tfm);
> +	struct crypto_ahash *fb;
> +
> +	tctx->key.mode =3D CMH_KEY_NONE;
> +
> +	/*
> +	 * The generic cmac(aes) shash has no export_core, so the crypto
> +	 * core cannot wrap it as crypto_ahash_fb().  Allocate it here
> +	 * instead; masking out CRYPTO_ALG_ASYNC excludes this (async)
> +	 * driver so the allocator picks the generic, synchronous transform,
> +	 * and its request is embedded after the reqctx.
> +	 */
> +	fb =3D crypto_alloc_ahash(crypto_ahash_alg_name(tfm), 0,
> +				CRYPTO_ALG_ASYNC);
> +	if (IS_ERR(fb))
> +		return PTR_ERR(fb);
> +	tctx->fb =3D fb;
> +
> +	crypto_ahash_set_reqsize(tfm,
> +				 sizeof(struct cmh_aes_cmac_reqctx) +
> +				 crypto_tfm_ctx_alignment() +
> +				 sizeof(struct ahash_request) +
> +				 crypto_ahash_reqsize(fb));
> +	crypto_ahash_set_statesize(tfm, crypto_ahash_statesize(fb));
> +	return 0;
> +}

[Severity: Critical]
Does leaving tfm->fb pointing to the asynchronous CMH transform in
cmh_aes_cmac_init_tfm() overflow the stack buffer in crypto_hash_digest()?

In crypto_create_tfm_node(), tfm->fb is initialized to point to tfm itself.
Because cmh_aes_cmac_alg sets CRYPTO_ALG_NO_FALLBACK, crypto_ahash_init_tfm=
()
does not allocate a fallback transform or update tfm->fb, and
cmh_aes_cmac_init_tfm() stores the fallback only in tctx->fb while setting
tfm's reqsize to:

  sizeof(struct cmh_aes_cmac_reqctx) + crypto_tfm_ctx_alignment() +
  sizeof(struct ahash_request) + crypto_ahash_reqsize(fb)

Since crypto_ahash_init_tfm() raises crypto_ahash_reqsize(fb) to at least
HASH_MAX_DESCSIZE, and MAX_SYNC_HASH_REQSIZE is sizeof(struct ahash_request=
) +
HASH_MAX_DESCSIZE, crypto_ahash_reqsize(tfm) exceeds MAX_SYNC_HASH_REQSIZE =
by
sizeof(struct cmh_aes_cmac_reqctx) + crypto_tfm_ctx_alignment() (over 560
bytes).

When a caller invokes crypto_hash_digest(tfm, data, len, out) (or uses
HASH_FBREQ_ON_STACK() or HASH_REQUEST_CLONE() when falling back on allocati=
on
failure):

crypto/ahash.c:crypto_hash_digest() {
	HASH_REQUEST_ON_STACK(req, crypto_ahash_fb(tfm));
	int err;

	ahash_request_set_callback(req, 0, NULL, NULL);
	ahash_request_set_virt(req, data, out, len);
	err =3D crypto_ahash_digest(req);

	ahash_request_zero(req);

	return err;
}

HASH_REQUEST_ON_STACK() allocates __req_req on the stack with size
sizeof(struct ahash_request) + MAX_SYNC_HASH_REQSIZE and binds req to
crypto_ahash_fb(tfm), which is still the asynchronous CMH tfm.
crypto_ahash_digest(req) then fails with -EAGAIN (because
ahash_req_on_stack(req) && ahash_is_async(tfm) is true), and
ahash_request_zero(req) zeroes sizeof(*req) + crypto_ahash_reqsize(tfm) byt=
es,
overwriting more than 560 bytes past the end of __req_req on the kernel sta=
ck.

Also, the commit message states that virtual-address (CRYPTO_AHASH_REQ_VIRT)
paths are forwarded to the generic cmac(aes) transform, and the comment abo=
ve
cmh_aes_cmac_digest() notes that the crypto core routes virtual-address
requests to the software fallback before .digest() runs. However, because
cmh_aes_cmac_alg sets CRYPTO_ALG_REQ_VIRT, ahash_do_req_chain() calls
cmh_aes_cmac_digest() directly for CRYPTO_AHASH_REQ_VIRT requests, which co=
pies
req->svirt and submits the request asynchronously to hardware instead of
forwarding to tctx->fb.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261026-cmh-b4-a-v=
7-v7-0-500a83faf500@rambus.com?part=3D4
