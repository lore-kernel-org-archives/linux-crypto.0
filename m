Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398AB2F1FD7
	for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 15:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779723077; cv=none; b=l/36lbYGMi1jSKj9dxdpoEtbhhO1lnEu97+3iSUUIO6mAZRcO+d/1ouh42Da24DSBWr7tOLEvME8lbhMqKRoL32vhbqjf95wcEMRgPS5+lX5FzdulQBAWkEXRayfzRlMcIxrgkqSF8C0++/vAbOTjNjkW2X+pha1uZCN+VTkwqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779723077; c=relaxed/simple;
	bh=r8swDJex6jUIPytR4EhqSUSdgn7ItdpKbWXlCYXafRw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O3UydHGAWec8CRaR9FeAu7OsN7/2TPjhRkXK95pBCsZz7+reKspeem/hBDtuv8MpITMoXzZljETj7BXRB0Df1voDJHoaOw8S9VKT/zw9ciHQyVZ8zEh0wwhjcCtkN+X+s6rvgY229sxfsXYRe5jYRxcEaRTRPoEAuO/VVo7qTX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49050ff7cbdso20387275e9.2
        for <linux-crypto@vger.kernel.org>; Mon, 25 May 2026 08:31:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779723073; x=1780327873;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gL2IpC5MvWuY4f2YMU2jwkl0JtJd1OwYuxD8i2xf5OA=;
        b=HocrtruYHswUj58jDxUchAyCKtxAvVbDAInHJnnMEXCSOfrxBZDo/z2EHi/3quKfN8
         RGgMcc9yKE3I8XjP5GloVo2E4OBzePnGH3hRREYTI94EQuzxcuO6MmrEQz1CCc9/ZCP+
         ih02oL34/qt5ykW21mYaSu1v4BolUneU1Q+KxDKiHckB/nJ6S0BGoXQDmtvwTd52apnZ
         PQk+8OEpu+Z6Ya9/mvSI+WjPOKZlSpE4yfojUyEM8xh9/vxIH60B7ybuBUBjtpwlNyk/
         jqBgYLGStTddxo6PSw1++rP3f2ZYeYYeTwxQP94xoCxqrZ0f4zYsMTIW9xyiBDr71rEo
         7qWQ==
X-Forwarded-Encrypted: i=1; AFNElJ9XQ/YppauDwcZHPjwLjf/sVnUoVWTX4qrleFzE8tTSj9+RNISp4fCdB+qCQRj/O7q1w+qZQ82lxFCqnxo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxtbD7DJp2vylCwM4LNOUD/Bt8tbeaplNTIeMen8sYSuSRh3tO
	6uJS/A9jwaEy1CIaYVkt4vEHn9V9AlEUnvVxzagFHI8Sy+4xZwA+zAZx
X-Gm-Gg: Acq92OHjJaxD7O4ibMWbHis4ASgqWGVqCuSBF6zx9mViJ9ekrqtXvV+lTHjmi27Biqr
	YBY5iamysWYgWAN3bvKVF6dTpwI6uXwIQXfiQ+GKGWpD03hr+ka1iB4h6D0NMSCqAE4wly5ZZ0Z
	aShIGmtF3blEZyUhxf3eiGmuzwl0mHSHSuC8QBQp5do0yKCbx4aHtnGI8FkPy6gMy0vDVPmuifQ
	qGGENG2pECUgi5kiNEwNZb3EysBlihyMjKTd5YttUvdDBw2Ct3PGgPBY30aa18CHXlK7OHjvdo3
	UJJn/5otROHDBR5ULTkikNLQ9qcmf2n+NLXgNgZn4OCYLQgXLW//j2VsE5iWWAKxhDsp6qtPWTp
	WcGM0Ky3zxtBTJXM6w9I3OQFforCV/0o/g9yJA+WGaM3yepOniMK5rZAV+6RUBvbD1178N13Keg
	ZRC+8S6hq4vl8hj+ykJ7Mge6cC2Gm9yhvBwaUL8lFp+Q==
X-Received: by 2002:a05:600c:3113:b0:490:6237:521b with SMTP id 5b1f17b1804b1-49062375366mr90500225e9.27.1779723073078;
        Mon, 25 May 2026 08:31:13 -0700 (PDT)
Received: from gmail.com ([62.197.47.167])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d6ebf0sm28873101f8f.34.2026.05.25.08.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 May 2026 08:31:10 -0700 (PDT)
Date: Mon, 25 May 2026 16:30:45 +0100
From: Breno Leitao <leitao@debian.org>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nayna Jain <nayna@linux.ibm.com>, 
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>, Eric Biggers <ebiggers@kernel.org>, 
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: powerpc: update VMX AES entries
Message-ID: <ahRrFOvjvBSOVB7F@gmail.com>
References: <20260524212943.799757-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260524212943.799757-3-thorsten.blum@linux.dev>

On Sun, May 24, 2026 at 11:29:45PM +0000, Thorsten Blum wrote:
> Commit 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized
> code into library") removed arch/powerpc/crypto/aes.c and moved
> arch/powerpc/crypto/aesp8-ppc.pl to lib/crypto/powerpc/.
> 
> However, the "IBM Power VMX Cryptographic instructions" entry still
> references the removed file and no longer covers the moved aesp8-ppc.pl.
> 
> Remove the stale entry, add lib/crypto/powerpc/aesp8-ppc.pl, and tighten
> the arch/powerpc/crypto/aesp8-ppc.* pattern to match the remaining
> header only.
> 
> Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Acked-by: Breno Leitao <leitao@debian.org>
