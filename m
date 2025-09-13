Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B3D02EA73B
	for <linux-crypto@vger.kernel.org>; Sat, 13 Sep 2025 10:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757758182; cv=none; b=POUl8zWRnERC5yf6UJjSbBVG1P0Zos4Y2ej265tNk8XpFRhStHik9wclqpd1eEDYQEudh98BIXI+j5FKiDEyoKKbGGBfg4t0hxflfETYCcjqnGixaN8JmGyR0xtvU2ybP38yTop4OBMsrq+OBZbpW2hZUGZbHGg0rO41L4+I3hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757758182; c=relaxed/simple;
	bh=HXD9XDW/6E7QMSaoYLhN8TVvh3jfCTb3k7Ruiiq7A58=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=F47atbhHMI0kUPx0kjnwjmWsjs38rgroGV6rwnbrBO/0TvFM8W/PNv7UGSkwXtT5JV7A9LKiCZsAPHX3SDa5uDLQK7Ue4oEVh6d0kF9npRIUFfA4Cz/lHQ2R7Z3D/P5tb9/fwtEzhaHwkEwXrqa8aO/Tc65th/OKPbYpmTv793U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xH79iFDH; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xH79iFDH"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757758177;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HXD9XDW/6E7QMSaoYLhN8TVvh3jfCTb3k7Ruiiq7A58=;
	b=xH79iFDHQ8QnmFHPkYte6F4ZxAI8YLfCMV1jn5ZuiA6aoDjzo77jzg7ksOmz9uhSDHkUI8
	Ex3d6GkoPdbQOlmt24UMVl+5ZIn4dUUBMOFnabsoT9n3DYBaJQ3ATQhzlxbPjLydd5cvK5
	0YlGMRrcMQ/P8G2uUASp40UxJl23Tjo=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH] crypto: qat - Return pointer directly in
 adf_ctl_alloc_resources
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <aMTyFx91lhp9galJ@gondor.apana.org.au>
Date: Sat, 13 Sep 2025 12:09:25 +0200
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
 Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
 qat-linux@intel.com
Content-Transfer-Encoding: 7bit
Message-Id: <76903217-7496-475E-9477-CADE1CB6C211@linux.dev>
References: <aMTyFx91lhp9galJ@gondor.apana.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Migadu-Flow: FLOW_OUT

Hi Herbert,

On 13. Sep 2025 Herbert Xu wrote:
> Returning values through arguments is confusing and that has
> upset the compiler with the recent change to memdup_user:
> ...
> Fix this by returning the pointer directly.

I didn't notice the warnings, but thanks for fixing it.

Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>

