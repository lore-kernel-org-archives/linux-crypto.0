Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33AC15A864;
	Fri, 17 Apr 2026 01:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776388947; cv=none; b=tbf8NrRt5rfBOOEIM2q/XGmkfup/Y16m8NWfCzUUgdE6Emwi2dGTDprJPI1fn9dWX4mvRx2vtiT4z1aXjrSw090qq5lfPZxAZVkh4TXFnkzAmqU0+hTVkVHbKcjcvU0B8NDx63yHcf5osA19G0LnfWccj9E9NmUcG1XwFaYf7Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776388947; c=relaxed/simple;
	bh=CG/NCwO+nPOC20Kz0LGE7rqG2F59/6JWtxYLDPHWBXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTWJiRX7e8AsuV0G0WGzH7AIYRkXL1eFl2qg4joXeG47JPIhdH6OHfNUtXUz25MoAupxvYP0dhL0ZOd2qI9Wa+06WmTDN4Ng9O36EQLGkqPLGwCYl2/2xN0XriAQ5YnJ0iQf88RK1kKnTyJPumrZDpmPiytiRW19sTXUesAbANQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=YzXAvkC/; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="YzXAvkC/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=A8ox5tavZ4O1d/3nbNfsxMmrke14ukZABfXa6XYclBE=; 
	b=YzXAvkC/aTuN6hcOqY0BSZbC0igguEt+AqnOjbpOeHIab9+hOWLFFunPIJnVkOgjqQE7IhAQ5hu
	WjbI50xqezJBXyxwl/9LL7BLjbzY3S6bBp2HqcYGMlfPHaq3kZUXN7fSxZC+U68VfnNFI2c1ltA6o
	T3Dvhqf55vk0vAS7jbT4jiQ9THh/zM/t9koLOmTM3CDqwRqDhAXqat+/OwMuUbfab06TZ4FR5t6jG
	kjHwFjrZ5B3qhqpMaoHOdI/+Uoe2JkvhIkykWq1UTKec72oWTIkz7hIrNNtl9GQcPKevyV01B+XN9
	ZPRyf1kxFzZz6Mfa9X/gMPyDie4vCJqKfG8Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wDXuN-006gxx-21;
	Fri, 17 Apr 2026 09:22:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Apr 2026 09:22:11 +0800
Date: Fri, 17 Apr 2026 09:22:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Graf <tgraf@suug.ch>, David Vernet <void@manifault.com>,
	Andrea Righi <arighi@nvidia.com>,
	Changwoo Min <changwoo@igalia.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	linux-crypto@vger.kernel.org, sched-ext@lists.linux.dev,
	linux-kernel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
	netdev@vger.kernel.org
Subject: Re: [PATCH for-7.1-fixes 1/2] rhashtable: add no_sync_grow option
Message-ID: <aeGLQ2X_svzH_00M@gondor.apana.org.au>
References: <20260417002449.2290577-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417002449.2290577-1-tj@kernel.org>

On Thu, Apr 16, 2026 at 02:24:48PM -1000, Tejun Heo wrote:
> 
> The follow-up sched_ext patch is a fix targeting sched_ext/for-7.1-fixes
> which I'd like to send Linus's way sooner than later. Would it be okay
> to route both patches through sched_ext/for-7.1-fixes? If you'd prefer
> to route the rhashtable change differently, that works too. Please let
> me know, thanks.

As I said earlier, we should work out if this is really needed or
not.

But if it is needed, we did have this feature before.  It's called
insecure_elasticity which was removed because we moved all its users
off to better solutions.

We can always bring it back.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
