Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0DB02566
	for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2024 02:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717382093; cv=none; b=fjjS0IpWFVBo+ANBHHXYInLU7E1J8o3nDXqu3Pmpy6xTOwm0YhDa9HyjU4pb/H3rrqteD6xNAP+x7VRgW9dMLHAgmqs++YtUwxz35Y7E7jNuTdORG2uYNP26GRE0Gx7A+i6kxW/5O9EAhcHUl/c6JGfiSi54/CrTIApqigoAJXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717382093; c=relaxed/simple;
	bh=kljjk8v23d9WKmOqamxofwSe+u5hhvxrPA34emJHnQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f40R0/l/tr2qMAjsscmigFvNKkWzayLY8aJcBbGwIMuBHIVA4WXRdAlitsLe9mp4bNbseQCdYqKOx/Xja4ZObFsLSPaW/awrtKXuDC+w0ZwqJheyJ5JjxDad/GcIUu0rIVeGte2GZRSydBzj7Ctxz0yAza/tBb4efNN2gJ0Oitc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=kR4Sva+C; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="kR4Sva+C"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3c9cc681ee0so2061746b6e.0
        for <linux-crypto@vger.kernel.org>; Sun, 02 Jun 2024 19:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717382091; x=1717986891; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QiYKSzwCEfTems7BymTHJkdxrOuAV5X1RKsUFRSxSJ0=;
        b=kR4Sva+CmqWKU5xpz7Tj6yBST+Cp1kBI7Hf168YTs9cGmTES/ftIa9Ii5AV/BkX61K
         x0JEan8qQiM7MEx6Wug0vGV73evSX4k4pg23br2e3iPnlfyHyLN1Yr4qkG/3XjIf7J/Z
         Xog3mbWlCnxjsawtXtUbaFuyie7Wy0rGPO3h0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717382091; x=1717986891;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QiYKSzwCEfTems7BymTHJkdxrOuAV5X1RKsUFRSxSJ0=;
        b=IdNyldnKZcvjI1yS8eA0LzJxWrD+zVAMmUZ0aetExtRkD2kNwlK+IbfIO4T68ZQsCY
         WEqQdlQhWownJC4mVcyfOJ5lKiZnF9Oz8gkB0F+VbKFtJ1cqY/RJdjmConRr2wZPwc3n
         HK4CTkmlOMTfNX1eaO1HYS9qN0oQn2oCcMyIe6ivYKzhdafc1nIInec9u1PIxUM10Ka6
         2CJUxWf5FIcKM+1rfEnpKTbm7DsyP8GXy6WzNUrfPXlV0YlJblUeGsY9tn242NvuYv7g
         7saWEn2Vb/lCQLtlwT8o6CM4mFi622j+QZ9hctq7ahP+h9ftT1co2PWxVq8c5EuiN/wj
         5Tvw==
X-Forwarded-Encrypted: i=1; AJvYcCUFPnaVvUNqk7nmUzSy3md0SCRkQ8LW6I6uIEvA9GRIbNjxrYCdSUf3pZWR09OxsK/VDvUm5bEMJdaq0SRGppBBENQVR/WFgLIL/XVQ
X-Gm-Message-State: AOJu0YwM1lvWDPkF11xatGfEmTf+90gzuKQDjkno1NMkwGh++o0cTcYf
	PVK9MG1qJe3PuOlDmdY6GEDlLKKEyvJ525ifikbfIeojJlYLiXthQPzNQyfjqg==
X-Google-Smtp-Source: AGHT+IEgKFEEarwNzO12xfOJYtcAsTZNMGWIS0Wnun+Yf43lL/a0nEVdESPEG2McRJbkr39v5GXsKA==
X-Received: by 2002:a05:6808:3a8c:b0:3d1:d437:28e2 with SMTP id 5614622812f47-3d1e35c4ca9mr7996830b6e.51.1717382090774;
        Sun, 02 Jun 2024 19:34:50 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:c840:c16d:ae8c:8e6a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-702425da465sm4536709b3a.73.2024.06.02.19.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jun 2024 19:34:50 -0700 (PDT)
Date: Mon, 3 Jun 2024 11:34:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240603023447.GI8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
 <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>

On (24/06/01 11:54), Herbert Xu wrote:
> On Sat, Jun 01, 2024 at 09:24:15AM +0900, Sergey Senozhatsky wrote:
> >
> > Is it possible to share a tfm? I thought that tfm-s carry some state
> > (compression workmem/scratch buffer) so one cannot do parallel compressions
> > on different CPUs using the same tfm.
> 
> Yes the tfm can be shared.  The data state is kept in the request
> object.

Oh, nice, thanks.

I'll try that new API (and tfm sharing) in zram, coordinate with
android folks on this and will come back to you.
