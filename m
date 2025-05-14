Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2125D27A450;
	Wed, 14 May 2025 16:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747240180; cv=none; b=Fc1kBezC6lYPp3wjnYsP7buyI4Kg67glfq4f1NBlFeP79TTdzL4m11/S/4QnAHFeMXDQ+KoZWa1XXNdHXXY85GSPzPPla2Ut2F5hqCsPeK7O800HNSMVt3D4+nk6UoiFNJdsLRVZYzPNGMrmzI69nh/cOiWtVVH5i7FQmVkqCZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747240180; c=relaxed/simple;
	bh=viHRzIvyfWm6Z/Hx1NafsPkUVC0n611P4vJNmAOjXhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gq7eqDQ0Rv7SqVi+vX+SNvk58s3ANGSCbS3Ng0PvHMuxmXT9l1fkC6VLb3Fe1dIYQsiqOHaKRWFlMM3N7EN4AyCswK3Mt6A+sWPJ76OrkaSQNG8M4MYY3Me+b3DdKGOy5mpAfY16tmgcGQve0A9HsO6AN0v9Rq2PbTA/eTe6yI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n0Hz+2qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n0Hz+2qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49AF8C4CEE3;
	Wed, 14 May 2025 16:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747240179;
	bh=viHRzIvyfWm6Z/Hx1NafsPkUVC0n611P4vJNmAOjXhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n0Hz+2qT7JlqFqIdhMkIf/FZS59SAcmunTrJe24zF6ImEDjtBid7Z/R0NnZeRevEW
	 sWoZWTF/BcIW7FEQ2SSNphEXHZtyXGaG3PaDdoJ0l2eXCDzV4VCFRtInmygmiHRwVi
	 Em/RO7XV4MgUVDWY6ARSyc8/W8oRlDbv9m9KE2pR9qRemS3EYuHdYd5T7K7ANLNVnh
	 6at9sOk9/6tKuT7Y77aFXMIYD7cPigRCng6UwhNYTG7xeoATlHWsHD24iFDbsTf38M
	 D3Da2oZS+i9uUho2wzhmIENiG23x1GphFdldsM5DtzQqOK927IugNtM7tiY4QIgUZb
	 b1iEoflih8IjA==
Date: Wed, 14 May 2025 09:29:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org, dtsen@linux.ibm.com,
	segher@kernel.crashing.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Message-ID: <20250514162933.GB1236@sol>
References: <20250514051847.193996-1-ebiggers@kernel.org>
 <aCRlU0J7QoSJs5sy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aCRlU0J7QoSJs5sy@gondor.apana.org.au>

On Wed, May 14, 2025 at 05:41:39PM +0800, Herbert Xu wrote:
> Eric Biggers <ebiggers@kernel.org> wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > As discussed in the thread containing
> > https://lore.kernel.org/linux-crypto/20250510053308.GB505731@sol/, the
> > Power10-optimized Poly1305 code is currently not safe to call in softirq
> > context.  Disable it for now.  It can be re-enabled once it is fixed.
> > 
> > Fixes: ba8f8624fde2 ("crypto: poly1305-p10 - Glue code for optmized Poly1305 implementation for ppc64le")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> > arch/powerpc/lib/crypto/Kconfig | 1 +
> > 1 file changed, 1 insertion(+)
> 
> I thought this fix should be enough, no?
> 
> https://patchwork.kernel.org/project/linux-crypto/patch/aB8Yy0JGvoErc0ns@gondor.apana.org.au/

I didn't notice that.  Probably, though I don't have time to review this subtle
Poly1305 code.  Especially with all the weird unions in the code.  Would be
great if the PowerPC folks would take a look.

- Eric
