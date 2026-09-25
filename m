Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB40845DF48;
	Fri, 25 Sep 2026 20:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790367050; cv=none; b=Or6eTyLCFwtbWWeUW7ke/PE3iYpoy6lFWKwqJhQN99+KR6FgBNTmAlc8d9ZuY8b/2WJhY5u5EQh7pnz/8zdcMiOn9KoMsAiycS/ZrrWQwHJxnP2kguOimSKOo44LA1mVEj9YRmI4PB3LOd4/IQjXSqpnD3X2xfs4QFV/4he0Qjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790367050; c=relaxed/simple;
	bh=/ZuscZjlb9eka3bRPFtZojdDYDdEg8xLH93b91zt4iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6yWC1Y3unauTKSTPvXcxNBOrAaSl2hKkKTZhKcTwSMQ5jfFIBImSVtLha/80XzxGCn2NRi5pkFIqA/nCov10yzVMB8FQpwTW9S/G0ruUoi3qmglLyfIemss3ofahrlEkeoeWVVXcaZNvbyvzGak1+V14up97lE0ric34c5YYfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PkebtEYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PkebtEYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D81541F000FF;
	Fri, 25 Sep 2026 20:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790367036;
	bh=Rq8PSAwTn/63swLZKI0+ZBOdi+NQRFEFxALpzDHtZqc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PkebtEYE3zf9/r/cMu/JKe+rIsbekM4Ji7ZiJMc/w10Zhjo/SbnvKoAFCoM33NUoK
	 U1BxIVFtewP6u/tmQ4Temm2RF7GumqMjWVc0p+FKFr54A+lyLjBRPE67+vCfGc7bcp
	 CACNy2MAcHGCbbzrjh/Orc5PWFHe4SAKxDd5iw7zKvnXvUlzcpOJic9AZoCYGzSVb2
	 LOx+f6P8aDlmhbrA4uChvh1D0J8V/3ogOauRzPZiNxZ4w6JPiW2GqxNjhN08yuTDdv
	 X9AqqGr9lnp7NwtummdW9SvIHtVDTBg83EVqOyTVYW5+kjC191ZwBCn4MJkP0bxdec
	 Kfm+EA5ai4kog==
Date: Fri, 25 Sep 2026 13:10:34 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: libcrypto: Add additional testing
 information
Message-ID: <20260925201034.GC5511@quark>
References: <20260925052502.188024-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925052502.188024-1-ebiggers@kernel.org>

On Thu, Sep 24, 2026 at 10:25:02PM -0700, Eric Biggers wrote:
> Link to the KUnit documentation, mention the existence of the benchmarks
> and how to enable them, explicitly mention that the tests can be run on
> real hardware, and mention that it's often possible to clear CPU
> features via the kernel command line.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to be taken through libcrypto-next
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
