Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85AE25949A;
	Sat,  4 Jan 2025 01:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735953572; cv=none; b=KCGSS0Gl31bvN/h+H4RaSfk+mBoL9Gw31j09SM+TTVX/I1OJ6nJAFCTOo1F8XalimH+YGKS2iPqlxkrpvI+CLPJipDLgAVXOisDDi6tJ2kIHyb00rhrjzfQddLm555Yp1Vd8FvNJe0fWKxcFlDM2w87BhufhYQQiEzo+MOhvwmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735953572; c=relaxed/simple;
	bh=I3DMfFDW0XsQSlFb2ojkARQS+GMS4RM8CknmDauYXSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=qaxbMXBaGfWOVddsfMMqiM5NveSvBB2Ng8W8cyGUNnhH2VveCsP8UECYMTm6V8yq6NEdA/uHmhVd1gjciRYwi+y1yKfgH4j74utrxH/Yuow28ZfCloFtcRg1demQq2bamoe/UrpsBUtS1N2y75QgLvzvDu+57zIjAzibkVclc/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ylmzhepo; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ylmzhepo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8QJpAKXwffJivBWZVaPrD2eBSneGMSf0LeKXvk46mAg=; b=YlmzhepoCxCkvz+FvqWBOkQ09h
	XsAjPJGx2iF5vTyp6znuzQ1euaHjbyOc/MAEXUb2zkLYYSl1Y1oFhn5dHp9O6POSTM6KpepBOa0Jz
	fUOJVnk/ene7u7aVesmBpRxdN0B4dNG2qVvQ/ahNi5u2M+eVoWsGBlI1rt06tIPUw3y6zV8WMcK1o
	iEiG0ikl4TYuyKf8Ob3MpQyGvJufFlTlDZtzLtpLF/Et/rRi6KchwWhLzzfCYLojM+CBSHTmBT4Y/
	jWQmczDh2PDvVahpRClgaJnPSxbUD0pLXXk/KDDcLAuDr0zmIf85f0YnZePyieuUgsu/gMLLyyEMT
	nEelV2Ng==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tTsc8-005fbR-0Q;
	Sat, 04 Jan 2025 09:19:25 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 04 Jan 2025 09:19:24 +0800
Date: Sat, 4 Jan 2025 09:19:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	smueller@chronox.de
Subject: Re: [PATCH] crypto: keywrap - remove unused keywrap algorithm
Message-ID: <Z3iMnNbcb0WXBGlz@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241227220802.92550-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The keywrap (kw) algorithm has no in-tree user.  It has never had an
> in-tree user, and the patch that added it provided no justification for
> its inclusion.  Even use of it via AF_ALG is impossible, as it uses a
> weird calling convention where part of the ciphertext is returned via
> the IV buffer, which is not returned to userspace in AF_ALG.
> 
> It's also unclear whether any new code in the kernel that does key
> wrapping would actually use this algorithm.  It is controversial in the
> cryptographic community due to having no clearly stated security goal,
> no security proof, poor performance, and only a 64-bit auth tag.  Later
> work (https://eprint.iacr.org/2006/221) suggested that the goal is
> deterministic authenticated encryption.  But there are now more modern
> algorithms for this, and this is not the same as key wrapping, for which
> a regular AEAD such as AES-GCM usually can be (and is) used instead.
> 
> Therefore, remove this unused code.
> 
> There were several special cases for this algorithm in the self-tests,
> due to its weird calling convention.  Remove those too.
> 
> Cc: Stephan Mueller <smueller@chronox.de>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> arch/m68k/configs/amiga_defconfig          |   1 -
> arch/m68k/configs/apollo_defconfig         |   1 -
> arch/m68k/configs/atari_defconfig          |   1 -
> arch/m68k/configs/bvme6000_defconfig       |   1 -
> arch/m68k/configs/hp300_defconfig          |   1 -
> arch/m68k/configs/mac_defconfig            |   1 -
> arch/m68k/configs/multi_defconfig          |   1 -
> arch/m68k/configs/mvme147_defconfig        |   1 -
> arch/m68k/configs/mvme16x_defconfig        |   1 -
> arch/m68k/configs/q40_defconfig            |   1 -
> arch/m68k/configs/sun3_defconfig           |   1 -
> arch/m68k/configs/sun3x_defconfig          |   1 -
> arch/mips/configs/decstation_64_defconfig  |   1 -
> arch/mips/configs/decstation_defconfig     |   1 -
> arch/mips/configs/decstation_r4k_defconfig |   1 -
> arch/s390/configs/debug_defconfig          |   1 -
> arch/s390/configs/defconfig                |   1 -
> crypto/Kconfig                             |   8 -
> crypto/Makefile                            |   1 -
> crypto/keywrap.c                           | 319 ---------------------
> crypto/testmgr.c                           |  20 +-
> crypto/testmgr.h                           |  39 ---
> 22 files changed, 1 insertion(+), 403 deletions(-)
> delete mode 100644 crypto/keywrap.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
