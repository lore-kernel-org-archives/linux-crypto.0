Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086744718DE;
	Wed, 23 Sep 2026 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790153904; cv=none; b=WfCrusSS4vj+8hwoEBpzFmh6neNJbaQdHmemYPTzrt7o1griaCiU1P7fnK+oCUv1gpB/D6iFeagWI+J7CQ149ZfP/QNv0GlnQdyd7n8RYedz2p5ls0AXU4mRXE9g+CL+oTpitoqabbQx0OApM2okdzvlxxvYIq/KFfRQN6ckxiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790153904; c=relaxed/simple;
	bh=W7ycSWwexvfwxIUI2s5ofsjl0342yi3qltm5fcwvZS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NyyHYn4lrB5GncjfZMJQBTA9nhHzngqOCp4OfbaD+Lj4tlVM6sR5txT5n0ja3hO6AWRbyaxSvjLfDK2fAmrL7WfTeC2vABrQ8A3ZiVzuP7bGXgnQMVt2i+2UFMP9f+5/uJi/+33y40tAA4uGKigtAqKNSIIi3LjnQe+bjSgIaBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=No5/6jR9; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="No5/6jR9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=gX2Nzj033hZljEmf63Fd9NSIs3Ot6MVPt6pHYQgS5l0=; 
	b=No5/6jR9zlNOJsQvq/yhcHzpITKm5r00jzOfD57Uh2URXpsHiz1bHa1rzwmXKvgDu0WWgj0OBGg
	12IlXmfHDLGz3+MWdTdhis+9WxbepDtMcQenNpnCPRCnvKIjUfs3TQIbTxYgpuiPdiJI1nby/+kvg
	CUou6b879sPG8MdrhLTPNc0ElNZlQQ4gaG0/Eigzg+lFTWtH1sSRlTQR8vOhfrx21c8g0gkBYFiRq
	3hS8hPUDQqGPoTIim5TgBjLaaqd4AoILvaMh74JfCEhHppbUA+zKlJHJQVoK+GndvKPInLwgnmW4G
	mp8dn3yGPHwl1jc/mZV/iJZRv+8K7MjtUlNA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1x9Iny-0000000GyP1-11IA;
	Wed, 23 Sep 2026 16:58:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 23 Sep 2026 18:58:18 +1000
Date: Wed, 23 Sep 2026 18:58:18 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiale Yao <yaojiale02@163.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Gary R Hook <gary.hook@amd.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp: kill v3 IRQ tasklet during teardown
Message-ID: <arOUqlZeLog6xfqs@gondor.apana.org.au>
References: <20260920173407.2126086-1-yaojiale02@163.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920173407.2126086-1-yaojiale02@163.com>

On Mon, Sep 21, 2026 at 01:34:07AM +0800, Jiale Yao wrote:
> On PCI devices using MSI-X, ccp_irq_handler() schedules irq_tasklet. The
> teardown paths release the IRQ but do not drain a tasklet that was
> already queued, so it can access ccp after the device-managed allocation
> has been released.
> 
> Kill the tasklet after releasing the IRQ in both the initialization
> error path and ccp_destroy().
> 
> Fixes: 7b537b24e76a ("crypto: ccp - Change ISR handler method for a v3 CCP")
> 
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  drivers/crypto/ccp/ccp-dev-v3.c | 4 ++++
>  1 file changed, 4 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
