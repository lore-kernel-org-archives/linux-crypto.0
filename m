Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD9522ACD3;
	Tue, 18 Feb 2025 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739865758; cv=none; b=Dq1ckzUxIsRjQ9z2R1JyQGd8yQRB5LOqKRCahO+/4f1WExS9idviGeG5bDwQWf+aSYOs1+dpA222LBuwYOmmKj59OfabLDZTpGdxD1dfINZ9B1h0xt/RgA8DWFRNdaHOuQec96nbs8oYxbAYbxuM3Ki6YbVkSo+G5UtShJRqUTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739865758; c=relaxed/simple;
	bh=hgBUpsnpr1ub7hlRJV0ehuWKWc9Dq4qTzLaxzwRbG/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VGHcfom8TqG7523cRu25PzpLJPHuUrnX9oBhzOhfEZxW7FtZtjKJDuTBJE416iylCw5Y53RPO1mSux86/IomN9LNlcgDxeo2CxW04IPKVulvteWAy0j9Vd3uHi8As2vlyVk50UTqJlCHfgkCIxOPVq5xB7w2o1H3IbaRA883H54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=iCfF8/cM; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="iCfF8/cM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WMUQZRQIhgP1DqRoKFKVytGvZcO014vRgMYtE+1LX14=; b=iCfF8/cMHupM+auCxOveCoQwin
	+bUN0CgMRVLMFVoLXpQD+rL32YVolkozFLuEEBf9NTFkw7It9d8HIhYwoQ8zAn5/QMv2Sx7i3hXsg
	do5CtLg7SGdoQdUfBYlxsse8HhOOXfZQ134pYZ9Rz0MebOD7PjRBHvz7gGPoHScPX4BjOfo4on+/6
	jxaoEQaQFxarurr56rzMThVq7nfz+T1cVd0jOIVzH9NCNoZ/99zd6u0skT5A1Vmjwn9y7jlhKWTD9
	XRP1akQc6OgYsb/aY5ml3pmflQyDLVIzq2OWXPyFERhfm0h4JUBRX8KDXVVnvzzJjcpUoBbVCjbLr
	trfhZnTw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tkILs-001BI4-2J;
	Tue, 18 Feb 2025 16:02:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Feb 2025 16:02:29 +0800
Date: Tue, 18 Feb 2025 16:02:29 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
	fsverity@lists.linux.dev, linux-crypto@vger.kernel.org,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Sami Tolvanen <samitolvanen@google.com>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	David Howells <dhowells@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v8 0/7] Optimize dm-verity and fsverity using multibuffer
 hashing
Message-ID: <Z7Q-lRwkCbXFpgXS@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <20250215090412.46937c11@kernel.org>
 <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
 <20250217094032.3cbe64c7@kernel.org>
 <Z7QBuIvr4Asiezgc@gondor.apana.org.au>
 <CAMj1kXFe2f0cCYznorrO-wJyh-qxJP5z-HdR9rbQiuMKC5u6qw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFe2f0cCYznorrO-wJyh-qxJP5z-HdR9rbQiuMKC5u6qw@mail.gmail.com>

On Tue, Feb 18, 2025 at 08:41:57AM +0100, Ard Biesheuvel wrote:
>
> And for IPsec, I'd assume that the cryptd fallback is only needed when
> TX and RX are competing for the same CPU.

Which can happen if the system is handling encrypted data in both
directions.  Sometimes you do want to have the hardware steer a
given flow to the same CPU in both directions.

> So for modern systems, I don't think the SIMD helper does anything
> useful, and we should just remove it, especially if we can relax the
> softirq/preemption rules for kernel SIMD on x86 like I did for arm64.

Sure, if we can ensure that SIMD is always useable even in softirq
context then we should definitely remove the simd wrapper.  But until
that happens, suddenly switching from AESNI to the generic C
implementation because a system is loaded is not good.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
