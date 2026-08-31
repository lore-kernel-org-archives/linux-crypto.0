Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8FA3ACEED;
	Mon, 31 Aug 2026 21:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788212905; cv=none; b=CaGmsgBaAYAj7EAqWMg8/e341cydRfUanGjWGkh7Y2wHZcNO4dfoHEXILrxQtFfPcHPpeOCTn4qpwHXUdvbGtOg/oDh7RMgik1ULCpp7XVrnOntIZO8LhQgPzuZHJGseLoQ3Y94nuTGe/A9f5hOTGhnYlRogn/g4hMLMxuoqLGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788212905; c=relaxed/simple;
	bh=IWZR763NtbOE1NQu0QvmQqMNmj4DlP5ujyZ7TJOlJjQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uPXsMRxmtdmvV/88Imm5DFqhngEuAr2vY69MnXwm6RE8T0j9LnErYQsbCUV1JUr+xs+5AScUa/oJkuv5tQhKfX0m1+bINcyOc9e57PXyOUt+1kMpmd+ZfiFLVbJMRMg+5U9J50yYW8JiNXmLFXv8XfIxpmoHLgNiCt2kfe5D6Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lCzX3lHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lCzX3lHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37F811F000E9;
	Mon, 31 Aug 2026 21:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788212900;
	bh=IGfw8HEg+7N3fS4p/fLFHLEX0PCBrDokzuki8PYqq/0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lCzX3lHd5ECof2q73Woal4vSJiqCLJQ5imd8nVHN6C4PAmjNQ7tbERcRPC8pajN/S
	 ZNhfOyUubZjkaRfjrDnScJzjWRChWOarntZgdRtSEjorUIJWTZHEWY3XPJTn7UFaXb
	 FuQsbOpC780MAVApF1S5vrrp26epDsKFEQVCXp11ddD6/QmSAHVwpsLX10rn2gTs4w
	 wZKWzHRqNGn/tAgcigFMQrro3QN0nykhDy/j/0MQVGOB2t1T/hBc/dH8I2aJHTTuAp
	 knyUC0T96tNuN6alpzOX8R0ttlpxpKhOvuS3RNfxXFmHMPH2VOJPnx6VFYCVz9r+t5
	 valQ0n03cUBsw==
Date: Mon, 31 Aug 2026 14:48:18 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: bpf@vger.kernel.org, Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	Jiri Olsa <jolsa@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Ihor Solodrai <ihor.solodrai@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next] bpf: crypto: Use AES-CBC and AES-ECB libraries
Message-ID: <20260831214818.GF86114@quark>
References: <20260831192139.94895-1-ebiggers@kernel.org>
 <apXwXLRpBUIWQuC5@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apXwXLRpBUIWQuC5@gmail.com>

On Mon, Aug 31, 2026 at 11:25:54PM +0200, Karl Mehltretter wrote:
> On Mon, Aug 31, 2026 at 12:21:39PM +0100, Eric Biggers wrote:
> > There are library APIs for both of these now, which are much easier to
> > use and more efficient.  Reimplement BPF crypto on top of them, greatly
> > simplifying the code.  As part of this, the bpf_crypto_type abstraction
> > layer is removed, as it's not useful.
> > 
> 
> This relates to my recent patch fixing state preservation in lskcipher's
> unaligned path, which exercised ARC4 through BPF:
> 
> https://lore.kernel.org/r/20260829194314.42685-1-kmehltretter@gmail.com
> 
> While looking at your patch, I tested the actual BPF-visible algorithm
> surface. The ECB and CBC templates allow considerably more than AES.

Right, apparently any "crypto_cipher" can be composed with "ecb" or
"cbc" as an "lskcipher".  I think in this case it's only of theoretical
interest and is a bug, not a feature, though.  Especially given the
presence of ARC4, DES, TEA, etc. on that list.

We see this a lot with the "Crypto API", where a new kernel feature
actually uses one or two algorithms, then unnecessarily allows every
single algorithm to be theoretically reachable (including insecure,
obsolete, or nonsense options) just because the API takes a string.

- Eric
