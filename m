Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89A8218DF6D
	for <linux-crypto@vger.kernel.org>; Wed,  4 Dec 2024 22:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733351780; cv=none; b=p54NBdgY/UFUxEbw2c7HX435gctDGZ/9Vpen3QrKjvc+L6Z1r7qse62FRKCHprdqtGuuFCFz+sHgksMI8ZtIc8gjsKyTjHCX/+koiZoMME/nl9mbGkyPW3GKAcLNZm1QQSZcHPBWbcxszo/ty1wca1iwI10zveyLj+s38cif+WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733351780; c=relaxed/simple;
	bh=y8PAwII+zOmKPr1Vni+Yw8XAi6kWucC9EB0LSh6GWLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nzsP6QlcILcObcAdIDSL0rc0g3BR/gK8H0Llmku19kVN8lMfwJFf1v9N1bPikRiTT42LtCNJdGLjaHBpy5mgXrGrasj1UjDZlSg+l4RLG2GO1oU90C6fGsYLNNJw1Qi0h2VisSeSrXrByhAAt/SY7HNgSFCx51HmR0jiIAF3BCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=23fAOSxB; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="23fAOSxB"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6d882619044so2662006d6.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 Dec 2024 14:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733351777; x=1733956577; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eS0FEsruGhh39Bjn4FTH2Nl4cCIzKoK/vUzX8vsG6WE=;
        b=23fAOSxBp/1k7ymyOsA1Hjk46tW706CCsVAI0DItQ3ot4PQ5GC6p9vHz8zFPjq18lL
         Axlyme0qxy0ITmmXORlYljE9WOZqu4hzWJMzPjYEp0aYnuu12CCehMPr30vGFF6BRCuY
         7gjo8eXUcA95x9OT4Y0R3lGwg4TDdFyu2ESZJq3Vp1lR4T4dXrg1fH2mGaXZuZCivPrS
         f51CSDCapay+rpPFTPXFYdh6CJjx3Lh6vOb5dS4MJVMI6HUx8L0li2BZVxj3Ack3izx/
         9xpfCU9J3BJHMurpezUV92fU805tykihMgejoKjFw5owWEwcdF+p43Up2NFvScB0QQ3o
         EM+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733351777; x=1733956577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eS0FEsruGhh39Bjn4FTH2Nl4cCIzKoK/vUzX8vsG6WE=;
        b=D+zWHZXKOBU40CniEbsVTh1NdjpwrhdnAMPDmUBOWzy34PewngSJGDfRUg9Vm6gsLx
         izsLX9xP5UybSdBnqUa4J0oEYbVDNL0UckjlMX1CanqsId3Dmw5RMtU1KfZM118mHdiR
         Wv9MEBNHgrt0WumnK9wl5UrnHo8u+kkXxW8PbUdBpFawgOAR2V1SHenZCs/b6eiMwNQH
         +L4wdDOHAsrQG3sIk+dY6MqlxIJnMTmx5rRTqLfttLcSKprEJZSQd6mLXJHyWuaTt4e7
         /e3oK6QqgHB0s2D+h4yz4LGQfopO+MQ+XDNiqAjTFlCxUOtpfL4SqwrazvvWTTq80Ww5
         P3aQ==
X-Forwarded-Encrypted: i=1; AJvYcCU1Gcs67q0U4uzePOFDs1dopheDmDIVbWZAuQJhVlQ2s2HGK3tqxTs1XcoGR4OLWIJ2HGTqGw9h4kjeu4I=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywt7HFhSOIm2PirkwsnS8MN0mk5BNkxWbrDYabDl+7lIAUvTlyk
	NB8qMcZ1PMlIuckxp0cZBj15oFuJOpcctcbTCoEilpjTBooOrlqy9lmWbAvORwSNI5vtdil/c8h
	Mlaqf8qi7tAoF0BwFnq8Q14eDABRnfwcOuvI1
X-Gm-Gg: ASbGncvCCHnzfVwaogLZNXqi5IjZAazAJocq1nHTFI1jTqlx7juhKj3EmmOfncxkFNx
	1QEYwtHRS6769/CQj8qn2GkR7NniU
X-Google-Smtp-Source: AGHT+IEDQzyAy1CVJBsw8OwP0dkCUTIHEYHMvraP8G80iJxS11sgJQkYnJWtKFeWBlFBtQFtcyr8YTxgY3yg7BNQkkE=
X-Received: by 2002:a05:6214:c4e:b0:6d4:16e0:739a with SMTP id
 6a1803df08f44-6d8c45905f7mr106003306d6.17.1733351777220; Wed, 04 Dec 2024
 14:36:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241123070127.332773-1-kanchana.p.sridhar@intel.com>
 <20241123070127.332773-10-kanchana.p.sridhar@intel.com> <CAKEwX=PmKWH4Z4Py9Jti9fcD6qCYJBBRrDF48qdmo8-i+LzzfA@mail.gmail.com>
 <SJ0PR11MB56783454B5985ACD48744772C9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <Z066p53LoISwqkmX@gondor.apana.org.au> <SJ0PR11MB5678AAEF4F62773847E6307FC9362@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com> <Z0-zboLmrybOt8pv@gondor.apana.org.au>
In-Reply-To: <Z0-zboLmrybOt8pv@gondor.apana.org.au>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 4 Dec 2024 14:35:40 -0800
Message-ID: <CAJD7tkaJwti5vwUXP=T9MW4XXHmen+SCQXv=hWWN+-V3SJJSVA@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, Nhat Pham <nphamcs@gmail.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@intel.com" <ying.huang@intel.com>, "21cnbao@gmail.com" <21cnbao@gmail.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 3, 2024 at 5:42=E2=80=AFPM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
>
> On Tue, Dec 03, 2024 at 01:44:00PM -0800, Yosry Ahmed wrote:
> >
> > Does this mean that instead of zswap breaking down the folio into
> > SWAP_CRYPTO_BATCH_SIZE -sized batches, we pass all the pages to the
> > crypto layer and let it do the batching as it pleases?
>
> You provide as much (or little) as you're comfortable with.  Just
> treat the acomp API as one that can take as much as you want to
> give it.

In this case, it seems like the batch size is completely up to zswap,
and not necessarily dependent on the compressor. That being said,
Intel IAA will naturally prefer a batch size that maximizes the
parallelization.

How about this, we can define a fixed max batch size in zswap, to
provide a hard limit on the number of buffers we preallocate (e.g.
MAX_BATCH_SIZE). The compressors can provide zswap a hint with their
desired batch size (e.g. 8 for Intel IAA). Then zswap can allocate
min(MAX_BATCH_SIZE, compressor_batch_size).

Assuming software compressors provide 1 for the batch size, if
MAX_BATCH_SIZE is >=3D 8, Intel IAA gets the batching rate it wants, and
software compressors get the same behavior as today. This abstracts
the batch size needed by the compressor while making sure zswap does
not preallocate a ridiculous amount of memory.

Does this make sense to everyone or am I missing something?
