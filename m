Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D8CB644;
	Tue, 10 Dec 2024 03:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733801027; cv=none; b=hCYev8mk35KdCLLFdNwuv+SZ3eo2dMdkMkFmmH0RlU2AhGjWO5AWLSV2Ey12FRRdKk5G+YS7/FIkkwlmXjOXcvxpy7fkov2KHTxDxfSjwzS4YrP3iCutLnfkg/z4sW/OYWHt/pxYTIQsRiIlcDhOfDmSFpT7ARBGcEnh29BaY64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733801027; c=relaxed/simple;
	bh=zWvfhOhTnJxZw3Q+SmdO4IWJaqD9iWKEoCYSD+OClC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cl01yShwtOw5Ce7opqNoMeDcjIVy0gBy6yXz3rivXewy7wef8tvhKUiw4/bVLZ7Gm6DD5w40SKaW07JAkgKZ8srqPuJ3YcSTfmrCIR8Api0uxkwBaDpEEfCk25FH7R3tkvG4hucESx5cJXaU2gl4px6Me+EX40E7KRAQpNsAyBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=LMi83BZk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="LMi83BZk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=QRJuG0s9T8kGT7fGW4vO0K9A1EqQPFWHMiDEkxy1xD4=; b=LMi83BZk7wb0+X/dmEn11mzy+6
	K2Vjr/2OMmRQEqKx+RoIaoOOZUIyn1HxqHNi2bxsNO1HwnE7T9E74EJUhPmlOPbCs7uc34RxBOZsV
	Tu8oEcxsjlgpCMzMPFydeu8lUXV51fXM3CkqBfIc2PHhvGshRzgNyLcqfePiUdv+gT0r8BS/iMl4C
	U3mWHy2/0wsU/BjVEbo70ynDD9k/G6JSrv7iCsAc4mT/e7m71IKtEhDG+GJHKg8ZnTqokonv0CHiM
	T6I83oN+tYXwwtU/+Tpw4M6mqGAqwoLu0oXLaWVO6UagK6Wb3uygeR+ZE2xLYM+0XUS56nRJNlAvp
	zr3/U7jA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tKqdP-000N6G-2C;
	Tue, 10 Dec 2024 11:23:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 11:23:24 +0800
Date: Tue, 10 Dec 2024 11:23:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241112015920.22564-4-ansuelsmth@gmail.com>

On Tue, Nov 12, 2024 at 02:59:00AM +0100, Christian Marangi wrote:
>
> +static int eip93_hash_export(struct ahash_request *req, void *out)
> +{
> +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> +	struct eip93_hash_export_state *state = out;
> +	DECLARE_CRYPTO_WAIT(wait);
> +	int ret;
> +
> +	crypto_init_wait(&wait);
> +	/* Set the req callback for hash_partial_final wait */
> +	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
> +				   crypto_req_done, &wait);
> +
> +	/* Set for partial hash generation */
> +	rctx->partial_hash = true;
> +	rctx->export_state = true;
> +	rctx->state = state;
> +
> +	/* Save the first block in state data */
> +	if (rctx->left_last || rctx->len) {
> +		struct mkt_hash_block *block;
> +
> +		block = list_first_entry(&rctx->blocks,
> +					 struct mkt_hash_block,
> +					 list);
> +
> +		memcpy(state->data, block->data,
> +		       SHA256_BLOCK_SIZE - rctx->left_last);
> +	}
> +
> +	/* Call hash_partial_final.
> +	 * This will send a dummpy 0 length packet. This is done to
> +	 * wait for every descriptor to being handled and sync the sa_state
> +	 * from the host. Partial hash and any other data will be copied in
> +	 * eip93_hash_handle_result()
> +	 */
> +	ret = crypto_wait_req(eip93_hash_partial_final(req), &wait);

Sorry, you can't do that here.  Your hash state should have been
exported when the request previously completed.  The export function
must not sleep.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
