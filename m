Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EEE91E49F;
	Tue, 17 Jun 2025 04:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750136249; cv=none; b=kGCJH3m0IVR6VW4rpqFJu57Gxh0vgugZntnz9VUqouKRE8Y7YPmFmLwWWgys07W7eTVxnNBd4zKYxS4ebWK2Z8hPZZTghg0t0iJhWyZttrrGzO78SFKYcauKOJV7YAGD6XY3T4Bxpy/uHOqhBF9GKODqu+I98S5v3vaiPn1V8iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750136249; c=relaxed/simple;
	bh=q/Kg1esu+cPgiA6+vrjnz5edDszeYiU+GwkduGfZsCo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MpFo4XmIzZkyrYGLiFAmNpFKQCLZ0jQBv/YSOW1kG/JDynGVNwLsCjWADoeTtAR+won+HuxHW9bldRV4wnVgsbyiej+8s46442hgkIFPrekXPjIyZpskcbQcbqWtV6yy+tYYkTGkFFtbrJjRGdjAsscGTO8uMbudElv0X5vK3t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=N3YUIUtE; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="N3YUIUtE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=obGrpb+Tpt/ckRKGUcPmCd/zRt19JMaRenjkRk+pawg=; b=N3YUIUtE+4qPAnXDNKxp/Lcjea
	j3olYwLpvlijPT8rN3RniQXfKb1utGoUGWj4E8uORjMDlW9mCzQQhKx835IRbjelkxC622V7zkIYO
	Xl7zsCBBkClvk9HEnj8sMeKcLw6izMlMdcuCrqvw7pyzkOPdp9tyEJIqkjBoKzxqsW1GslT6bmloz
	HlBRBIJ6lZYxwjScC9nxiDu3jKm7grRQ+CMWQsWbs4AwugTokaW34GTVwE+LCs3sq8ijuXLYhLYRC
	7UGc6A/C6sHn+LYDLuMbKQGDOzcaj/8N9p3E2D1wrnSOLgqA/D7EdBKHX9hrrdf3xZ0+3H09plDjw
	Ykorhndw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uRO8T-000ZxS-1V;
	Tue, 17 Jun 2025 12:57:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Jun 2025 12:57:05 +0800
Date: Tue, 17 Jun 2025 12:57:05 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: ebiggers@kernel.org, linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - lower priority for skcipher and aead
 algorithms
Message-ID: <aFD1obs5rQaMLA4u@gondor.apana.org.au>
References: <20250613103309.22440-1-giovanni.cabiddu@intel.com>
 <aE-a-q_wQ5qNFcF_@gondor.apana.org.au>
 <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aFAyBgwCUN2NLXOE@gcabiddu-mobl.ger.corp.intel.com>

On Mon, Jun 16, 2025 at 04:02:30PM +0100, Giovanni Cabiddu wrote:
>
> This level of performance is observed in userspace, where it is possible
> to (1) batch requests to amortize MMIO overhead (e.g., multiple requests
> per write), (2) submit requests asynchronously, (3) use flat buffers
> instead of scatter-gather lists, and (4) rely on polling rather than
> interrupts.

So is batching a large number of 4K requests requests sufficient
to achieve the maximum throughput? Or does it require physically
contiguous memory much greater than 4K in size?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
