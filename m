Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5CF1A5B8A;
	Sun, 12 Apr 2026 08:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775983544; cv=none; b=H/sgnRt7bIfqOxzKawO5s/iZY+fvnlbPwKc06Xt0/46e1nzvkvxFeVJOaLKfTnBV1OxQJTUdyfV4DQ8A4+vSsv/yjhkeATVWInexmhBCpJmX1LAWt3+cvxzFNkrOyLbSFKFjhedjPaad5pinaD4PvTVZGgVlhS0/uxVPkqPgkpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775983544; c=relaxed/simple;
	bh=azBMNWkRFLFZobvLunZ0jxtA0RCb2XZiLVhv3hgTWdo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGm2Lp4DkZn2A4hoqxkJasbizL8g9/ylaw0QFs93Sh72CEUNGoWOoCk3Ca8COe870Aj9eJ4rtB/iMhJyzqu4JuRn7enRV73APo3qAKPKaM6N77VgNWC3lsP3IIHGwDJNl7nhF8s2L/R/FDyNEaUp1fLZHjAPadMuUjqJ+Xy2L6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kyS6YePK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kyS6YePK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=inyq2RXE9vkP9Qjr+cmQdCFlBBVJbK3ysS2Mz6uybWg=; 
	b=kyS6YePKm+g3xe/PccnTSrzGmC8JyWv4mgWWHGEYpFDh1EVGLVjsi0jOkKmm31l6KOeeKNjrygc
	DdFOaltMpson4p2BRic/MEf72TMFkiK0ueZ0xxCPtPjj48A8ysuaxvqdknPL7LF+4prVXSdJEqp2f
	hN2h+bMlFTocbhe8jMEf3zYH8S+52f25/uslwmvD8GRBUbkVJZvo1qwc8s7lG6xtJXv6YLh+HLyX+
	Bl8R3g4hcL6y2ojLkag0DKVngxgWqHEjTrLkLRjky37zRCkZcfez4lupPa6XztFl6l5FQnh98IZkr
	W4ugzv8veZimcndwe+81HF8MLHPx5no4EUlQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wBq28-005UDs-2T;
	Sun, 12 Apr 2026 16:45:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 12 Apr 2026 16:45:27 +0800
Date: Sun, 12 Apr 2026 16:45:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Lukas Wunner <lukas@wunner.de>
Cc: "David S. Miller" <davem@davemloft.net>,
	Jarkko Sakkinen <jarkko@kernel.org>, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org, Leo Lin <leo@depthfirst.com>,
	Eric Snowberg <eric.snowberg@oracle.com>,
	Mimi Zohar <zohar@linux.ibm.com>, Ignat Korchagin <ignat@linux.win>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] X.509: Fix out-of-bounds access when parsing extensions
Message-ID: <adtbp6f2uhH8Grog@gondor.apana.org.au>
References: <db192bcb9467d30068c97a4007822f21aab6766f.1775512248.git.lukas@wunner.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db192bcb9467d30068c97a4007822f21aab6766f.1775512248.git.lukas@wunner.de>

On Tue, Apr 07, 2026 at 12:58:18PM +0200, Lukas Wunner wrote:
> Leo reports an out-of-bounds access when parsing a certificate with
> empty Basic Constraints or Key Usage extension because the first byte of
> the extension is read before checking its length.  Fix it.
> 
> The bug can be triggered by an unprivileged user by submitting a
> specially crafted certificate to the kernel through the keyrings(7) API.
> Leo has demonstrated this with a proof-of-concept program responsibly
> disclosed off-list.
> 
> Fixes: 30eae2b037af ("KEYS: X.509: Parse Basic Constraints for CA")
> Fixes: 567671281a75 ("KEYS: X.509: Parse Key Usage")
> Reported-by: Leo Lin <leo@depthfirst.com> # off-list
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Reviewed-by: Ignat Korchagin <ignat@linux.win>
> Cc: stable@vger.kernel.org # v6.4+
> ---
>  crypto/asymmetric_keys/x509_cert_parser.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
