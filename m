Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31D6342515
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 19:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781119053; cv=none; b=BYI4VCYKHaDqNexfcsn96dODI824UQ6XpgpJTOg9D6aydYXGP6DwzqJtVyCJ7gdOVCQyQLxtvsyqrdalsylNA7rWw9I6nrJXItGXagcpVGaNLOb2wJgSItbuGpeoTQpjakEN2SMUYVitQRF+35eFmYwtw+35oM9+N9mc7uVoa7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781119053; c=relaxed/simple;
	bh=AZvi6ZNzBZy6L1WVZ0LtkofFo1vWzMWYeJFKz3V4hFE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ENIv1nUm3l9D3vE0YznjsJxKK9uLNGJl9VSuZ2bXdeoMbwu/H5bP5jNwb19GMfDhCL/59gAkKmpx1zcU9erPyTRVX4ZK31aKP9PFJNSJApSw4zhaXM3OrLyMnYf48n6TZ0WHm99SgzV9Cxo2vtu+O7wmgZIKQgLN7qUiPGywihk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Orrg8s0G; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Orrg8s0G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781119051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/myOSqG7uv5qCnsE2QetCIJ83uVxLLLFgvexWhF+Xlo=;
	b=Orrg8s0GzQH/elWDaM8swFa1uIkYrzqyjF75NIKuWcrvL353TeCCbeOJx7wf9O+X1rKXh5
	9QbkN/0TGjdm5Qf1rDtRICfEqDGD0uLDlaC4ThUNRBqGKx7l73mPbfrw3tl7iveFTZ9TOs
	AODHc7nR05W7+FKQZBtF5VX82bD11oE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-481-wXi_R3TWMLeok5rQbRDlbA-1; Wed,
 10 Jun 2026 15:17:23 -0400
X-MC-Unique: wXi_R3TWMLeok5rQbRDlbA-1
X-Mimecast-MFC-AGG-ID: wXi_R3TWMLeok5rQbRDlbA_1781119041
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0E7FC180048E;
	Wed, 10 Jun 2026 19:17:20 +0000 (UTC)
Received: from thinkpad (headnet02.pony-001.prod.iad2.dc.redhat.com [10.2.32.102])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CABD23008DCB;
	Wed, 10 Jun 2026 19:17:13 +0000 (UTC)
Date: Wed, 10 Jun 2026 21:17:10 +0200
From: Felix Maurer <fmaurer@redhat.com>
To: Daniel Hodges <daniel@danielhodges.dev>
Cc: Daniel Hodges <git@danielhodges.dev>, bpf@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, vadim.fedorenko@linux.dev, song@kernel.org,
	yatsenko@meta.com, martin.lau@linux.dev, eddyz87@gmail.com,
	haoluo@google.com, jolsa@kernel.org, john.fastabend@gmail.com,
	kpsingh@kernel.org, sdf@fomichev.me, yonghong.song@linux.dev,
	herbert@gondor.apana.org.au, davem@davemloft.net
Subject: Re: [PATCH bpf-next v8 0/4] Add cryptographic hash and signature
 verification kfuncs to BPF
Message-ID: <aim4Ntj22wM30Ga8@thinkpad>
References: <20260225202935.31986-1-git@danielhodges.dev>
 <ag8zGP5azt743BWc@thinkpad>
 <fm43bx7min3olvz4ok46emxvyvbczw4weq5dkwitzwmq6h4jzg@a56b3irxynks>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fm43bx7min3olvz4ok46emxvyvbczw4weq5dkwitzwmq6h4jzg@a56b3irxynks>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Hi Daniel,

Sorry for taking long to get back to you, I've been on vacation for a
while.

> It would also be helpful to hear about what your use case is.

I'll put this one first, as it probably informs my thinking quite a bit.
My use case is accessing hash functions from the networking bpf hooks,
mostly XDP and tc. I'm less interested in the cryptographic hash
functions (although I think we should support them as well), but
checksums like CRC32c which have efficient implementations in the kernel
and are not straightforward to implement in bpf.

> > Taking an initial look at your hashing patches, I'm wondering: the usual
> > interface to hash/digest algorithms is to have three functions: an
> > init() function to set up state
>
> Doesn't bpf_crypto_ctx_create already provide the initialization? I was
> trying to make that pattern work by adding the bpf_crypto_type_id to
> make the code a little more maintainable.

No, bpf_crypto_ctx_create() doesn't do the initialization I was
referring to, it only creates the tfm that is later used to do the
hashing. The actual init() of the hash function happens inside
crypto_shash_digest(). More details at the end of my reply.

> > an update() function that can be called  multiple times to hash new
> > bytes, and a finalize() function that creates the actual hash.
> > Depending on the algorithm, some of them (esp.  finalize) may be
> > no-ops. Often, a fourth function, like hash(), is provided
>
> I think the bpf_crypto_encrypt should cover that along with the
> bpf_crypto_hash in the first patch.

Not sure if I understand you correctly, bpf_crypto_encrypt() shouldn't
be callable for a hashing crypto context at all?

> > I think we should provide the same init/update/finalize interface in bpf
> > as well to make the API more flexible. That would require splitting out
> > the shash_desc from the (mostly static) context. But doing so would also
> > address the review comment from bpf-ci bot to patch 1. WDYT?
>
> I was trying to make things work with the existing bpf_crypto_ctx
> lifecycle. IIRC in the V1/V2 of the series there was a separate struct
> but it was suggested to integrate the changes into bpf_crypto_ctx.

Yes, I see that the idea is to integrate into the existing life cycle
and I appreciate that! But IIUC, they are subtly different at the
moment.  Just to be sure, the idea of your first two patches is to
provide an interface to shash that supports the do-all-at-once function
hash()/digest() (i.e., internally do init+update+finalize), pretty much
the equivalent of the existing encrypt() + decrypt() interface to
skcipher, right? I.e. not supporting each and every use case for now but
just the case where all data is available and we want to hash/encrypt/
decrypt in one go?

With that assumption, the current implementation for skcipher looks like
this: we have bpf_crypto_ctx_create(). It sets up a bpf_crypto_ctx with
the chosen algorithm, the right key, etc. It must be called from a
sleepable bpf program because it may require to load the kernel module
with the requested algorithm. The prepared bpf_crypto_ctx can be stored
in a map so it can be used from other (non-sleepable) bpf programs,
e.g., XDP programs.

When the bpf_crypto_ctx is used with encrypt()/decrypt(), both functions
have the siv argument. It's a dynptr to some memory, containing the IV
for algorithms that need it, but also has room for the *state* if the
algorithm needs it. This means, the state is provided (fresh) for each
invocation of encrypt/decrypt.

Your proposed implementation for shash, bpf_crypto_ctx_create() calls
bpf_crypto_shash_alloc_tfm() which creates the tfm (just as above, needs
to be in a sleepable bpf program to potentially load modules), but it
also allocates the shash_desc which has room for some algorithm state if
needed. This mixes the static, long-living, reusable tfm with the
per-invocation shash_desc. shash is safe to use with the same tfm
concurrently exactly because the state is stored in the shash_desc,
which must not be used concurrently. Think of the shash_desc to be the
equivalent of the siv for skcipher.

Therefore, I think the memory for shash_desc.__ctx should come from a
dynptr as well. Do you agree or did I miss something?

Btw, your bpf_crypto_shash_alloc_tfm() never sets shash_desc.__ctx, so
that's a bug anyways.

> Regarding the bpf-ci bot I think it's somewhat valid, but you could
> solve that by putting the bpf_crypto_ctx in a per CPU map or protecting
> it with a bpf spinlock.

Two things for that: for networking use cases, needing a lock because of
implementation details doesn't sound very intriguing. Plus, if per-cpu
or a lock are required, that's currently not enforced. This means an
invalid/unsafe bpf program could pass the verifier, right?

> If you want to give it a go feel free.

If you're still interested in pursuing this, please go ahead with your
work, I don't want to take it from you. Only if you're explicitly not
interested anymore, I'll go ahead and try to build something on top of
you work. Just let me know :)

Thanks,
   Felix

