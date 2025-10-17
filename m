Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F071F30C60A
	for <linux-crypto@vger.kernel.org>; Fri, 17 Oct 2025 05:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760677945; cv=none; b=M7Stvept8wBW20tHfqyTXE+sKmOqC2XtQwZtc37YVY/JwiRUtNo+6iNXenkN1IBwAzxM11UvNyFV31S4LdCStr3QVzqIRjh98Wma4uAdUaEkiF/cb+kCsW05NLj+4RBcEb1YS87sL1YFc4y2dGxN17NGQm/WvfO2EUWl69OOy/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760677945; c=relaxed/simple;
	bh=5HmFIvuXl7rh6yAE6mxlyEZLV01rbipPhieZ9YQXOVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gR0NeRk/4BogWP4icQyfnw7s7nQtXwJWXolQ4clVLH8ZKOXSVripZSUvd5Z3k+rKwv4sJGthPW+0WCTQAkXEI5UAWpSFLW0uEoET1w8+rElQzLD3/His4aE1MHU6zECiiFdFhI6IxM1SAS1EmMgigFfk/mYNr1jrZzjc93rGx3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=M9mLMLbe; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="M9mLMLbe"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-33b8a8aa73bso1409885a91.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Oct 2025 22:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1760677943; x=1761282743; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zx7gecJVM0B3tgHO4gvhQyUHfVpL0ObYiuUhv4Yc1KY=;
        b=M9mLMLbeWr7xnOX6OthqV/rw/MZ5y8YS8emPZAruZ6BM8cZTzhRLIIXG90XdF0wVlC
         Ez9aRG4953PI9U3TmLIwFV/cy6RGXZeZffa8BdpXucOqyTUS9KVDSME1H46Z1K938Lx+
         LtNwUOoENUf9Ftj/uDXgq0CYnfPsmupvVb6QE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760677943; x=1761282743;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zx7gecJVM0B3tgHO4gvhQyUHfVpL0ObYiuUhv4Yc1KY=;
        b=q8Bz2+EZWBDJpPM7ehL70B3XcJaHRaeWx2X0+/B9siowWL9NqXgjaFxrwrbDgq85ea
         y8nbN+6Fo6/YmLahRmRWjbmyGV2vFRjMEU49u9xESlo6r1VQmjaTyA6l5o94uSQmmif3
         GmEPczEAlnbzAUSXV0XfkgH/6SvNgsCqSIMClETqMlMznXYKvj79HoalyE+hpeVU7tqY
         Wx2kVzf7SgcKA9INhAHsQyaTWuUVRJ3i4275WtKJZndnghibdPLF7dPEtbKO0ei0hR+B
         zqjT2R94M9WmmD4I9zAmnSpNeTyZw5UUlRn084CRTXcpzT7sKpCBqLGNuQ0W9lBMElsg
         /X/g==
X-Forwarded-Encrypted: i=1; AJvYcCVlM/eBcPTNam2WaQ/YvnmiquQ5Q22upZDx99NncMei7h3+cWSGLczb0XfDGzb4kFDR8hvTYjk4dEnNta8=@vger.kernel.org
X-Gm-Message-State: AOJu0YwvzArA0b2A3cam8ntXVa7raGbk9yCqxBhhr/k1ad38vBMg7H/9
	o6CIwhZVvtimlqGiJQYODJtt2v2zTrcTXhaYZRS44EkVK1azSeq8wcIR0d13fRH0MA==
X-Gm-Gg: ASbGncvtQeDbtDf+LU3tVm3N7P4pXAImqAWbX/vQd+m6xzJOx/RlOqDxiBtlJpYBsdH
	LVcMw3Txrf1f/Qoup039h2TDMp+4IG3tiYsV6kOirrdMFvS5czLsIxNyyQ9dGhB0xeARAd1LWQD
	Ajyt/ju8pPwtGeZ9blXTY+5zINR9YpcBUe9807TzYDWybBP9uYfIRMMKMGjl+LuKr31DaULBRHD
	GArMpIF9Q3vLwBfBs6ULWjSOgOjzNwXi8mEsuLYR8ngNlN/josjv0GBsdmbPdf9O43GlIHNal/A
	vF36yp9p5F9Nj1UdhSbzAuD06A2FoSqMU1I/B6rnVW2LJwra/VAa+3NHP5DU9h3SRJ3e5fgh0hm
	CO9aeoq9NVQqp/0T45HqBkvu6DFv5h68A2IbVDSy/nPTOQ2ePJJ3lXZ0F0qVlLi067T2x9RHKb4
	ouvdv+Q6Eowentb7gMfsbyP+Db
X-Google-Smtp-Source: AGHT+IHMSNNWjuMVf6ka4ZRAthIkCQkaS+3tfv60BOFg4hlZ3TU5YeQGrih/jnEx7KdcsWc9ynXdTw==
X-Received: by 2002:a17:90b:2d8f:b0:335:2eee:19dc with SMTP id 98e67ed59e1d1-33bcf8f94b6mr2535744a91.28.1760677943281;
        Thu, 16 Oct 2025 22:12:23 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:98b0:109e:180c:f908])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33bd78dff7esm1409370a91.0.2025.10.16.22.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 22:12:22 -0700 (PDT)
Date: Fri, 17 Oct 2025 14:12:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"21cnbao@gmail.com" <21cnbao@gmail.com>, "ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"sj@kernel.org" <sj@kernel.org>, "kasong@tencent.com" <kasong@tencent.com>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Subject: Re: [PATCH v12 14/23] crypto: iaa - IAA Batching for parallel
 compressions/decompressions.
Message-ID: <rbl5iuovk5xd2ed5ip4n6mkh5ad6d52ygkqlwbehu3rm6awkn6@tswgallufq4u>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-15-kanchana.p.sridhar@intel.com>
 <aPGXUxRZeYLO_CUo@gondor.apana.org.au>
 <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <PH7PR11MB8121C3BAD72D03573D6B4951C9F6A@PH7PR11MB8121.namprd11.prod.outlook.com>

On (25/10/17 04:04), Sridhar, Kanchana P wrote:
> > What are these for?
> 
> Hi Herbert,
> 
> These are for non-crypto users such as zram.

I agree with Herbert, I'd keep zram out of this discussion for now.
