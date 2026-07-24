Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012FB2F9D89;
	Fri, 24 Jul 2026 16:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784910763; cv=none; b=Rdzi2XtqElUpIfWHG+sSshPXhC/g0YWwVLUhr4JpzSz/uggB3K3/diQWL0l2XXtLnGcacVUFMtRFJZliveDXiZkNYzDpMfweAQrD9uW28rHVaNKoLJNhp+DbL5wg7VBSqGsXZs7W4Uta0AOj070ajfyszlg+WiNkyGfa4kAoPZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784910763; c=relaxed/simple;
	bh=QAB56mMGhrf2Qos/ibU71GGhxUIwqG3ueBE4dX+y5rU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a1YVDMSJ3PG2UfW2VAe1YvAhy0i/fFNRs6XM1CcTtW3U4grwnybzlb/dwCSWqYqGlKk452rtP2of3+hbXar90zdASCiUYZhK5GDQJHvLv0lrBWlPHnkHem69pKD+mm9OD7s3jLgbIfPNPw4pbMyCCz0d0LpsQ8BLvi9bATkk99Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=ABEIOwWY; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="ABEIOwWY"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id C3B8414C2DE;
	Fri, 24 Jul 2026 18:32:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1784910757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pr75B2nE8KRHDz6YmRazBOYCHUF9tlzdiBw3I3n2jrU=;
	b=ABEIOwWYkL2AzPOxD4b7sRNgirZ5pXF9gTSiyHWXkmvY/J/7C//g4zD7bI++t5B3Q5EtXq
	XOpKNZFILaFUbRASm1kXiL+8cYyyY9Prm0VpdDYX7+y9iJmjxnJdVeIk33nG25HMUb58e5
	1j3Mscbem3ZaLpq6Me5fYS+EhHTDtR/nv5XfEfiy253ihDP9TK4iSTsIhncTV3FATiXS5j
	BCcNut0eYj/2BJSOj+XU/wUr2TrRj2CeNCYZrTG+RV2QwPoCZ3b0W0lBA0JXOZpakvi/Gc
	p2j/yZzyQl0Zk9L1r785REtxC87F2QM8blCcsIc2q6vDQF8nXP8nSfbJ3I6uLA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 9829caf7;
	Fri, 24 Jul 2026 16:32:27 +0000 (UTC)
Date: Sat, 25 Jul 2026 01:32:12 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: demiobenour@gmail.com, Harald Freudenberger <freude@linux.ibm.com>,
	acme@kernel.org, adrian.hunter@intel.com,
	alexander.shishkin@linux.intel.com, ardb@kernel.org,
	axboe@kernel.dk, corbet@lwn.net, davem@davemloft.net,
	edumazet@google.com, herbert@gondor.apana.org.au, horms@kernel.org,
	io-uring@vger.kernel.org, irogers@google.com,
	james.clark@linaro.org, jolsa@kernel.org, kuba@kernel.org,
	kuniyu@google.com, linux-crypto@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, mark.rutland@arm.com,
	mingo@redhat.com, namhyung@kernel.org, netdev@vger.kernel.org,
	pabeni@redhat.com, peterz@infradead.org, skhan@linuxfoundation.org,
	willemb@google.com, linux-s390@vger.kernel.org
Subject: Re: [PATCH 2/3] AF_ALG: Drop support for off-CPU cryptography
Message-ID: <amOTjPW__CNZui3_@codewreck.org>
References: <20260523-af-alg-harden-v1-2-c76755c3a5c5@gmail.com>
 <20260603133312.12848-1-freude@linux.ibm.com>
 <amOGWwdjnJqyxH5L@codewreck.org>
 <20260724160034.GB2032@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260724160034.GB2032@sol>

Eric Biggers wrote on Fri, Jul 24, 2026 at 09:00:34AM -0700:
> On Sat, Jul 25, 2026 at 12:35:55AM +0900, Dominique Martinet wrote:
> > The tool source is available here:
> > https://github.com/nxp-imx/crypto_af_alg
> > (which now fails with:
> > bind(3, {sa_family=AF_ALG, salg_type="skcipher", salg_feat=0, salg_mask=0, salg_name="tk(cbc(aes))"}, 88) = -1 ENOENT (No such file or directory)
> > )
> > 
> > 
> > I don't particularily care for the API used as long as we can keep using
> > the hardware key, but as far as I can see there's no alternative API --
> > what's the path forward?
> 
> There's no "tk(cbc(aes))" algorithm in the upstream kernel.  So, it's
> not possible that this ever worked with upstream.  Given that, there's
> no regression in upstream for this program, and it wouldn't be
> appropriate to consider a sysctl knob in upstream at this time.

Bleh, you are correct, it's an NXP patch in
drivers/crypto/caam/caamalg.c that they've been carrying in their
tree(s) since 2018[1] and has apparently never been upstreamed...
[1] https://github.com/nxp-imx/linux-imx/commit/6868c9e49c1854028fb46022daac3b1b10ca2c70

Sorry for not having checked, I was hoping for better.
(I should be used to it by now...)


Regardless of the specific algorithm, most recent SoCs flaunt some
"secure element" or similiar hardware-backed keys (so one wouldn't be
able to decrypt $whatever without running on the specific board it was
intended for); I'm sure _some_ of them are upstream?
(Never used it so not sure if they are reachable from af_alg, but for
example drivers/crypto/ccree/cc_cipher.c talks about hardware key...)

There's not much I can do about the vendor's kernel I'm stuck with, but
that doesn't make having encryption material not accessible to userspace
useless as a concept;
forgetting about the sysctl for now, what are the alternatives API this
kind of implementations could be based on?

I guess I should start looking at how tpm backed encryption works,
some other day, it's getting late here...


Thank you,
-- 
Dominique Martinet | Asmadeus
