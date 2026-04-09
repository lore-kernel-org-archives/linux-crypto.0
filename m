Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.61.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD2E3BD62A
	for <linux-crypto@vger.kernel.org>; Thu,  9 Apr 2026 15:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.61.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775748314; cv=none; b=mnopzQCmfmpJmTUDpR896gJrLngA+2ZE8JuGUO1Bf3WHxNYXPCWsgIWVs7sLiK9IJTGAyXD3btXhz0asMd4mPEnrVgZGWsnpokZTC7eCfhNbK+B/eqepJlaoan2kRodWH4bq4Q/oGLjlrS0TWxXzhza1cR4LZLowoXHOIPLs2UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775748314; c=relaxed/simple;
	bh=9DzyjFQNlU2JTzRGbhH3voGhaqwsaf/RHWrWdHJAXJw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qL4FEhoMRM3VBjg84odPXQq0auMWr3m/rIGjzyX83HPHyJG3XXR8sFg6xHypzPlzmSrSgXznol+1RhcIAznsP7EnyLzY9bX1LMjMhtDbtROobQ+pP1dgUWiwu/FFHL8Yg28/bcdwMSgJCpURCYmFzyTM0CDoLq4pc8l0oj4v8Cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=bNSm6AZc; arc=none smtp.client-ip=188.68.61.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="bNSm6AZc"
Received: from mors-relay-8405.netcup.net (localhost [127.0.0.1])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4fs3dp0QMTz71FR;
	Thu,  9 Apr 2026 17:25:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1775748302;
	bh=9DzyjFQNlU2JTzRGbhH3voGhaqwsaf/RHWrWdHJAXJw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bNSm6AZcUIRxkmWZcnCHHIWbFelHrmvd17QsCfcWk8g88V2cSUDaIXur5YvBQwHaT
	 TaDYF/eXPdeeZck1tgrFQnSCneoX2srLYWn30ioxyGRIWxi3+lF5c0FeL6DyDcEOIl
	 1qBspngfjeGS5qpfTHxHdH5C5AmleNuriGgNS1EOxfmKB3fGfk7tkNjqtx+3KvtNAC
	 C15k+xkhX/er/WAYE6LuQxWL8/CcluOblNHZgiC90nvtCgz8bOIQyUr6/k/re2fstg
	 ixZ7E9PVoKC2yNy4U9ASjNl6OWiikTcuK/YWsOjh8bNeY7zGSbwqVymrumvQo3EqYu
	 hSRc4LLuTc/sA==
Received: from policy02-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8405.netcup.net (Postfix) with ESMTPS id 4fs3dh30R8z70gP;
	Thu,  9 Apr 2026 17:24:56 +0200 (CEST)
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy02-mors.netcup.net (Postfix) with ESMTPS id 4fs3dd27xPz8svC;
	Thu,  9 Apr 2026 17:24:52 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id EE72E633E1;
	Thu,  9 Apr 2026 17:24:50 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <73ab5267-57b8-4394-9c10-4ee3bf92e444@leemhuis.info>
Date: Thu, 9 Apr 2026 17:24:49 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: algif_aead - Revert to operating out-of-place
To: Herbert Xu <herbert@gondor.apana.org.au>, Taeyang Lee <0wn@theori.io>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Eric Biggers <ebiggers@kernel.org>,
 Linus Torvalds <torvalds@linuxfoundation.org>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Greg KH <gregkh@linuxfoundation.org>, davem@davemloft.net,
 Brian Pak <bpak@theori.io>, Juno Im <juno@theori.io>,
 Jungwon Lim <setuid0@theori.io>, douzzer@mega.nu,
 Linux kernel regressions list <regressions@lists.linux.dev>
References: <acOpDrnN3cVfiASk@gondor.apana.org.au>
 <CAH-2XvLZD_-CVQT0omao2+GrdQt1Loq+oo4X6q=0NUAeUk==1w@mail.gmail.com>
 <acTSfLPWDGTaGIf7@gondor.apana.org.au>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
X-Enigmail-Draft-Status: N11222
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 MEK4
In-Reply-To: <acTSfLPWDGTaGIf7@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: 
 <177574829155.1037382.16457480669499281659@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: EE72E633E1
X-NC-CID: BqsNYuuAyFwgxgZZ+ThRBGfQ0Pbc753eY+n0zZWX/XgL7RJ0nxc=

On 3/26/26 07:30, Herbert Xu wrote:
> On Thu, Mar 26, 2026 at 02:59:24AM +0900, Taeyang Lee wrote:
>> I don't think checking only `src != dst` is sufficient for the issue I
>> reported.
>>
>> In the AF_ALG AEAD decrypt path, the child AEAD request is intentionally
>> set up to look in-place: `req->src == req->dst` on the RX SGL head, and
>> the TX-backed authentication-tag pages are then chained behind that RX
>> SGL. So from authencesn's point of view this still takes the `src == dst`
>> path, while `dst[assoclen + cryptlen]` can still resolve to TX-backed
>> pages, including splice()/MSG_SPLICE_PAGES-backed page-cache pages.
> 
> Right, that's a separate bug.  algif_aead should not attach a
> read-only mapping to the dst SG list, which will be written to.

This meanwhile became a664bf3d603dc3 ("crypto: algif_aead - Revert to
operating out-of-place") [v7.0-rc7] and according to Daniel Pouzzner
causes a regression reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=221332

To quote: """Seeing Oopses and some kernel panics in 7.0_rc7 under
modest load, roughly 10% of test runs.  Discovered by serendipity
running libkcapi test.sh to test our own crypto module (libwolfssl.ko),
then reproduced on native crypto to exclude us as the cause.

[...]

Note re the above, AFAIK the instability has nothing in particular to do
with exercising the kernel crypto.  There's no crypto in any of the
backtraces, and it's identical syndrome with in-tree and out-of-tree crypto.

The config, toolchain, and runtime were identical for the rc6 vs rc7
smoke testing loops.  In both cases they're running under qemu-10.2.0
like so:

qemu-system-x86_64 -kernel /usr/src/linux-7.0-rc7/arch/x86/boot/bzImage
-nographic -append console=ttyS0 ramdisk_size=65526   -initrd
/tmp/tmp.4346_28411/wolfssl_test_workdir.17219/initramfs-7.0.0-rc7-wolfssl.img
-m 5120 -enable-kvm -cpu host -machine q35 -smp
8,sockets=1,cores=4,threads=2,maxcpus=8

The passed-through CPU is AMD Ryzen Threadripper 7960X."""

Ciao, Thorsten

> ---8<---
> This mostly reverts commit 72548b093ee3 except for the copying of
> the associated data.
> 
> There is no benefit in operating in-place in algif_aead since the
> source and destination come from different mappings.  Get rid of
> all the complexity added for in-place operation and just copy the
> AD directly.
> 
> Fixes: 72548b093ee3 ("crypto: algif_aead - copy AAD from src to dst")
> Reported-by: Taeyang Lee <0wn@theori.io>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>  crypto/af_alg.c         |  49 +++++-------------------
>  crypto/algif_aead.c     | 100 +++++++++---------------------------------------
>  crypto/algif_skcipher.c |   6 +--
>  include/crypto/if_alg.h |   5 +--
>  4 files changed, 34 insertions(+), 126 deletions(-)
> 
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index 0bb609fbec7d..0d2305ac1b52 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -635,15 +635,13 @@ static int af_alg_alloc_tsgl(struct sock *sk)
>  /**
>   * af_alg_count_tsgl - Count number of TX SG entries
>   *
> - * The counting starts from the beginning of the SGL to @bytes. If
> - * an @offset is provided, the counting of the SG entries starts at the @offset.
> + * The counting starts from the beginning of the SGL to @bytes.
>   *
>   * @sk: socket of connection to user space
>   * @bytes: Count the number of SG entries holding given number of bytes.
> - * @offset: Start the counting of SG entries from the given offset.
>   * Return: Number of TX SG entries found given the constraints
>   */
> -unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
> +unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes)
>  {
>  	const struct alg_sock *ask = alg_sk(sk);
>  	const struct af_alg_ctx *ctx = ask->private;
> @@ -658,25 +656,11 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
>  		const struct scatterlist *sg = sgl->sg;
>  
>  		for (i = 0; i < sgl->cur; i++) {
> -			size_t bytes_count;
> -
> -			/* Skip offset */
> -			if (offset >= sg[i].length) {
> -				offset -= sg[i].length;
> -				bytes -= sg[i].length;
> -				continue;
> -			}
> -
> -			bytes_count = sg[i].length - offset;
> -
> -			offset = 0;
>  			sgl_count++;
> -
> -			/* If we have seen requested number of bytes, stop */
> -			if (bytes_count >= bytes)
> +			if (sg[i].length >= bytes)
>  				return sgl_count;
>  
> -			bytes -= bytes_count;
> +			bytes -= sg[i].length;
>  		}
>  	}
>  
> @@ -688,19 +672,14 @@ EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
>   * af_alg_pull_tsgl - Release the specified buffers from TX SGL
>   *
>   * If @dst is non-null, reassign the pages to @dst. The caller must release
> - * the pages. If @dst_offset is given only reassign the pages to @dst starting
> - * at the @dst_offset (byte). The caller must ensure that @dst is large
> - * enough (e.g. by using af_alg_count_tsgl with the same offset).
> + * the pages.
>   *
>   * @sk: socket of connection to user space
>   * @used: Number of bytes to pull from TX SGL
>   * @dst: If non-NULL, buffer is reassigned to dst SGL instead of releasing. The
>   *	 caller must release the buffers in dst.
> - * @dst_offset: Reassign the TX SGL from given offset. All buffers before
> - *	        reaching the offset is released.
>   */
> -void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
> -		      size_t dst_offset)
> +void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst)
>  {
>  	struct alg_sock *ask = alg_sk(sk);
>  	struct af_alg_ctx *ctx = ask->private;
> @@ -725,18 +704,10 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
>  			 * SG entries in dst.
>  			 */
>  			if (dst) {
> -				if (dst_offset >= plen) {
> -					/* discard page before offset */
> -					dst_offset -= plen;
> -				} else {
> -					/* reassign page to dst after offset */
> -					get_page(page);
> -					sg_set_page(dst + j, page,
> -						    plen - dst_offset,
> -						    sg[i].offset + dst_offset);
> -					dst_offset = 0;
> -					j++;
> -				}
> +				/* reassign page to dst after offset */
> +				get_page(page);
> +				sg_set_page(dst + j, page, plen, sg[i].offset);
> +				j++;
>  			}
>  
>  			sg[i].length -= plen;
> diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
> index 79b016a899a1..dda15bb05e89 100644
> --- a/crypto/algif_aead.c
> +++ b/crypto/algif_aead.c
> @@ -26,7 +26,6 @@
>  #include <crypto/internal/aead.h>
>  #include <crypto/scatterwalk.h>
>  #include <crypto/if_alg.h>
> -#include <crypto/skcipher.h>
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/kernel.h>
> @@ -72,9 +71,8 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	struct alg_sock *pask = alg_sk(psk);
>  	struct af_alg_ctx *ctx = ask->private;
>  	struct crypto_aead *tfm = pask->private;
> -	unsigned int i, as = crypto_aead_authsize(tfm);
> +	unsigned int as = crypto_aead_authsize(tfm);
>  	struct af_alg_async_req *areq;
> -	struct af_alg_tsgl *tsgl, *tmp;
>  	struct scatterlist *rsgl_src, *tsgl_src = NULL;
>  	int err = 0;
>  	size_t used = 0;		/* [in]  TX bufs to be en/decrypted */
> @@ -154,23 +152,24 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  		outlen -= less;
>  	}
>  
> +	/*
> +	 * Create a per request TX SGL for this request which tracks the
> +	 * SG entries from the global TX SGL.
> +	 */
>  	processed = used + ctx->aead_assoclen;
> -	list_for_each_entry_safe(tsgl, tmp, &ctx->tsgl_list, list) {
> -		for (i = 0; i < tsgl->cur; i++) {
> -			struct scatterlist *process_sg = tsgl->sg + i;
> -
> -			if (!(process_sg->length) || !sg_page(process_sg))
> -				continue;
> -			tsgl_src = process_sg;
> -			break;
> -		}
> -		if (tsgl_src)
> -			break;
> -	}
> -	if (processed && !tsgl_src) {
> -		err = -EFAULT;
> +	areq->tsgl_entries = af_alg_count_tsgl(sk, processed);
> +	if (!areq->tsgl_entries)
> +		areq->tsgl_entries = 1;
> +	areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
> +					         areq->tsgl_entries),
> +				  GFP_KERNEL);
> +	if (!areq->tsgl) {
> +		err = -ENOMEM;
>  		goto free;
>  	}
> +	sg_init_table(areq->tsgl, areq->tsgl_entries);
> +	af_alg_pull_tsgl(sk, processed, areq->tsgl);
> +	tsgl_src = areq->tsgl;
>  
>  	/*
>  	 * Copy of AAD from source to destination
> @@ -179,76 +178,15 @@ static int _aead_recvmsg(struct socket *sock, struct msghdr *msg,
>  	 * when user space uses an in-place cipher operation, the kernel
>  	 * will copy the data as it does not see whether such in-place operation
>  	 * is initiated.
> -	 *
> -	 * To ensure efficiency, the following implementation ensure that the
> -	 * ciphers are invoked to perform a crypto operation in-place. This
> -	 * is achieved by memory management specified as follows.
>  	 */
>  
>  	/* Use the RX SGL as source (and destination) for crypto op. */
>  	rsgl_src = areq->first_rsgl.sgl.sgt.sgl;
>  
> -	if (ctx->enc) {
> -		/*
> -		 * Encryption operation - The in-place cipher operation is
> -		 * achieved by the following operation:
> -		 *
> -		 * TX SGL: AAD || PT
> -		 *	    |	   |
> -		 *	    | copy |
> -		 *	    v	   v
> -		 * RX SGL: AAD || PT || Tag
> -		 */
> -		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src,
> -			      processed);
> -		af_alg_pull_tsgl(sk, processed, NULL, 0);
> -	} else {
> -		/*
> -		 * Decryption operation - To achieve an in-place cipher
> -		 * operation, the following  SGL structure is used:
> -		 *
> -		 * TX SGL: AAD || CT || Tag
> -		 *	    |	   |	 ^
> -		 *	    | copy |	 | Create SGL link.
> -		 *	    v	   v	 |
> -		 * RX SGL: AAD || CT ----+
> -		 */
> -
> -		/* Copy AAD || CT to RX SGL buffer for in-place operation. */
> -		memcpy_sglist(areq->first_rsgl.sgl.sgt.sgl, tsgl_src, outlen);
> -
> -		/* Create TX SGL for tag and chain it to RX SGL. */
> -		areq->tsgl_entries = af_alg_count_tsgl(sk, processed,
> -						       processed - as);
> -		if (!areq->tsgl_entries)
> -			areq->tsgl_entries = 1;
> -		areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
> -							 areq->tsgl_entries),
> -					  GFP_KERNEL);
> -		if (!areq->tsgl) {
> -			err = -ENOMEM;
> -			goto free;
> -		}
> -		sg_init_table(areq->tsgl, areq->tsgl_entries);
> -
> -		/* Release TX SGL, except for tag data and reassign tag data. */
> -		af_alg_pull_tsgl(sk, processed, areq->tsgl, processed - as);
> -
> -		/* chain the areq TX SGL holding the tag with RX SGL */
> -		if (usedpages) {
> -			/* RX SGL present */
> -			struct af_alg_sgl *sgl_prev = &areq->last_rsgl->sgl;
> -			struct scatterlist *sg = sgl_prev->sgt.sgl;
> -
> -			sg_unmark_end(sg + sgl_prev->sgt.nents - 1);
> -			sg_chain(sg, sgl_prev->sgt.nents + 1, areq->tsgl);
> -		} else
> -			/* no RX SGL present (e.g. authentication only) */
> -			rsgl_src = areq->tsgl;
> -	}
> +	memcpy_sglist(rsgl_src, tsgl_src, ctx->aead_assoclen);
>  
>  	/* Initialize the crypto operation */
> -	aead_request_set_crypt(&areq->cra_u.aead_req, rsgl_src,
> +	aead_request_set_crypt(&areq->cra_u.aead_req, tsgl_src,
>  			       areq->first_rsgl.sgl.sgt.sgl, used, ctx->iv);
>  	aead_request_set_ad(&areq->cra_u.aead_req, ctx->aead_assoclen);
>  	aead_request_set_tfm(&areq->cra_u.aead_req, tfm);
> @@ -450,7 +388,7 @@ static void aead_sock_destruct(struct sock *sk)
>  	struct crypto_aead *tfm = pask->private;
>  	unsigned int ivlen = crypto_aead_ivsize(tfm);
>  
> -	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
> +	af_alg_pull_tsgl(sk, ctx->used, NULL);
>  	sock_kzfree_s(sk, ctx->iv, ivlen);
>  	sock_kfree_s(sk, ctx, ctx->len);
>  	af_alg_release_parent(sk);
> diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
> index 125d395c5e00..82735e51be10 100644
> --- a/crypto/algif_skcipher.c
> +++ b/crypto/algif_skcipher.c
> @@ -138,7 +138,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  	 * Create a per request TX SGL for this request which tracks the
>  	 * SG entries from the global TX SGL.
>  	 */
> -	areq->tsgl_entries = af_alg_count_tsgl(sk, len, 0);
> +	areq->tsgl_entries = af_alg_count_tsgl(sk, len);
>  	if (!areq->tsgl_entries)
>  		areq->tsgl_entries = 1;
>  	areq->tsgl = sock_kmalloc(sk, array_size(sizeof(*areq->tsgl),
> @@ -149,7 +149,7 @@ static int _skcipher_recvmsg(struct socket *sock, struct msghdr *msg,
>  		goto free;
>  	}
>  	sg_init_table(areq->tsgl, areq->tsgl_entries);
> -	af_alg_pull_tsgl(sk, len, areq->tsgl, 0);
> +	af_alg_pull_tsgl(sk, len, areq->tsgl);
>  
>  	/* Initialize the crypto operation */
>  	skcipher_request_set_tfm(&areq->cra_u.skcipher_req, tfm);
> @@ -363,7 +363,7 @@ static void skcipher_sock_destruct(struct sock *sk)
>  	struct alg_sock *pask = alg_sk(psk);
>  	struct crypto_skcipher *tfm = pask->private;
>  
> -	af_alg_pull_tsgl(sk, ctx->used, NULL, 0);
> +	af_alg_pull_tsgl(sk, ctx->used, NULL);
>  	sock_kzfree_s(sk, ctx->iv, crypto_skcipher_ivsize(tfm));
>  	if (ctx->state)
>  		sock_kzfree_s(sk, ctx->state, crypto_skcipher_statesize(tfm));
> diff --git a/include/crypto/if_alg.h b/include/crypto/if_alg.h
> index 107b797c33ec..0cc8fa749f68 100644
> --- a/include/crypto/if_alg.h
> +++ b/include/crypto/if_alg.h
> @@ -230,9 +230,8 @@ static inline bool af_alg_readable(struct sock *sk)
>  	return PAGE_SIZE <= af_alg_rcvbuf(sk);
>  }
>  
> -unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset);
> -void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
> -		      size_t dst_offset);
> +unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes);
> +void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst);
>  void af_alg_wmem_wakeup(struct sock *sk);
>  int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min);
>  int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,

