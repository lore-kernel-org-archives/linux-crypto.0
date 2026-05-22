Received: from devnull.danielhodges.dev (vps-2f6e086e.vps.ovh.us [135.148.138.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0076C18B0A;
	Fri, 22 May 2026 11:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=135.148.138.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779447605; cv=none; b=KKY5kVRfC5IlESpEmyn5bggaP+weW8cCuS2I6HY8gfA6kLsDkJrOXtr43T/HNwdFIS+tdr8/Qi8rwzRitZ9aVaslUcsefZWZz0wzhgjYbpMEvkiKdEqiEA0oUU+8usI0cQJamuNdAYontyOcjc7MIFI/4dq02YWO2eyW+CYBdTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779447605; c=relaxed/simple;
	bh=La4ldckeJ1DEkTYBEqbb8ZnKY0L5q2JI0gPRNMToICc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=klud6EJCDgXvBYkxyCYOp091A0c7UNcuIv1DdxdvVCp0EtjS6zKVHjEKIrU9j+RKKKMwQk1qQGYUaIi9a6ni9APjNa4YR2/DEM/pwoa2x7tGsftkFf95B340yfX4qTT7ON9QoF61av/bo2d3LIYPQU2Lau+rghlMPAYIDFhqN6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev; spf=pass smtp.mailfrom=danielhodges.dev; dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=nTCNub3q; dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b=xmSQM/FS; arc=none smtp.client-ip=135.148.138.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielhodges.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="nTCNub3q";
	dkim=permerror (0-bit key) header.d=danielhodges.dev header.i=@danielhodges.dev header.b="xmSQM/FS"
DKIM-Signature: v=1; a=rsa-sha256; s=202510r; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1779447438; bh=mnoTLsgIKH+ds8HEwODUsUa
	009Zv/bcrsjFzbvmtvqY=; b=nTCNub3qdX54BdLioh7xz31yGeRXK2taqcvjvit+rdUe51zr+/
	Mn4T2CIDBagu7nMXgqew8rgEZooAXYPjGFjEHqj6InDk3wIvLzLd4huv5lSr/F3AhVotP3Jin6x
	4IUOFeutJjbHXdGIoBp3g6rQdapNEkRW5xp1l9KMfUJ0CbcZccfo6a6l7u9ZpE8eMo5f9GlaehH
	uGXGf4dG9l9lmGA3IugOCwJPAQDTK2sANtNJbtA5mRCb/GT9Y7b6HP/0Gv/do+r/TrG7UD6tP6V
	DE0lTodRttIQAf1FrG0ooBGMNUylbyAld37z8qt2a6pyk/Ax77/vCnc8k++OIS+P0Ug==;
DKIM-Signature: v=1; a=ed25519-sha256; s=202510e; d=danielhodges.dev; c=relaxed/relaxed;
	h=Message-ID:Subject:To:From:Date; t=1779447438; bh=mnoTLsgIKH+ds8HEwODUsUa
	009Zv/bcrsjFzbvmtvqY=; b=xmSQM/FSpmhUZAdvpxO/ahWkMzZ4hkx+cxqjJb/yR/T5tgocCE
	sjrHlWzONcfbIGAsyQ9gA8gEo5aPtEody1Ag==;
Date: Fri, 22 May 2026 06:57:17 -0400
From: Daniel Hodges <daniel@danielhodges.dev>
To: Felix Maurer <fmaurer@redhat.com>
Cc: Daniel Hodges <git@danielhodges.dev>, bpf@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	ast@kernel.org, andrii@kernel.org, daniel@iogearbox.net, 
	vadim.fedorenko@linux.dev, song@kernel.org, yatsenko@meta.com, martin.lau@linux.dev, 
	eddyz87@gmail.com, haoluo@google.com, jolsa@kernel.org, john.fastabend@gmail.com, 
	kpsingh@kernel.org, sdf@fomichev.me, yonghong.song@linux.dev, 
	herbert@gondor.apana.org.au, davem@davemloft.net
Subject: Re: [PATCH bpf-next v8 0/4] Add cryptographic hash and signature
 verification kfuncs to BPF
Message-ID: <fm43bx7min3olvz4ok46emxvyvbczw4weq5dkwitzwmq6h4jzg@a56b3irxynks>
References: <20260225202935.31986-1-git@danielhodges.dev>
 <ag8zGP5azt743BWc@thinkpad>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag8zGP5azt743BWc@thinkpad>

On Thu, May 21, 2026 at 06:30:16PM +0200, Felix Maurer wrote:
> Hi Daniel,
> 
> I found your series because I was about to implement something similar
> like your hashing implementation. In other words, I'd be very happy to
> see this patchset move forward.
> 
> Taking an initial look at your hashing patches, I'm wondering: the usual
> interface to hash/digest algorithms is to have three functions: an
> init() function to set up state

Doesn't bpf_crypto_ctx_create already provide the initialization? I was
trying to make that pattern work by adding the bpf_crypto_type_id to
make the code a little more maintainable.

> an update() function that can be called  multiple times to hash new
> bytes, and a finalize() function that creates the actual hash.
> Depending on the algorithm, some of them (esp.  finalize) may be
> no-ops. Often, a fourth function, like hash(), is provided

I think the bpf_crypto_encrypt should cover that along with the
bpf_crypto_hash in the first patch.

> I think we should provide the same init/update/finalize interface in bpf
> as well to make the API more flexible. That would require splitting out
> the shash_desc from the (mostly static) context. But doing so would also
> address the review comment from bpf-ci bot to patch 1. WDYT?

I was trying to make things work with the existing bpf_crypto_ctx
lifecycle. IIRC in the V1/V2 of the series there was a separate struct
but it was suggested to integrate the changes into bpf_crypto_ctx.
Regarding the bpf-ci bot I think it's somewhat valid, but you could
solve that by putting the bpf_crypto_ctx in a per CPU map or protecting
it with a bpf spinlock. I didn't hear back from the crypto folks so I
sort of left things as is. If you want to give it a go feel free. It
would also be helpful to hear about what your use case is. Thanks for
taking a look!

-Daniel
