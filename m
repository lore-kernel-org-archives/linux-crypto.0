Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794088805;
	b=3+fTg5k0DJ2vffqEWVar17J/HjtQsvpS2FImAtnP/1pZcuHbtED2tVbVuHutxk7eyVVW
	 4CdRD6j3KIYaF65x9k6MrgkGTpW+Fm6am75a/tVH1NWm2skmW69v9AGczdKIMBga29X2t
	 MDr2GLy4J6z9aBhUK7T1May9mDKAf1eoVtJbwWxQxL2smRhYSKSTS4W5VUc7Ck6kOaMMa
	 iiBzaW6Y4hDCoEMGsvHIIxJdwql0SwHzEeXgEwFjHFRpCFMbVih19UgIihaOnKfg0sCuw
	 UmAZXLSnuG/IivBDYDhcPWN1MutHPz1tolZB9oOXBbhC64gDWkBr5QCRzdXqrYri6cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794088805;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=QOqoGTcqxD5MbCjH8leaLTd50ZisDuY99VoVcsncWpw=;
	b=e+c0pYpVPxIrX2MVGAvKMvYpDaHAYVdb05faEVYQJrSnvMAnJmh8Yi8xZRlUynoFa4dB
	 QyCNE5Fqr5Ep2QWQhIOmMdaQey6IecpDLHx4/aaNNO56+WCrko2sENTNFlsvs1QjHbyww
	 TTxxapqO0+mCe+DHrh2MHdKDXnAz0saR9Lz1AuJx1Y4PxFQnVupo5KSykp4jd7W65Twjo
	 flOeoLf4tkEpSr6mcr0CNx20dxzaf4YWiUhW+7VXUsQLKamFX6fItSEJcPqhsMRKrkSiP
	 kQKEld4piq2KEkhdff+IKIrxP9hyJwqWMgISLu/Vp15jqll0T5mTQaOikkS3RKjVu/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="I/Y+kqUx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34D0606A32E
	for <linux-crypto@vger.kernel.org>; Sat,  7 Nov 2026 22:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I/Y+kqUx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6581F0089F;
	Sat,  7 Nov 2026 22:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794088804;
	bh=QOqoGTcqxD5MbCjH8leaLTd50ZisDuY99VoVcsncWpw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=I/Y+kqUxSOafvMVRyrZ5C227RrmYaKZ8pIepQR3jp2mWtnNASrSLum9wiKVDw/+C6
	 2UIG9uGgOZBF+EH+EFItuvp9dvC7UoAvWLkILa6FGeCO+JeFB/RiF8udC9kg95mRvV
	 S1P5SP+CMCBPFsdNjMUtGYQcPkyO181mIQ0F6kmRUsoQzOPo6xZEx9PVvwgbDVWZQv
	 fgQqWhi0BHzwYxlxIkcTk53QcQL74gK+345a+P3uaQpo1PL06/kqalmYX+LgBMh3ZB
	 f96eBqCxyNlr9+N8xoyyZ2ardabJ/A5TDMhnxophd4s3UE0AbUzEBrGcS/2GrUE67b
	 t1dCP5RJdH8Vg==
Date: Sat, 7 Nov 2026 14:00:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: x86/nh: Optimize nh_sse2()
Message-ID: <20261107220002.GL137269@quark>
References: <20261105042427.307868-1-ebiggers@kernel.org>
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
In-Reply-To: <20261105042427.307868-1-ebiggers@kernel.org>

On Wed, Nov 04, 2026 at 08:24:27PM -0800, Eric Biggers wrote:
> Various microoptimizations for nh_sse2().  Nothing too exciting:
> 
> - Instead of adding the message words to the key words and then
>   permuting both, do the following: permute both when loading, add the
>   permuted words, and multiply together adjacent pairs.  This saves two
>   pshufd instructions per 16 bytes processed, and the ones that remain
>   are now better separated in the flow.
> 
> - Reassign register aliases to put the most frequently used variables in
>   %xmm0-%xmm7, which take fewer bytes to encode in many instructions.
> 
> - Replace the unnecessary T7 with T0.
> 
> - Replace the 'add $0x30, KEY' with base+displacement addressing, which
>   was already being used anyway in most cases.
> 
> nh_sse2() shrinks from 1038 bytes to 913 bytes, and a quick benchmark
> (with AVX2 support disabled) shows 3% faster Adiantum encryption.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/x86/nh-sse2.S | 60 +++++++++++++++++++++-------------------
>  1 file changed, 31 insertions(+), 29 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
