Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A96233F7;
	Fri, 13 Sep 2024 03:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726196422; cv=none; b=tWdB9AgereOm4HVbcjm47kEBOWWRNpGvFwdKM8wl0G6CQmX2Xtm13Nx9ruSr+s0y223qyHVFdy7lw07oQM4kyLFCPhPde1VWd27tRnCnyUeER3IZYSCVq5oarIZVygsSBIP2+A6ZfV7yCb3Rx536TKPPOpsLSh3YmjfB39oqRzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726196422; c=relaxed/simple;
	bh=wGcW0ryoWSmMnOrWfzgUVtd4wXwz/mJPng33ojPskp4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=uyJj4qgDW+bIWvDGQ3m59drexGnpD3Md2GxiFboa+rlmNufzNPaJpl7KJvQPo3x2YWSncXbN5sYKDvKWvWM63BkGqTCAu6F20Its8oATdVg5Q1O+ENdiyxzMFDGr8pyLRcDRz4zBzaWxdWe1XCN277jwMB1nzhwiG5427JqEX2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=XI8MblzZ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="XI8MblzZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1726196415;
	bh=VhEvHeaOii1sg1WCaj1iaRY0Bf+Yt5n42VZMErYucL0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XI8MblzZWDcLAgT7rI1fbJ9/KgWBSBAfmngFygl/fEKIMKL8TsRZdq4K7rhTAYh2I
	 QNOMH2i+uemDMWG35kp/IgIo9D9FxLtx/IU3iM3Z3QTiA05RbYwc9VVBuVAt3q7yu0
	 SlzY4hbBMns41/2Pq5pJvmSU3kl949tK4pceWfOJVslCAYzU/ilf78Dn09DTJ8XfA7
	 hspqMQuxEd3c4UvqSdZyP1YBaJ0l0Ar8jidyZfJMCHWduZCzJkIIjl7EBaCUXfKX2R
	 kvb1vnLiW9hhU6uxUsbKovn1NoUyzaqrfe/ynS2UAvH98DA1o++dXT6iWSLn4okxBY
	 20S9pWjQJ/A3A==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4X4fDv2Brgz4x9D;
	Fri, 13 Sep 2024 13:00:15 +1000 (AEST)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Danny Tsen <dtsen@linux.ibm.com>, linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, leitao@debian.org, nayna@linux.ibm.com,
 appro@cryptogams.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, ltcgcw@linux.vnet.ibm.com,
 dtsen@us.ibm.com, Danny Tsen <dtsen@linux.ibm.com>
Subject: Re: [PATCH 1/1] crypto: Fix data mismatch over ipsec tunnel
 encrypted/decrypted with ppc64le AES/GCM module.
In-Reply-To: <20240912174537.1409567-1-dtsen@linux.ibm.com>
References: <20240912174537.1409567-1-dtsen@linux.ibm.com>
Date: Fri, 13 Sep 2024 13:00:13 +1000
Message-ID: <87seu4qmv6.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Danny Tsen <dtsen@linux.ibm.com> writes:
> This patch is to fix an issue when simd is not usable that data mismatch
> may occur over ipsec tunnel. The fix is to register algs as SIMD modules
> so that the algorithm is excecuted when SIMD instructions is usable.
>
> A new module rfc4106(gcm(aes)) is also added. Re-write AES/GCM assembly
> codes with smaller footprints and small performance gain.
>
> This patch has been tested with the kernel crypto module tcrypt.ko and
> has passed the selftest.  The patch is also tested with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled.
>
> Signed-off-by: Danny Tsen <dtsen@linux.ibm.com>
> ---
>  arch/powerpc/crypto/Kconfig            |    1 +
>  arch/powerpc/crypto/aes-gcm-p10-glue.c |  141 +-
>  arch/powerpc/crypto/aes-gcm-p10.S      | 2421 +++++++++++-------------
>  3 files changed, 1187 insertions(+), 1376 deletions(-)

As this is a bug fix it should have a Fixes: tag, and probably a stable
Cc as well.

But that diffstat is really large for a bug fix. Is there no way to fix
the issue in a smaller patch? Even if that is just disabling the feature
until it can be fixed in subsequent commits?

cheers
