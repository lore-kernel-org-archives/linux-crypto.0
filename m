Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3463B2D8363;
	Fri, 18 Jul 2025 11:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752837344; cv=none; b=BszcSIAlMDMBxk2rpnxfW0lgNEIxCxLZRls9U8aaa8qQw+JQO1dsxJeIgZHM8reC9Ie5XwsqQg7faQz1nvfuUODeaj/gBhXQqFwm+uFSyNBpQMA8k17XlHcyyfcfWzbQyQRJcfxSQtlaWmqGVsBW17mUGSR+5omArYcJ4cdtym4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752837344; c=relaxed/simple;
	bh=L4NrF1xyhtYN1LlvrCUR/1PNtFOiU/Yqr0WRbfXHDKs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=OXb2PgDErU7rnDam1FBKcJMuP4HUDNbf1K8Ddn+gZeEk3KfFsJyfUuiHcvfqb6k06Ywo9OBnUbi9c/yre8Omc5Rwj5Vrq9sxSmVltXNXm/6Wprao0cLPPa9cbNhX5XjkRWsc1Bxf+pD09oz5Pn8OHjUAFtUgRes/B/Cxvd+vFMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PbephWPs; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PbephWPs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gR7DnbvdY99tuhMKUpQMsvh86F+Ko1XHIHz6GnJsjM4=; b=PbephWPs9x4cl3Aow6OjI/KmWk
	hoTAMnKu3gD+4VNeTcpa4lTvfW+Q+t4v3L9fsN27lYnJWz1E2Kzl9UHEWth9yXQnEDa3M2Ude++R2
	g+zKiksRUSDQ0OUzJXttPhIENawd2QihGOj48+uikwG6a00ZqF4FRs+weDF9GbPsWtlEExMhQpP+X
	kuFBcE4T8Y8lIW08/hYDtG2izpBV+Ij1aEBuoib2CUTZgx7+7TCQ0Cr8LEVhy0+J8sAKluaH0+jOc
	q3y6TXrXrs+f0EI74QrxWJU1M6QfSDxJc9nOcOSKkkpSPGmaqaqd9eBYH1ljmvuqCb1z/ff0TbARZ
	8TYOfPTQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ucioV-007ypC-1g;
	Fri, 18 Jul 2025 19:15:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Jul 2025 21:15:35 +1000
Date: Fri, 18 Jul 2025 21:15:35 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ruben Wauters <rubenru09@aol.com>
Cc: davem@davemloft.net, rubenru09@aol.com, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: jitter - replace ARRAY_SIZE definition with
 header include
Message-ID: <aHos16fgwhMRltMy@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250713131608.38859-1-rubenru09@aol.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

Ruben Wauters <rubenru09@aol.com> wrote:
> The ARRAY_SIZE macro is already defined in linux/array_size.h
> 
> This patch replaces the ARRAY_SIZE definition in jitterentropy.c with
> an include, to make the code cleaner, and help reduce the number of
> duplicate ARRAY_SIZE definitions in the codebase.
> 
> Signed-off-by: Ruben Wauters <rubenru09@aol.com>
> ---
> crypto/jitterentropy.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
