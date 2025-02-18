Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 172CF1714C0;
	Tue, 18 Feb 2025 03:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739850179; cv=none; b=PyZqbBuxUtjw2XAZMle0GWPl3fpewGkTKKrciAv1rjGfkP45sncEclHnO3SqzGSPXQ5PulMCLzepnO06/Fz11Qq5i6CZQi5/eZR2n7bPL4v+lc25+o0YC3VdqH409oYpgSy8O/Spd7g/hvGZERLwGNId7BTmW9AjEc8T4hQUDmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739850179; c=relaxed/simple;
	bh=oxnmzV0u7YLeSdOMcjT0XG/CoG1KcOL8BTBtJhEF4gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QieapwRs1szyLapSnfN0Tt9JcuiRQCNC2kcSa3BasVGINOD5/k/Pp2coWsR//6kNElfMv5JIOX0ZdMltwhnPUnpLQuwbKyXK39LbnB7R1ZtcFSQuTV/V7bJa6jN6VbfUcoPqP/nNLIBxlw1KoNxa099L0hv8lIHVym0R+WWVRqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=aFOI1FU6; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="aFOI1FU6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vyRhLFHRB6fmclm1Piz9ZAXQjUujdHyc/1CCpu4kda0=; b=aFOI1FU6shtJerIQ7DxiFI+Ewt
	neYE/ji6PhieKsTYzsfnrOIyHGle3ecc8D/lsYZjcRB3ZTlju51sq+UzE1cNTkIUNAWD9aJX0aHU6
	FkCq5fgTjmknPu6V+aWzQ4nimBemr84uYqb4SNiODjzJAQggytL4AXm5q6Ujdz5pGb3sJbrfhT5Pj
	QNBUo/kShIgx7+0rrhrOQxr8Ndt+m7t9dT9Ye7skKBgUpGiN9gH5qvrCyJolhV3Yr8WO694bOTNf2
	cdqRkjUXjZXH47/5bas+iIhxf0+HsIuyEIjs78jtZKjjPxHIQ2Dz7TYfZUmvATqV1uj7lY6kx8yoq
	2Z09xE0g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tkEIa-0018pK-04;
	Tue, 18 Feb 2025 11:42:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 18 Feb 2025 11:42:48 +0800
Date: Tue, 18 Feb 2025 11:42:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Eric Biggers <ebiggers@kernel.org>, fsverity@lists.linux.dev,
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
Message-ID: <Z7QBuIvr4Asiezgc@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <20250215090412.46937c11@kernel.org>
 <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
 <20250217094032.3cbe64c7@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250217094032.3cbe64c7@kernel.org>

On Mon, Feb 17, 2025 at 09:40:32AM -0800, Jakub Kicinski wrote:
>
> Yes, that's true for tunnels and for IPsec.
> TLS does crypto in sendmsg/recvmsg, process context.

OK that's good to know.  So whether SIMD is always allowed or
not won't impact TLS at least.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
