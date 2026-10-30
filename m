Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793386667;
	b=Dl8aGRTA/X54z+3SpX0M0bvdAoymggdXtVD3Za6vmsk4RcSt8ypebjVJPKiMiDgyfT9j
	 j7ZFtmJUXS6pbGdmY2/guzSOKswhO4ceYUVA/zAV4kVXRRIPlXJ0owG+sAXdSaPrGboyd
	 RdAPYs52O5e0YZreHQU+gq2AD0o30Unp5MkJIKzppN/zNpubnBi8PXZk9ZBIhZ+KIyazI
	 AsXhYiRiwZm/VrklAQbwwBboS4BBRnf3udkzsGCITYYVrY+F/ZVRaN4tAqu8Hb/cd3PkY
	 2BlH3mEsW7SamCVuMlKZeLrD6IYip6aTo6DZsukwUJXRHHLBN/2dPumXqFb6EigQe3Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793386667;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
	b=DNckp7+uoRKhZb5MU6O/bVYlNCgF/ejIkIwntwBMkqcFWAwACJRfJ3mXpld5HyKpZf5U
	 /Utg3ywIEy9WVnNxIa3izrA7B1LKeLhXiVOZc8PpTMTQVSyJt+TyKzJwUgsLjeLCnK2BL
	 jxRweLmNqmdxGDMYURXoYglEtZOqBJJ4x8hpXt7qt6jFYKjEFlkBYAGFYvX+ZMj3Rd0fF
	 cpRpliOA7UKczaoKI+kQ/SJLZVy7qdQK0BHf9m1D+5YQzDHSdPVsC8UqUSNiu428sGcR8
	 nkVz4+sBPZJ0oXPPXlQqFuWiAwabwJqWbWoCpLVD+0a+JOpY+RNaBbslbTz2zbJtk6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OxzrvNrf;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.51
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D316606A31D
	for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 18:57:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1D316606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OxzrvNrf
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5ba35c0df4fso1169028e87.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Oct 2026 11:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793386665; cv=none;
        d=google.com; s=arc-20260327;
        b=lLEZe/3B6TNW+DkzHRa+yIpifalYuYAoHrxxE7RcrGpiAijyz6ZIrc0aUz16NI30G4
         c5Err32IUoLBcpiFUgBceq5epBq7dYYa1bKmCZWycPhroIn4M7a4lp2srvwXLjUXFm/C
         oSc6ipj7q3DT4ih8zoc1SnIwG/8EdXefJnAIYS9VnvcLsMm0Xuom2rmjFXZuQoE/SRp2
         rtlUaGVlsv0Vs/U+eOaBuZUgH48ukBXqVQsL2Nz1283/MYa8qXMadQmWkYHudACQAkFh
         I+PEWLchgkMHoSDNEUfb8xRudr7YqwlWjU3nbLP9HUyja4R66qXCoHiJjXs2lGh99DN1
         HEpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        fh=maCaKkdM3juEBXCMKeD/Ra0UTXALSMI8mmaKIupjV/Y=;
        b=IgfiS4GMPgExMk5X/CP71lo+zWGtnwtpGQld5mQwCss1GLWaOQd09CBqmYzy7APvkF
         Y4gDs/S0GAXeR+uFa0DYoqdpx1bsX4MQrmyzGfqTF9EcjUPK9W+/LuQFYgAT9+reEzAb
         LNhkU/irDZ7f/MXV0+1iMpjFnNyTbklVw1Qvcn4zlDWanQxceoMGWtIhWhMIR1EhB9ss
         EsYty63J2ho7R8OZ//TvGM8DwwsNmNvZo26SvI757ZGWhezEhlb3dDDjS4aVOxHx90w6
         1UYV1pk08gowEOFLKwOqSyPVi2WnHDEjJfpz9IaGKuDyKgiErlMjGPDWrBSDcUtEjRAR
         osVQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793386665; x=1793991465; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        b=OxzrvNrfWrTCKHaEXeJq3CpXwXBlBlqT8VigytE0kQJ2WOVI58Gegt3PIWoUhvqRs5
         FDq4iThJqgVHvu/m3EQ1mtRxgogqFq4R969bAtQQKVNN3+Ujq0QXIgCJC+WF8A+hhBae
         55gQPvHxu+HHzduPo4e+64P1UeumeXYsgRU/cGZAyob2eB0fEPQ/DZcTa/BRIcPETkTK
         I8rCDw8XoR1ExJ7N625MR05h6FqryzGjS7HMfLnjqZDXaaELaAJ0VBuLXoDtqLw3MVMN
         CxmdsR/ofprvraVtByXOd3b6plmUz47xx9rZ7Rp6oAAC0CRJQsy/MFWkEU7++3dTENi1
         lFHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386665; x=1793991465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        b=AwrdLRz4bvtGo3xYb+8eiNfhkb5g64alFLXmmlXrQk3ZoFv4I+Ex95ZeXU7vmg77vd
         raLS8Wqa1zilaP1LTitL1ESdIlyBtI2N7VSrA+Mu4qGLJD3d+Od2DzvycKyyt/w7/nTg
         ExGVU+fDnupUIOD8XBsd9yNgT2NXXYhezqHms6E6+VWTzixdz0km/xhLpHe9KEPAFgVn
         fQDo3hJRnmtGPWwn6RRfiGcRz7yudZ86VGYKMkpNYwVM0rnyXeMsFxAWqDbw5mc+rq5+
         CqI3FpMKEqYDYPgzuNWSReFnU/2+zyKPjpDxaw7ynwOhgz6NLOUk5BUyyNoXDoRQjqex
         H1Eg==
X-Forwarded-Encrypted: i=1; AKwUvBw4CCZiFJH+HJlSm6sWqadH+PyR6AUoU8p7n2OWYoqRr5MX5C2lCaM8ROSgxDj0a8wj19CgiTAOoN7rB+U=@vger.kernel.org
X-Gm-Message-State: AFq9FYLORROE+75LuQKhFJdY5b+lioVRsKftxTlIT0FEO8Xy3uopUncI
	aF3unFIh8DKt1qm7hB1qphd43C3RHyRVdVOZ6t7GkkIUEBXjdy4JGH1lzZynzBxw+KJzIIlKBsq
	QAtMerDIdd5sj140vGvujodSGXF6IgGE=
X-Gm-Gg: AYBFou1MANN3INUxmA6Rb4hQmvkb4hiMHGLvn6HiDhAQVd70p984dwcZ6Y3kD1Y0JAt
	1LDkLL3xC2x9AbcangxpQTAUQf7yMnru+lD/mznVsL+ae97z2brHT/3/gyGTJfpJYE7QvFNskkR
	M+PZNOUTXgcyCD4JJiCJb4CK6w/uYXFRWh9BuhFTc/558yl+td+bY1bf4ZZe2JbnUBVLOflZdOm
	Eq6fkxis7HNrL093HMFmgUrj/aENqpq4UqRt01Xk9pAVbM4Rm2fmu1A4elBVutUFZD/J125lAba
	WC7gmqIUrDgib62X8onLjfAKCMyCqdA9QjWkn5xts98Ab69yrB3MF5MHf5MNxk/Jy6xBYd5wEO7
	m2FwdGAIu0aTc2IonDdPaC1NNpu7wj9jr9iYMLZOe7gW+aTH9TTIgLikVLA==
X-Received: by 2002:a05:6512:23a5:b0:5bf:ae0d:5c8e with SMTP id
 2adb3069b0e04-5bfd957c5b8mr1213952e87.57.1793386665018; Fri, 30 Oct 2026
 11:57:45 -0700 (PDT)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au> <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
 <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
In-Reply-To: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 30 Oct 2026 11:57:32 -0700
X-Gm-Features: AclHuK9yf0museVZzj5aEtQylAllkhugfekxs2Uqb3nStINOr4M3_o9XKSMDYxk
Message-ID: <CACpmpodboNxOLAKRxOL75HtPawJ_rhOXUh1_UW1aDtA8NA5sxg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Yosry Ahmed <yosry@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, sashiko-reviews@lists.linux.dev, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 7:49=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 29, 2026 at 11:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apa=
na.org.au> wrote:
> > >
> > > On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> > > >
> > > > This is how it is in the current mainline, and has been for as long=
 as
> > > > I can remember.. I assumed it was because we need a per-CPU acomp_r=
eq
> > > > to be allocated for the tfm. Can this be done with a single
> > > > crypto_acomp for a given algorithm?
> > >
> > > The request needs to be per-cpu, but the tfm does not.
> >
> > Great.. we can save a lot of memory this way.
> >
> > Yosry, should I go ahead and include this fix in this patch series? I
> > am Ok if you want to take this up.
>
> Feel free to send a patch, but I think it doesn't have to be part of the =
series.

Sure.
