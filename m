Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6775E13C684
	for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 21:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723670447; cv=none; b=TAOV2UQ8FpRQFqvKlVbAcINDuAqhNFBuuBhgCBrzEutUAU/0Dknw8sIV0e7E6MFTAOd+3ZOrVj8qZyDPCNtJZLElLm39QU0gF8G0HNlaB46Ad4WgKDVu3tGpBvcirqvwIzSU8SIv6m7aGEFzahCfXqAfrAKCqL82PVh7PSuFsis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723670447; c=relaxed/simple;
	bh=BXpWJ7G60z8moZHykofBPZq77vdUi15m9nFEAwLkLYc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RMYy+v9x8lB+TqEW8N8h8gyuajpKp0uyqOJxx+r9uYiYYgdz98r1YLf5nBKSEKipyYuqI/tlv7jIET/GXmucoV/yFY/uCIHHYfFOeUsa8rpNfkPlNuI+YlibUwCFOKEc5CIfL1H3310sdrEEWwg+xrzgEkkGG5M9h2RqEse2mpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LXJkDOrg; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LXJkDOrg"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-428243f928fso2094165e9.0
        for <linux-crypto@vger.kernel.org>; Wed, 14 Aug 2024 14:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723670444; x=1724275244; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9oAYmnH6MofwvfK7sgRQ6mxCg378Vn0pCt20dkMthag=;
        b=LXJkDOrgO6ZQlF5TwYc8UAiRfQ8vZOzKHK6lNbsPFPhXEQCv7Zvr24szwgv8nZ5Wmc
         dxswBL8Bw4AOC+ghjzJMKMTtaDyYHnpgQ4vx2FZRk7dKwNEQMs9e/KoVust8F8JMMBhF
         IIm5n65EJRoUWb1otRsnVM7gy25yVnVDe6ZUa8gGTM0Ka1LLqJKyTIVDyyxM9qXFRRqO
         9SVGgx9QgOQL1dXRhI00wF9ETbn4FdP+6hSBAH81DW/FgyKxqfnP10pv7X+mGVLAhUIQ
         C4B5Ki6cy6llvm9JO1XMSgHj4EANk1fuqBSxUcROnU/Qkp0tTtAybfk+tu6Pi9D9zhr+
         SVRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723670444; x=1724275244;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9oAYmnH6MofwvfK7sgRQ6mxCg378Vn0pCt20dkMthag=;
        b=LBlv9SlRmruF6kaoGO9iGvEnPQ7VM5mOKjhupJ698vgQNtDLucUqaDQsNeEITrlMQi
         ssGAUHT50rUBXTBsEN8a3/DL5LGAOL6bYtDD/FGVZie4K/vI2VNkYmqWSRDZRDNrMdGX
         QwWWeCU4EzR3dtUfE5Hg+Rbo9UOnb5BhnUkgO5as+nXprWXRm2Zm5usubtJwpdCl50+Y
         qnrxF+hISOZnSarMMt1hNuH3a/MZd7HSsh0+nB/j0zO3xJj+CUIpSL7aIxuDWGalALAe
         UFCIxUoiGXHbQZdNotWhL0AAAgVhh9exp52sxhfwZQ/YjiNkZiJP6bJfZ/IQjbQ+MU+I
         g53g==
X-Forwarded-Encrypted: i=1; AJvYcCV1ti12NPa0TkCtXi/AI+b/pbQvcx66KQmbGpw3x0NmqiGsQlZt9W3UbA9cUJY2xSZEwQlg0fonGv8NgthNedLZ4tvjvs0QJlU8vUoW
X-Gm-Message-State: AOJu0YwFz6jo3N7MDcpaFUA5dvHHTuywf4m8PXfPH/BjBmnBePzI960c
	B9wA29y8q0XZ0bdeUpPaAr4DobJCInFsXF/3UdjDPfSb4N2R/igdnLqkEzaedgU=
X-Google-Smtp-Source: AGHT+IFeFdsWCWSXFxKzZH3YN0A/8/j4lcY3BId4eyq51PWhMqA3R4eNW2JxWCo7iUvVwKlvj2scBg==
X-Received: by 2002:a05:600c:5488:b0:428:e30:fa8d with SMTP id 5b1f17b1804b1-429dd22f43emr33659265e9.6.1723670443523;
        Wed, 14 Aug 2024 14:20:43 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-429ded3596esm30497385e9.22.2024.08.14.14.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Aug 2024 14:20:43 -0700 (PDT)
Date: Thu, 15 Aug 2024 00:20:39 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Bhoomika K <bhoomikak@vayavyalabs.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Pavitrakumar M <pavitrakumarm@vayavyalabs.com>,
	Ruud Derwig <Ruud.Derwig@synopsys.com>
Subject: Re: [PATCH 0/3] crypto: spacc - Fix Smatch issues
Message-ID: <35f19bb9-8035-4301-924b-45d6a20512bd@stanley.mountain>
References: <b47b6e7a-dd63-4005-9339-edb705f6f983@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b47b6e7a-dd63-4005-9339-edb705f6f983@stanley.mountain>

Sorry the threading was messed up.  I'm writing script to add cover letters but
it had a bug.  Hopefully that was the last bug.

regards,
dan carpenter

