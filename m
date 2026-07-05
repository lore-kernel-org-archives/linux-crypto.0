Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AE42C0296
	for <linux-crypto@vger.kernel.org>; Sun,  5 Jul 2026 05:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783229623; cv=none; b=UO02aNkE5bsLnbEs60IIAGskiPFr3DkL6U7U7qTeedCSsVhf7J0ewrNKJoad/Y5uGITsmhb8bdgpLeDhYP/bx2Nxr+hOby4GjUR4TNOeeOauTpeGgA8JPNSQdKKlDXYpJpi2iw090+I/qd1lGSjj8k1YhXvH4zRRy8XIYuDnDvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783229623; c=relaxed/simple;
	bh=NeIbXBDg9sY9u4gAnhjeG2uKeAkUhD+l18AFRm4+POE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KtqzjINfWu3K4pDBEfrFFPNjXHjKbFwIUYxYdA9kFN+l3MAambinZILQEE3HihXuCK5+fEinDZOzX/t+e/u3FCr8Pk9fhhOIEHvZD2qMghBxPGpBxspvXQbjzgqWUxgm6nqdwNLoPUcpGCfONGVfKCrIRSF6RkPRnxULnAw2n8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hOaup+t5; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hOaup+t5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BRkbh9w2c+zAjH58NXsWsFks3bAu/1aefpyeKz6UnSk=; 
	b=hOaup+t5fnbjX50+vxSAnF50c4dITFDBSMqwxWfqWmjWQsTKXag58D9PHoVdtamvQMmL2FLmoqS
	KhzSSCtvYeHv/LNTWXnFv7bPx6aHkwEArNguf381vXPjO8W6GDN1UZ+heOpSUfw0ZeYD1FpXRNFgd
	gbHXXKPNKEksV9/yH41VlqwqO2NjQIjHo2Q8o/zW+W9ZyM5C/lajOTP9ZRiOObBnCCYlkcDr6FUni
	MrZgAfmWO0MCgSVaPKirdo3lCo2HfyHFWSM/CQ+C8+AcIjwoSERaE8GGNJLhmvTo8EffyUdAEtGCW
	wQRXwncRuEoDouHlJzCgqoCLwJQ4XgR96V4w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wgFU2-0000000AjgB-0VL6;
	Sun, 05 Jul 2026 13:33:39 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jul 2026 13:33:38 +0800
Date: Sun, 5 Jul 2026 13:33:38 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	Ahsan Atta <ahsan.atta@intel.com>
Subject: Re: [PATCH] crypto: qat - cancel work on re-enable SR-IOV timeout
Message-ID: <aknssg1kRsm9zHt2@gondor.apana.org.au>
References: <20260608150104.135313-1-giovanni.cabiddu@intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260608150104.135313-1-giovanni.cabiddu@intel.com>

On Mon, Jun 08, 2026 at 03:59:40PM +0100, Giovanni Cabiddu wrote:
> The QAT reset worker queues SR-IOV reenable work using a work_struct and
> completion embedded in an on-stack adf_sriov_dev_data. If the completion
> wait times out, the reset worker can return while device_sriov_wq still
> holds or executes the stack-backed work item.
> 
> Cancel the work on the device_sriov_wq on timeout before the stack frame
> unwinds.
> 
> Fixes: 4469f9b23468 ("crypto: qat - re-enable sriov after pf reset")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Ahsan Atta <ahsan.atta@intel.com>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_aer.c | 2 ++
>  1 file changed, 2 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
