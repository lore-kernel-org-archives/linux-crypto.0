Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFCDF4ED;
	Wed, 14 May 2025 03:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747191614; cv=none; b=XWBN3wSavrJWPmnxwy0hpVdjvLJmszilWciXP7/n7xDZgeuqOfOdzlLzgXI+SLKvzeNsYbWqgwu5pdHhUWbCep8DXFuZIhNatwCPxYfMVpiFWyTQSyViAKP0g77llmLMUZ0CezA4Xil+tQ9QLZOmqBakZMDoJ9aI8tXHDcwltQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747191614; c=relaxed/simple;
	bh=ubh9TlPTD7W4U6wPWbQQxXk+IE9xbwcI5RVWb/egcgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Bp67L+2ZpzwbygHEDpXTn0GSBlrIOGZe49t959OoeKOGq2obwonUOsNWwOHt9MRo2HGdE8sHOuZ9Z/nyrt1XQSCVSZTpSTlVLBjt5K3+LajUU+JpN6bWs+Rl7Qo+tVLVBHrkscIVNU96s9vFJhRvvpGVAhS17uQjGSA0TjE+ATs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KLD6xr14; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KLD6xr14"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=A2IcOM+Jv51AuN+5E4zGxSWcW8AP5sQ7kd2IdjfCzVA=; b=KLD6xr14fav0AqE6JxNlinuQY0
	BMYJvnBdLOO+FDqMJWzJVmGpx88JW3KSNSYKlmiGgicpKA6scipRliv/01e3ozOBZZyp4Ap/MVss9
	AlFbfwdVEVvhtI3vzvZbt7c3M4AsbX6q6MfZ1GVtTbZXlrgyEuWG+WRxYVo2lXAGCml8J3zfMvni7
	b/P0DYHh9bMxlBcHKA1IYUGqzjrClb9yRKxMsbLw9u8XbnXWC78/8KIw7RBtsRu+wcdRSuWouGbMC
	wFrwxMA9mCY9mU9KRPPjSKYNuQptwcnxeziAADF5irLWocqKmiql2IdpkDIGSlx0JgD8GlKL4kvFx
	kQr9a85g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uF2LZ-005vwi-1t;
	Wed, 14 May 2025 10:59:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 14 May 2025 10:59:53 +0800
Date: Wed, 14 May 2025 10:59:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Zaslonko Mikhail <zaslonko@linux.ibm.com>,
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
	"Cabiddu, Giovanni" <giovanni.cabiddu@intel.com>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCHv7 10/24] zram: add zlib compression backend support
Message-ID: <aCQHKQ9bGaZiVrXs@gondor.apana.org.au>
References: <20240902105656.1383858-1-senozhatsky@chromium.org>
 <20240902105656.1383858-11-senozhatsky@chromium.org>
 <6046d139-2a46-4824-bdfc-687750c1ee5b@linux.ibm.com>
 <gekqwhcpombpm2u3b4xl7zladuyzbxybeq5wcwt47k7tsgo4bh@rfrxaeqwzypi>
 <df805c0e-bf25-4cf6-9601-aac594fa0f45@linux.ibm.com>
 <uaxb7sbvrg3eqn2sp66sg77urjzr7jwi2m2bwigvj5n5cta2xu@qsks2da3zrha>
 <3bd33a06-f8e2-4901-ada1-e970d18afcd4@linux.ibm.com>
 <jejqy2tqaasir7vtu633ns3nybrzxvjlpebfavxnmq7inq2shz@egfzio3p2wgt>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jejqy2tqaasir7vtu633ns3nybrzxvjlpebfavxnmq7inq2shz@egfzio3p2wgt>

On Wed, May 14, 2025 at 11:56:38AM +0900, Sergey Senozhatsky wrote:
>
> Crypto API uses a hard-coded value of -11, which wouldn't work in your
> case.  However, if you don't use crypto API (e.g. zswap) in your setup
> then it probably doesn't need to be patched.  Cc-ed Herbert from the
> crypto API side, just in case.
> 
> [1] https://lore.kernel.org/linux-kernel/20250514024825.1745489-1-senozhatsky@chromium.org

Once we have parameter support in acomp you should be able to set
this as an optional parameter.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
