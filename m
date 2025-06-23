Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0500E1F1522;
	Mon, 23 Jun 2025 09:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750670698; cv=none; b=Pcpvu2MDymTyYnoD5JhsRK2hOTk0gaxTFzK/VI/GHeuibijlx5XQNU0OLEYR7YlzQkyLTtkPu0nx4aaPqlmFfEgeG0ao8VqQT9VQSygMo3YuFY1hqQHga0riH8va/AkHnOJHlAa0VQfE4L25jNVNMV7ix7PjlFzWZVbAbPi+V38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750670698; c=relaxed/simple;
	bh=yxximNRZg10fk70Q/eGnQ3KnoNbsSsD9NHTqlJs2ZC4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AlvwVVTG67aZqHEPjEJRh5O1DfvWuiDoda4sb4qryrws/eGXzByZBWzSEeKGvlpRrgzGBQ0wo3bza5poX5qFGzGbIMcuJeGHByMcu3zXTHJrtcGaj4AqsvW0og+F+tZ8aDIVMabSO9nueyV3Mtv4pCtrovW/GtF8fj3ga5YkpCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=l9AhgzrC; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="l9AhgzrC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WYO6dUwunWcz7wqIiPUd0m6sJh2n71+M5Cw939+rQ/c=; b=l9AhgzrCOXC/8F7TPB047C1Yzn
	k8leIX5hUWqLGKBzUTl2CgMFmuO/+PLau/3cGqmFsM0o3nfrA4Y/c3lDJvqZu2zoTbFJ9uprXYokD
	McBEWZnFs7yheb1sZrk2WNnagX7WrGtIDcA+/DjiPdgtWFCB8Ybta4iG6ScV+5MNB8NKcAq4JaL4c
	4yD1qQOIEqucvjwevfRNhKAuDA5EvCRIltfWN3/L0HmXy8+Hx5yaX9TPumhH4KJbJ4NPwjWYYd8pu
	k5FiU8bvFRfmMOeIkG2/eUafbx7SsIhYKYqBCWyc4nKqKuV24VR1cM9krjKZeDCoPoKBJgyuSfzds
	RVpMzAkg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uTdAa-000FeC-2O;
	Mon, 23 Jun 2025 17:24:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 23 Jun 2025 17:24:49 +0800
Date: Mon, 23 Jun 2025 17:24:49 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ashish Kalra <Ashish.Kalra@amd.com>
Cc: thomas.lendacky@amd.com, john.allen@amd.com, davem@davemloft.net,
	aik@amd.com, dionnaglaze@google.com, michael.roth@amd.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [RESEND PATCH v3] crypto: ccp: Fix SNP panic notifier
 unregistration
Message-ID: <aFkdYX1tZsESRpne@gondor.apana.org.au>
References: <20250616215027.68768-1-Ashish.Kalra@amd.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616215027.68768-1-Ashish.Kalra@amd.com>

On Mon, Jun 16, 2025 at 09:50:27PM +0000, Ashish Kalra wrote:
> From: Ashish Kalra <ashish.kalra@amd.com>
> 
> Panic notifiers are invoked with RCU read lock held and when the
> SNP panic notifier tries to unregister itself from the panic
> notifier callback itself it causes a deadlock as notifier
> unregistration does RCU synchronization.
> 
> Code flow for SNP panic notifier:
> snp_shutdown_on_panic() ->
> __sev_firmware_shutdown() ->
> __sev_snp_shutdown_locked() ->
> atomic_notifier_chain_unregister(.., &snp_panic_notifier)
> 
> Fix SNP panic notifier to unregister itself during SNP shutdown
> only if panic is not in progress.
> 
> Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
> Cc: stable@vger.kernel.org
> Fixes: 19860c3274fb ("crypto: ccp - Register SNP panic notifier only if SNP is enabled")
> Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
> ---
>  drivers/crypto/ccp/sev-dev.c | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
