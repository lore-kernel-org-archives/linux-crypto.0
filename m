Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 164D56F06A;
	Sun,  9 Feb 2025 10:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739096568; cv=none; b=PGPaonk+Pm5ePMDsamM5XCe342ES7NqpX4m3N7hQgFu9gT8eK/kiUkmIAC9v1hZRHrLFwY28rbA1PFwo4k+d3i/szir8cZwrK+tXqCfsM+Bn4oRGhF2xlj4Qjhais8zoZLB5iVaYoZySHhJ6Wb2aZQ3f5SZUkMJDcRg9wJ++IVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739096568; c=relaxed/simple;
	bh=0XsNF0wkFzKnPR/Duk1ZHdacxwpOfc8zDKCgoIBLRM8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CYzKcVGmenXDLzOK7Nf+jc75tfWPWWgyMZB2vRVQSNOLNYQoWvqE3fjTG3Wy1ViWOwk3N8GcQo054RDG2H2uDD8HJASTkl77iz8dERhXRfOqignYU3CEtG2qmN2SM90HEfJvvaiJwWGS/yEcpTStIJmWCl6wGC7dilVGH8lq7bc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=i8xYpTH5; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="i8xYpTH5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/gn5hryCcopP9HshD9KQRMkU+RgBN7HRXnfQn6rCrSg=; b=i8xYpTH5mmpVBrndiDyu3I2Wb3
	i58HNr3XmR9wN1+rX3GP95OXToH7z2tJwkKhCOeqMnwjANEHD56AEkVjqimiQicFd+s8pfA6Qu0FG
	Px/U2nmT2Ar3ZzYtdTxcOrTuwBafhR1jccNN36FwdmcsGZCFUjZ5RZDY3ogo4WIoKEPtTJ1FE6JVY
	pmFr2MTiWJC7gpXOdSKtaOinxehXjhQaVh96FY8KwiCbrYoxoJO7QOsmWix6fKGv1eFcy8lXVezYN
	6JkUfwI7G+XRA8IIrlKWDqtGXcJdErSVbh4FRT2NMoO+R9A9dUA1uE3HJ+X7QWpeQRY0UsbaiPNv9
	WeT2jAEQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1th4Fb-00GIlG-05;
	Sun, 09 Feb 2025 18:22:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 09 Feb 2025 18:22:39 +0800
Date: Sun, 9 Feb 2025 18:22:39 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: skcipher - use str_yes_no() helper in
 crypto_skcipher_show()
Message-ID: <Z6iB764zAdtceKZ0@gondor.apana.org.au>
References: <20250117144222.171266-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250117144222.171266-2-thorsten.blum@linux.dev>

On Fri, Jan 17, 2025 at 03:42:22PM +0100, Thorsten Blum wrote:
> Remove hard-coded strings by using the str_yes_no() helper function.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  crypto/skcipher.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
