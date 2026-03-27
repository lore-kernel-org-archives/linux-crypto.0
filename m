Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 960BF28D8D1;
	Fri, 27 Mar 2026 10:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774606011; cv=none; b=DUUkv23Hy/9P5rON9vz0njZcntQzidgbBy46nYYbkFB4m5lZIwtk1uCR6cOrd98SzXcLKd+5r5P3/aHnNNJ+Ljqo02mUyK4oPEqOC+cDMeN7n8YvKMdHFpb5BH0VNkntpJc03phyfxAUkncJq+W9HCz3VzQqtewmQh6EJrwUaSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774606011; c=relaxed/simple;
	bh=RQ6IHNBx01dBJbWQ6PcCmxvviJY8Ftqwgxc8xMjoN0Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aDoKuK5jFjif690SJEBrDskXDcV3qcU43Ja2tOcbC3/l83wWymbpIl2dr/aq2gRsrq8oWjjDomkLU++6PBTYlLjgUKyHei1bR+0YHx4Bn5u8wqq+9I9/w437n4OcRVx/VRUmQSFVBmFeYOU3bsP07sdldLzjrZiJXR2PlVjh2zQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=a0ZUXc74; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="a0ZUXc74"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=4QzfYaLe/rXOHs+mVzfwGVshXWnq3+lcNx4XDowLmVY=; 
	b=a0ZUXc74/1e6kzIhdvVuxxUMrsvKdlw6sre0AwUe7RMDlU42cTHobkKWmwFjMIdZKdhFySCK5Lu
	6O5QBrh13CvDfIe7CkDax5OA884h//hU10X0UtlyRgn8eBd6NImAonJOna5naVY8Yhlp1CXAHfVyk
	HM/rGBhpk0en4bUjSfuu4Zz4p0VbnAEInBJ2LltuPJ0bSICwDTSjL3DBYqQ1FiXOAtwlI/buXtZB/
	12UEe59s3U668P1RMc8BsWYl749mNTmW23d2ZpwW/WazmaXMrB8+klHwTAjAF45yacdIrSBSiZKVC
	aBaQ6lvpR5K7BbUv1uHCBcMGWOSEGo/2BKvg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w63fn-001bmP-2t;
	Fri, 27 Mar 2026 18:06:31 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 27 Mar 2026 19:06:30 +0900
Date: Fri, 27 Mar 2026 19:06:30 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Haren Myneni <haren@us.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx - annotate struct nx842_crypto_header with
 __counted_by
Message-ID: <acZWps0gefzjyktn@gondor.apana.org.au>
References: <20260317201804.1393389-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317201804.1393389-3-thorsten.blum@linux.dev>

On Tue, Mar 17, 2026 at 09:18:06PM +0100, Thorsten Blum wrote:
> Add the __counted_by() compiler attribute to the flexible array member
> 'group' to improve access bounds-checking via CONFIG_UBSAN_BOUNDS and
> CONFIG_FORTIFY_SOURCE.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/nx/nx-842.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
