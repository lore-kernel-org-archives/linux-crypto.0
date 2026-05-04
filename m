Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197603DA5C7
	for <linux-crypto@vger.kernel.org>; Mon,  4 May 2026 13:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777900534; cv=none; b=qH5kxHPI/5njlwbOHB4gmz4yxeXh8INtNmFRWn6lP/2hypiJRY5MHXZMKYFcbTGAUqLsvcgRX+M8JVzUv99alaoWo+NmUhFV9dQv9/s6/ohfgytrWhNVPlW17i4oRNrgyBE2wRIZYhtddxYodWHVfamoEZ3a/7tzTUW7clS7P5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777900534; c=relaxed/simple;
	bh=nNRtWEvgEcOeCWrFpdJ5bMrM0PjrSphj5OnvXZ3vQXI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aet5Y2HP2NNm00a+rFTnoX6Xyd4MxZEWGCPzByRhL7cjQE9bPHFOwZj4BNbYT/TDr+djMt1/SPy+YCG7V7N2rdZLXrNGl4Sa+Fn8it264sEQevQ3R7lEPxQ/ZulX6x4cgiy2KYJ9/6EBwY16ZUqhTAttQTXEL4fi1daqktXdgoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RP8vriHR; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RP8vriHR"
Date: Mon, 4 May 2026 15:15:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777900528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qbpKOLCRWIuTpDyaMhLtUYPmrV9m20KzgcOyXnrlcV4=;
	b=RP8vriHRHHkDoK2a05AsTKNBu6mBItNjqw6GV9iM+AWEZysKtSFmmebColn1rGrxhpF5Rn
	4ldZ0oIRNyJYKryRQxwEVjHZESpexITFCZtfw091les7W2XehD3oaA6E7UDPf3Uh7Omg2u
	BuFATlnEyy4NlMv8xoN+RU4h2KH74u0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Lianjie Wang <karin0.zst@gmail.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Olivia Mackall <olivia@selenic.com>,
	Manuel Ebner <manuelebner@mailbox.org>
Subject: Re: [PATCH v1 1/1] hwrng: core - Replace strlcat() with better
 alternative
Message-ID: <afib61h9JJPiPcMv@linux.dev>
References: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504130259.473382-1-andriy.shevchenko@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

On Mon, May 04, 2026 at 03:02:59PM +0200, Andy Shevchenko wrote:
> strlcpy() and strlcat() are confusing APIs and the former one already
> gone from the kernel.
> 
> In preparation to kill strlcat() replace it with the better alternative.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

I already took care of this one a few days ago:

https://lore.kernel.org/lkml/20260430110047.248825-8-thorsten.blum@linux.dev/

Thanks,
Thorsten
