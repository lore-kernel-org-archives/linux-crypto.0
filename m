Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06091E502
	for <linux-crypto@vger.kernel.org>; Fri, 24 Oct 2025 18:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761331664; cv=none; b=OOng/em/dlGGv44OH4x14lOZWMc6HBRb2lSJNf9y5nLQ6xpk7csr/Nr5Qcars1zDBSYCsVgutD5MF+jRaiX2zKxf1V4hVEnBlAALkGOlJ59LfJY7ASNycIzbbMA4guW5bvokZcPkTn5pxUqiWLilAUqPcKqH9WBp0Wmaw8n9vsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761331664; c=relaxed/simple;
	bh=+eCIF2IlRSgLtgqyMLdcppY91B3d1Izx9iwRGwuPGmw=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=MeMRgKGOPVRB4nz26E1ghjqeBsk+jNpec2n25Av/IU6T1ApnRip3BBHjllcivrX4oJf/Z9voLhzulYNBOwE5nQ/yiWaIQNha58r+GcgccuJ1c6FzTPWOmD//fnTFupMnQ/t6kRHLnXMo7zG3SxJZJFaczvCOE76i3h6HrFBW8pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ReLU5l2p; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ReLU5l2p"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761331656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nyaAcUFtdOezW/04o42XGGlpnb5s60o3ly6brN/viLg=;
	b=ReLU5l2p4uD9wbKRbRjyugxHn76F9XWdy3acBYw8rJJC3CReYIFg4GyjwzFvz0G+SZ8ZCV
	W/eh+kIrPxBLzNtJTN7g6eLxxUPp8ra6Lj7a681wB4qG5L7z9XYuDomkbodq7zCVdZFUyy
	BpaKJhbPFYlb7XfvZyiqOysELUHBXDc=
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
In-Reply-To: <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
Date: Fri, 24 Oct 2025 20:47:02 +0200
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Jack Xu <jack.xu@intel.com>,
 Suman Kumar Chakraborty <suman.kumar.chakraborty@intel.com>,
 Qianfeng Rong <rongqianfeng@vivo.com>,
 qat-linux@intel.com,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <B981F95A-287C-44CF-8852-B4642E728975@linux.dev>
References: <20251022123622.349544-1-thorsten.blum@linux.dev>
 <aPkfsuliKYy5UAbB@smile.fi.intel.com>
 <6DB96B06-108C-465B-9A54-88B8008DDD60@linux.dev>
 <aPp3cXRxvdJzBkw9@smile.fi.intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
X-Migadu-Flow: FLOW_OUT

Hi Andy,

On 23. Oct 2025, at 20:44, Andy Shevchenko wrote:
> On Thu, Oct 23, 2025 at 05:35:00PM +0200, Thorsten Blum wrote:
>> On 22. Oct 2025, at 20:17, Andy Shevchenko wrote:
>>> On Wed, Oct 22, 2025 at 02:36:19PM +0200, Thorsten Blum wrote:
> 
> ...
> 
>> How about this?
> 
> LGTM, and that's what I had in mind, ...

I was about to submit v2, but checkpatch warns me about simple_strtoull:

  WARNING: simple_strtoull is obsolete, use kstrtoull instead

Any recommendations?

Thanks,
Thorsten

