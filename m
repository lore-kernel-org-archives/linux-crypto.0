Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795092923;
	b=ZCQR4+3czZAwIrDBmJMjtuSiOoaKFayJSRRIjRlcj1bXlgvIDKMCio0Adhm0iQ07Qrr0
	 hgyulMDYJYK+1kfooUyAPX0VLY+vLBdcaP9h3uQEQqNVlS3Xp9UK2BAJYPUR1q5lBTxu2
	 /Pgc/G2KykaDjpdvybXsMIZ8CKC4m1YGfz1yZiMl9GlK9r19ABsr0GtnKtmrNp7m0YK7r
	 d4qn2Pwi7NIzNrsi9cTX4a3IR8zrlWxZL4MYR+T/H8oO+eAJYWab43f0JNrEAuREGg+Jh
	 nL6W3yiE2K4s34PfCk7kvAtBuM2czm8ivnVJo1flopcLymPDrY0fikZwuXQvYPtnn4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795092923;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=aKFaPlRmE0zV3W7s3uN+J8C1YBk/B7F14prRJXrqeXA=;
	b=HCRhV27pT4OuOAhhrY26He+s4jk8nZ3VtkbDR7g/VpZEZpqOl6cxhbuOEERgORCO5QxV
	 GOeUvA+8prTDfZXJQHdFY3q09+P6VG+adXdtGCDlocw1hCUktKth1fL1kfEtHmMhnVGVD
	 BKW4XmWi7hZChUg1j5k0OsmjS3TQIHg8kDwNdbZV1m0c8PrxBJLREDgTN9mADpRnCoEeg
	 rUvp/1Toy/AGjYNkoLx/zjMGTo7Vfk27yxrLW9PT6he7YexhSnCreu+ByaGzJRd3HpAzk
	 9aSk6bHpIhi5Q/HgV6apLN1gzx1mCzMZ1DJ4STzSlsgyGUHSk9GvKqxbdmkM1HoXVOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKtAOpEw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 03942606A320;
	Thu, 19 Nov 2026 12:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dKtAOpEw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1341D1F000C5;
	Thu, 19 Nov 2026 12:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795092922;
	bh=aKFaPlRmE0zV3W7s3uN+J8C1YBk/B7F14prRJXrqeXA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dKtAOpEwvvcK0EfPLb8LUddspY//kDE+HnZZY51eiOAXKtEOarwBPebmfqrmrwYwn
	 BPWy/1YycJAY03SaHVYbka9Z45d1vyUFepE2rLFzh21Ea4EDm2sfY0pCO+7igWavPU
	 9zD6QvpuLMCWvjiLzHHkRAo8k7xOQKeRFBUESuTkgjfrFZZvHMYOKdK9C3gti/ZBFx
	 3IdEhkcNJVfv+YGcG9hhML3HA3bi0ZpNWCOBCqdgFnG/saIXfX6aoKlQqugfeb1Tk1
	 /dvEe/720HJPfjU5WWv/X60JieyzoNJOGt8X5U6jGsmXHI+QsfjwpqGVt8a45gBwuI
	 rws2g/d64Ie/w==
Date: Thu, 19 Nov 2026 14:55:18 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: Guicai Ma <maguicai@kylinos.cn>
Cc: Florian Bauckholt <florian.bauckholt@cispa.de>,
	David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Hui Peng <benquike@gmail.com>,
	Stefan Berger <stefanb@linux.ibm.com>,
	Rodolfo Giometti <giometti@enneenne.com>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] KEYS: fix signature length passed to
 KEYCTL_PKEY_VERIFY
Message-ID: <av7xtr2Owxiuzp3O@kernel.org>
References: <20261119-keyctl-pkey-fixes-v2-1-9e2d1c7db7ec@cispa.de>
 <20261119075004.689388-1-maguicai@kylinos.cn>
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
In-Reply-To: <20261119075004.689388-1-maguicai@kylinos.cn>

On Thu, Nov 19, 2026 at 02:50:04AM -0500, Guicai Ma wrote:
> On Wed, Nov 18, 2026 at 11:19:28PM +0000, Florian Bauckholt wrote:
> > As a result keyctl_pkey_verify() ignores the signature length passed by
> > the caller and always reads max_sig_size bytes from the signature
> > pointer. A shorter signature is extended with whatever follows it in
> > the caller's memory, or the call fails with -EFAULT if that memory is
> > not readable.
> 
> Verified the union usage in struct kernel_pkey_params and reproduced both
> failure modes on arm64 with an RSA-2048 PKCS#8 key (enc=pkcs1 hash=sha256):
> 
> - A truncated 200-byte signature with the remaining 56 bytes still intact
>   in userspace memory was falsely accepted (0) before this patch, and is
>   now rejected with -EINVAL.
> - A 16-byte signature placed right before a PROT_NONE guard page (as well
>   as a 0-byte signature at the page boundary) returned -EFAULT before this
>   patch, and now returns -EINVAL without faulting.
> 
> Reviewed-by: Guicai Ma <maguicai@kylinos.cn>
> Tested-by: Guicai Ma <maguicai@kylinos.cn>

Thanks.

Br, Jarkko
