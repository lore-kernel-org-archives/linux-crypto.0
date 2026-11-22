Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795376522;
	b=FmVv3t+fhXtXxR4Is1KMG/d2r1H/NpxsvYeona/n3WhRWLJ18j9HHyWKSReIvRIoapV9
	 sjp0i1jCCcq6AE6d8xFBhMAspyWhtNtHSMOdfngTuZJtJtUnFPfIza+I6JtoyHcnOFEKk
	 q0a0XSTl7LN394tcHd2LUbi397HLFxH8czpBfh5Hv8w6V6x0fz/NPrhQi+3iUbiu5Q6nP
	 VomvraOT5OiAHYbuQt9FQ5tU/b0uh8jKducBsclakrpWNcHNGmTJSJCMknQAVE9cndYRF
	 iSPVFlzUfRUQjHmzHgTb4qlwHsmM1SQG+ZJieT3fekbn0o82XM7SZSnRKfu8Pfh4tbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795376522;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=BbPOsx5puKOE6m5zslrdQFiFGMgsU43/M8/IdHqCUX8=;
	b=o8A/C4BwG3UCRKa8On/u3/SnBNIRpnvh80T0xPqxzA+VwCTNPci6leKxn6eiqVIY84wO
	 Nuqn6AaN98M0cYcVk7JIJqKqtZr0cpO73Qtbfwv3/E44iDqvDiUlDOPXTU+ZN+qCb/qad
	 cFqcOZE6h2N6yuRh6mGqVu0921en2r2ppRbwSXR2GnjLSopIZY0jIBU98Uzw8UnSJNlXC
	 Ycfzp9uvK0hntqoFZFp4s9imr7Rn3YOGqMnvkd7x0ndceJz+e0O2eL9hetTJW1wVUReyI
	 glbtZWVH3N6SSJPtscJfnUPelEeAQ0Bkaurond1ode8cRljMnbPi/3B3f9R+dVfaTMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ip1ptZVs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCFD606A31A;
	Sun, 22 Nov 2026 19:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ip1ptZVs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25341F000CA;
	Sun, 22 Nov 2026 19:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795376522;
	bh=BbPOsx5puKOE6m5zslrdQFiFGMgsU43/M8/IdHqCUX8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ip1ptZVs0S7Rm+qxEHxzARp/LuU83aoWAgkdvkuJEOzIy6R9FOe2bBmLANODDY3sY
	 +/rI2SOp4JqqKXVQPL39VCtgIrSNBZYnVcQ70k9LSkD+DysAuHnyKxB62d5kCXBYq1
	 A7znzXTuTHmjCvi6DSYZxE/PBfCrt+ytT0lCG3ApwaldOTI0p57QB3mwNF+KVAl3DQ
	 XDOxwUIvqKV7tZuMATUuYhRef2TSo7OIQT6rOnKrTXnLVxw+eXjTzaimgIeCjB4vx4
	 8h1s4GqQkxmz9utz8EzwmOQQ+CCr4cIKuymPgVvNPHF9qvDt0RxHa1zmJDuhSdGQt9
	 +IFwPoAKhgu+g==
Date: Sun, 22 Nov 2026 11:42:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Shreesh Adiga <16567adigashreesh@gmail.com>
Cc: Ard Biesheuvel <ardb@kernel.org>, Sasha Levin <sashal@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>, linux-crypto@vger.kernel.org,
	llvm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/crc: Use uint64_t for the new NEON crc64 fold
 constants
Message-ID: <20261122194200.GA2122@sol>
References: <20261122152900.1113961-1-sashal@kernel.org>
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
In-Reply-To: <20261122152900.1113961-1-sashal@kernel.org>

On Sun, Nov 22, 2026 at 10:29:00AM -0500, Sasha Levin wrote:
> Commit ff049836f05f ("lib/crc: Don't include <linux/types.h> in NEON intrinsics
> code") in mainline switched the arrays passed to vld1q_u64() to uint64_t, since
> u64 and the uint64_t that vld1q_u64() takes are different types on arm64 once
> <linux/types.h> is gone. The two arrays added by commit ef4102757fdd ("lib/crc:
> Add 4-way folding in NEON crc64_nvme implementation") still use u64, so the
> combination fails to build with clang:
> 
>   lib/crc/crc64-neon.c:66:40: error: incompatible pointer types assigning
>   to 'const unsigned long *' from 'const u64 *' (aka 'const unsigned long
>   long *') [-Werror,-Wincompatible-pointer-types]
> 
> Use uint64_t for them too. This builds with and without ff049836f05f.
> 
> Fixes: ef4102757fdd ("lib/crc: Add 4-way folding in NEON crc64_nvme implementation")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
> 
> crc-next is based on v7.4-rc2 and ff049836f05f went into mainline after
> rc3, so linux-next will hit this once it merges the two. all-next hit
> it already.
> 
> Tested on arm64: lib/crc/crc64-neon.o builds with clang and gcc on
> crc-next, and with clang on crc-next merged with mainline 4843f6873f7c.
> Without this patch the merged tree fails as above.
> 
>  lib/crc/crc64-neon.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> index 03b46d0abcc41..f36389789fe65 100644
> --- a/lib/crc/crc64-neon.c
> +++ b/lib/crc/crc64-neon.c
> @@ -11,11 +11,11 @@
>  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
>  
>  /* x^575 mod G, x^511 mod G */
> -static const u64 fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
> -					   0x62242240ace5045aULL };
> +static const uint64_t fold_consts_4x_val[2] = { 0x0c32cdb31e18a84aULL,
> +						0x62242240ace5045aULL };
>  /* x^319 mod G, x^255 mod G */
> -static const u64 fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
> -					   0xe1e0bb9d45d7a44cULL };
> +static const uint64_t fold_consts_2x_val[2] = { 0xb0bc2e589204f500ULL,
> +						0xe1e0bb9d45d7a44cULL };
>  /* x^191 mod G, x^127 mod G */
>  static const u64 fold_consts_val[2] = { 0xeadc41fd2ba3d420ULL,
>  					0x21e9761e252621acULL };

Thanks Sasha.

I've dropped "lib/crc: Add 4-way folding in NEON crc64_nvme
implementation" from crc-next temporarily.

Shreesh, could you send a new patch that folds together that patch with
the two fixups for it?  Then we'd get one clean patch.

    lib/crc: Add 4-way folding in NEON crc64_nvme implementation
    lib/crc: arm: Support partial blocks in NEON crc64_nvme
    lib/crc: Use uint64_t for the new NEON crc64 fold constants

Thanks!

- Eric
