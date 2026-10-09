Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789DF49A3C1;
	Fri,  9 Oct 2026 10:14:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791540896; cv=none; b=YFtmvOUBbyrG7AxPzpcLooCAo8UZXOVY/fioblYljKuka3xhim0X/dvNHkZut2eLz2M2WVYbUhqh4y2YcFO+VmZFH1aNZwaTZKN6Iomo8tOcNpDsSBzvJQmXntibslEOgHTJ2DCGA+BVIfjuC/5rSHzliq8DzbGfy0nDUtkMo4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791540896; c=relaxed/simple;
	bh=pVD16InXnmHTxghomgegEpy8lwjBvfKGO2XkDFxZk98=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JKhDqaWxOHUgQBTkocNCGGpbsrO3i1+w3+v7edv5Hfs0Bh9oRlQSOv21fvDYHMnqyXDtyfdFlBvGJEeFLa39l+Wyv5jfbTax9mMnTHUBHamGJRMObzips64wiE09RzjSwldrn+ZhNs4wH0I8nVRTipRFh1/+nBXHSye7hHR670I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PTgAnpyW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PTgAnpyW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE471F000FF;
	Fri,  9 Oct 2026 10:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791540895;
	bh=1OUnjufhFAj5bKUwflUsjQV0tB1mzkN+KwvUPmOroek=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=PTgAnpyWMds/u1S4c6JQhjrNirRvKddlrWKO6/K01rqjCNIL29p6iWzbXEhlubrb2
	 xlnFTj2n0dFg5zrOf1sY/vlDl4JKGmS4sDtW7MOnRChkpleCDiuGahGjlFwSoRX4sz
	 xaDLgmypWvnMSG0eY7cShdEDR3mciqwLZgFdD/90cTw0gFy8W/fbvIsbV2CceMcHPF
	 TcJA5q3jnp9F0HJWUN8rlsOeVJ2DI4kVGEMJCO1P2+4c9Q/NEmfUj85/A64m9uUURw
	 fPL0XUiIwvrV+VjlcT5AQ9OGHmPlTdaF5PleulUNW+Puv8JjBGNCXsIoTg6JYh+FaR
	 qJhEZTJlB1kyg==
From: Vinod Koul <vkoul@kernel.org>
To: Frank Li <Frank.Li@kernel.org>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, Frank.Li@oss.nxp.com
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-crypto@vger.kernel.org, imx@lists.linux.dev, 
 Frank Li <Frank.Li@nxp.com>
In-Reply-To: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
References: <20261005-dmaengine_prep_dma_pq-v3-0-a4a241f26fa7@nxp.com>
Subject: Re: [PATCH v3 0/5] dmaengine: Add dmaengine API to avoid call DMA
 Engine callback directly
Message-Id: <179154089287.553139.1067496680834545620.b4-ty@kernel.org>
Date: Fri, 09 Oct 2026 12:14:52 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3


On Mon, 05 Oct 2026 05:37:13 -0400, Frank.Li@oss.nxp.com wrote:
> Add dmaengine APIs to avoid call DMA Engine callback directly. Prepare to
> make dmaengine provider private.
> 
> 

Applied, thanks!

[1/5] dmaengine: add dmaengine_prep_dma_(pq|pq_val|interrupt|xor)() API
      commit: 4bdb88eb5496cb09902b9778ca7f4628c43b0d77
[2/5] dmaengine: add dmaengine_is_*_aligned() helpers for DMA consumers
      commit: 11e801ccaca78c9d92b1f3a9733772bf9d2c079c
[3/5] dmaengine: add dmaengine_get_copy_align() and related alignment getter helpers
      commit: 072975a8a578a62ea68ec1ceb8d2d7dcfb5dfefa
[4/5] dmaengine: add dmaengine_get_cap_mask() and dmaengine_has_cap() helpers
      commit: bbc109e0e686266d784483df108af206bc52e120
[5/5] dmaengine: add dmaengine_get_max_xor() helper
      commit: bff69558d64a98bc8d03f373d1331223c3428a2c

Best regards,
-- 
~Vinod


