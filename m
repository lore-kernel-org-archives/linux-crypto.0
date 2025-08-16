Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6ED823C4F3;
	Sat, 16 Aug 2025 09:34:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755336861; cv=none; b=BtS1t4mfygV8g6nIjGrKxO6/Yn3jx4suse/wL6dBpKlhJQKdhvyoPKaKOUurWGRBr6j0y6qoqStgT+4z7nNaIpSuGraEMfUg7mTXmp7dBK5MQfQJSNWUiVQv0gQFx4bDkzZroGIcdc89Y3/bMP6Dqp4cqKAPmhzZdupoeSIzCgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755336861; c=relaxed/simple;
	bh=NreotFmdvCqe5dboEEqlO9j5zYl3Mbga0EfMSY9wtjI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OBY+KOdiFTzilspyK2sUemMsKN3+z3dzNPHbuP5SrPipgM4swydOMqXHENb4SzYJUxX1284tMfCjy9NO4/Fpq7qBR7WR2nxES4hrHieQwnOZnxAXSTBe5AdXbCkFB0EU+fLPpX5305Mr9ZbHjnQprPVy5TF6qBhlrnijmasqPFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=PYqBIZbf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="PYqBIZbf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gtQLfs+34koM9jdIExXjuJCj8tbyuQyg15JBH0Prp3U=; b=PYqBIZbfQDmL9MR3vaH6ATJ/Kp
	s49Nfkkwr1v2R9ONR7csXpOPY+wiJ77COmu+ba4FRg7Asv9hMo4yl+fRrwnvItKpn6xPvkYeyzWSK
	0ZrMZN6mVlUuMPHCnNDVX26A496O1yPZnM5JsTpfQepV8ApHeIv0WaTyMxifLn+eeyTw2GGbB/nPW
	8mCQcqjZqUs2LWJIi82KEwcU8DbGbBPM0LVsaK7DQ+b7Glgh2Nt0ju3T/XCqQeyLB3eofYs4sMRQq
	Xb1x+iEpRcoArcAX+OXQC1YakLlfSRaAa3Bz5iibwhWMpVad6Qj/3E99ypENz70B+iR2QF/KSU2E8
	k1+Z8hHQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1unD3H-00EmOW-0R;
	Sat, 16 Aug 2025 17:34:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Aug 2025 17:34:11 +0800
Date: Sat, 16 Aug 2025 17:34:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
	Declan Murphy <declan.murphy@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Mark Gross <mgross@linux.intel.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: keembay - Add missing check after
 sg_nents_for_len()
Message-ID: <aKBQk2RaKhgc6sIn@gondor.apana.org.au>
References: <20250728120331.53342-3-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250728120331.53342-3-fourier.thomas@gmail.com>

On Mon, Jul 28, 2025 at 02:03:30PM +0200, Thomas Fourier wrote:
> sg_nents_for_len() returns an int which is negative in case of error.
> 
> Fixes: 472b04444cd3 ("crypto: keembay - Add Keem Bay OCS HCU driver")
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-hcu-core.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
