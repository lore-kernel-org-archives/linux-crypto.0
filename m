Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C3554706A
	for <linux-crypto@vger.kernel.org>; Fri, 18 Sep 2026 09:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789725297; cv=none; b=D9/rTGXu2+LjXnUf+eWuZHXy5XgU/5pbEcCQjLWXPWySsqHjtKJ62gwwmsFWyhHa2lktPHNzgnX7bbN0FSdazJVmZC4SrDBAxqIFheagrV1oTJNGovSMUSHPNkSmYZ3B69qf/P+1vB3YcKcYnrAhU0x7njQdklZ7+QVUSL+t5oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789725297; c=relaxed/simple;
	bh=4NuhKEf9tZwRxhy0WfTypVHrUR1vOV9UmtHO970Dbmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LdhvkwHoJl2qsiNef/FsZnxt13BlLUhWBwgFPhXiwNC3hB8IgUWVBv1O/cUiu83pMVssAkj7AJj/w7H+JzVtWpZumydN4jSa3710HBKiSfCfPe2LRRJ5dQpqNAphEVyC/pcJJkOAOSpa6QOOHAM64Mk9QzdQDCzPdzy06sKd6us=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=O6kwHzlk; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="O6kwHzlk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=1Inz3fB4nVm6Vrp/2E01v6mN2JtwXOryqMXxhgkKTUo=; 
	b=O6kwHzlkr5kHL3EU3qgXHg1Nt55i3V+BOcpkoxCg0fWNOeaxf6DUeTGHFdRHCnjuCbZUn3GCfPW
	sa9vOEH+a2DeCYOMqd+C7vDHvxKV5D8akrPxvlP+NzcB/jIZpXzBSF8N7uINGuTAgjJxq9T83OH+6
	Te6obxxuIve6rCWXW3PwwSKQPjqJc1rg9GApQqO+tOMJLM02wELZLZcCdavxERbBPk7Bxs392OX4z
	tWYx7ohdDQQqDOV8Vwan7LiQDBd1bJMPTWXdOB6HsM+9cvFlfaV50IBknVcYYVi82YvV9RwhkdhJm
	Bm2V2Ne1mNpNZVNPhIfwhSH7AWXGn6Nh7F1g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x7VIv-0000000FM1o-1d8G;
	Fri, 18 Sep 2026 17:54:50 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Sep 2026 19:54:49 +1000
Date: Fri, 18 Sep 2026 19:54:49 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ahsan Atta <ahsan.atta@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH v3] crypto: qat - fix active_devs leak on crypto alg
 registration failure
Message-ID: <aq0KaS4qksSG5nTO@gondor.apana.org.au>
References: <20260909141521.1821101-1-ahsan.atta@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909141521.1821101-1-ahsan.atta@intel.com>

On Wed, Sep 09, 2026 at 03:15:21PM +0100, Ahsan Atta wrote:
> adf_dev_start() registered both alg sets in a single condition.
> If qat_algs_register() succeeds but qat_asym_algs_register() fails,
> ADF_STATUS_CRYPTO_ALGS_REGISTERED is left clear, so adf_dev_stop() skips
> qat_algs_unregister(): the skciphers and aeads stay registered with
> active_devs stuck at 1, pinning the module.
> 
> Both helpers leak active_devs internally as well - they increment it and
> return without decrementing when a crypto_register_*() call fails, and
> the asym path also leaves the already-registered akcipher behind.
> 
> Split the registration in adf_dev_start() so that an asym failure
> unregisters qat_algs, and unwind active_devs (and the akcipher) on the
> error paths of both register helpers. While at it, propagate the error
> code returned by the register helpers instead of a blanket -EFAULT.
> 
> Fixes: 9b2f33a1bfcd ("crypto: qat - fix unregistration of crypto algorithms")
> Signed-off-by: Ahsan Atta <ahsan.atta@intel.com>
> Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
> Changes in v3:
> - Added Reviewed-by tag from Thomas Huth.
> 
> Changes in v2:
> - adf_dev_start(): propagate the error code returned by qat_algs_register()
>   and qat_asym_algs_register() instead of returning a blanket -EFAULT.
> 
>  .../crypto/intel/qat/qat_common/adf_init.c    | 24 ++++++++++++-----
>  .../crypto/intel/qat/qat_common/qat_algs.c    | 15 ++++++-----
>  .../intel/qat/qat_common/qat_asym_algs.c      | 26 ++++++++++++++-----
>  3 files changed, 45 insertions(+), 20 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
