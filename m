Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C54364E81
	for <linux-crypto@vger.kernel.org>; Fri,  8 May 2026 20:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778271107; cv=none; b=P1MH+t4+dHKz1dyC+xgKbNUTYR7QRnKUa6Csu509UKpelzsu6NHLRkZT/9wf9p+c1vOePkzfLd8WLJ7BTXVd0cg0oUr9wedKXmM/LYkcIi59Qf1xI6t8+R/9HkpSkhX9VKTvj1nIrDw5Zsnfy5pxyXLYs/6RO9jCs8K8BvoxCFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778271107; c=relaxed/simple;
	bh=gFM+1DtlfWABxcetTW+y/wcHkrJwYbA8IwlYL1+XUC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uApgNz2u/aDIdAA55dbhExCvS/O7THL24hhF8kzFzdjRJg2VL60xAJ0N9GSGh+1V+jOfXjfBTT+dQTAfP57bD2CVZvkhVBBmF8FkbGd1VcxzaBNQch698jQj6TrNIKutf9WVGmXbPpqAtARBuRN6njvxeqZdT0VyDaDmzMrqaa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cJ3QEDVU; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cJ3QEDVU"
Date: Fri, 8 May 2026 22:11:25 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778271094;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ryCh/KwkvC7J+1KyZjp5sJF3n83AW+FG1o3Sx2IpqQ=;
	b=cJ3QEDVUprgH40Jy/nzJyk1skLtPJXfkuD4T4cWVzOibpTTw4ybt7pQYsNv3cemWpV89of
	UG4G5MCFLfXeywMq23Jq/DbhBfPKqrOgsRcKecuX9aUYJyDqq4uyAfpkiMR9AjzAq5Zdrj
	CVrDjQSarBqAROO7Zeaw+9rOAEXRi3E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: use designated initializers for report structs
Message-ID: <af5DbZKdf5u0H_-1@linux.dev>
References: <20260508105717.472043-3-thorsten.blum@linux.dev>
 <20260508184013.GB4145640@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260508184013.GB4145640@google.com>
X-Migadu-Flow: FLOW_OUT

On Fri, May 08, 2026 at 06:40:13PM +0000, Eric Biggers wrote:
> On Fri, May 08, 2026 at 12:57:17PM +0200, Thorsten Blum wrote:
> > Use designated initializers for the report structs instead of clearing
> > the struct with memset() and then copying fixed strings with strscpy()
> > at runtime.
> > 
> > This keeps the structs zero-initialized, lets the compiler diagnose
> > oversized string literals, and makes the code easier to read.
> > 
> > Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> 
> Did you verify that none of these structs contain any implicit padding?

Yes, I checked the structs manually and with pahole, which also reported
no holes. The structs only use char[64] followed by unsigned ints, so
implicit padding shouldn't be an issue.

Thanks,
Thorsten
