Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9595138911B;
	Thu, 16 Apr 2026 09:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776330411; cv=none; b=SZZT1I3BEUthYQbxmqTQHFCvFSkgW9vBEcdCVMl5mElgKF9+ATHGP4yvTkh4LRX8nSzhZIMykUfVsuuIZNILWP1LnoXj5iPf9PutEL+yo1fN21gF9KcmxYlt+QEsH0ZfWDGAkukqw7mDBzFa6nVIHn2nhnXGC7HgUWVxU72Ke6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776330411; c=relaxed/simple;
	bh=sd4l45J7JVR41fkLv7/opVSX++as0aGrrgxz+JYAvjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pp0YhvVRM3EohzVCpPAvNtGHImOe+o9J+70cm9pt+5U8JpJvmW4TmT3jaSRCEu45IdBSuzoS4aR77aqLGgNLLTDaI+N1xMmAKwlcmmrn2cunpE6k0ymNiJ8Edfc74t39B0znTbqf26ryhVTJD6pgfrhjgiHA/AWVIufGJqtlxYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=m8rWVK+P; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="m8rWVK+P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=OkhT0SJSXNUabO8sjsvBTtSy3/Xnqv7M3gz/N6ysxEk=; 
	b=m8rWVK+PwBbAdMiq6WjvcnjUrVYIDVYXKcOy6mTtCJlAEJtwJkBCJdxz5RIU3kMXpU3ZhfEUcZb
	wn4/cNzbPVSr//Y2ZQrtBGlimJj9XABAoSoXVJQzosGBT4Ngh8R+D8hMqPZjdTboLmXAYrkGiPZXA
	QXK91HiP8IEkJg6THPulcf+ph0ylUPrW0iKa3F2X0Jc63OR7XgppS0SX/MJNpqimYsqkqr6jhULuc
	5A5OQxZZY3HDdl/n1n8Lgkf92BnXyNzZw8Cd2Ssan69gOQX8TdWxDSWreNQfMkIEn0L5R64Dw0BDv
	ZtbD1uAdACjTfvGsLTgAXT1HLotOKDT/eQOg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDIg7-006VCE-2a;
	Thu, 16 Apr 2026 17:06:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Apr 2026 17:06:27 +0800
Date: Thu, 16 Apr 2026 17:06:27 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Jeff Barnes <jeffbarnes@linux.microsoft.com>,
	Paul Monson <paul.monson@capgemini.com>
Subject: Re: [PATCH] crypto: tstmgr - guard xxhash tests
Message-ID: <aeCmk6LbLFT4Keo2@gondor.apana.org.au>
References: <20260407192859.270745-1-hamzamahfooz@linux.microsoft.com>
 <adYNClYB6RY820Xl@gondor.apana.org.au>
 <adffSYxKIuaDLZit@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adffSYxKIuaDLZit@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>

On Thu, Apr 09, 2026 at 10:18:01AM -0700, Hamza Mahfooz wrote:
> 
> alg: hash: failed to allocate transform for xxhash64: -2
> Kernel panic - not syncing: alg: self-tests for xxhash64 (xxhash64) failed in fips mode!
> CPU: 0 PID: 425 Comm: modprobe Not tainted 6.6.130.2-2.azl3 #1
> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 01/08/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x4c/0x70
>  dump_stack+0x14/0x20
>  panic+0x179/0x330
>  alg_test+0x678/0x680
>  ? __alloc_pages+0x1e2/0x340
>  do_test+0x26f8/0x7670 [tcrypt]

So the error is coming from tcrypt.  I think that's where the ifdef
should be added.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
