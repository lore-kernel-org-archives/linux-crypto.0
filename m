Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795805049;
	b=MRO31RaFNe0dWdgszzBYGb3UDm7hJG5Aexf8xAIAZClTJgVRRD+Xc10GTXiMjktZIW/E
	 jdcRvp+7Gp1reogJR9tzAmX8EWeOaRPbJm6HeS2J3rqXPUGFeJN0MW/gv/ozruuNyIGsH
	 7hDrVctzJHkFyj0QONC+HMvTn1bFbIi2oNOBtr7uz0xhZHDajThE+Ksdm64xYrXov3AkU
	 d0japrTjUvsbHzc8YtKKONfqlVEPG+UooluSmWRXAdJ4+m0TQ1PcYsMugVD0oYrb/d1qk
	 /4gAN8Sk+1qYnAb528gk+DG4084nSHn7tjSAjgwSOSp1jd8Rq+HK26ozHj/7erDOKfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795805049;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Rp4rYzgNw4nX+/vzYMGQGnQfPxDPdmfvj69vauWPj9s=;
	b=N6x+YobHdPMkjsPsLTb/qYriyWnqXuqFaQOsWFHoFWFhssrO+AbjqRbAa2BZjPO7BCdd
	 YykETeBL7ON9LQxBJuegmRWkAFSAkz1AVkRcDG6LavVCI5ZlwgE+/GONOGg1cBoE0tDFj
	 VUfaiVrgV+UvRERIVuDLs4wKi9Q6TVgRgGNp19pLODBncRmMb96To9Oa6vs+h/SNdYFX1
	 5ML1+QvhGC5fJr1G4KM1+gHtOb+HL0Otxe45ELM+0b3CmM8gWFEvbCwnRW3wk1j389PFN
	 2o71vpG2tiIwDqt4887l49CzLvJTiXYi81iFsyRIDaVashl3T1nlrvC4H80Sk3HAh7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aymk3lD6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2CD606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 18:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Aymk3lD6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E047E1F000C1;
	Fri, 27 Nov 2026 18:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805049;
	bh=Rp4rYzgNw4nX+/vzYMGQGnQfPxDPdmfvj69vauWPj9s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Aymk3lD6KrVQfZ7YdjagR4QVkLTXlYODihx9tEdLxiHDZH9PcY/XIkbJWZ/FEnRvu
	 9yvstuaBhMNsd2wKprg6/NTMNVzyYxaaHvR0MBqI30R8RZ6cXlOl0hMESb4IJTe7PU
	 YhvmXeVGQgxP/Pac/CpeUsx5U45sByrAHUXGs3v9vj9cvaogGhbUn3GMRM+ivTpZDt
	 wyeLyjKbM8SvacoayC8HHS8XbY5aHozEfExm0e83qvl3fxaCOhVnJfWxOBsI6LBzzx
	 a9O+OcQmOxifxAszHzbIc8U6jLGYZeZObNMUeXJdAlbeFTe5xgfb8BRHghKqvBI/N3
	 lQUdAQ7DLH16g==
Date: Fri, 27 Nov 2026 10:44:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Laveesh Bansal <laveeshb@laveeshbansal.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: adiantum - Eliminate slab memory allocation in
 setkey
Message-ID: <20261127184407.GB1974@quark>
References: <20261125013553.94480-1-ebiggers@kernel.org>
 <20261127015345.33904-1-laveeshb@laveeshbansal.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261127015345.33904-1-laveeshb@laveeshbansal.com>

On Thu, Nov 26, 2026 at 05:53:45PM -0800, Laveesh Bansal wrote:
> I tested this on x86_64, arm64 and s390x (big-endian, emulated in QEMU) --
> all on top of mainline c44104f3642d.
> 
> On Tue, Nov 24, 2026 at 05:35:53PM -0800, Eric Biggers wrote:
> > +	memmove(tctx->nh_key,
> > +		&tctx->derived_keys[BLOCKCIPHER_KEY_SIZE +
> > +				    2 * POLY1305_BLOCK_SIZE],
> > +		NH_KEY_BYTES);
> 
> I checked that this gives the same ciphertext as before. On each machine
> I compared it with and without the patch using 400 seeded random keys,
> tweaks and plaintexts for each of adiantum(xchacha12,aes) and
> adiantum(xchacha20,aes), including re-keying one tfm against a fresh one.
> The digests were identical with and without the patch, and the same on
> all three machines. I saw no round trip or re-key mismatches.
> 
> > +	SYNC_SKCIPHER_REQUEST_ON_STACK(
> > +		req, (struct crypto_sync_skcipher *)tctx->streamcipher);
> 
> I measured the stack cost. With -fstack-usage, the frame of
> adiantum_setkey() grows from 64 to 640 bytes on arm64 (gcc 13.3.0; 96 to
> 896 with KASAN) and from 72 to 872 bytes on x86_64 with KASAN (gcc
> 15.2.0), under the 2048 byte frame warning limit.
> 
> I also ran the stack tracer on arm64 (KASAN, 32 KiB stacks,
> with v3 of my blk-crypto patch also applied:
> https://lore.kernel.org/all/20261125081417.77674-1-laveeshb@laveeshbansal.com/)
> under the f2fs/adiantum workload with memory pressure.
> The deepest stack at any adiantum, chacha or blk-crypto function was
> 7784 bytes, going through adiantum_setkey() via inode eviction in
> reclaim. That was one run and I did not run the tracer on x86_64.
> 
> I think this is an acceptable trade. The old kzalloc() could enter direct
> reclaim from setkey, and an allocation in the same fallback I/O path (the
> bio encryption) used about 4 KiB of stack in reclaim in the same
> workload. The new frame adds 576 to 800 bytes, mostly the on-stack
> request (a fixed 384 bytes plus header).
> 
> A couple of other results:
> 
> - The lockdep cycle from the blk-crypto report is gone with this patch.
>   In my f2fs/adiantum workload under memory pressure the base kernel hit
>   it in all 3 runs on arm64, and lockdep recorded the &profile->lock to
>   fs_reclaim dependency. With only this patch I got none and lockdep no
>   longer recorded that dependency. I also got none with
>   CRYPTO_SELFTESTS_FULL.
>   On x86_64 the base hit the cycle in all runs - 6 across 2 hosts.
>   With only this patch I got none,
>   and also none with v3 of my patch on top. I saw no hung task or
>   KASAN reports in any of the runs with the patch.
> 
> - CRYPTO_SELFTESTS: I did not get any failures, with and without
>   CRYPTO_SELFTESTS_FULL. The WARN_ON in
>   adiantum_init_tfm() did not fire in any of my runs.
> 
> Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>

Thanks.  Later we should shrink the required stack space by switching
from crypto_skcipher to the ChaCha library.
(SYNC_SKCIPHER_REQUEST_ON_STACK() uses way more stack space than
needed.)  But that would be a separate cleanup, and the stack usage from
SYNC_SKCIPHER_REQUEST_ON_STACK() is tolerable for now.

- Eric
