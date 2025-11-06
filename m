Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078522D9485;
	Thu,  6 Nov 2025 07:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762412952; cv=none; b=VkRd5ayn9aV3AHOj+D9l+ehYtGWVdCAqKcR+jaOZ04YX2WZus+Trs/yACDIGbY6RYYART+QtIJbmKDWYQ4gAvVUXykoWQUl9f8hV3mGU98R+7ymtj/u9ltsZzcpGRQjwWo22n5vMZWYfYcRtXAvsXjmj7IVZlIDcPgsBz4xA2OI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762412952; c=relaxed/simple;
	bh=+WKYj7TxyeuieQ84LodmgcRb1vIcHvaR2UQI81UHl0k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R5cjDTUxKvKWaosIzcbdBZoWUAUYS0xL4XXo+MpG/iOi2AtBh4d5tL0KCaaz6bcCqdaGoTuB9JdsZ0LntT6kV2EKcnK7V9FPbvX2qgXMlgBP3rzOOZZg8qtazRzgh/WPcUBAhlnLUrFDMeSOpbuXUJCn3oy7NiqyNSpbylRpwdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=kdLXakno; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="kdLXakno"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BBgLji/1weaJQdSKWmMv3FFhXVrOshzsvKfPhLEbqZo=; 
	b=kdLXakno7SHSKk9tS2ivYVRxBzqh7EMBU8ZZ1sZQ8Fl3bi7Fs0+TcW5FMHuQlZcXgE/8Crf/+nM
	Jwg6WdGBm8uVUBmuIG7usQtPLJEm1AypugwYoryTWl3GJ7w0BN26qh5Hw80FwRymAw4Qxx5plwSvB
	LFJLEkBjv5ALAcgoMcuzNOkyWXoMPH7sMOaHS3cFQOHTUfuaECsdubVmgNuls+Vbe+wL4S8ME/DYO
	VZPxtm9iGAgtC2bbr7zwqRA9zOgR0dV07fLMktWMYF7lWJLRSEwjtg31F/iFB4A8AHQYKwr4ZOevM
	oUgyF9OJHmyCKkScSEk14d7FHbumzfZ25jZA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vGu78-000rbR-2T;
	Thu, 06 Nov 2025 15:08:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Nov 2025 15:08:58 +0800
Date: Thu, 6 Nov 2025 15:08:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ard Biesheuvel <ardb+git@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, ebiggers@kernel.org,
	Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v4 01/21] crypto/arm64: aes-ce-ccm - Avoid pointless
 yield of the NEON unit
Message-ID: <aQxJigkyl4bCDpxh@gondor.apana.org.au>
References: <20251031103858.529530-23-ardb+git@google.com>
 <20251031103858.529530-24-ardb+git@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251031103858.529530-24-ardb+git@google.com>

On Fri, Oct 31, 2025 at 11:39:00AM +0100, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ardb@kernel.org>
> 
> Kernel mode NEON sections are now preemptible on arm64, and so there is
> no need to yield it explicitly in order to prevent scheduling latency
> spikes.
> 
> Reviewed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/crypto/aes-ce-ccm-glue.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
