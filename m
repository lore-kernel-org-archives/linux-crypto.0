Received: from norbury.hmeau.com (helcar.hmeau.com [216.24.177.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45378156C40;
	Fri, 21 Jun 2024 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.24.177.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718973283; cv=none; b=InM6iKV4ZxvyXgX8K233gx1EzMlKBSn0Jkbe/S789IsDsQDHo9Wu6X08ICdfzD5fHsqhvALfyRmoChuAjAdW828GKL6c7wGHqHHFRWZpedybAeRycCdMQhfbrP8T/HK1pSEd1hR/GLDv1bt5/BDac2WGL6rz9b4CtZDKHoVuMJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718973283; c=relaxed/simple;
	bh=3eAh1OQbFyPvUz3wYmuGY0Pg/++QB+UnLKZ6kXlgvHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kA0AYF4VCBU4NDllIe7Oo04orMf5TT/C9JUSz408/R0+a2cwAXYXg91N044ULow18gb8lDeWHdZONGsyqqjge7gdj3//ql5GmX0y3+IyNdl0BoklOeemKgX4b45bC8Nw5k6QrAgifXrpAKZ6nymR1kw6MB2fCMYQP9MMtwzsR4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=216.24.177.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
	by norbury.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sKdTE-002eoJ-1a;
	Fri, 21 Jun 2024 22:34:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 21 Jun 2024 22:34:24 +1000
Date: Fri, 21 Jun 2024 22:34:24 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH] crypto: lib/mpi - Use swap() in mpi_ec_mul_point()
Message-ID: <ZnVzUCw0Vzd1ogRe@gondor.apana.org.au>
References: <20240614030912.10736-1-jiapeng.chong@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240614030912.10736-1-jiapeng.chong@linux.alibaba.com>

On Fri, Jun 14, 2024 at 11:09:11AM +0800, Jiapeng Chong wrote:
> Use existing swap() function rather than duplicating its implementation.
> 
> ./lib/crypto/mpi/ec.c:1291:20-21: WARNING opportunity for swap().
> ./lib/crypto/mpi/ec.c:1292:20-21: WARNING opportunity for swap().
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Closes: https://bugzilla.openanolis.cn/show_bug.cgi?id=9328
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> ---
>  lib/crypto/mpi/ec.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
