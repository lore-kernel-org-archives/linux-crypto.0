Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965DCBA4A;
	Sun, 16 Feb 2025 02:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739672839; cv=none; b=ArGFudeb28s90KSa2ao3MfF3ySlR13TZhGSgr9MvPdzjq1QvquZx1FzIu/13OfXqOBnaLtMBcaeY/6Nv1GdxONheUZU7V8dODqBg8qKcHyxj8j1+SMyoU8UytOPuPGvOwzBs2u29USd6jy4GiECdxe4BC09KRH+8CU3ZT1RFdQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739672839; c=relaxed/simple;
	bh=y594kqnFYnmSKQC1AE3fsEF7zTOcAohwMW7qDULL64o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l3ra9z/28mcvdFlkhgm+qTaAgqvZD9itN7D1um2F+bfduzDK35wzokF/doAK40My+ZcHTFFbWF1eJS+gDQJ20vxzKw8HLDCAfnaiygY9Sg0dF/MbL3Ot5Gua4o7bfSkunTpPe2Gi4gXaPpfTsOyhmRBNSZ+BtlH/14mPc56WgS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=GakgaZxU; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="GakgaZxU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=g2yG0zZeHrh41/HUvAcj64EieaWG1lDiLMI8ggvgcIQ=; b=GakgaZxUxo5UvoGCj6Z78b2nFR
	1ABLhDgqZLFZgRqbS0rm4ZExs1mSizKDwWXCTA3fzCQcZk3YZfu/U/T/YSE3lpWk23UTZquJie9Rr
	y9GW7PI+UrBYGz2ALDO+oDT5U9S53yGWlwaqk1AuOUKPSX8x1Ce1DIGpJdYhzkmYVsVYLZxZ4JgeH
	w7ryL7q86eqjgRawoHEnXijCTJjUIgFfefHus8xH0iEn8/lT28iuEzpdze0ET13c52a1OpSV5C+i+
	ntv7NPzqZvCzSaANwx9c1rHGc+4JDUdhrwn/YWzPb1d5E9bLgjPKVnqTszqbq7oU8enRZ9zhAgek6
	N+3nXd5g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tjUA9-000gJl-1j;
	Sun, 16 Feb 2025 10:27:03 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 16 Feb 2025 10:27:02 +0800
Date: Sun, 16 Feb 2025 10:27:02 +0800
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
Message-ID: <Z7FM9rhEA7n476EJ@gondor.apana.org.au>
References: <20250212154718.44255-1-ebiggers@kernel.org>
 <Z61yZjslWKmDGE_t@gondor.apana.org.au>
 <20250213063304.GA11664@sol.localdomain>
 <20250215090412.46937c11@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250215090412.46937c11@kernel.org>

On Sat, Feb 15, 2025 at 09:04:12AM -0800, Jakub Kicinski wrote:
>
> Can confirm, FWIW. I don't know as much about IPsec, but for TLS
> lightweight SW-only crypto would be ideal.

Please note that while CPU-only crypto is the best for networking,
it actually operates in asynchronous mode on x86.  This is because
RX occurs in softirq context, which may not be able to use SIMD on
x86.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
