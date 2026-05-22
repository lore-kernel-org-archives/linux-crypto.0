Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6387D37EFF9;
	Fri, 22 May 2026 12:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779451388; cv=none; b=ZFGQWb4CAyOcuSfwOUUnZ8z/60DBI4uMSWMkfVhxt0xHOS6xFCE9Sxq5E86s/6Y+dTN9v0Ml7Ny37bIfRnV3rtm3AfJPxeVXXIyn8XoPW+2MjMwLe0sHRrtuf4AyhzMzE5wlvV34SjNRqhoaAx+zvblcINwhdv2P2lz+8MmcWvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779451388; c=relaxed/simple;
	bh=PXY9YoPSChdjK/XziM8x2lxcnL8lZJepJxhDc0Gcfn0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KfoeKNy+UMyXXLV3fsi94iQe6SYdFl8hZzQ58Mp16IxQOK8fprYXFEGoqiwe4v2bqAl60bbiY7cVGXf94fr9Nn12apu3dZvTFZ89tAth+G7DJwVb+CBY2EBqEGG2V5kTLDayeB0KxGa/+BgmiCm6/SnbtSucKJ+s0pyBlGtf4VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Uccw+G7v; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Uccw+G7v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nAaXB/SYFANCFH561bJyEAhhMJAOQPurUYe1Iz0gBMw=; 
	b=Uccw+G7vHSoh7nO2MHIgqt9cWywPRF/NogZR7gL+5dqxxSPIuDJl24Ul4EqpdAmkBWWJ2DCdpfC
	duhR6i+52i45UnIyc8OOdXPJmKJEf5wYLkAjby9zJG46jDRx62hp0AziwR7J04+3Ph4Pn6t4DbPz0
	0ZkYfY1CBosWfIPk9TALB0qvoJ/lw071Huv0gbj5FYTgMdBa/Pqemsl7jx4AV8Gu2QB4w+u7Ad3Td
	mdGuDWrzB/MQaYVdqVQo77x8g+P7Ar+5tBYBp2tWpXPDIAdAosIeJ5uyoBvDDLrTGJVwc4IzCQJBJ
	UjtJir2YnMPhcqTSxFYNaiwDuughrSb7OvWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wQOaZ-00GRsH-2Y;
	Fri, 22 May 2026 20:02:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 22 May 2026 20:02:51 +0800
Date: Fri, 22 May 2026 20:02:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Thomas Richard (TI)" <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH] hwrng: core - Do not read data during PM sleep transition
Message-ID: <ahBF69_ti6KCssnN@gondor.apana.org.au>
References: <20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v1-1-b12551c1c7dd@bootlin.com>

On Wed, May 13, 2026 at 11:27:37AM +0200, Thomas Richard (TI) wrote:
>
> @@ -538,8 +539,9 @@ static int hwrng_fillfn(void *unused)
>  		}
>  
>  		mutex_lock(&reading_mutex);
> -		rc = rng_get_data(rng, rng_fillbuf,
> -				  rng_buffer_size(), 1);
> +		if (!pm_sleep_transition_in_progress())
> +			rc = rng_get_data(rng, rng_fillbuf,
> +					  rng_buffer_size(), 1);

Isn't this going to cause rc to be used uninitialised?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
