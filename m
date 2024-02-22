Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E356614B832
	for <linux-crypto@vger.kernel.org>; Thu, 22 Feb 2024 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708629248; cv=none; b=A4Vf8uJXJi8+ZFQeUFgf6kTcLKxDUtTPCOc/LhK+hlsE5TywUwZlqqhylZfWMz55yHVgU/+0AqmVRzGvKuB5JZbxUcEXIj0Nfulm5Pg3q+CsWZYQNvgZ49xypccchBSXpRe8u5z5q+z9dIRQhz5NWrTvPrrw2bqWqOD7MW2Q6aY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708629248; c=relaxed/simple;
	bh=oW1gFNVKJodwdwSEaE47Yse3wtffu8EGgYCEElN6ibk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=amb+pH7utEy47/YaTI09lB5X+T2ClroBzM6pEwwbG2GhhGeMYYBdZmOwe5RuaWlmBZHqAjWe9pja33Mqvo2Ecvl43L2gVBGcm48k+qaODFKcgKL/Uw9iP+YD8qcve9VHB6TWCGQ1vfRUC8OZGtsD8rmYEP7R3tiAydb0kQ6OYS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CTVePZSd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CTVePZSd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708629245;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9EcVr/iXDKl2dFQaTrHjb1w8gC2gsUfhhAy+IlCxU7Q=;
	b=CTVePZSdbst6lT9rLbXLyegFWeEOSK1+brRrAs8IIF/BsDIw7h6zFK/OKuf6AjRX6oJgUm
	wc87waFtPmYJyhi8Extw6TfjxfkpOubMcJ08Cm7yl7C8TmeQ/KAQj2wjjpCX2miW2vNLzG
	wv45tfyw5VQsMaLqFBUFjoWCn6CycqI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-463-492ooX2tOFCBvTmW2y6xVA-1; Thu, 22 Feb 2024 14:14:03 -0500
X-MC-Unique: 492ooX2tOFCBvTmW2y6xVA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-411ac839dc5so287455e9.2
        for <linux-crypto@vger.kernel.org>; Thu, 22 Feb 2024 11:14:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708629242; x=1709234042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9EcVr/iXDKl2dFQaTrHjb1w8gC2gsUfhhAy+IlCxU7Q=;
        b=GZ+GUJNh1L3idwdsyEftXXSUe+AQX2OOQGWzuq8pMC8XeauOjEXsrabsLy1jRnJym0
         aSdXNzUEFHgQ8YTOll8NEeRxcrybfEoEtYMC0EGqipxgnKzJ1i2h+GxAggP/HwBuMXC6
         zAp2/GePun7NfehjxACTMIozDrupLcyWpHe/SKfPdAS/mLXcXQWjGadbZC0znqXmVtxY
         o4n6WAfNm7r5v9LV7EEPAg4Y5/BpnOu8/9d8FkaCcCq36CF+2dvO40F2M6rpJRTR6UM6
         nGF8iEHQJlF4FzMF+pfMBl2I9JzTeHesifXCCfuBe5G1MbtRTaB72dSG9voJpFGBqsLp
         qXTw==
X-Forwarded-Encrypted: i=1; AJvYcCVZ047zZKjNkTK0YABsM6dmEH7AxPQxGmRxaYz5tjxoyJuykV9gqp7nb3VvlecmPdk2Ny8Q9lzfQvnJXKxiyg7ApA01vxdguBvk+TKY
X-Gm-Message-State: AOJu0Yw4cgBvTyLvoV87Bmh3mpau8NU/gPLllCpNRxBeqMT2jcj6KL81
	qWw8mp8FLFXSyejDQgioT/DIAcRUpuZPkaUCca2f5GT/N/kRtZG+7tbFpCmexVVOjMLmZQC4am0
	K/cTxZzsRSEtWS26FlCnV2y5IS1viEpFEASSGj6+3/FDdTKLs7hwxN4lmykNPMw==
X-Received: by 2002:a5d:4688:0:b0:33d:2120:1016 with SMTP id u8-20020a5d4688000000b0033d21201016mr48609wrq.52.1708629241835;
        Thu, 22 Feb 2024 11:14:01 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFGOdbI1tAnkcf0Z7MVzUgYDiaNDKtZW8M+iyfNr7KmoAdkj5DXpMhLNPxfmu3vVrZJNmerWg==
X-Received: by 2002:a5d:4688:0:b0:33d:2120:1016 with SMTP id u8-20020a5d4688000000b0033d21201016mr48601wrq.52.1708629241544;
        Thu, 22 Feb 2024 11:14:01 -0800 (PST)
Received: from redhat.com ([172.93.237.99])
        by smtp.gmail.com with ESMTPSA id k5-20020adfe3c5000000b0033b66c2d61esm21027161wrm.48.2024.02.22.11.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Feb 2024 11:14:00 -0800 (PST)
Date: Thu, 22 Feb 2024 14:13:52 -0500
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alexander Graf <graf@amazon.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Olivia Mackall <olivia@selenic.com>,
	Petre Eftime <petre.eftime@gmail.com>,
	Erdem Meydanlli <meydanli@amazon.nl>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	David Woodhouse <dwmw@amazon.co.uk>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: Re: [PATCH v7] misc: Add Nitro Secure Module driver
Message-ID: <20240222141319-mutt-send-email-mst@kernel.org>
References: <20231011213522.51781-1-graf@amazon.com>
 <20231225090044-mutt-send-email-mst@kernel.org>
 <363ca575-f01a-4d09-ae9d-b6249b3aedb3@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <363ca575-f01a-4d09-ae9d-b6249b3aedb3@amazon.com>

On Mon, Dec 25, 2023 at 05:07:29PM +0100, Alexander Graf wrote:
> This patch here is already applied in Greg's misc tree which I'm happy to
> have it trickle to Linus through.
> 
> 
> Alex

Kernel test bot was unhappy with this patch btw. Know why?

-- 
MST

