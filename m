Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795744449;
	b=RtoLVe+Ke9wDWzgG52/Dft6kzhQ1MRYZ4nj1Z8oXt5JlBaKFYw9aAZFjHbjOlRcpVGfE
	 Vp7myE1u7kjv/qUaB1lmapgqOXFWjvQTYe26gT7WxUSJYCHFyGNwuFmj/rMdeORhtRb1u
	 FyOn777AHMgaXna00rf2EDMaAsKVh0AXt0LUZPQNeOQAnMLekTzLZ9q+4EjrihTMH2xh9
	 tvIUCMenEyHOTyTMDxBuq1KYdwILzlIO7wPt0Z9qHs8WaXKHjKejpAcrClohd+SZ/5DRw
	 6pSIQ92i60qB6F73ydf+lacalQcMtrUCzWrpQ1p+IdAGM9cvNXT9kPhih1Nf3o9QYgw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795744449;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding:X-ZohoMailClient;
	bh=vHdgcHXdABLVLLZ/6jXjR8p/kmya3OMTM86heYCTE4g=;
	b=Mp31qBiZIu5oQnYsbReoiWNINWApbTNlUWCWGLNXM6q4Y5GAYAkBIbub2LtZ+YyyzN6j
	 kvoIVzz+4ui0dU/hHrinqM6YuK0LcKX/IkvA1Znk8LjJmZ82DGqxCa491ah9pMytvFwOL
	 L0AA7XuL/I7DNTKr5iPrYP+QCmKx/1jffR9oioa1cHXjh3LABrg0xqMXCy2jBOf4vV9k3
	 z5d3PiMjkFf0qlx7EOhkp/CuJ1CziI5oq7L2dY+2uCH9Anv5J4lA/3A1A5BQNEvi7DdYi
	 PhngcqCHiex+PSeMUZnFPBF7q0uMZ21qSX3U8KZb+FYCiH4j/27SF7EEtgNUCAwQZIw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=none header.from=laveeshbansal.com;
	spf=pass smtp.mailfrom=laveeshbansal.com;
	dkim=pass header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Hvb7Q2qp;
	arc=pass header.oldest-pass=0 smtp.remote-ip=165.173.180.15
Received: from sender6-op-o15.zoho.com (sender6-op-o15.zoho.com [165.173.180.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A8D606A31C
	for <linux-crypto@vger.kernel.org>; Fri, 27 Nov 2026 01:54:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00A8D606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=laveeshbansal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=laveeshbansal.com header.i=@laveeshbansal.com header.a=rsa-sha256 header.s=zoho header.b=Hvb7Q2qp
ARC-Seal: i=1; a=rsa-sha256; t=1795744435; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=fzWNecYvtGZBHljnYBmyC9yNdIP27i9lyCBr5c1dGMAbFNmqkP984LPpS/sJFeGawdu4Fn735nQd/tUlMwzrY0q53xWBDA4FbzAvn1Dsi6k6cjtRQre7JWJCLMzLVUZuEDnLgqs91gqKpFL714O2D1O7O1gmpgN3bmnltfBXHdU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1795744435; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=vHdgcHXdABLVLLZ/6jXjR8p/kmya3OMTM86heYCTE4g=; 
	b=O36pt0VcNa9IoZYkJcVoHV9AVtlBhM9BDvvZ90Ccp5fkJS5WDWfKJpDW1DocGhK946DuOZzN14hpHAU/TYLCIoJdC/DSINGO7CK9xpgRePvICG+WchtgcPA+a9Fv8+lgLiy67j+ZZyxwNz62m0K7acVVALEa1KY9aW9WfWgLik0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=laveeshbansal.com;
	spf=pass  smtp.mailfrom=laveeshb@laveeshbansal.com;
	dmarc=pass header.from=<laveeshb@laveeshbansal.com>
DKIM-Signature: a=rsa-sha256; b=Hvb7Q2qpXD3Cznpk3mh/5XwULWUPyBC9Y0C+wsfHeIuaulez5UecZ8zv33UYgBVg70w7BmQYycNs2S5l2Yeg3y4HoSGTyX3tuMX4S/dPMQSV9n9bj1lH947hTSJZEgw5KMd8x16TOnsRstFXdcWn9R7QnZS1NMwm8DHWo/iJewo=; c=relaxed/relaxed; s=zoho; d=laveeshbansal.com; v=1; bh=vHdgcHXdABLVLLZ/6jXjR8p/kmya3OMTM86heYCTE4g=; h=Content-Description:Content-ID:Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:List-Subscribe:List-Post:List-Owner:List-Id:List-Archive:List-Help:List-Unsubscribe:MIME-Version:Message-ID:Resent-Sender:Resent-Cc:Resent-Date:Resent-To:Reply-To:Resent-Message-ID:Resent-From:Sender:Subject:To:Date:From:Message-Id:Reply-To:Subject:To:Cc;
Received: by smtp.zohomail.com with SMTPS id 1795744431749754.912559375918;
	Thu, 26 Nov 2026 17:53:51 -0800 (PST)
From: Laveesh Bansal <laveeshb@laveeshbansal.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: adiantum - Eliminate slab memory allocation in setkey
Date: Thu, 26 Nov 2026 17:53:45 -0800
Message-ID: <20261127015345.33904-1-laveeshb@laveeshbansal.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261125013553.94480-1-ebiggers@kernel.org>
References: <20261125013553.94480-1-ebiggers@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

I tested this on x86_64, arm64 and s390x (big-endian, emulated in QEMU) --
all on top of mainline c44104f3642d.

On Tue, Nov 24, 2026 at 05:35:53PM -0800, Eric Biggers wrote:
> +	memmove(tctx->nh_key,
> +		&tctx->derived_keys[BLOCKCIPHER_KEY_SIZE +
> +				    2 * POLY1305_BLOCK_SIZE],
> +		NH_KEY_BYTES);

I checked that this gives the same ciphertext as before. On each machine
I compared it with and without the patch using 400 seeded random keys,
tweaks and plaintexts for each of adiantum(xchacha12,aes) and
adiantum(xchacha20,aes), including re-keying one tfm against a fresh one.
The digests were identical with and without the patch, and the same on
all three machines. I saw no round trip or re-key mismatches.

> +	SYNC_SKCIPHER_REQUEST_ON_STACK(
> +		req, (struct crypto_sync_skcipher *)tctx->streamcipher);

I measured the stack cost. With -fstack-usage, the frame of
adiantum_setkey() grows from 64 to 640 bytes on arm64 (gcc 13.3.0; 96 to
896 with KASAN) and from 72 to 872 bytes on x86_64 with KASAN (gcc
15.2.0), under the 2048 byte frame warning limit.

I also ran the stack tracer on arm64 (KASAN, 32 KiB stacks,
with v3 of my blk-crypto patch also applied:
https://lore.kernel.org/all/20261125081417.77674-1-laveeshb@laveeshbansal.com/)
under the f2fs/adiantum workload with memory pressure.
The deepest stack at any adiantum, chacha or blk-crypto function was
7784 bytes, going through adiantum_setkey() via inode eviction in
reclaim. That was one run and I did not run the tracer on x86_64.

I think this is an acceptable trade. The old kzalloc() could enter direct
reclaim from setkey, and an allocation in the same fallback I/O path (the
bio encryption) used about 4 KiB of stack in reclaim in the same
workload. The new frame adds 576 to 800 bytes, mostly the on-stack
request (a fixed 384 bytes plus header).

A couple of other results:

- The lockdep cycle from the blk-crypto report is gone with this patch.
  In my f2fs/adiantum workload under memory pressure the base kernel hit
  it in all 3 runs on arm64, and lockdep recorded the &profile->lock to
  fs_reclaim dependency. With only this patch I got none and lockdep no
  longer recorded that dependency. I also got none with
  CRYPTO_SELFTESTS_FULL.
  On x86_64 the base hit the cycle in all runs - 6 across 2 hosts.
  With only this patch I got none,
  and also none with v3 of my patch on top. I saw no hung task or
  KASAN reports in any of the runs with the patch.

- CRYPTO_SELFTESTS: I did not get any failures, with and without
  CRYPTO_SELFTESTS_FULL. The WARN_ON in
  adiantum_init_tfm() did not fire in any of my runs.

Tested-by: Laveesh Bansal <laveeshb@laveeshbansal.com>

Thanks
Laveesh
