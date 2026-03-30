Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43E28373C1E
	for <linux-crypto@vger.kernel.org>; Mon, 30 Mar 2026 20:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774903254; cv=none; b=exDBTk3TxkOcl9pNW67XblcIBTSVTlhj+KeX1l3ZsVRYS76Dk46RdOdHf+rTHmKvJ5VxyClZ/CDMln++UDflwANdigE0q5C6c9u8ipGugeUjKbkk7F4VZWw2xyD/p1M6b1e666v7Y55XFHUK3WzrgcU/QKpDxRJtOCYn8byveF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774903254; c=relaxed/simple;
	bh=EOWaw231OXh+OCxOVHHgKO4PsXZfxwWLnNexMXm5QQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RPJp3PDKvy/6xpdaL9K3+LwDzUCDqEmqegpdEnDYpx8dYJ+voPL6/g94ClG6JAFn1OuaUBgjzBRlTX8jL/fj5xDF4RSu7U7KkdPRVKb+q6RDE1RJZbvPrlRbZ9w1HDnF/UxXkIDlBH1XvuQ6N05yIftA1wPb2ujW7GhVXlLYVZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HagsZGlw; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HagsZGlw"
Date: Mon, 30 Mar 2026 22:40:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774903250;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DIyuPEO9vyWDylSg0YsJe0wIWRfP6LZmQavPdsYHxNQ=;
	b=HagsZGlws8VdmhpA4ru3LgmD73bBL6yVU3Z1fdSrTifZ9DwS7G3uBmC1NNYUdeWmjDkhUj
	MrDF1ixdgb+eDMWtUE+8/Zhjz6Aovj1QDWabPOL4HMDub+WvV0MJjiLFhGvvO6ypfHtjx+
	pEBwtQ0LlAhmWejfJmvp10RR4vpO8FY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Kees Cook <kees@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: hisilicon - Fix dma_unmap_single() direction
Message-ID: <acrfym5HGJK8NfzQ@linux.dev>
References: <20260330151937.83837-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260330151937.83837-2-fourier.thomas@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 30, 2026 at 05:19:32PM +0200, Thomas Fourier wrote:
> The direction used to map the buffer skreq->iv is DMA_TO_DEVICE but it is
> unmapped with direction DMA_BIDIRECTIONAL in the error path.
> 
> Change the unmap to match the mapping.
> 
> Fixes: 915e4e8413da ("crypto: hisilicon - SEC security accelerator driver")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>

LGTM, thanks.

Reviewed-by: Thorsten Blum <thorsten.blum@linux.dev>
