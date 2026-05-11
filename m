Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749982032D;
	Mon, 11 May 2026 00:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778458777; cv=none; b=NpIoDxzPicymo9OUK2m0i1j4vOujhBSJThxneG5hCySJpMSfF+wzHZh0i87j2UXVcx4fvF1Uv/g0xn4fCJI1Myynh7+LfZ1Ap+JI+MznIipbuyvLZrkDJqscKim/9riRlEouwrTdHuQCwwYze/OHxCwkCysrR2AehfVr53DOORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778458777; c=relaxed/simple;
	bh=FFfWSJIN0M+XWQkxkgqga0wg4IDSRJ3nMfsMlZRCX7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HciQ/W+A3QEoSOFUlgyEi2/dUT4MZUfrgorWbE+vIRdxs/6XsBvwHaYiLGjWuBaav3cLGpDRziAJNdlNdZhdtmgu42HPxUYnQFXhi0ZnsEcx3oWdY854tDpNurt+VgtAsGqPUuO0e5t20oQD5AoVH4A7Ruw7SDrYZxH5za7pcx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ck+FJQPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ck+FJQPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6751C2BCB8;
	Mon, 11 May 2026 00:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778458777;
	bh=FFfWSJIN0M+XWQkxkgqga0wg4IDSRJ3nMfsMlZRCX7Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ck+FJQPq+e7LVoFAOxQkWeNApMWQ4GyR8ZIxl/CH9iC9aF6qCB5jQ/t2JGgYJ/+BJ
	 IYoFzImONvAeWuM3T/vOmaGUXPkEVmpi2DKGac13+BG6y4h3PtNI4u0an7palTJD7+
	 LJI696C142WbaCaokHzC1Fkp5RLHKVZa8jKD+iN2TSb9FpWMXCiYjbWF2C8C95kYDz
	 d8CxtJISJ+ziDqwPhg6NgzvTaCSHhiYMvF7dC6HDCSOWbT0Xb4Mjoex6Zz723BkT3F
	 GaM1G9z/jf8AU8HwWEMHTDSrbCMiDYet0sBVTqhsd2lawrvjtVY3sRpNq45PKgEoZ4
	 JOeCLpUlEOU4w==
Date: Sun, 10 May 2026 17:19:35 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alexandre Knecht <knecht.alexandre@gmail.com>
Cc: herbert@gondor.apana.org.au, "David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: Re: [PATCH] crypto: ctr - Convert from skcipher to lskcipher
Message-ID: <20260511001935.GC60510@quark>
References: <20260510230901.1772949-1-knecht.alexandre@gmail.com>
 <20260510233237.GA60510@quark>
 <20260510234452.GB60510@quark>
 <CAHAB8Wy1APeCcm7_OfrNYeZFcMXfZ5rUSeDX7-c7WO_rGg2Zig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHAB8Wy1APeCcm7_OfrNYeZFcMXfZ5rUSeDX7-c7WO_rGg2Zig@mail.gmail.com>

On Mon, May 11, 2026 at 02:02:22AM +0200, Alexandre Knecht wrote:
> Le lun. 11 mai 2026 à 01:44, Eric Biggers <ebiggers@kernel.org> a écrit :
> > Also note that lskcipher doesn't provide access to the accelerated AES
> > mode implementations.  Indeed, almost nothing is supported by lskcipher.
> > The fact that you found something to be missing isn't surprising.
> >
> > I think "lskcipher" is kind of a dead end, to be honest.  It's not clear
> > why it got added.  The path forwards is to get the AES encryption modes
> > added to lib/crypto/ and to just use that instead.
> >
> > - Eric
> 
> Hi Eric,
> 
> Thanks for the review — you're asking the right questions.
> 
> I'm developing a VXLAN/EVPN-based CNI for Kubernetes (releasing in the
> coming months), and the goal is to implement datapath encryption for
> overlay traffic in a zero-trust datacenter model. The encryption
> happens in BPF programs attached via TC on the VXLAN device (encrypt
> inner frames on egress, decrypt on ingress).
> 
> The algorithm I actually need is AES-GCM (authenticated encryption of
> VXLAN inner frames, with the outer headers as AAD). When I looked at
> bpf_crypto, I found that:
> 
> 1. Only lskcipher ("skcipher" type) was implemented
> 2. ecb(aes) was the only usable algorithm
> 3. AEAD support was designed for (authsize field exists in
>  bpf_crypto_params, setauthsize in bpf_crypto_type) but never
>  implemented
> 4. ctr(aes) wasn't available as lskcipher either
> 
> I looked at Herbert's history converting ECB and CBC to lskcipher and
> assumed that was the path forward for CTR. But you're right, the
> real goal is AEAD, not CTR. CTR alone doesn't give me integrity.
> 
> Your point about lib/crypto/ is interesting. If there's a path to
> expose AES-GCM (or the building blocks) as direct library calls that
> BPF programs in TC/XDP could use (avoiding the template/instance
> machinery and getting hardware acceleration) that would be ideal for
> this use case.
> 
> What would that look like? Is there existing lib/crypto/ work for
> AES-GCM that could be wired up to BPF, or would that need to be
> built?

Sure, it makes sense that AES-GCM is what you actually need.  There's
actually a lot of demand for AES-GCM in lib/crypto/, and I've been
working on it.

There's already an existing AES-GCM lib/crypto/ API (see
include/crypto/gcm.h), and I optimized it a bit in 7.0 and 7.1.  For
example, it now uses the architecture-optimized single-block AES code.

You might be able to go ahead and use that right now.

However, it currently supports only one-shot computation, and it doesn't
yet take advantage of the fully optimized AES-GCM assembly code that
interleaves the AES and GHASH computations.  I'm planning to address
both of those limitations soon.

Anyway, that seems like the clear way forward.  The lskcipher thing
seems like a dead end to me.

- Eric
