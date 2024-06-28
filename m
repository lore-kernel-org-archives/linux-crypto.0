Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0F412E75
	for <linux-crypto@vger.kernel.org>; Fri, 28 Jun 2024 01:49:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719539351; cv=none; b=h5jv769vxl7QTgi/eOynASew7+kOOofEE5XK1ZOm5o+ufTWfY/QpcvGrkwkW88BGusAA364rV4Y/xvcYecFzSVHCCKmbYXDN1kx3L7IQVCNGJ4NWiYw/E+u3aTLJc/1akL++rbI7KOT1NYz+fkY5uA/wHrCf58iZHEK5fdxeJfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719539351; c=relaxed/simple;
	bh=9Ef1mUZ1oPLFuGr9g7pgrzTJKhF0XEjgZW3VDe3rLwc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UkZWFiF8LfqJkD2OBqZwOKnhpdWSkyp9H2lo6qDP3+GCdfwzpwAHTWHfSUWH54juEXpwCNpqMbBrkZDCHh3/w1XWpXeQ3SFoR78RQ9EK5Lv2cDHkFrOsVfGVBrQutS4eXLFfL5X1qerOd1Zh4HtEzx7+sngmwkcP7PHsx4StwqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sN0jK-004GDJ-0T;
	Fri, 28 Jun 2024 11:48:51 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jun 2024 11:48:50 +1000
Date: Fri, 28 Jun 2024 11:48:50 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Portnoy <sergey.portnoy@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH v4] crypto: tcrypt - add skcipher speed for given alg
Message-ID: <Zn4WgnF6eIdbVfu/@gondor.apana.org.au>
References: <20240617161048.3480877-1-sergey.portnoy@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240617161048.3480877-1-sergey.portnoy@intel.com>

On Mon, Jun 17, 2024 at 05:08:29PM +0100, Sergey Portnoy wrote:
> Allow to run skcipher speed for given algorithm.
> Case 600 is modified to cover ENCRYPT and DECRYPT
> directions.
> 
> Example:
>    modprobe tcrypt mode=600 alg="qat_aes_xts" klen=32
> 
> If succeed, the performance numbers will be printed in dmesg:
>    testing speed of multibuffer qat_aes_xts (qat_aes_xts) encryption
>    test 0 (256 bit key, 16 byte blocks): 1 operation in 14596 cycles (16 bytes)
>    ...
>    test 6 (256 bit key, 4096 byte blocks): 1 operation in 8053 cycles (4096 bytes)
> 
> Signed-off-by: Sergey Portnoy <sergey.portnoy@intel.com>
> ---
> 
> v3 -> v4
> 
> - moving speed_template declaration to case section.
> 
>  crypto/tcrypt.c | 9 +++++++++
>  1 file changed, 9 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
