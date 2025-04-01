Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C531E5B7E;
	Tue,  1 Apr 2025 11:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743507189; cv=none; b=qSd0o/TRSNYnRl6dEEJuFCo6WB9VDxXokYc+yabibT6SzlXI5SnDyAmQO2xGa4SnPcdnDdDEgm8lphXe8B8NBmr+yohYtqGODAvLGmDXsSNXOA7U4WC3wQDQ5fJRMGYKOsLdILcHpK5xVAsQVVINcuG8P/4vPk0a86B76v+8f+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743507189; c=relaxed/simple;
	bh=VmGB/yCo429SCYhXKaOZrX7BJEqbBZPxqRBuHdexR4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9lCcSHo7380Ck4ZSQj5M3I/hYVFRX7JcX4mEg4FJ9BhZH0LUnbMys0SV2G4Nlzg6xXCHKujwPscVAPxxlq8+r04Q13aXGo0embxvhJR7zj2iRFUwd+hJauk43PTzlb/2vArtRY0NAW5C97aBovEjkD8E7qzAGKy2ClgmuzMq6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KOIVz3ac; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KOIVz3ac"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ocC/++/TCVxv+z4UQmnd6M5+42avEPB26fr5qefyCao=; b=KOIVz3acS0X2GsivC9sMp9GpTS
	Xkst9kotroVjkA3VgrriGMu+v1OWy85TDF0Ues/zDBKUx+VzjPwoULBIUje3z0mVRrhQbpSSXNh+R
	tvNjpDuXnqWae5Wx3X4DTCDCnK2Breo0HgYXUj/TmG7djZwTaDiEndCyDhvNd4taihTNcV8DXDNAx
	3rPssB1lS+qYCnqigdMTqes3CscD2HCl5B3MuN3lEv0giP920gnJ7VRbmjaOEqBJpkV6s7mBXqMaj
	1HLcW49x9mDMJd2neLxAxpNzzUoT5mU8Db9VW+ubCMOIY3hpvOHHLT3w+EWvgjce8rxefy1THI/wX
	1TTZ6+RA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzZrM-00Bomz-3A;
	Tue, 01 Apr 2025 19:32:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 19:32:48 +0800
Date: Tue, 1 Apr 2025 19:32:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Christian Marangi (Ansuel)" <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z-vO4ImhytEpGEEy@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
 <20250114123935.18346-4-ansuelsmth@gmail.com>
 <Z-u67D7xl2_SR-hg@gondor.apana.org.au>
 <CA+_ehUzZruhT7Bko2Xm2kyOaZxUPA4vNLQhq_5V30gfjgmfcng@mail.gmail.com>
 <Z-vGkbmX2PQ_gt7Z@gondor.apana.org.au>
 <CA+_ehUxCD1+CUJ_6rXa8ra=tZ1Nr1LCZVYQ0X9RhDndJ33F=ug@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+_ehUxCD1+CUJ_6rXa8ra=tZ1Nr1LCZVYQ0X9RhDndJ33F=ug@mail.gmail.com>

On Tue, Apr 01, 2025 at 01:20:44PM +0200, Christian Marangi (Ansuel) wrote:
>
> Sorry but isn't it enough to acquire lock before eip93_put_descriptor to
> prevent 2 thread?

It would be, but where is the lock? In the other places where the
same function is used you take the ring write lock.  But not here
in the hash function.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
