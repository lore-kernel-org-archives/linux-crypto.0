Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB811E51FE;
	Sun, 27 Jul 2025 12:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753620270; cv=none; b=WsuuDK2fXure6KL0s7J9FKl7B2mjWPZT+YPqyJd8sactdwBO5UlxgyUEA+Ri5Ngdg+45f++rSd1aKdu97nqLJMhKtO3s7hrUecokpgYRznYDQkVGP85woyGKER3v+ZMjM+dfM+Wb42veYaB4jyalcUtS0UtS3Bv9/SYU4dHJrb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753620270; c=relaxed/simple;
	bh=XYgdO7+Chd6v6Lp6MCwkEwX1EWvd5xjcOdUX/UkdAxE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ahqGk+Q9EMfj/0vJAcEuJnENnP95yLrtxeoBieOwFJja5zDAHrRnjL/9LBQxhYLJgLoSSbZ5OD3b9K0rKchbvKe6AHHMvDby+XsyMnRgYcpdJ0WI+U6EUI9oHr0T2O3zEvaKu/hIHkBORdVF603sz0fmg9MyKr1uhYfoepzOwJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QbwVwsof; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QbwVwsof"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vSegQj8uDEB8Usg7qCkwbtNNQ+GYcGIh4jcsvMKt8b0=; b=QbwVwsofrJkubDQxDmgumH24b6
	E7Sn0VnfJDzpBaGwa1Xt/P9FRK33uEFnzUSq2buqnzxX52GmxD0xg+0JZenHvPvQaFg6xZAbWkwye
	4lDVvMqaQphZdBHreABU+zemiWoSxeLI2xkvNKCrs1ybcc6ItLdH9w6YXAUfpGFu0UXsJ2I2xG7kM
	e0QmR+qffmKOeyld+mMlFTLv00Vw1eCS7NGrp5TkR5kxQ9+BOt+s454YFsHuxyIWmmTA7hq8CW1+5
	00fynZp9rVN7Xl+0jBFfTbb26AMaehojDNkr4Eu2Bl9G42x5CFxaknG186JZuTTuAmplHc70w0mGR
	PLahFhmQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ug0UA-00A4sm-3D;
	Sun, 27 Jul 2025 20:44:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 27 Jul 2025 20:44:11 +0800
Date: Sun, 27 Jul 2025 20:44:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: reduce stack usage in ccp_run_aes_gcm_cmd
Message-ID: <aIYfG1VbN89ipThb@gondor.apana.org.au>
References: <20250714145921.699060-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250714145921.699060-1-arnd@kernel.org>

On Mon, Jul 14, 2025 at 04:59:12PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> A number of functions in this file have large structures on the stack,
> ccp_run_aes_gcm_cmd() being the worst, in particular when KASAN
> is enabled on gcc:
> 
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_sha_cmd':
> drivers/crypto/ccp/ccp-ops.c:1833:1: error: the frame size of 1136 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> drivers/crypto/ccp/ccp-ops.c: In function 'ccp_run_aes_gcm_cmd':
> drivers/crypto/ccp/ccp-ops.c:914:1: error: the frame size of 1632 bytes is larger than 1024 bytes [-Werror=frame-larger-than=]
> 
> Avoid the issue by using dynamic memory allocation in the worst one
> of these.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> I'm not overly happy with this patch myself but couldn't come up
> with anything better either.
> 
> One alternative would be to turn off sanitizers here, but even without
> those, the stack usage is fairly high, so that still feels like
> papering over the problem.
> ---
>  drivers/crypto/ccp/ccp-ops.c | 163 ++++++++++++++++++-----------------
>  1 file changed, 86 insertions(+), 77 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
