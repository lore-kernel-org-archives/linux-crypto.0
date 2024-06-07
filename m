Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEC915B99B;
	Fri,  7 Jun 2024 12:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717761688; cv=none; b=TZVw1GOK3kOg6elglV+ZFyMcik1mhDY6+bg7YzfdWijcfTJtbbnsNlf2E5L/kV24zezO3qgfUX0kFqbC0PWktccKgG4PoGexloU3wT+uroyVmYLnvevBiBDf2Gdq2ZVt00mq3Y9bTMrjMjshFz3mxd8z98jo5ubSTKKboGNjVMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717761688; c=relaxed/simple;
	bh=FvzdToBSjBCiS2IGDmmIwx7sqhC+HaL8UB1u9w9JTtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXT1FNv/mKxo5drXJKw9bGAz5E4YCzOS0BHYttNEtuwhH0YilmHVWNTWb763FxxEKZFdT3TqK5JbuYJEI2s97g8nqQtCB6mpnr8jYlDJ3UVUQBbS7H1oG9uZcKui2adp17b7Nv5D7AYL66UWchZsucqCnf8lLN5mbknzYL5xeFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sFYHQ-006pMo-2a;
	Fri, 07 Jun 2024 20:01:13 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 07 Jun 2024 20:01:15 +0800
Date: Fri, 7 Jun 2024 20:01:15 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jeff Johnson <quic_jjohnson@quicinc.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Michal Simek <michal.simek@amd.com>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] crypto: xilinx - add missing MODULE_DESCRIPTION() macro
Message-ID: <ZmL2i4m_P4J2Nfpa@gondor.apana.org.au>
References: <20240602-md-zynqmp-aes-gcm-v1-1-e431cb9b558e@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240602-md-zynqmp-aes-gcm-v1-1-e431cb9b558e@quicinc.com>

On Sun, Jun 02, 2024 at 04:17:08PM -0700, Jeff Johnson wrote:
> make allmodconfig && make W=1 C=1 reports:
> WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/xilinx/zynqmp-aes-gcm.o
> 
> Add the missing invocation of the MODULE_DESCRIPTION() macro.
> 
> Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> ---
>  drivers/crypto/xilinx/zynqmp-aes-gcm.c | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
