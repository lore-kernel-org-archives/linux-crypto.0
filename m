Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E2F1A9FAB
	for <linux-crypto@vger.kernel.org>; Sat, 14 Mar 2026 05:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773465373; cv=none; b=nlO6LN8v7qIaNimZ742Cf3Shf0z9qc45VmT6pUqIhCs30Y2TX3cyMqRgiMylJ4pREFDoSzSL6MOO2QMdRIrNtX332rMIwB6d3xdtHxkwRfYr3JH9wyNMJj5dlG1Lqx13pyH46l8moOqk7T3NXNqdCk5mHOj/BHebR1BWOy0Q2MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773465373; c=relaxed/simple;
	bh=12o/HG11CudirfU0TkEdIPweXENwrsAUAA7FpVCP0y8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SOrvthDhStCVBk2c92OUJSgL0cRa2QTt1Tf+0Bt2OHkZ7eNFFH9I0EZPnx8Bq5MavHrwBZ1XSwfpk6PVAtXtkrb8rsvvHJmu5NXPtA5Nn8yOYygCP63bHpSkVxCuULkQWyg6O0ZbWCigvUQdbqeJGI9F/fFVZ9jAr1u17KPzdGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=g15OuUcF; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="g15OuUcF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aYsiJm+cVNjpPB5eB68gcD41Q1iL9CSLRQdu295HLIc=; 
	b=g15OuUcFglof5m6NsSB9qfhT29Bv9G7Ht0w/C9Ux/rR08m2q+3jbLXvSP1XUNFvaG3ecErxvINT
	9tjFQsx4GwUNALeuqk4iJrli0NxRKQZpLTo31VddenSqd3inW0LWv0sXeW8KC+rg1WLmShx6gF0vr
	mmkAfI1BetOWRmtemeo57ucmnrP7vPlKHG3qquRqH+K95MSBjkk+bWjQ4RDUKuaAogTBPkJ5W4B+S
	Sm50CYtX3LmcAc5XxLFPsk0spZgYHhrcaD7Ccg17AOeg9Li/FubWUNId1DUsEbTVZEBEFCXvnVrlU
	84N98lsUSpGKOIpi5XpYy1y2/lmxpYc1QWSQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w1HM8-00ELBC-0V;
	Sat, 14 Mar 2026 13:16:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Mar 2026 14:16:08 +0900
Date: Sat, 14 Mar 2026 14:16:08 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
Subject: Re: [PATCH 0/2] crypto: qat - GEN6 firmware loading fixes
Message-ID: <abTvGNgmwL77Hl5F@gondor.apana.org.au>
References: <20260305085955.66293-1-suman.kumar.chakraborty@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305085955.66293-1-suman.kumar.chakraborty@intel.com>

On Thu, Mar 05, 2026 at 08:58:57AM +0000, Suman Kumar Chakraborty wrote:
> This small series addresses firmware loading reliability on QAT GEN6
> devices.
> 
> The first patch fixes inconsistent whitespace in the macro definitions
> in qat_hal.c, switching from mixed tabs and spaces to tabs throughout.
> 
> The second patch adds a hardware-required minimum 3 us delay during
> the acceleration engine reset sequence for GEN6 devices. Without this
> delay, firmware loading may fail intermittently. Earlier generations
> are unaffected.
> 
> Suman Kumar Chakraborty (2):
>   crypto: qat - fix indentation of macros in qat_hal.c
>   crypto: qat - fix firmware loading failure for GEN6 devices
> 
>  .../intel/qat/qat_common/adf_accel_engine.c   |  7 +++++
>  .../qat/qat_common/icp_qat_fw_loader_handle.h |  1 +
>  drivers/crypto/intel/qat/qat_common/qat_hal.c | 27 ++++++++++---------
>  3 files changed, 23 insertions(+), 12 deletions(-)
> 
> 
> base-commit: 3f61a0a3491596d6973e132848fead2dc5fa7ad1
> -- 
> 2.52.0

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
