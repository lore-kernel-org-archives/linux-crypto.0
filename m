Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB5529994B
	for <linux-crypto@vger.kernel.org>; Mon,  1 Jun 2026 16:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780330520; cv=none; b=Qwdv9LXqvKTGtu6VcKq9StsEXbjS7/wJR7McAaL1rNZoAt60a7CoM/2SpTY2A0EFOqJetOCA/daf8YjC0W2H2ZQE8OLfWmoaZ9Pyn9/5r1Sa76hesnT1cJRzEOQrcICC4+5YYmYBdoDw7EV1h2pKLTmhFhtab1ebf+asS7nOY7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780330520; c=relaxed/simple;
	bh=gGgts3vFhcvuNsY6Ezu3ekzCGMMCBZk5YhQuXrdHvKc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=mjsW6dkW2q/xR2ZVnZggJplXB2glG5+rfTkwquVSG+SLfqoD8lmY5akb6PUBcMKwofpgLwetqFKolTlqy3WJy60xyPiKkrlh/POah0wxi5tJTHbc6ZSxuJbvm/BQ29YjL3xy7WJ2zmZEggTAa4jutojk/X8wKV7LoVz2qrLrslc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=foZkOJ7A; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="foZkOJ7A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780330517;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TTT+gEI5KEOq43SEOKUvHTrUsZAXYCqPmLn6rmfCg7c=;
	b=foZkOJ7AnEpA68+60wKxDD49F6p0JPXEo/wg+AdGcCyJ7B6f6TqnhgonZCSihUYrvO4owG
	zL+ZtoS902voee4TSZeBzg1gvtnuJmankExqpYQmMpy8Q/VhQlqn9TYhwqXGOib/sqUynw
	mMNH7BbNXyetIKpZMepgxLZhx7JDNus=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-596-CD5e8A7LMVOcOyd1kCx4yA-1; Mon,
 01 Jun 2026 12:15:16 -0400
X-MC-Unique: CD5e8A7LMVOcOyd1kCx4yA-1
X-Mimecast-MFC-AGG-ID: CD5e8A7LMVOcOyd1kCx4yA_1780330515
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5228018002DC;
	Mon,  1 Jun 2026 16:15:14 +0000 (UTC)
Received: from [10.44.49.105] (unknown [10.44.49.105])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3642C18004A3;
	Mon,  1 Jun 2026 16:15:11 +0000 (UTC)
Date: Mon, 1 Jun 2026 18:15:08 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Leonid Ravich <lravich@amazon.com>
cc: Herbert Xu <herbert@gondor.apana.org.au>, Alasdair Kergon <agk@redhat.com>, 
    Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
    Jens Axboe <axboe@kernel.dk>, Horia Geanta <horia.geanta@nxp.com>, 
    Gilad Ben-Yossef <gilad@benyossef.com>, linux-crypto@vger.kernel.org, 
    dm-devel@lists.linux.dev, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 4/4] dm crypt: batch all sectors of a bio per crypto
 request
In-Reply-To: <20260601085644.13026-5-lravich@amazon.com>
Message-ID: <d3bb0caa-cd29-a68e-0676-0b9418751865@redhat.com>
References: <20260601085644.13026-1-lravich@amazon.com> <20260601085644.13026-5-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93



On Mon, 1 Jun 2026, Leonid Ravich wrote:

> When the underlying skcipher driver advertises support for multiple
> data units in a single request (CRYPTO_ALG_SKCIPHER_MULTI_DATA_UNIT),
> configure the cipher with cc->sector_size as data_unit_size and
> submit one request per bio instead of one request per sector.  This
> removes per-sector overhead in the crypto API hot path: request
> allocation, callback dispatch, completion handling, and SG setup.
> 
> The optimisation is enabled automatically at table load when all
> of the following hold:
> 
>  - the cipher is non-aead (i.e. skcipher);
>  - tfms_count is 1 (interleaved per-sector keys would break batching);
>  - the IV mode is plain or plain64 (the only modes whose generator
>    produces a sequential 64-bit little-endian counter that the cipher
>    can extend by adding the data-unit index, matching the convention
>    documented in crypto_skcipher_set_data_unit_size());
>  - the iv_gen_ops->post() hook is unset (lmk and tcw use it; both are
>    already excluded by the IV-mode test, but the explicit check makes
>    the assumption durable against future IV modes);
>  - dm-integrity is not stacked (no integrity tag or integrity IV);
>  - the cipher driver advertises multi-data-unit support.
> 
> A new CRYPT_MULTI_DATA_UNIT cipher_flag, set once at construction
> time, gates the multi-data-unit path.  The existing per-sector path
> in crypt_convert_block_skcipher() is unchanged; the new
> crypt_convert_block_skcipher_multi() is reached from a small dispatch
> in crypt_convert() and shares the same backlog/-EBUSY/-EINPROGRESS
> flow control with the per-sector path.
> 
> Heap-allocated scatterlists are stashed in dm_crypt_request and freed
> in crypt_free_req_skcipher() to avoid races between the synchronous-
> success free path and async-completion reuse from the request pool.
> On -ENOMEM during scatterlist allocation, the bio is requeued via
> BLK_STS_DEV_RESOURCE rather than failed, matching the behaviour of
> the existing -ENOMEM path for crypto request allocation.
> 
> Verified end-to-end with a byte-equivalence test: encrypted output of
> plain64 dm-crypt with the multi-data-unit path matches output of the
> single-data-unit path bit-for-bit over a 256 MB device.
> 
> Signed-off-by: Leonid Ravich <lravich@amazon.com>

Reviewed-by: Mikulas Patocka <mpatocka@redhat.com>

