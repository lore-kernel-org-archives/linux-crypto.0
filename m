Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 711BF265CAD;
	Thu, 28 Aug 2025 21:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756417185; cv=none; b=QXPFsGWonc8PPc+5pE0hBjVo03O6CRNy0tkXxqUOQ/jbYAgrpgF3aiMUjX7VMC1VSnhrNPUsXQk7/S664vMZaw/J1kgHa/TuRms8y6WYlszRNMUZkz0zysVuHel+sVHdFuQW20CggmWlJ9g5/jSlzP0jKZ6gpMi/8m4QrL1vALE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756417185; c=relaxed/simple;
	bh=2KkWaDBRS33p7HdwYM8eCBIZQvlmy9NRnHCc7OAPd0g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RVmub1CB37yWT4rq3zckt7xotfSoPSs3rGXC0vZvWP5hQvKWvg0ucWMWgsQ/MivV+/1+Cyog6y0kk33cuKY0KnqVfvvwbBuqAYJRjK8hbCUi5KrM2e3BZsfD38clPEGIO6iNBRPl8u1VW9RbAVX8xkSYaUE98v8dsmf857dRc4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=acnOw0HF; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="acnOw0HF"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-54479be00edso560248e0c.2;
        Thu, 28 Aug 2025 14:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756417182; x=1757021982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egeVb4jL6h5nFyN9xRw5wQS4OVht2YfrG8JsM55WIk4=;
        b=acnOw0HFcLCfQ7qj6IJRR53gYKxPVJuwItrfiQpJsKyhBw16PyedPZxkvw7NB2H+eF
         9flYZXLbxEaanv1ZpGV8+Id6UdEqylw1PeEfYNYwRrLLpvG0hh2l5ga/GocXmAV75jHp
         4bSm7UTwQsPUwWvSB5EEIw1bvcxeicaBeYcBkFkpx+0UbFjwdyRXRHTJQDir2ma66/aL
         QGO7EbG6Nyju7ScyMHTWtbymtJWNwcvHcA/nXJ2xaJyUSoOcjbdZbe2RFQl9gBSSgc/1
         Zdlmcxr33YkDYNIxq9Kw51cJ2PhtF5SHJCwnKBEtOmjD8YRO8PW3q72j6e6abWkNIip3
         ZfVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756417182; x=1757021982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=egeVb4jL6h5nFyN9xRw5wQS4OVht2YfrG8JsM55WIk4=;
        b=K/qAcxK62ZaCGIB1AAf0bLumHJ8BOMtFE5cXRf4JlfLrmKD7RBLj4pmOqR9YG73hep
         mG5Nb9Sq4v9T3Q1lzyx856JDL27MRF6rczKtc0ti7c5LAbLkjRQtRN5GLPmVLvxxx0WQ
         hsXiptCjwZdFJAfSPLqM7rs6EZx/aDbNqThU6gwpOlDps/DJ1AKl2Lt/jT5nsb/XCTd6
         SkSM0lT7+i8It9O6kRMJMoWw/ls4D0AV63TxTMP/IPokVZJ5Z4p532zqNTsVbAY6Pdpy
         fZsTt1dHNId7eHvNqomSAbAA7AbqAfdSaHIAZXX7b3ucvrLMB4EjTfkg0OveJMzvjwE9
         pKfg==
X-Forwarded-Encrypted: i=1; AJvYcCUfMno33jax2s/nIWUOQdqwaa1Xsi3nRoeV/OvDiiSrbfUpY0SvdyuWHCL/k3+AWbx5T0wUBf5FJqypYxY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz63/xq832FGLCXoNQFVgb0VQdoZcKZlc6E1G9Wf/19uIGT87Wn
	cZKFCDKECz80yqUezjYBDdXitX5jhtNGNz8cmcL6jDdQftK8zJJ/3OtWIldE06JyGmZusB1lA6A
	p07QmzEmXJ6H5pnU7e4a7aKPNR//tryU=
X-Gm-Gg: ASbGncvTWzhtD2JNMk44AZ7s9ciacXTtLkLzzyUf87LF8DVYhZ4VbDi7/nmcNOZGGH3
	s1ZimVO1aVKnGF7B17nOGQpMC58KAcnlx89kEIZO1vNfn+5mGOxwNiGGpSDEB44VNC6ov0cDMKn
	Xp7ce0wfVrinYqP5yxOlYToEwsRNSQkwZKcYs0HEDUrfRFrT180qKegqrNkdJJl7VMn6KaQjFne
	IbjS9ukc9dS1T7J0ck0v7bB1U7R
X-Google-Smtp-Source: AGHT+IHie7MOkNsj8efrQCm04ILQxwbVuLefNNdiQWU7MzTGW0l35HwAhXQIlJpyb1p2xzNAzusa/ZuPiM79Z7UDlew=
X-Received: by 2002:a05:6102:5e86:b0:523:b5c8:2b0b with SMTP id
 ada2fe7eead31-523b5d7ac6dmr4910509137.12.1756417182085; Thu, 28 Aug 2025
 14:39:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-23-kanchana.p.sridhar@intel.com> <CAGsJ_4xRij-Vz_-dmL44YLvaQrYLKKnw7O_Skedrxj_YxuaT5Q@mail.gmail.com>
 <PH7PR11MB8121532CE4368DF5BAA6D46DC939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4xMuLPy3+mAxzOj6SfnFZaDf+B=WkmbrCNqv8gvK080Fw@mail.gmail.com>
 <PH7PR11MB8121B86E65349F5CF854CA57C939A@PH7PR11MB8121.namprd11.prod.outlook.com>
 <CAGsJ_4zt9zQFh1mz6gpQOCWBOjz1osN9jTd62uKGf865vRwuLA@mail.gmail.com> <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
In-Reply-To: <PH7PR11MB8121C1B5965584AA8E59C0B7C938A@PH7PR11MB8121.namprd11.prod.outlook.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 29 Aug 2025 09:39:30 +1200
X-Gm-Features: Ac12FXwKgcdDELJZzuofq3TYBazdJbuunzZRTQMwHeFHqBjqIkT5JByIMca79Ik
Message-ID: <CAGsJ_4zjPxSjrSomm3E3gOuW+AqiTKwUHJ34q9m9aJb3y3vEKw@mail.gmail.com>
Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resources if
 the compressor supports batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "yosry.ahmed@linux.dev" <yosry.ahmed@linux.dev>, 
	"nphamcs@gmail.com" <nphamcs@gmail.com>, "chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"ying.huang@linux.alibaba.com" <ying.huang@linux.alibaba.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"senozhatsky@chromium.org" <senozhatsky@chromium.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, 
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, "Gomes, Vinicius" <vinicius.gomes@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 27, 2025 at 12:06=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Barry Song <21cnbao@gmail.com>
> > Sent: Monday, August 25, 2025 10:17 PM
> > To: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>
> > Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; yosry.ahmed@linux.dev; nphamcs@gmail.com;
> > chengming.zhou@linux.dev; usamaarif642@gmail.com;
> > ryan.roberts@arm.com; ying.huang@linux.alibaba.com; akpm@linux-
> > foundation.org; senozhatsky@chromium.org; linux-crypto@vger.kernel.org;
> > herbert@gondor.apana.org.au; davem@davemloft.net;
> > clabbe@baylibre.com; ardb@kernel.org; ebiggers@google.com;
> > surenb@google.com; Accardi, Kristen C <kristen.c.accardi@intel.com>;
> > Gomes, Vinicius <vinicius.gomes@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v11 22/24] mm: zswap: Allocate pool batching resour=
ces
> > if the compressor supports batching.
> >
> > > > > > [...]
> > > > > > >
> > > > > > > +       /*
> > > > > > > +        * Set the unit of compress batching for large folios=
, for quick
> > > > > > > +        * retrieval in the zswap_compress() fast path:
> > > > > > > +        * If the compressor is sequential (@pool->compr_batc=
h_size is
> > 1),
> > > > > > > +        * large folios will be compressed in batches of
> > > > > > ZSWAP_MAX_BATCH_SIZE
> > > > > > > +        * pages, where each page in the batch is compressed
> > sequentially.
> > > > > > > +        * We see better performance by processing the folio =
in batches
> > of
> > > > > > > +        * ZSWAP_MAX_BATCH_SIZE, due to cache locality of wor=
king
> > set
> > > > > > > +        * structures.
> > > > > > > +        */
> > > > > > > +       pool->batch_size =3D (pool->compr_batch_size > 1) ?
> > > > > > > +                               pool->compr_batch_size :
> > ZSWAP_MAX_BATCH_SIZE;
> > > > > > > +
> > > > > > >         zswap_pool_debug("created", pool);
> > > > > > >
> > > > > > >         return pool;
> > > > > > >
> > > > > >
> > > > > > It=E2=80=99s hard to follow =E2=80=94 you add batch_size and co=
mpr_batch_size in this
> > > > > > patch, but only use them in another. Could we merge the related
> > changes
> > > > > > into one patch instead of splitting them into several that don=
=E2=80=99t work
> > > > > > independently?
> > > > >
> > > > > Hi Barry,
> > > > >
> > > > > Thanks for reviewing the code and for your comments! Sure, I can =
merge
> > > > > this patch with the next one. I was trying to keep the changes
> > modularized
> > > > > to a) zswap_cpu_comp_prepare(), b) zswap_store() and c)
> > > > zswap_compress()
> > > > > so the changes are broken into smaller parts, but I can see how t=
his can
> > > > > make the changes appear disjointed.
> > > > >
> > > > > One thing though: the commit logs for each of the patches will
> > > > > also probably need to be merged, since I have tried to explain th=
e
> > > > > changes in detail.
> > > >
> > > > It=E2=80=99s fine to merge the changelog and present the story as a=
 whole. Do we
> > >
> > > Sure.
> > >
> > > > really need both pool->batch_size and pool->compr_batch_size? I ass=
ume
> > > > pool->batch_size =3D pool->compr_batch_size if HW supports batch;
> > otherwise
> > > > pool->compr_batch_size =3D 1.
> > >
> > > Actually not exactly. We have found value in compressing in batches o=
f
> > > ZSWAP_MAX_BATCH_SIZE even for software compressors. Latency benefits
> > > from cache locality of working-set data. Hence the approach that we h=
ave
> > > settled on is pool->batch_size =3D ZSWAP_MAX_BATCH_SIZE if
> > > the compressor does not support batching (i.e., if pool->compr_batch_=
size is
> > 1).
> > > If it does, then pool->batch_size =3D pool->compr_batch_size.
> >
> > I understand that even without a hardware batch, you can still
> > have some software batching that excludes compression.
> >
> > However, based on the code below, it looks like
> > pool->compr_batch_size is almost always either equal to
> > pool->batch_size or 1:
> >
> > +       pool->compr_batch_size =3D min(ZSWAP_MAX_BATCH_SIZE,
> > +                                    crypto_acomp_batch_size(acomp_ctx-=
>acomp));
>
> I would like to explain some of the considerations in coming up with this
> approach:
>
> 1) The compression algorithm gets to decide an optimal batch-size.
>     For a hardware accelerator such as IAA, this value could be different
>     than ZSWAP_MAX_BATCH_SIZE.
>
> 2) ZSWAP_MAX_BATCH_SIZE acts as a limiting factor to the # of acomp_ctx
>     per-CPU resources that will be allocated in zswap_cpu_comp_prepare();
>     as per Yosry's suggestion. This helps limit the memory overhead for
>     batching algorithms.
>
> 3) If a batching algorithm works with a batch size "X" , where
>      1 < X < ZSWAP_MAX_BATCH_SIZE, two things need to happen:
>      a) We want to only allocate "X" per-CPU resources.
>      b) We want to process the folio in batches of "X", not ZSWAP_MAX_BAT=
CH_SIZE
>           to avail of the benefits of hardware parallelism. This is the c=
ompression
>           step size you also mention.
>           In particular, we cannot treat batch_size as ZSWAP_MAX_BATCH_SI=
ZE,
>           and send a batch of ZSWAP_MAX_BATCH_SIZE pages to zswap_compres=
s()
>           in this case. For e.g., what if the compress step-size is 6, bu=
t the new
>           zswap_store_pages() introduced in patch 23 sends 8 pages to
>           zswap_compress() because ZSWAP_MAX_BATCH_SIZE is set to 8?
>           The code in zswap_compress() could get quite messy, which will =
impact
>           latency.

If ZSWAP_MAX_BATCH_SIZE is set to 8 and there is no hardware batching,
compression is done with a step size of 1. If the hardware step size is 4,
compression occurs in two steps. If the hardware step size is 6, the first
compression uses a step size of 6, and the second uses a step size of 2.
Do you think this will work?

I don=E2=80=99t quite understand why you want to save
ZSWAP_MAX_BATCH_SIZE - X resources, since even without hardware batching
you are still allocating all ZSWAP_MAX_BATCH_SIZE resources. This is the
case for all platforms except yours.

Thanks
Barry
