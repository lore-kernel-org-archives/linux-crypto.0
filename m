Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC7F33F38B;
	Mon, 13 Jul 2026 03:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783914397; cv=none; b=ijynaNrZQWP5YhKCbs8AUBaxV+aIkCFxQdIqHlfygXKwekQJ1GaLPUYg9WoJJSmW6eeuhHJ8DP7Erjx1BBOR3XM/Y7lkG4vCpMwivuW6/X0U8WGfac8oSkfwCvXVcKlA8QRXUFXjCsif/GyFBRZjzSUjaea6do+Xf05VsoxzXvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783914397; c=relaxed/simple;
	bh=Uvr2Fd/lnagmF+gNNQIGQS7YNcf4dy2hX1qS4zqmqxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GTvhk7xEkO2i8Qtax2CZFxj/iS1yHTSYrNofKc4EKDOOntB+P1ob/RB6OKa6uTQn5YYIe/ohVPN3XHH6MtphnVZTuxYrzDwrzGoR296gebR6sxj22PxWQKyj5O4Owah7V106LwVm7DT6LYHPe328BLA2avn+/1XeNTci9sKeG/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=MIivsQAv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="MIivsQAv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=IV4qlhj0eWVV13eQM7LMrxiETB767e9EAWhq8ihnBHY=; 
	b=MIivsQAvEx/0c0RIKb33C0eme5xtd8+73kusaFdmhzGLZL0bPpqNZv0EQoTIKGCbEQfFLJBf1ok
	hrLlq089g0WbWrM6/9E64VGBnUMujyQo+0qvhWF3GGp5wFcP3I4ye50JSUr/SB56DLRozAdW9PKzu
	LBgxDriZpoIq+dum4Yw3DltjJvyZb0O2V6tr2KFrsA6V5ipqoKadEmzgvPxjRrnKzs77Oos/F2/Bl
	8zsTKc8eVjQJB2yk44SC+0jnrdrask6P5+jWfL7j5FO4KyZyob/S0SawHydjOXFSHZKb2P6nrK3bP
	dF/L//HAAv7KApoNmzLZ9gV8FfliQezgkoLg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wj7cj-0000000CyIZ-0fU7;
	Mon, 13 Jul 2026 11:46:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 13 Jul 2026 13:46:29 +1000
Date: Mon, 13 Jul 2026 13:46:29 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: Prabhjot Khurana <prabhjot.khurana@intel.com>,
	Mark Gross <mgross@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: keembay: add missing MODULE_DEVICE_TABLE()
Message-ID: <alRflcX52b0e6Q2V@gondor.apana.org.au>
References: <20260704124609.16628-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704124609.16628-1-pengpeng@iscas.ac.cn>

On Sat, Jul 04, 2026 at 08:46:09PM +0800, Pengpeng Hou wrote:
> The driver has an OF match table wired to .of_match_table, but does
> not export the table with MODULE_DEVICE_TABLE().
> 
> Add the missing MODULE_DEVICE_TABLE(of, ...) entry so module alias
> information is generated for OF based module autoloading.
> 
> This is a source-level fix.  It does not claim dynamic hardware
> reproduction; the evidence is the driver-owned match table, its use by
> the platform driver, and the missing module alias publication.
> 
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
> ---
>  drivers/crypto/intel/keembay/keembay-ocs-ecc.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
