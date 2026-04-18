Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E6035C1BD;
	Sat, 18 Apr 2026 13:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776518014; cv=none; b=lJfwry89SWqRYuD2qbKRXePLhlYQ9pLZq0Q4FaZtgbhzoYr1i90oQAQeIl6833vGpx9Ad7InhrFoPCM/o84Pc4JuTKWlydMqiHv73P2HDPG7+8/EzCy3vfOEZEkqCPqzT/Bs0ItMk8PE1B7HwQye8VfTzQQDR/aB6M8MAdZlIfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776518014; c=relaxed/simple;
	bh=linMTRrQmbwthnOxldhn7k8UFwsFpH/puDeXwoNJ4LY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NISwtczPOIi1/XdqHoKq1QfVEAQxqef2s/iCn3H6qmXiztFueM0pw95UbvH9qnU63UOAF+wF3Tf5Fm6ZwrxZMcmWVFzaC56RYygBxySMqOUuSmysSKJkW4kpUgNIfuhwkQ+UNVpoeJdor06T7M7MjfQabe7eY40MlRJlql8ce9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Zzlh2sIf; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Zzlh2sIf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=HPsyAHKAlLETKe2yH8LmN13bz2fsZBuIi/osHntdTm0=; 
	b=Zzlh2sIf5jp6ScauHz8G8YQweRnvcRrrfXhs1MW5pCt53n11yTHWSuQEsXcvE/8rmlzbyQX+rVr
	k9iwCcVX2CqYXdLdQXqfKZnwbRIRBittC3wej6IH98BgOkANQHlyIrVRx5pZPShcU3S8ZmK9lfrmH
	Z2sQjjHxeQlBDPiXc6Ust4vJr+lzMSuG0XZgrqH20HW0fb6kQmvQq9SyxsdT/pw1al+xjTfM0tniF
	emfZGw1QmlYsVR8Qhp7up+MIO+UgU4LAF4J+xxFe+u9OYJay73POphx4b7O4qGzGKn4ySmQyNuIjp
	7CWpXNHKFLP02xEKBc1eRAPg1dRMdkCOquyA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wE5UB-0070y0-0C;
	Sat, 18 Apr 2026 21:13:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 18 Apr 2026 21:13:23 +0800
Date: Sat, 18 Apr 2026 21:13:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	John Allen <john.allen@amd.com>, kvm@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Tycho Andersen <tycho@kernel.org>
Subject: Re: [PATCH v3 1/7] crypto/ccp: hoist kernel part of
 SNP_PLATFORM_STATUS
Message-ID: <aeODc6v3Ok5Dwq5U@gondor.apana.org.au>
References: <20260416232329.3408497-1-seanjc@google.com>
 <20260416232329.3408497-2-seanjc@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416232329.3408497-2-seanjc@google.com>

On Thu, Apr 16, 2026 at 04:23:23PM -0700, Sean Christopherson wrote:
> From: Tycho Andersen <tycho@kernel.org>
> 
> ...to its own function. This way it can be used when the kernel needs
> access to the platform status regardless of the INIT state of the firmware.
> 
> No functional change intended.
> 
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Tycho Andersen (AMD) <tycho@kernel.org>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 31 +++++++++++++++++++++++--------
>  1 file changed, 23 insertions(+), 8 deletions(-)

Acked-by: Herbert Xu <herbert@gondor.apana.org.au>

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
