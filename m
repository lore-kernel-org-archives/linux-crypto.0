Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C63324A043;
	Mon, 24 Nov 2025 10:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763978862; cv=none; b=QN7xZMzDAYaaPV9nuqXZ8JgFh5QTSDjIDGwLBFIuXXeatowXPYGYwBh4qmBqxVpLkRsNTy6pL/ow6n/LHaCaeiWGusd2egvVQ4vZK5cfpNv0PvY/WYM0VX+tjl2bppKk4gQmVFxxc3LWr7kjegxcjRQZSpc/5i2pmlCHBGpXBQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763978862; c=relaxed/simple;
	bh=+mwAHnrUGHFDKB8XZfif0JXTCXVB4n3qcjzaW/132r0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WrtwPftN3cZmfeq/GwLMWve/YbwNHehYvL5tJLYjIJBrOMw7a4RjwT/oEUXNLWr3bLGSJULHaSaMzbkhsrch3BpXxhzyvFlsOdBejuuJw6MsmfPaAQgI2Smi51KTVYYHy9IWcKYHX9paB2ZiOj3vgcLkEH0tN366lrp7+mKLP7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cJa0V8Fn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cJa0V8Fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C154C116D0;
	Mon, 24 Nov 2025 10:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763978861;
	bh=+mwAHnrUGHFDKB8XZfif0JXTCXVB4n3qcjzaW/132r0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cJa0V8Fn59Isf1jQzAgwgA/1y9fdT8D3/yM030TrbakBWifL27QssEQWKp2nh9C//
	 JtUwpoT3m+7Vyb+unNxRzyoN+W5XLwzfcoz3rVTV6HidrpRokxJY7HT6jIpEFf4yAJ
	 M0wDLifsiGT2Vr+U1gUNoEW4L32oKtYCJljM8TRD9VuYoPM2PaE87SXyJVEuvKCHx4
	 kTcG+FtuuBn8MqCtVKGD7lfO9fgqNWNI+lb6s6mviRqJrGXO+TPmY1/n055p4NXCvh
	 jrIn79jrPymrEuAqogb62MzRDgQF7sEyUFC2Fa6BJUrH7k+MKoTNMyByvMz5QywUQj
	 ndCN+bq3egLpw==
Received: from johan by xi.lan with local (Exim 4.98.2)
	(envelope-from <johan@kernel.org>)
	id 1vNTTw-0000000029K-2v77;
	Mon, 24 Nov 2025 11:07:40 +0100
Date: Mon, 24 Nov 2025 11:07:40 +0100
From: Johan Hovold <johan@kernel.org>
To: liulongfang <liulongfang@huawei.com>
Cc: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Kai Ye <yekai13@huawei.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon/qm - fix device leak on QoS updates
Message-ID: <aSQubH4nwxgmgK_U@hovoldconsulting.com>
References: <20251121111130.25025-1-johan@kernel.org>
 <f7a83c28-af17-7479-0b39-ff3b06ee4b8c@huawei.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f7a83c28-af17-7479-0b39-ff3b06ee4b8c@huawei.com>

On Mon, Nov 24, 2025 at 10:03:03AM +0800, liulongfang wrote:
> On 2025/11/21 19:11, Johan Hovold wrote:
> > Make sure to drop the reference taken when looking up the PCI device on
> > QoS updates.

> This issue has already been fixed by the following patch:
> "[PATCH] crypto: hisilicon/qm - Fix device reference leak in qm_get_qos_value".

Ah, sorry for not noticing. I was still using rc5 as base and apparently
forgot to check linux-next.

Johan
