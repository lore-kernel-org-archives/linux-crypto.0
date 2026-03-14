Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2052334F24F;
	Sat, 14 Mar 2026 05:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465432; cv=none; b=ZCB+/rna2n76Yzc/BqnE5q/VOskG3iF6DKkjOwvRNKfFpbEjOtXbhaiHRUbcS/869kPlEdbY6Ktj0vb6+l5RSLA5xGqfx2z0yCRGCHJMovd7r4e3UUjhkEazssT07L/YGhC8pIpIqjLIo0GBQ3zPkm9Z3hLnZOExhYGnlXoek50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465432; c=relaxed/simple;
	bh=VNQ8X49n67mjJKYjJ70gXZn0OBW27zKUg/noshol8ns=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LFfknwbFNv7Kae7Wb+9gvlcmSGFbgkKUgqlXJBV4R5pG9VnY32Ptn0jT4gtUMBnxCvNULCaqtcK3hDbgTBl3YumeJz2Zup7GwM9vlg3QJYp/tPlxZKF1ae2FW3CTsFIUEsxjcoDSsWAMSdbOon1QQ1ki1STntLMCvG5escYMTD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=VL7CNb6l; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="VL7CNb6l"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=EJmMBFmPGqTHkDwG1rY3Bg/JhJ5nB1wazIAAkQAXfx0=; 
	b=VL7CNb6lp2XD/NcSdTvMXNT2X57OWml7UIRIHUL8ATFY3RP3+6UAbn7Q5DcE09I/KebSnOwt/T/
	SAKA7Afa8hKcKxvVYGn4ehAAfUt3ZI7YbSKJswq8TfR1CVgA57sLxQvJHnDW4RCT+ovR4qZ7tZo0Y
	wcKlT12vrHjge7iPoHj1UpqOfve35HdQlxqllfUk5aAuD5begJFDslFC0EdbXpeJrolECDWUbSoL4
	WeDJ60F3sTEgBA4ZuuerXkYPLrdOozK/NiYT5ume2XkGcH0QLCDOcW8zqlebww9ZVBPrljWNbzpAn
	wxcWLtENIamp9FIIk4rS8E+HpztP3Libc/hw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HMt-00ELBR-0i;
	Sat, 14 Mar 2026 13:16:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:16:55 +0900
Date: Sat, 14 Mar 2026 14:16:55 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: davem@davemloft.net, mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com, linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] crypto: testmgr - Add test vectors for
 authenc(hmac(sha1),rfc3686(ctr(aes)))
Message-ID: <abTvRwX7p0msmGI8@gondor.apana.org.au>
References: <20260305201036.63280-1-olek2@wp.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305201036.63280-1-olek2@wp.pl>

On Thu, Mar 05, 2026 at 09:08:20PM +0100, Aleksander Jan Bajkowski wrote:
> Test vectors were generated starting from existing RFC3686(CTR(AES)) test
> vectors and adding HMAC(SHA1) computed with software implementation.
> Then, the results were double-checked on Mediatek MT7986 (safexcel).
> Platform pass self-tests.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
> v2:
> - rename aes-generic -> aes-lib
> ---
>  crypto/testmgr.c |   6 +-
>  crypto/testmgr.h | 221 +++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 226 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
