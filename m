Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0626E446CF
	for <linux-crypto@vger.kernel.org>; Mon,  3 Jun 2024 08:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717403342; cv=none; b=BRWy91kxZI64QcMEs01i0VPupcBAEnSfuvl7sneg99R73C3/NgOrb8BnsEJVI2MS4v9p1P/aZbRStfqwDYhf6trsQ1ccLJj9HXiheXLrznf89DDpCpaQxkZJNI7GlHt485GCqkvSjB9+iWQDlu7lLplE0raj1Eg2hqJaiNljPuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717403342; c=relaxed/simple;
	bh=S6tgM9FJMHrnhLSmUSB1xDZWE0T3AH5BFhyLQ4HEHJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iC+I0cuzRBvxF5KJJvVtMKUngYYinY1cpQY/dbsltnuZfdM6ra1PtFMWJy43KwJrEEnop/1Ik0tf6H1VmFc81zbjgAJ5jG50uWRy3ELgX+bOT1uq3OINatA9qtEEWzsYiG26ZXucgu5RvITcFUmlw7/lP5AlsKjkFDr/iypRZBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=mjrRN0Ag; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="mjrRN0Ag"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2c2039db0c6so928387a91.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Jun 2024 01:29:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1717403340; x=1718008140; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bq+7EeJqw1p9yMPmuluGYa0F2GfKMY9/qIM5XtQqkQM=;
        b=mjrRN0Ag2jUK/NHnXlqfRV5LVRnREc917DoOIj4KjNYTzt6v/EBRHRl/G8biWdnxot
         M8oo+6BbZEpsKgZHeuVSL0nnXro6wYDgurjuY9d/gloSMwWjzyMjlzopmcBJqyBaAK74
         eSMSi3YtGOCJpg94u/gpkHo+7xIwiXTMQGrRw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717403340; x=1718008140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bq+7EeJqw1p9yMPmuluGYa0F2GfKMY9/qIM5XtQqkQM=;
        b=r+L/JnmA9pjtfffESnpS1fwsTotEsvk1eqxjoWS3GC+vJoVn90h6FQtl1i4jogIg+0
         ej74Qnss8l7mkOc188LCwMlNjG3AmZgXxpEWCdoOti+sdm7JryhGDY51/ZEB25Tp51QL
         BP/Tc9kcQSg7z9WrrBQdmAF3/tuSiN2jrYfVqw7NHlkypUTi9jXf/VZdcLRoYoi9y2de
         7IqRpMQnzDBFk1JSbU1Gx/8ugrJJCdblwqeTZSPovoPCZxYivZ/Yhmo3XaqyDH4ufjWs
         w7iRiZkTZ8H53xLMe56YdAxbWHoZxoIpWV2y7fnVyveUaZH/NauRfTnu7yZMV3bTR46q
         uuCw==
X-Gm-Message-State: AOJu0Yz1rvlVYHghsl81zpIs3Y4VP74//icp9zIVq3r73qa+hN+QjiB7
	6oOxbOI9jefoPiKODdPvfiPUDywdNxAa4TARkbrH4GJMjVpZBqLeUrlhEqxcYQ==
X-Google-Smtp-Source: AGHT+IExNGs5gQTcqqOa6oV31I1En/dvqG35S6ClFaigXxDI6iZz9C0aeLBud+ctXmjwKcZfoeXJ5w==
X-Received: by 2002:a17:90b:194f:b0:2bd:9255:91b6 with SMTP id 98e67ed59e1d1-2c1acb2f44emr16951336a91.4.1717403340325;
        Mon, 03 Jun 2024 01:29:00 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:c840:c16d:ae8c:8e6a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-6c353e130cfsm4979878a12.5.2024.06.03.01.28.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jun 2024 01:28:59 -0700 (PDT)
Date: Mon, 3 Jun 2024 17:28:56 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [PATCH 1/3] crypto: scomp - Add setparam interface
Message-ID: <20240603082856.GJ8400@google.com>
References: <cover.1716202860.git.herbert@gondor.apana.org.au>
 <84523e14722d0629b2ee9c8e7e3c04aa223c5fb5.1716202860.git.herbert@gondor.apana.org.au>
 <20240531054759.GE8400@google.com>
 <20240531063444.GG8400@google.com>
 <ZlmKX4dD1EcstVmN@gondor.apana.org.au>
 <20240601002415.GH8400@google.com>
 <ZlqbcKUTa5e3rOtH@gondor.apana.org.au>
 <20240603023447.GI8400@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240603023447.GI8400@google.com>

On (24/06/03 11:34), Sergey Senozhatsky wrote:
> On (24/06/01 11:54), Herbert Xu wrote:
> > On Sat, Jun 01, 2024 at 09:24:15AM +0900, Sergey Senozhatsky wrote:
> > >
> > > Is it possible to share a tfm? I thought that tfm-s carry some state
> > > (compression workmem/scratch buffer) so one cannot do parallel compressions
> > > on different CPUs using the same tfm.
> > 
> > Yes the tfm can be shared.  The data state is kept in the request
> > object.
> 
> Oh, nice, thanks.

Herbert, I'm not sure I see how tfm sharing is working.

crypto_tfm carries a pointer to __crt_ctx, which e.g. for zstd
is struct zstd_ctx, where it keeps all the state (zstd_cctx, zstd_dctx,
and compression/decompression workmem buffers).

When we call crypto_comp_compress()->zstd_compress() we just pass tfm,
then the driver gets tfm-s state/ctx via crypto_tfm_ctx() and uses it
for underlying compression library call.
