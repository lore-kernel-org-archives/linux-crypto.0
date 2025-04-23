Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4475B1F16B;
	Wed, 23 Apr 2025 03:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745379690; cv=none; b=EoTayO0jYB8/3y9gJkGhzNTATBTFtanCfDXngPvVHbRCvplZtexfMcltqF2MMOlXQMb4BipGz2mFaBd2OOVIER2cM2Ywzi+jO9Ssfj5VDEMoOpac50ibN4lQOtE7fMarNMh4yBvyW9Zi9mhiZh8buVUEd0f+QbMtw5Y38pwY5aM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745379690; c=relaxed/simple;
	bh=GU4IjCjosUGdwTzgwGwuhcMewpqmSjnXfJaDEbsv9eA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z81l2TW2FynQsBOSjTuREv+bfdHhQs/v/mKNWnRSFy9+fA5Elfg93ytd6DTtJOrq5Dos/yew6ECm8W8tQWK55ENh83pF3KbbCl0TJbkCEnN6ncnrXnTwEFy59+qsD2QVyATzKgT5JoDGwkyUOUf3ytK68ED+n+Zk3/IypUOZzBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=re4BHWQk; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="re4BHWQk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=creojN5NCvp47+x8To/ERiJxYBKpq0R7Oo1oxDALUCg=; b=re4BHWQkxlIIqfIXRzp4D776fD
	7yLf37h8HFc2pEG8KLclhwR2vG/XZ0tmIHVVkDLl8cDrslObEN2q+v5xtQIPmhj6Yry6A7/XxGyj3
	uDMhI7AkUzqbLI35D3q8PCvHBJ367Kl7WBTHeOtbR0CQQL9YlxHp2qtdU/6w2phHWy9ZSaCRj7Jwd
	9mkASxsmOoCku21CHNEWxG5uxaNLTS+/8oc7mRiVAC/OhJN4mc94CoC5X8FSgpTP5BV7mKbSU6UK+
	yaN3vN4ZtjfCXPupAjCIPB49itLHFAo5Ra1Vga/zwUS0GWBpB8VKJRMkUQhec0q0yP4gyl2GGUZ7g
	ptNhVNpw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u7Qz4-000Gj9-0C;
	Wed, 23 Apr 2025 11:41:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Apr 2025 11:41:14 +0800
Date: Wed, 23 Apr 2025 11:41:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: engine - Realign struct crypto_engine to save 8
 bytes
Message-ID: <aAhhWhB1tLHlRGHR@gondor.apana.org.au>
References: <20250417223650.72687-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250417223650.72687-2-thorsten.blum@linux.dev>

On Fri, Apr 18, 2025 at 12:36:49AM +0200, Thorsten Blum wrote:
> Realign struct crypto_engine to reduce its size by 8 bytes. Total size
> is now 192 bytes, allowing it to fit within 3 cachelines instead of 4.
> 
> pahole output before:
> 
>   /* size: 200, cachelines: 4, members: 17 */
>   /* sum members: 183, holes: 3, sum holes: 17 */
>   /* paddings: 1, sum paddings: 4 */
>   /* last cacheline: 8 bytes */
> 
> and after:
> 
>   /* size: 192, cachelines: 3, members: 17 */
>   /* sum members: 183, holes: 2, sum holes: 9 */
>   /* paddings: 1, sum paddings: 4 */
> 
> No functional changes intended.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  include/crypto/internal/engine.h | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
