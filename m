Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D064F192B6F
	for <linux-crypto@vger.kernel.org>; Fri,  8 Nov 2024 20:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731097475; cv=none; b=khk/Eo5fmqp+17hW9y5ZP/VhXv1ttARvZXmo6ajsQEjuIT7eofjr43R+7b7mQMoBc1R3GMsc4sPEKSmerN7FRkGZsfY3NcIZZdnVuv3jLDsVLnBYcOO6dgiFBiOB1mIqjN1Ds11ytIAJtjd+wtT6BlmdbEVcug8Qj+iQJR4OAVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731097475; c=relaxed/simple;
	bh=NjWcx0U69TXGpkAnm8bJv29GUAXhA0iQfJ5knHqcOQU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=esQkLUbTT9PQ6IUujs/dWwClLVKy6A2F5C+SkT50HZadXPBBzE6qh65ZhNZ1/WGI0GdGFZCpw2f0Gkcrmtf7Fzad7rnCJhZGSeDysa5+8FSsvXMKVNIpbuigtwLb9YEpZnYMl9kS00frd1As7eDrEnSDnYJ9EmlzdPtxOF8pRZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=soawqbLQ; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="soawqbLQ"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-6cc03b649f2so14364966d6.3
        for <linux-crypto@vger.kernel.org>; Fri, 08 Nov 2024 12:24:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731097472; x=1731702272; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NjWcx0U69TXGpkAnm8bJv29GUAXhA0iQfJ5knHqcOQU=;
        b=soawqbLQqW2ksLAwSYlx2t5O1j49HAxU1aKiBAELfxK3INGU3jGl0+QMr0wd8V/bG6
         zdGrCMs5db98hYvWPMC4F4lNqRUR/fOhrH0KqBDMXtg89lScZJZP6H37+Hw92fUJhQ9+
         eVmFjQFi/dFGN7pBCahM9gbRVy4h990zGNR7fJhyyQY30jtH0kjN0HPDZgGkdffRmKAr
         4wqu9j/I+De2hJiTLGvbTu2uza6zKji2hRVvAQDLQ8elme6mhycwhLS1IRs/303NOUpO
         6EotJXuPFJejS8/5bd8Ua4Ez88YkUR3wsYG3ba2JJeZXfVlPzrmLc66FujM0IUzcT0So
         EX4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731097472; x=1731702272;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NjWcx0U69TXGpkAnm8bJv29GUAXhA0iQfJ5knHqcOQU=;
        b=iAMw++5yZJLBAOVBGaGzcm4m4lR5X0XHHnfjcvLcIYYEtQ7SWW+glBVWbSJyKmlfzN
         a2PJdGCtBC64kenEA5dGC+bSlMWooSEdPuG0sOspgUdHV1VzJT72qyaHglJCbIwSK7Fh
         l7pgjDpVWSfLIcjSd9g6np95mM2vmIfUBlAn+TPHWA5aR9gWtLbxozwRO2xwkA/GR/Hj
         RxVYEFIq2CK8gdYHsNjCuN6JQjYPorpWfbT8nx7jH019OHrwxH8sAl0Mo67E6fJdK5qP
         BzWueg3Q700YkGf7iacE61hOngSZFQGrQbHk2fQLayP+pMndAX7D80PFISxCD44oECop
         z3fg==
X-Forwarded-Encrypted: i=1; AJvYcCUINW61QioteLut3oyP1i/e2j6MatUqMj9rSvQ/RSciNeqKuk5sDSBj9zh2S9zU+bIuOJe2J8dWiQenJIU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwSAmhg81WxTYlpR8wfE3owH9tNyrVuPoYinvb8yYnZHFh0eHRa
	0AH69hCA1nNmUBhrkQvoVKH/qdxZiWB41YtRi5eSchUtL4uWo3vJDJL7KrU8bbahejwPZjJdl4R
	e/Ih52pt/2FdaKoy1FC6jmbpK1HKK1aUma8V/
X-Google-Smtp-Source: AGHT+IFTCXzZqbORIu77S8vltjpbqT2jiD2zFDJVpYKUMIQpdWZiXDw65WdrevpcMDyrDtwDYFhTKELCt2B1xRFsSBo=
X-Received: by 2002:a05:6214:430a:b0:6cd:ac54:7995 with SMTP id
 6a1803df08f44-6d39e1ee6a1mr58087386d6.36.1731097471563; Fri, 08 Nov 2024
 12:24:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106192105.6731-1-kanchana.p.sridhar@intel.com>
 <20241106192105.6731-13-kanchana.p.sridhar@intel.com> <20241107173412.GE1172372@cmpxchg.org>
In-Reply-To: <20241107173412.GE1172372@cmpxchg.org>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Fri, 8 Nov 2024 12:23:55 -0800
Message-ID: <CAJD7tkZGBcoREDCbjczdLUtDgYt1Dg06Wk=N=ZGVqRzVBmoPyg@mail.gmail.com>
Subject: Re: [PATCH v3 12/13] mm: Add sysctl vm.compress-batching switch for
 compress batching during swapout.
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	usamaarif642@gmail.com, ryan.roberts@arm.com, ying.huang@intel.com, 
	21cnbao@gmail.com, akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, zanussi@kernel.org, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 9:34=E2=80=AFAM Johannes Weiner <hannes@cmpxchg.org>=
 wrote:
>
> On Wed, Nov 06, 2024 at 11:21:04AM -0800, Kanchana P Sridhar wrote:
> > The sysctl vm.compress-batching parameter is 0 by default. If the platf=
orm
> > has Intel IAA, the user can run experiments with IAA compress batching =
of
> > large folios in zswap_store() as follows:
> >
> > sysctl vm.compress-batching=3D1
> > echo deflate-iaa > /sys/module/zswap/parameters/compressor
>
> A sysctl seems uncalled for. Can't the batching code be gated on
> deflate-iaa being the compressor? It can still be generalized later if
> another compressor is shown to benefit from batching.

+1
