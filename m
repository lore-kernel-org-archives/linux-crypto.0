Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1594278F5D;
	Tue, 10 Dec 2024 13:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733837298; cv=none; b=P13pn87dhXfhtmyCLThEulQWOgZZKajVl05SJIldnxVgXTb12dmM0PM0EVu5eBTKgOdR/2OX+niMTLdBUXhHZXT4C9D6+VS7hSRUOZAwEXJsY43+sDcfj7uDM2d6klLy+U8mRh/TqzADavTnrbmrRDtDv0mD+bjkMOyHN2FzLig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733837298; c=relaxed/simple;
	bh=ccNvQpqjr+JUyfSrXZAo24D/1j0K9F9qxyXslbViEUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PBzx4cje2ZdoPi3cbHsH6tolxe40YHtTDXx5EAbWSYJExtLucBmsB4V8xgRe6SG7dMaEp56giBTe2vSDIBb8zZCtr7AQ0k87jKEt12rMvQVZoMpGjddqB9Ro1i7pPHsCVLUJRInOkbX3HTVFb6psPY2iFALAl9+jaEWwLFiBXuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gqg5lyC4; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gqg5lyC4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=J4SZIWtWFvdEBBxd7ahrqofkskwaW/nYB7tGpgucLH0=; b=gqg5lyC46/+OCgH1rgdFL1T8DF
	PveoXZ+zpRnN8xUoEDGHbmb1TIqhUS4jyeSsmdvJZP+5dSp988XW2FpPOmXUR2IV1DECQuUFZ5Lcx
	fpup43NxrOmKbnPf7l/22nAl+WTkAS6AEIJ/2sOpPY2aBH7HuMlecrXogFbhUdkinRM6FWb+hThcf
	jwJ6zVD/rWN+kf1fSkgV/TlGkShpCBibAdf9MZUnlyBZi46uMx0zzL7mJRODcYazyKxDKzesWlbPW
	0bRoeKGz8ojqo0N215dkUAehNDWtk2bZEqO2pJ3wZ9CpjoJipN/AdggfmKrfSrWHkUAQXQfuWHWco
	tR+Ulh7w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tL04O-000U78-2l;
	Tue, 10 Dec 2024 21:27:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 10 Dec 2024 21:27:53 +0800
Date: Tue, 10 Dec 2024 21:27:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
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
Subject: Re: [PATCH v7 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z1hB2WftNhyGt9oj@gondor.apana.org.au>
References: <20241112015920.22564-1-ansuelsmth@gmail.com>
 <20241112015920.22564-4-ansuelsmth@gmail.com>
 <Z1e0LHycNGcWqd2q@gondor.apana.org.au>
 <67582c1b.050a0220.83ef5.c8df@mx.google.com>
 <Z1guyCJy-Cpo7U11@gondor.apana.org.au>
 <6758312f.df0a0220.100594.1c3a@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6758312f.df0a0220.100594.1c3a@mx.google.com>

On Tue, Dec 10, 2024 at 01:16:42PM +0100, Christian Marangi wrote:
>
> Oh! Ok, that is neat. Just to make sure everything is clear,
> to complete the request it's the same used for final, the
> ahash_request_complete(). I tought the -EINPROGRESS,
> ahash_request_complete() pattern was only for final.

Correct, the same calling convention applies whether you're doing
update or finup/final.  One difference is that after final/finup
you don't have to export the hash state because it's no longer
defined.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
