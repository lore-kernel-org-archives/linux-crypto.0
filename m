Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0460FC8CE;
	Sun, 16 Feb 2025 03:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739676575; cv=none; b=EwoPRlOz7I8RX9KASMK+3wQAWGHbZgKKRUbtREnUPt6jlHoJcMQ/oPwuQsJ1Y291dRpXWJi5Zhy4gmH3MzkJuJSxoxOmO6AO4nzyRkMq6oUaMFeQz+KAX23CQgesEJYEf0Dn+YlrDcEnwbZMcLrA9J0i4Kxf6bp8RbGx2yA12Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739676575; c=relaxed/simple;
	bh=iUhWftYdo9T8UrzE6GeB1DWNOpDcX5qptKrCMHfnN7Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UWLtFhibBiDTGEGK7c3PjVOTdUPTxAUFq8UEdoJRoism6rZtXezSceqQhqnnqV2R5KSZMzOUStEDa4/Z8JLiw7X6CxS1mWXh+qJCjQ2ALHP8rGDJJKL39FwzmrdkoC+Wg+Qm6ulDR43Z++QsRHXvZ1f/zM8rq+vzHQ3tard/N0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=jYOUT/DN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="jYOUT/DN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=rc0BQgcYMwktFIfCc+amXmngzIQoye0cjtheqjw53zQ=; b=jYOUT/DNQz6ndVzPKDPcgy6BGS
	Sbrt/uk1tV1ZGFwl6P5x2Q0ZbtQ8hF6wdBbCCJVtZytfAdZhcm66YhQttvb2L0D6RFTl2ABbNRTKr
	PyewzxHJ2VUArIHg2dlw8DGS3maCYle5MQ5xZjzTLmB0eVGLkUE6WIAYlt2sCgAnS7zExJ7rxRQyz
	U8F6Ug5NkRI6vnr2vuCgI9vZERbyczYpL5ho2vbI74+Zg0pD3ctbwn7lnZwjZfrdnEZSG0e+RmSKe
	rSkCpeXURirWd+jIhugHpG0ydOLYDBkIsu9aTMFz5H3a9BHzmDR+NJMdg66akqLtLTXry4svUdCZx
	tgk088Yw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjV8X-000gj6-2y;
	Sun, 16 Feb 2025 11:29:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 11:29:26 +0800
Date: Sun, 16 Feb 2025 11:29:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, fsverity@lists.linux.dev,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	x86@kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <Z7FblsbOQnJ7sYOA@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <20250215090412.46937c11@kernel.org>
 <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
 <20250216032616.GA90952@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250216032616.GA90952@quark.localdomain>

On Sat, Feb 15, 2025 at 07:26:16PM -0800, Eric Biggers wrote:
>
> Well, the async fallback (using cryptd) occurs only when a kernel-mode FPU
> section in process context is interrupted by a hardirq and at the end of it a
> softirq also tries to use kernel-mode FPU.  It's generally a rare case but also
> a terrible implementation that is really bad for performance; this should never

It may not be rare if the kernel is busy doing bidirectional
TX/RX with crypto.  The process context will be the TX-side
encrypting while the softirq context will do RX-side decryption.

> have been implemented this way.  I am planning to fix it so that softirqs on x86

Sure but it's way better than falling back to the C implementation
on the RX-side.

> will always be able to use the FPU, like they can on some of the other arches
> like arm64 and riscv.

That's great news.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
