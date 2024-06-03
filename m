Received: from xmailer.gwdg.de (xmailer.gwdg.de [134.76.10.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F0D374EA;
	Mon,  3 Jun 2024 19:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=134.76.10.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717443204; cv=none; b=DfvIrzAcod4y2olu4UFwl0RaMECxLo6zTL25CDWV5izg5WF+eOpO+k53yVR+AXt9zzCkcyjckblCVccjJVFhv6ReEOEkp377L/UZf75CsiCd8gyemQwkskHpYT7pJofGlkh0pX9Capd0OSNy1661kv8eLjqgS3QsQ8gwcO/ouOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717443204; c=relaxed/simple;
	bh=ZFG0RzAoaOkp+zsaLv13A2Z5uR/A9GDeP1h90WlRyV0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZQHsKGh3tfZeqUIazFYkR6t1hAod/SiHKqUT//T0zsdGldbGICF7VUj4l7yJQe1Q8z7gc017vHdn4MTtiZam5p8NPxKPXeYnzG7URRCK2pC5vDYKbYCvQP3l03f7AVV39nIgr1NYPoHspOZcqloqxHBviISZrv8LKbO/JG9DrPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de; spf=pass smtp.mailfrom=tuebingen.mpg.de; arc=none smtp.client-ip=134.76.10.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=tuebingen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=tuebingen.mpg.de
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
	by mailer.gwdg.de with esmtp (GWDG Mailer)
	(envelope-from <maan@tuebingen.mpg.de>)
	id 1sECtE-0005IN-0g;
	Mon, 03 Jun 2024 20:58:40 +0200
Received: from [10.35.40.80] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 55632179; Mon, 03 Jun 2024 20:58:39 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Mon, 03 Jun 2024 20:58:39 +0200
Date: Mon, 3 Jun 2024 20:58:39 +0200
From: Andre Noll <maan@tuebingen.mpg.de>
To: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Jonathan Corbet <corbet@lwn.net>, Andre Noll <maan@systemlinux.org>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH v2] docs: crypto: async-tx-api: fix broken code example
Message-ID: <Zl4SX4mF0EFuJLnc@tuebingen.mpg.de>
References: <20240529-async-dma-docs-v2-1-8faf87e72e6d@pengutronix.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240529-async-dma-docs-v2-1-8faf87e72e6d@pengutronix.de>
User-Agent: Mutt/2.2.13 (00d56288) (2024-03-09)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav

On Wed, May 29, 10:08, Ahmad Fatoum wrote
> The code example fails to compile:
> 
>   1) addr_conv is defined twice, once as a VLA, which have been phased out
> 
>   2) submit is not a pointer, but is still dereferenced with ->
> 
>   3) The first call to async_xor() lacked the trailing semicolon
> 
> Fix these issues and while at it, fix some code style nitpicks as well:
> 
>   1) make the functions static as users are unlikely to export them
> 
>   2) include the relevant header
> 
>   3) Shorten the example a bit by removing a redundant variable
>      definition
> 
> Fixes: 04ce9ab385dc ("async_xor: permit callers to pass in a 'dma/page scribble' region")
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> ---
> Changes in v2:
> - commit message: fix addr_conv typo (Andre)
> - commit message: note addition of missing semicolon (Andre)
> - add header include (Andre)
> - shorten code by removing redundant variable definition (Andre)
> - Link to v1: https://lore.kernel.org/r/20240523-async-dma-docs-v1-1-b900e0804e11@pengutronix.de

Looks good to me now. Feel free to add

	Reviewed-by: Andre Noll <maan@tuebingen.mpg.de>

Best
Andre
-- 
Max Planck Institute for Biology
Tel: (+49) 7071 601 829
Max-Planck-Ring 5, 72076 Tübingen, Germany
http://people.tuebingen.mpg.de/maan/
