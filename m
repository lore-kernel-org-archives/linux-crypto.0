Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9415A33C502;
	Sat, 14 Mar 2026 05:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465386; cv=none; b=u0aoz3vngK3BeTvkKbhYIGJ7fQcLBdiAPY6I/Gy+GKYKsUpPPIxdBkYTLA3v31CLzG4dhRmG+ctIuD8eiUn1sgs1F8qlAGZ8nGt/uT9ook327iavF4RSNiRrQhvRyiOqPxa/Xd5G4BxTGNCyWKENzEm895P3KwaxLJ7TwfqLAu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465386; c=relaxed/simple;
	bh=wrPW9TNHxhpC1tBaxZcp6Al7mlvJAK+WSvhrriXbyUE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEFRD/KSpW/pesjY5Lw1ThKnMR47Af8DtYpzw8g6r2YCDsRxhabZQKxfc9qGJ1cJqL/vdPEf+tLRpFbf4CZYuLkcY2iBnQtp8FsQ8+jB8tL/tdn40AqJdvU+auJ8rblDmwtQKruUtesqIVCFPjzZssNRFcCKq6mYHu59Xenp+Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=nMY2+lNV; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="nMY2+lNV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8+8Qfz1GfNnypKtO2TrFMNiJS9vAmz9Qi030oGKVImk=; 
	b=nMY2+lNVRuLu2+6Wg4aCwzVkQMXSFamqOsQfvtLkAvvf2oJqUV9P0WiSTRc4MbOvAMgSwZvdLFW
	QIbiduzxCz/hyKHmCFvnYl69AsL71kheZ05T+OIicZHjpfvWzvdVh5R02jmAh8YwZhgTNtHGQv+65
	3SWkTkJQtKd/r81ZCLKSWGBQuzW/J0xyK22FoKgT4aPf78RwQIA5Rg++YAJq7m5VSWZK1ZobvKhoW
	cl8lRN2Ank1HPwuCSydq7X4fQTfUdQmVUyIhNRybEeXiJyraYV0apWz9Lux0sF6v5SEGnaKQKcevQ
	nsuIRMa7XD26MI3IXDlKJz4J3MFcujTEkQlg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HMH-00ELBI-0S;
	Sat, 14 Mar 2026 13:16:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:16:17 +0900
Date: Sat, 14 Mar 2026 14:16:17 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org,
	Kristen Accardi <kristen.c.accardi@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Remove bouncing maintaner for IAA driver
Message-ID: <abTvIYissJyO7cZU@gondor.apana.org.au>
References: <20260305172133.3115510-1-dave.hansen@linux.intel.com>
 <1cb80a0f-d704-48a1-9d81-02b6c56d7b84@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1cb80a0f-d704-48a1-9d81-02b6c56d7b84@intel.com>

On Thu, Mar 05, 2026 at 09:32:56AM -0800, Dave Hansen wrote:
> On 3/5/26 09:21, Dave Hansen wrote:
> > This maintainer's email is now bouncing. Remove them.
> 
> ... and I'm a doofus. I'm not sending things via my normal workflow and
> I missed:
> 
> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
