Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B1710A1F
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 12:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748004989; cv=none; b=sI0aB9MwSWxKAqfyvrwo0oog7f/eJjVLHgrhpzo2yjOus+GinHJ0KBd2j7Ex6keeEqqJSn5xr+2JJNLA4TeAoD3H8cGbu29xZlataJVSYRlo/sivneJHoPwaVGVU1F1GlLlSYq0YJqfqTmbr1+93A7DNs1NfjI9N6H4UT1xNd60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748004989; c=relaxed/simple;
	bh=TtFQ0YAT6hMOZ0XQdfEODRWBwBzvg/Oz2VOY1iNi2rI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VaLsPCREa5jh9wukRvg6SjFb74yg5DHHcqHjZCUXpLuHf/vKDCVYiWqVSoDeF8goImVMFF1+yhBu+UCSOg0zyxq0QhfcUpoDHvY3qewf7ySHNiNZFEjcRscMlpGas/JnbyUyt2tYsudOCdSj67hOhyMnSjK7LGg6kIPECGFdgAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ogfMXt4f; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ogfMXt4f"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Obg7cM8t3zKL9/278bdf8xy66ZZw7hQLGLnGHLthDhE=; b=ogfMXt4fkqljDJT+0mEChE6Fut
	jhQ2I5gBvmoxocR3DdIfSQek0Fn5NPHaEimP0gL1dbwm7Dz/FN9mgPvHnTj3/IJMuRwySctRJs9oW
	L2BwvqbCD8PVey3nc12PISE0b8nm+Q1P0KeAJzRugnsgNVU6ZmhQiz5L0R+7hSVNzlX6vhTDvO0Or
	Fa+pJaU+ymFIfJcLueiD1TXg67fcgJWW1dp309WCrvjlCRo/0DWAucHaArjM3vOjhwvRpL6YxFotY
	uTm7sdCLMY9jG4oBDH4LrygrUpL6bKdI8lzJDNHDmxAwzbzoqUzwjakHcJyZdqhUtm2R0ejopqB7J
	Q8f8wpTg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uIRwk-008Lvv-1N;
	Fri, 23 May 2025 20:56:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 20:56:22 +0800
Date: Fri, 23 May 2025 20:56:22 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: [PATCH] crypto: s390/sha3 - Use cpu byte-order when exporting
Message-ID: <aDBwdsX0-60WNw-K@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
 <aDBe3o77jZTFWY9B@gondor.apana.org.au>
 <38637840-a626-49a9-a548-c1a141917775@linux.ibm.com>
 <aDBqCEdH0U-cNIHA@gondor.apana.org.au>
 <f1a46095-6894-4c56-ac86-c0239bde91a6@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1a46095-6894-4c56-ac86-c0239bde91a6@linux.ibm.com>

On Fri, May 23, 2025 at 02:54:26PM +0200, Ingo Franzki wrote:
>
> All seems OK, unless that you always set first_message_part to zero at import. So even if an initial state was exported, after an import first_message_part is off. Previous code did retain the stat of the first_message_part field in the exported state as well. 
> OK, one can argue that this loss of performance improvement is negligible for a saved initial state situation.....

Yes we have to set it to zero after an import because the import
could've come from the generic sha3.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
