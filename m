Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793905715;
	b=RL8eHcFPt2z6qQRZxCy5iE9CEzcNRPAsUfA9glkDUS6wTpLGEewyxJIQTZktBFi3Gziu
	 UpGbQA2eWFcbqkdqYJGtZckxXcEbJz+eR0I3/4okBrjfwzZb77n3U10fXzN5EZPYIxnFa
	 4Mm4OW9kWvvb92unQgNI2aGtDxzYoxYJeewQyv+GRPVKNN0/cHHdTfZ/ssTlP/HEdXlaz
	 QHj11/bGBLBRP+BXJl+jOxzhOXUius0WMl82uBuNwUF81r1aQ/X/ACabR/j5B6Ecz1THN
	 uEf76UjpC7Lwb2eOq83xibaLFB77tnNO23/j5/ASEnzcle0cq/OaKPTLTqCuEHxMgIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793905715;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=NKZYMA78ETBI2kINMoR4Qis2NmMD3cqLskp965i3YqE=;
	b=xi0aju9to7q0h+Yz/bfpVtQcXNPf6dhPd0rmUfvgM/z2W5lTuYYzNfXG68ll53j7wcBm
	 uFQhevNNNbml84uN7bWx2/B0nAKp8iJaTpCyB0RWIl/lPBUO2LOMTWxN3kID3axDOYgrB
	 wYtO17NvvUuN0dWzrtay79dKHoXOWlMvhJJpT+LgyTdAvRjkq87Xx/Kax8e6aoSkMIi5F
	 dJbcQBU/RhlzFVBybGXD4WN8yPPU8FlHhWTNXV8OLAI84fiGIwnBEKp/W0K4Q/3vRhb+g
	 cxZertT/mkcx3gZQRBwpEH3mV3/ZtYJdjQFWu7eAOKW4jYO2J29fUQPDgD5taCUFauA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IEtDbxQl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0D2B606A328
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 19:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IEtDbxQl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9042C1F00919;
	Thu,  5 Nov 2026 19:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793905714;
	bh=NKZYMA78ETBI2kINMoR4Qis2NmMD3cqLskp965i3YqE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IEtDbxQl8uxWn1lDBU70UVouRfgY76A1xMyT8DyhrTNT380ozp5dP/gsxac+9fFFR
	 oDK7OugT8mSUx7MMq4Aql3gzbQeTtZRq9VEJJ8yNaqqGF6JWuWi2I87Prd8QMUa+2k
	 JtRL01XwZLyNfbRvyLH5ImeZEUz0fNWKaCHy2ye6UH6JDdWkDIEV8UyKswQZP0sWeN
	 Rm5ADtJA0IdV+osc/crXR1B+DAOL+c5N3wcQ9P1PhoJjmfc+OxL0Y6E+zvhmeeXztu
	 90/6sL3arPgOyFkYPKqS7HtBJTJvx+/RoxZ7x/zWhhnH5BlRUCRrIUMVNjdjAJHfyp
	 RWN/QYPnEgpzg==
Date: Thu, 5 Nov 2026 19:08:33 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Antonio Quartulli <antonio@mandelbit.com>
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH] lib/crypto: x86/chacha: Eliminate more never-taken
 branches
Message-ID: <20261105190833.GA3266627@google.com>
References: <20261104225526.68557-1-ebiggers@kernel.org>
 <3349b575-5f1d-4b81-be15-5f92565904e7@mandelbit.com>
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
In-Reply-To: <3349b575-5f1d-4b81-be15-5f92565904e7@mandelbit.com>

On Thu, Nov 05, 2026 at 04:31:41PM +0100, Antonio Quartulli wrote:
>   path                 CPU setup              KUnit  perf
>   -------------------  ---------------------  -----  ------------
>   AVX-512, zmm         native                 pass   -1.0..-0.1%
[...]
> There is a little loss in the zmm case. I presume we can live with that, but
> was worth mentioning.

Probably just noise, or maybe instruction alignment which is best
tweaked separately if needed rather than relying on chance.

Note that removing these branches will help mostly if the caches
(instruction cache and branch predictor) are cold, which the benchmark
doesn't measure.  We maybe should start trying to measure the cold cache
case in the lib/crypto/ benchmarks, as it is meaningful too.

- Eric
