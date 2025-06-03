Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B7E49659;
	Tue,  3 Jun 2025 04:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748926791; cv=none; b=S7TpeikIjwnR7TwfSXEwiIaLgi30KMxpShT2fxW8dRAOvArhK8coNmZ9pRfGdVR3YBsX6jtAQiRh+ROtXrWrDaAcCRI/fgb6whFAwAkw74evnD5lDw5N0YXfqYifz6dXRnvx0EdJdLCvnAjAVQi9xTVDPr/FHsjOGWx/oQQgAuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748926791; c=relaxed/simple;
	bh=RoBxX+C8GRgMV/a/jijShaa3R7L6MkF5ArllDSPY9hw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amabPg2ZXTjFXuIlp61uyElvbC+ndrKxLycorxj9urDQ6tUOPPI618HDQuq+5MBQUPwI+4+OS0ofLgFgRxh5genmgf2NZ3kSScltDVNZjSvGM3JNE0fY/z3rJuaezK44c8P+Ad2CIsoqIISYJoUkeP3yIXWbSKC6mOUrAmm6HMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=DdBNVT1+; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="DdBNVT1+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZX86cZL0UlaGsEpsGGqXeUV01qQyj+mDcUeEiAmPdiQ=; b=DdBNVT1+T/H3XlqToJh8VBf94y
	LQIV6UZN/Yk/gPmBYjtZNN+cQD2XmOTTi/lj1VIdJhA7yy6XHb9t5/tYgVcG5HIqD+HDP6x2JoV9t
	BozYgtvUJCifNQzYjPwETFxnhJLzAwsY1lEtAQDIFVogovf+50vTIfWSC+Vw3hDFT/VoaZwfgjIqP
	m4PiIZRanFy9Sk74KqTE3wEdJmMi8T5iTciOIIKXeJHHz2k0etp5RlYzlZH4iezapxvdBpM6qqVsg
	HCWEyekBZ1VwcomSyxrS+klcLnvs/QussZ46Ocp1D9Apqp0kFbobJi0HMtyQalSODGHUZIcOiNwhn
	jiZMj7vw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uMJkM-00AU1i-2Q;
	Tue, 03 Jun 2025 12:59:35 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 03 Jun 2025 12:59:34 +0800
Date: Tue, 3 Jun 2025 12:59:34 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [v2 PATCH 1/9] crypto: lib/sha256 - Add helpers for block-based
 shash (RT build failure)
Message-ID: <aD6BNjkGBKljbfmH@gondor.apana.org.au>
References: <cover.1746162259.git.herbert@gondor.apana.org.au>
 <c9e5c4beaad9c5876dc0f4ab15e16f020b992d9d.1746162259.git.herbert@gondor.apana.org.au>
 <85984439-5659-4515-a2bb-09cdad69a3e3@roeck-us.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85984439-5659-4515-a2bb-09cdad69a3e3@roeck-us.net>

On Mon, Jun 02, 2025 at 09:56:27PM -0700, Guenter Roeck wrote:
> 
> This patch triggers the following build error. It is seen when
> trying to build loongson3_defconfig + CONFIG_PREEMPT_RT.

This should be fixed by

https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=b9802b54d41bbe98f673e08bc148b0c563fdc02e

I'll send Linus a pull request.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
