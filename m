Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AFA2EFD9C;
	Fri, 22 Aug 2025 09:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755855304; cv=none; b=BLL+oDRJfk+7E689FffJV4hFFaRhOdJoIqLGa8X1Hf9hBZGaejQnFXggn0Zgwq7YsxsVSGClQFrA8VKMewB45H+/mw3GwcTdeTTCoQ6AE1fQwA5L2zx+Am9f4AhhhGit9HLVOef85IESeMtn16HIhjUFddOMt4qOedWZCVzzNbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755855304; c=relaxed/simple;
	bh=36P3LtQsFqeWWr29JzUlsFPBbbcRBBm0rlngp1lZyz4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abhLvW/8k0W3fO2JM0orePSUb3IWb7xaDHuZyMVbu8Wyt+8KXocU3HnDXYmkiFRq6gthV0/Vklff78mzu451L3G9fyr8WzpJR7PjCQLRqoXYVIipUp7/Mel5hcB9FOXC6OBaU0el3aqhXCqtzi2/8gJ68SzrrPOirtSz0ftFxEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=shU/8NSU; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="shU/8NSU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=t/Kcct6sgBpDZexPxzMTI4phQMJW9fQfj62vTbH9DXM=; b=shU/8NSUsVco6SpdjyINrFHoJ9
	15aOSQwO04O5dGOZEb3NjhiBRO7oVFaib9wts0ZmLAyWr+xZr9YKjNRGq7YqS1qTSAsIhO3Mp0npd
	KxLBgLnLOwATpceC90OTIMmzNw5obhdBuJrighZ+Fk+SlEdPfTxA3McsoKLbrhVEHBEPUzatV4wS/
	9967ottcAf0T+h/z6pJPtqXbEf+lePYLkehn0TU080YaPPVGPropKCLWMpGtKRxZbyogmU9BeLBAN
	jjdrHZXuTTlup3LfFEY79ahXPghwn1mF79Z0iYxHtJ35e7c9tnU05/fQyljsUiJSLuAJgVihqoseX
	t+7NgyIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1upNvC-00GN7Z-0P;
	Fri, 22 Aug 2025 17:34:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 Aug 2025 17:34:50 +0800
Date: Fri, 22 Aug 2025 17:34:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Mario Limonciello <mario.limonciello@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: Fix typo in psp_populate_hsti function name
Message-ID: <aKg5uqxlJgVOy46k@gondor.apana.org.au>
References: <20250816143028.1111603-2-ysk@kzalloc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250816143028.1111603-2-ysk@kzalloc.com>

On Sat, Aug 16, 2025 at 02:30:29PM +0000, Yunseong Kim wrote:
> The function "psp_poulate_hsti" was misspelled. This patch corrects
> the typo to "psp_populate_hsti" in both the function definition and
> its call site within psp_init_hsti().
> 
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
> ---
>  drivers/crypto/ccp/hsti.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
