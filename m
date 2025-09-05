Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766D62C9D;
	Fri,  5 Sep 2025 08:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757061985; cv=none; b=A+X8NvausH80jqdQK4QUaNuJ1JAsWWDCOGn7UVGdb2FGBIH6JI8gOB0F++Oa8xRzd/n3aZA35nLdX3LGEonOAbJnf7YQ0TFBYv+0bpQFurx/CGSuclPxEy/6IicNeUj8LirKRD47mNsskBFTvj8VBB/0q355K5WzuE7wGm0q7vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757061985; c=relaxed/simple;
	bh=00exLymqkvnpp3T8dxyEGh2QBjDNwmc2T2vb2kDYJ6g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KT7k8E1MTBYhNtxwIj/gu4p6m7b5t5kTYcp/urDt+7la6M1N41K4hvgGRLs1jDaE2M91o6Vwr2GOAod5UpeSlDzbH7S9+ywfQFcprlGAEyobINIC0UKkzicsLNlGs8tfNNJaa9anIsBmGvzfgL+ouCZjv4rE7SLTUX/bCEkBC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g3V5gAgo; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g3V5gAgo"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b52047b3f19so629684a12.2;
        Fri, 05 Sep 2025 01:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757061984; x=1757666784; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w/3us9q7SO3a7mU0skwVqh5PccHM5efYByNeek2KuIo=;
        b=g3V5gAgoTPvUx2iHiXsT+RZQFb0uAB+07v+D/dFKwfA323RQX/Zh3uy5ZG/HAadXd/
         1ElSI8IAmYD3PMnQOgrTUjHhBk87LTCyoC5R2zVGPl1h8eY6q2Mts3QGEWp4MpK1X/Zt
         Oc4wcCJMtgzztqUcHkd5sHN+lU0rRt3AdUlp1Yg7LG3L+JWoy0lLKQiZdsgc7QFJf3P3
         1PULP1SVR4YEtif3WsjS9RjZG5PWpZDjsxyGfEvHJIc2Lq86k+/q1DRkuPfBIiX7lNXn
         rfICeZQbU7ErBN7A1CaUx1pZFNCoGDYYWSW+Ul2uw6U49aGC+F8s1HNbxD1lYgsPeCCm
         gv1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757061984; x=1757666784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w/3us9q7SO3a7mU0skwVqh5PccHM5efYByNeek2KuIo=;
        b=klg9LGYbFW8CIyyrP923NsMiEu7XEVEZ49vI2ZXRei+Qtx5/3iC05c+abdNuyuoMo5
         60+wtMGcfDkNGOSQuHAVtW4raGw2eYlKrDBu8kpp+xlW2pOf0iVLI+FSIMzY0+GPiMwP
         lNDuSi0+CDM2xrqba6Jyldjxoy3K74yroYPTJD6CaKc9U/plDEBmLYanOfj/2lt4vC7q
         jSHb+bjf9cjr9/e6bZmMjNKGExXEmFQZIMrSKqYx8IUfw8yClfUa9zg6yXmESh/SKoZk
         w6++J5Ob1nXaHEn+jD0pf94z1chEfjolQSYVHoQrh9Ol/ViyuAzc2/aryixzBiPP2CFW
         S3iQ==
X-Forwarded-Encrypted: i=1; AJvYcCWy7ANDlaHifHr66NwSkx+MaIA6BXq7E+E9Opfcww5jbz1CtULVJCHEjWScjGg0tD8xnbgmaC3TSF8cRHE=@vger.kernel.org, AJvYcCXcJ+TbW2vAmr8dxIdojPso5OPCzD9/7zPEuCOhHqLpWI4JTfHQFcz2XD7rdfNZ9yaBBr6vbqwK/CPMYWnn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8LjyoKPIEUnCjNoDU7I7ovgijzMOI5uy48R0Rb9nlxR36X5rG
	0AEAbdG69jnAFfBFLbBMCWz6/eWUo1qps/YmGOi+5v36NtgS629iqIeDqSkyxYN02bwTEnmxs/8
	kquQI+eiWrVNoiFvLr9cgatwXDga/zQI=
X-Gm-Gg: ASbGncvHqVhK8U/iOIxgBUfI1f78krjD+u53vObhqoQibz3g7Yn4kSXGYnpfTREaVsj
	sp2C1R5UsC082qeO06Shnp0h/kuEcSKvE0ZDcEBkJZoH9/6Rs9yhE2jdl/O/PS4TBuNUdA3LEGq
	wzBwp/ZuNgIzPRI43nwf2c/TAtdW4J13HNA8yz64nLTsCsUDw1WQQ1P8N8qBW80gi2MDXLMUatZ
	Mc2RmQBjN3F+vrk3C//atH3t5+eS4zy+4nwzA==
X-Google-Smtp-Source: AGHT+IEgZ3Eftrkppq1vXGap76yLwC8VeWEdDVcer7sGUvlg3ifsdfCIykIdtTSslNhI1Xh7L4rf7v+2AN+/xauuHq8=
X-Received: by 2002:a17:903:19e5:b0:249:11c3:2db9 with SMTP id
 d9443c01a7336-24944b498a8mr331935075ad.46.1757061983557; Fri, 05 Sep 2025
 01:46:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
 <20250901164212.460229-2-ethan.w.s.graham@gmail.com> <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
In-Reply-To: <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 5 Sep 2025 10:46:11 +0200
X-Gm-Features: Ac12FXzjiY59pui3__MIUUA0N5euXw0YDQBMc9KrPXFvKz93QZm3lShTvhMy6Y4
Message-ID: <CANgxf6wziVLi5F5ZoF2nwGhoCyLhk5YJ_MBtHaCaGtuzFky_Vw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
To: Alexander Potapenko <glider@google.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 5, 2025 at 10:33=E2=80=AFAM Alexander Potapenko <glider@google.=
com> wrote:
> > + * - The poisoning of the range only extends up to the last full granu=
le before
> > + *     the end of the range. Any remaining bytes in a final partial gr=
anule are
> > + *     ignored.
>
> Maybe we should require that the end of the range is aligned, as we do
> for e.g. kasan_unpoison()?
> Are there cases in which we want to call it for non-aligned addresses?

It's possible in the current KFuzzTest input format. For example you have
an 8 byte struct with a pointer to a 35-byte string. This results in a payl=
oad:
struct [0: 8), padding [8: 16), string: [16: 51), padding: [51: 59). The
framework will poison the unaligned region [51, 59).

We could enforce that the size of the payload (including all padding) is
a multiple of KASAN_GRANULE_SIZE, thus resulting in padding [51, 64)
at the end of the payload. It makes encoding a bit more complex, but it
may be a good idea to push that complexity up to the user space encoder.

What do you think?
