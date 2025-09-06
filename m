Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1065266B6C;
	Sat,  6 Sep 2025 08:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757145757; cv=none; b=WxuG4l0wNnJNqjnXtyxhwtt2D3RShnwiVm87CQroAvZKNs1cO0yN+9dtS1D+znNlOeKQ11e0ND9vNmqjCdrjVxtppSD0oN+20TJribiP9+DKUs8Hk/zxZG31QALyg1wvR3N3/4Spoww+kuv7sq/+gWXwe1kLDmAI8zfP2ks6KlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757145757; c=relaxed/simple;
	bh=gqkV47KOfRCXdUkuq/+y5ncsCY1H78uWaFqNhFtoQfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVAx/CA+bTmgpN0BuJQeEu9a8UyjDfV9+aESsZ/yqLQE+V4Y5ArjPKCLTQmkXP3Ikad2uUdscRS8KhvI4KfqS0hvZXcuHmJhBRKFAcS0OBT2Llvor6IUFc1WOydlOyHqp4m1ErtsxEHzC9MHua9hhBuOy0SiEIYGxxYmkPt27SU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=lUlUX6Em; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="lUlUX6Em"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tohAqj/B+zsO8G+a2upJDotvw/fsoT149KifcZaPU4c=; b=lUlUX6EmqfNIvAkEgLs7SFUOfi
	C9rs4FdGGRgwTo2VgWZGLnE4a3m/M1m/YWc7FeqRzcMZTMaVhOCkkDPEi0uiYU82J3Re4Ey0MibqY
	uuqGW716JWB/dYcZLCmVQ0lkPd4XdMT95ucZChBY2NuGz3zYFeQKFiFF0UKIDPyf8t1KVIu3gBYUl
	K3Gyp/92HQ3EmyylgQORvy0n8cLi95MpINsVrPgiD6BSdJZLTmHvT37UjyisISqqyILWboJ5aFPnq
	2Xkzr9HUq+m0xjPzDehffVd8EqRtYMMjRmgZB/+KT6vJEj+NbFsl2RIdelGPxBiUkPZ8bbVqZYGah
	AhoSFBvA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uund1-003BPV-2S;
	Sat, 06 Sep 2025 16:02:29 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 06 Sep 2025 16:02:28 +0800
Date: Sat, 6 Sep 2025 16:02:28 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Menglong Dong <menglong8.dong@gmail.com>
Cc: tgraf@suug.ch, menglong.dong@linux.dev, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rhashtable: use __always_inline for rhashtable
Message-ID: <aLvqlCL113D59jZl@gondor.apana.org.au>
References: <20250829072844.333123-1-dongml2@chinatelecom.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829072844.333123-1-dongml2@chinatelecom.cn>

On Fri, Aug 29, 2025 at 03:28:44PM +0800, Menglong Dong wrote:
> Sometimes, the compiler is not clever enough to inline the
> rhashtable_lookup() for us, even if the "obj_cmpfn" and "key_len" in
> params is const. This can introduce more overhead.
> 
> Therefore, use __always_inline for the rhashtable.
> 
> Signed-off-by: Menglong Dong <dongml2@chinatelecom.cn>
> ---
>  include/linux/rhashtable.h | 42 +++++++++++++++++++-------------------
>  1 file changed, 21 insertions(+), 21 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
