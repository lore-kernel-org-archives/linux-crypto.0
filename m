Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED37D1F543E
	for <linux-crypto@vger.kernel.org>; Wed,  4 Dec 2024 22:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733352944; cv=none; b=i4++peLEGe40uBrCRuAbaoMr/L4E4SlZxPiJkg4fm+cu3l5qMXRckRZQ8GA26SWO/ryWopl3OC1npwr3rYNT2AwJ75LDnhIMRT7Q+XidLGL3MezGuzKKjOWiAfjhdZGz1u7pK0k2HIPYRSZszeDTAmBcpsCWi27vPwtQ6HZl2ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733352944; c=relaxed/simple;
	bh=sn4enATu6n42dvq7Gr3MM0WwCTGADHpPBuoqCtsWjMc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ILvtM5NrFXfPFir/9Sfk7OSI0VDOXxUOoV2/50AEus+OvXlFpQbkmWGb8uEK65EElSMTWASkGhcYBQVfy+WtQfHF62Ht6v2Mm80X7WiNcxkj7pNL0F/lT9zN0NaK4quVxJbN1JuWYOR/UxgO2brn/uPWOogl44MMeGapqF5af2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b57mTEVz; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b57mTEVz"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-46684744173so3854621cf.3
        for <linux-crypto@vger.kernel.org>; Wed, 04 Dec 2024 14:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733352941; x=1733957741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h8PrHsy7yaVJu8qpxJGFoxRiq8VZTbuR/cuaMqNGRsc=;
        b=b57mTEVznwGgmhqt5gAsg8h7j3aB2+l5F/wOMndhABhH6Bqv3wbH1K6UV41htvJCfn
         7Y5jGauXFw35WP4q2NIV3A1TSX6n+kpbahf5PgGEfbVLttbptGHIkrRaaxpzT6yxTY61
         JpHFM6/uyjgY+g4cZZLtkZ07kK8v6eQNXLL70gv9xYweKpyqTygnpS6l7rVg1/eqqnOR
         9fyjYjG/0xFr7VVaLAf4UMVVh0NEXXhslm3pfwIO9sN1ZyjvvQdDlNsKjbFsC6EjoTEt
         W8vQrOb6EWHSepn5Tiz6OV6JuvqWQCy4hbxdaT/Iwv/M2SXAxktFO4ZPNG4YmoLQLumR
         TY6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733352941; x=1733957741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h8PrHsy7yaVJu8qpxJGFoxRiq8VZTbuR/cuaMqNGRsc=;
        b=eSVhNlteP7Xw0D75U1Lj8/wRQ1cQpGbBcjnD9dSiSijUolz739Om2T0YyUr0kUveEf
         p1/1QbZ9t7jw4inAqLfFqfrRvkod/mMNhKWmDhAf5UQwhbisvqJLl/f8mTDhnvXoNkbF
         iNdDKYNXVfsvQBeq6IRDTp3tzr5UMUwym+3Kizof9nFelotaC5FGCNTttQU18KpOeoKD
         M7ttJn8JYCymL9vsDBJE3YYJX5hwFGpu7gFwSQ+juHSMGoljN3V6azhzXE244dNo1F/C
         AqAaTO7CLf459Kqhi4CN1L2pgzaE71l6RAvLoIbJZ9CQXuh62Jt2QgZa0PwXPhLb65+K
         LyCw==
X-Forwarded-Encrypted: i=1; AJvYcCXw9Ztcc/oGKjvPiNU2XDMYUzRsIJI7W4h6dVwWnLq22l/y1ofqqS2AopF8Q805ZMtWZ0F47JvMuMNx0Wk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2cGIY9r20KuO7YOV09mMHWEVqhcAqV+vaYpaKq0CcPgu7dKH6
	3XYvKEwdpLiAIGcKWZYFwS+ZgU41t6aBucQ8Rul3ghjLqbBv8I/AlYnqT5OLoukBpycBAM2cBjd
	rF+8wnipPfeohMgSrhD/uhFg72xgsd+wHN8Da
X-Gm-Gg: ASbGncvxwS/KhPVHnAwX8lc8VivxOLrZiafklvsU7hemDFkI8ulMh7kjBBnYSBGdo5/
	nWuNAbbROvfNoqTgdEeY55NRabZX/
X-Google-Smtp-Source: AGHT+IFHMvdGJnDSH/n2cmR1dw1uCaoTdi4uTiVuOPJ7MAJXp/aLmZCowxUTvoBD+ogJikqJuWi8/DrgUYgZfKbTBzw=
X-Received: by 2002:ad4:5f8a:0:b0:6d4:1662:348c with SMTP id
 6a1803df08f44-6d8b73067b5mr123350746d6.17.1733352940619; Wed, 04 Dec 2024
 14:55:40 -0800 (PST)
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
 <CAJD7tkbui2MTkkGA6_+RDA0oZW2m3rMnUTKp1Fp6tPqp2QLgKw@mail.gmail.com>
 <Z0-zboLmrybOt8pv@gondor.apana.org.au> <CAJD7tkaJwti5vwUXP=T9MW4XXHmen+SCQXv=hWWN+-V3SJJSVA@mail.gmail.com>
 <SJ0PR11MB5678F2E6E78A2B74D2F6AB8AC9372@SJ0PR11MB5678.namprd11.prod.outlook.com>
In-Reply-To: <SJ0PR11MB5678F2E6E78A2B74D2F6AB8AC9372@SJ0PR11MB5678.namprd11.prod.outlook.com>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Wed, 4 Dec 2024 14:55:03 -0800
Message-ID: <CAJD7tkbgaV-KjvAyLs5LXa95qb4f93QY4FxCzt7r-Juccq4z_Q@mail.gmail.com>
Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resources if
 the crypto_alg supports batching.
To: "Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Nhat Pham <nphamcs@gmail.com>, 
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

On Wed, Dec 4, 2024 at 2:49=E2=80=AFPM Sridhar, Kanchana P
<kanchana.p.sridhar@intel.com> wrote:
>
>
> > -----Original Message-----
> > From: Yosry Ahmed <yosryahmed@google.com>
> > Sent: Wednesday, December 4, 2024 2:36 PM
> > To: Herbert Xu <herbert@gondor.apana.org.au>
> > Cc: Sridhar, Kanchana P <kanchana.p.sridhar@intel.com>; Nhat Pham
> > <nphamcs@gmail.com>; linux-kernel@vger.kernel.org; linux-mm@kvack.org;
> > hannes@cmpxchg.org; chengming.zhou@linux.dev;
> > usamaarif642@gmail.com; ryan.roberts@arm.com; ying.huang@intel.com;
> > 21cnbao@gmail.com; akpm@linux-foundation.org; linux-
> > crypto@vger.kernel.org; davem@davemloft.net; clabbe@baylibre.com;
> > ardb@kernel.org; ebiggers@google.com; surenb@google.com; Accardi,
> > Kristen C <kristen.c.accardi@intel.com>; Feghali, Wajdi K
> > <wajdi.k.feghali@intel.com>; Gopal, Vinodh <vinodh.gopal@intel.com>
> > Subject: Re: [PATCH v4 09/10] mm: zswap: Allocate pool batching resourc=
es if
> > the crypto_alg supports batching.
> >
> > On Tue, Dec 3, 2024 at 5:42=E2=80=AFPM Herbert Xu <herbert@gondor.apana=
.org.au>
> > wrote:
> > >
> > > On Tue, Dec 03, 2024 at 01:44:00PM -0800, Yosry Ahmed wrote:
> > > >
> > > > Does this mean that instead of zswap breaking down the folio into
> > > > SWAP_CRYPTO_BATCH_SIZE -sized batches, we pass all the pages to the
> > > > crypto layer and let it do the batching as it pleases?
> > >
> > > You provide as much (or little) as you're comfortable with.  Just
> > > treat the acomp API as one that can take as much as you want to
> > > give it.
> >
> > In this case, it seems like the batch size is completely up to zswap,
> > and not necessarily dependent on the compressor. That being said,
> > Intel IAA will naturally prefer a batch size that maximizes the
> > parallelization.
> >
> > How about this, we can define a fixed max batch size in zswap, to
> > provide a hard limit on the number of buffers we preallocate (e.g.
> > MAX_BATCH_SIZE). The compressors can provide zswap a hint with their
> > desired batch size (e.g. 8 for Intel IAA). Then zswap can allocate
> > min(MAX_BATCH_SIZE, compressor_batch_size).
> >
> > Assuming software compressors provide 1 for the batch size, if
> > MAX_BATCH_SIZE is >=3D 8, Intel IAA gets the batching rate it wants, an=
d
> > software compressors get the same behavior as today. This abstracts
> > the batch size needed by the compressor while making sure zswap does
> > not preallocate a ridiculous amount of memory.
> >
> > Does this make sense to everyone or am I missing something?
>
> Thanks Yosry, this makes perfect sense. I can declare a default
> CRYPTO_ACOMP_BATCH_SIZE=3D1, and a crypto API that zswap can
> query, acomp_get_batch_size(struct crypto_acomp *tfm) that
> can call a crypto algorithm interface if it is registered, for e.g.
> crypto_get_batch_size() that IAA can register to return the max
> batch size for IAA. If a compressor does not provide an
> implementation for crypto_get_batch_size(), we would return
> CRYPTO_ACOMP_BATCH_SIZE. This way, nothing specific will
> need to be done for the software compressors for now. Unless
> they define a specific batch_size via say, another interface,
> crypto_set_batch_size(), the acomp_get_batch_size() will return 1.

I still think zswap should define its own maximum to avoid having the
compressors have complete control over the amount of memory that zswap
preallocates.

For the acomp stuff I will let Herbert decide what he thinks is best.
From the zswap side, I just want:
- A hard limit on the amount of memory we preallocate.
- No change for the software compressors.

>
> Thanks,
> Kanchana
