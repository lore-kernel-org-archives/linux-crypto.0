Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0D455E57
	for <linux-crypto@vger.kernel.org>; Fri,  8 Mar 2024 12:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709899905; cv=none; b=pYPlVvMnaT5nl5I69JZCa3DXB81cKWIk8Ir5FzjI/C3RuWXM4tvk3t5m3Nuq3JF04OPHXnvfkrOJOC1ubTofl+xdCt1L9Ah78NiE5V36EpU7vJHV0/OwC2aQagrdDO2SXmFavgUkZNBmFJQQSCFh4qcpfIlWcnC8gs4HiXf9ZCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709899905; c=relaxed/simple;
	bh=h1EUAZcY4Sa9OLfLS8GuZCaKJI43c+bS6eKGcPLLqVo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DzRoiqZJwY0C1DcH+LmwbO7Upd/NAYScU7iCIiiQU4Iwfz70ytIZwCMhlX+lDQtuwgLmThlC/B5qBIZQho0+kRuu8HnzFgevoAKgIJRZ0fT/EU9ZoL0Ss/cqZ91p1EoCcHmdt+GzwVm1mXif1/58rHNe7JMh3T4jpbkAHqFsUAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b=pbzvu5tR; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg-org.20230601.gappssmtp.com header.i=@cmpxchg-org.20230601.gappssmtp.com header.b="pbzvu5tR"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-78850a904e4so26407885a.1
        for <linux-crypto@vger.kernel.org>; Fri, 08 Mar 2024 04:11:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1709899901; x=1710504701; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LFWHyOgkTFQ1yJTh6kQ8rZCjVUuuePKTHTw1zfzOKuU=;
        b=pbzvu5tRB/lqisuP71hR0ywqb5B3VpAK2GgJE+5luY3O8a47GFGrh1pVkuCammvtTu
         sNpRkU220qbOq2k2Cagz+ncOMJ5zuVMfHBXE2Ezn7bkuo4VId9JD7fXBcfSbna/r0uFB
         Mgj62TpaYAyaZH3rTNdNo+c0tnU4oMPNGyEU3now5lrmaqy5+L+n08O+N4GiNxjzZt+L
         KyMJWPe++8rkl9Gl0XRJlRbrvN21X5I5Roh2Cg2d2phphqDLU+0jTzYZAZdWYnEmaH5Q
         MChyAo9kJ0d6EMlXyauaqPjDsmu4s9/Nu3X0OF+EMPjZHQ4jeBiXPfyaCVxEkcukPzwN
         xM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709899901; x=1710504701;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFWHyOgkTFQ1yJTh6kQ8rZCjVUuuePKTHTw1zfzOKuU=;
        b=VOROSvXr0KqjY4w8XIolAYrengoTeftOspN6WudciCm4//iN6nkXDPr6AW3PcA8DfR
         TN8PgIYEiUawYtrYNc4Kcm+UoxOChWOsyrihR170OOZYyWZjJyEVGZHDIplWOZWBU8YQ
         /jXjxukh4W5ryMydy2JlYd9nga1cy6Kdf4GGcnYQnDNTWT+RDXmiTHpa/mApl2ERJ2iz
         knoPEWBtkAgAftl+QN9FZoWmfGBQUO44P3pacbJgR3PGhb8FOezqm7O5s1fXCUGt1YkT
         lBDzGRPLQ5Zr8upiVtZBx65Ytd+ubncSaCsKn7sUDV7ilSImuHgsEwWsk6uuEQhttJBx
         E0GQ==
X-Forwarded-Encrypted: i=1; AJvYcCWwdK8DVdKzkdtZ966QPKOLCjJQjMCHvFM+lHg2k2ronSfhrJf/nJt4UAGqeF6/INuuY3u7P54npkDGtjIerA7r5VcFIPpjybIBIcmy
X-Gm-Message-State: AOJu0YxqMa3trvU0h9r+iGvzArhLfdWjxQg0MQdGsQPt4XMcyZRipjpb
	dUsyT8FqTMHKEgn+XkgNaFB70OsX6DsaC5BJ3B16M+lXOt/H8iE5u7qxelhaJqg=
X-Google-Smtp-Source: AGHT+IEzxOxVKkJMR57UwDLb3/yh3+LCr6bD0C5SHDj0C+YHgMECjWjVL0bqStieUxK8nnlRvm1EGA==
X-Received: by 2002:a05:620a:1265:b0:788:1dbd:efe6 with SMTP id b5-20020a05620a126500b007881dbdefe6mr10872949qkl.55.1709899901345;
        Fri, 08 Mar 2024 04:11:41 -0800 (PST)
Received: from localhost (2603-7000-0c01-2716-da5e-d3ff-fee7-26e7.res6.spectrum.com. [2603:7000:c01:2716:da5e:d3ff:fee7:26e7])
        by smtp.gmail.com with ESMTPSA id s18-20020ae9f712000000b007882b33f6d5sm4969471qkg.114.2024.03.08.04.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 04:11:40 -0800 (PST)
Date: Fri, 8 Mar 2024 07:11:39 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Barry Song <21cnbao@gmail.com>
Cc: akpm@linux-foundation.org, davem@davemloft.net,
	herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-mm@kvack.org, nphamcs@gmail.com, yosryahmed@google.com,
	zhouchengming@bytedance.com, chriscli@google.com, chrisl@kernel.org,
	ddstreet@ieee.org, linux-kernel@vger.kernel.org,
	sjenning@redhat.com, vitaly.wool@konsulko.com,
	Barry Song <v-songbaohua@oppo.com>
Subject: Re: [PATCH v6 0/2] zswap: remove the memcpy if acomp is not sleepable
Message-ID: <20240308121139.GA116548@cmpxchg.org>
References: <20240222081135.173040-1-21cnbao@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240222081135.173040-1-21cnbao@gmail.com>

On Thu, Feb 22, 2024 at 09:11:33PM +1300, Barry Song wrote:
> From: Barry Song <v-songbaohua@oppo.com>
> 
> In zswap, if we use zsmalloc, we cannot sleep while we map the
> compressed memory, so we copy it to a temporary buffer. By
> knowing the alg won't sleep can help zswap to avoid the
> memcpy.
> Thus we introduce an API in crypto to expose if acomp is async,
> and zswap can use it to decide if it can remove copying to the
> tmp buffer.
> 
> -v6:
>  * add acked-by of Herbert, Thanks!
>  * remove patch 3/3 from the series, as that one will go
>    through crypto
> 
> Barry Song (2):
>   crypto: introduce: acomp_is_async to expose if comp drivers might
>     sleep
>   mm/zswap: remove the memcpy if acomp is not sleepable
> 
>  include/crypto/acompress.h | 6 ++++++
>  mm/zswap.c                 | 6 ++++--
>  2 files changed, 10 insertions(+), 2 deletions(-)

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Looks good to me.

One small question: why cache is_sleepable in zswap instead of
checking acomp_is_async() directly? It doesn't look expensive.
