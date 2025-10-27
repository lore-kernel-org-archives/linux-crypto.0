Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DA62264A7
	for <linux-crypto@vger.kernel.org>; Mon, 27 Oct 2025 08:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761554626; cv=none; b=RMVbtaiW+woqU4WNC4bZzF8frHzibVGQwBIHGb/CLTbgzJdCMfZL0VkdcOZsN4c3BHuEFwleM0vDeJU1tpkHwBNKD6POha7GZxtbRx6FZbj6YfcJAGdp9pCNIxFxX3z1TIXz3hB/ysP0/DuEA1Lguk6h5tc2DNFpFRWHBLbVU/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761554626; c=relaxed/simple;
	bh=tqv9oNTMFeWo+CDUalWwdjt7MmuAOQ3CpjGUhS8s1+k=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=aS24sdDe0RaWAwPg3g47Xu9+pVm5SZ0ILLc3CjJhPZyeo5EYJiaWV2QHPekQTe0g8E4s7BjUF1zQQ3I+5SoFiqMHoNTYhaoCq7t9HzqGr8bc2BZuNg1kr8l626G/r3eABIboz620Bk1LlfLtbMpE5qkixCwYiRj1cqpNGjDjXeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jf3C5XbZ; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jf3C5XbZ"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761554622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqv9oNTMFeWo+CDUalWwdjt7MmuAOQ3CpjGUhS8s1+k=;
	b=Jf3C5XbZQtat3jQ0BW7uYQK0E3POXTU4b/IXxb/60LgzcXIx31edAm+lq9U0g478lPOVCI
	kEzpLd6gI9fXWNYRrpZr9BxSgvSJ9IKfsNqeY99L07HbJ9Nj8qwC07TRJz28rA9hFHjVAE
	oZTNfpUDhEDUTNUNc7ifPX2vIa4zOaI=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] crypto: qat - use strscpy_pad to simplify buffer
 initialization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aP8rHYq4I09pvhFa@smile.fi.intel.com>
Date: Mon, 27 Oct 2025 09:43:02 +0100
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Jack Xu <jack.xu@intel.com>,
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
 Qianfeng Rong <rongqianfeng@vivo.com>,
 qat-linux@intel.com,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D4A83F19-05EC-42AD-AD6B-B096E0303C2E@linux.dev>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
 <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
 <B981F95A-287C-44CF-8852-B4642E728975@linux.dev>
 <aP8rHYq4I09pvhFa@smile.fi.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

On 27. Oct 2025, at 09:19, Andy Shevchenko wrote:
> On Fri, Oct 24, 2025 at 08:47:02PM +0200, Thorsten Blum wrote:
>> [...]
>> Any recommendations?
>=20
> Yes, fix checkpatch as per commit 885e68e8b7b1 ("kernel.h: update =
comment about
> simple_strto<foo>() functions") or ignore this false positive.

Thanks for the commit hash. I ignored it and submitted v2:

=
https://lore.kernel.org/lkml/20251026015710.1368-1-thorsten.blum@linux.dev=
/

