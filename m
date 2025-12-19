Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E203E192590
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 06:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766127439; cv=none; b=RbEfawF759HMGlLJS1SqN9aw3RdsgWu1BOuQkUdUJ5AvXnfWY67xQ+zf7AO/LIbxWaqjK1NJUC0O9s8c4u+D0ee494k9hmGjQcPw6jIgJl8U97rptKnOT1FvmWGzeGs9nN0XulLJzOGxGraVeZiI9Szp1ga93GjnKioDmd8HAXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766127439; c=relaxed/simple;
	bh=dseUkamnU7hYELr1gExE81Ks9+PCFrtG1sG2i0/0+04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PkX+xe+8xA1WS6Ll8zQmXHoloAXbXRGobk45xm93NIkKSvxlLwT6B50MU8034KWTKbPChywYYsa+teEgfUBYDs1LWXtrS6OYTKadj0WC+PSojgVGPmcR7mLR7vUiAvu7O/fGl1YaW7Neb0K+aWGjuQqTcb3I6dR5YWInMQwfHeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=lA6OBWdf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="lA6OBWdf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+CF91CjLRoT5+m2hYhW9rsvfprFeV0KQAhwjemtntQ4=; 
	b=lA6OBWdf5V8qOOF8mMNukbYiaDgZKc98orLRsHZNIMU96yC7aQAyJ557WWHzxi/Q9AKJYXJ83fy
	aNK1v6TmxENwsJchHcbNmG7uJsjGbIsYWZpAMHBWRwVFJlLBDATBl7RNNh/yBpVa45yXT8A+0Iujp
	adUofiEDL4E4AokScQNEnXSqipWFvtgqWVBSpqvB50VVEmFMnw6t88MAVoGUFz/FDJ2uQddYVgC5P
	RfMVQaXe7GbRRv6RcKuKGV1K6WMrjCk5tAE9Umd2i6WlYwO6KEFgwOqe0EwDLCpvgisvfqI+1/sur
	Axmrzn6xa5TXcZaKRbQa3mXotOcPSKyeLImQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vWUQK-00BEXI-08;
	Fri, 19 Dec 2025 14:57:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 19 Dec 2025 14:57:12 +0800
Date: Fri, 19 Dec 2025 14:57:12 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - add bank state save and restore for
 qat_420xx
Message-ID: <aUT3SOUrD_ix6el_@gondor.apana.org.au>
References: <20251120163023.29288-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120163023.29288-1-giovanni.cabiddu@intel.com>

On Thu, Nov 20, 2025 at 04:30:19PM +0000, Giovanni Cabiddu wrote:
> Register the functions required to save and restore the state of a ring
> bank on the qat_420xx device.  Since this logic is shared across QAT
> GEN4 devices, reuse the existing GEN4 implementation.
> 
> This functionality enables saving and restoring the state of a Virtual
> Function (VF), which is required for supporting VM Live Migration.
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
