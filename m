Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4DB2EB10;
	Sat, 22 Feb 2025 06:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740206528; cv=none; b=HUNNyyWI1zfiBNV8XUQH73Jnt6orPICq8ricHEkcXkg2Urk6NH0UZo+zIbrIY+3dVwVsYOM8M3lUgoKIugvPJSiXCtTMHMB8jgf9zS9xvtAjYsVsCr4qOTZRfaYuM2Kg+LFP6Wf+KB3j/B9Rw3YqVQyn+mb6XdQIAR8d72vIt9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740206528; c=relaxed/simple;
	bh=cnfG0hIgMPJ02Llcutcw46/+Ww+e021KFIks/90nkEs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O2OISd8XUBlvo6pNM+JpNyOfg28J7D3JT8haLwv0dkH/qR9O3Ub+wmnxdlTwXaJm31KO9BoyHTnJxrJghGBfQMOQIVecc95pIv4D7f/iN0GZyirjEU0fqQC45bvk13GORqIiOXVHZKu/vfD9yORT5quvj2T1ydfLaBfxukh4vfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ARAGUNuL; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARAGUNuL"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-520b58510c7so748498e0c.0;
        Fri, 21 Feb 2025 22:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740206525; x=1740811325; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oSaxQxuNaNvr7jWVenpv73vu1UWmnwa+JPv741TO9K8=;
        b=ARAGUNuLhaIJfVeTBfsDWAK0HRuqdPhI0m1XfR4lOyRCYR8gyDrtotWuXffuM3qGrY
         hgFUewbA+nHuArMPESBQNsW7mfqRpfUTsc1AmKHECdj35BMRlVrBg8vHt6IZVoaNN1uI
         LnoH/XQzwzsjF8ObyP55Xfvl8KSrpIg1r6jOhO7Xt7cHQfwZ6UWGIY7jL2W4qsJKnbzg
         sFTyJi6PLirn8Ihzwa7LVuXFNHxulH5Idh0siZH7zKvnGy+oFTLfrLfoGG2VrvBRhizA
         /wsLjkpRoj9IXqoprGn3naZpnNBtbFlvolgAVy2R35aaJ6zQtZJY3MZOad629e5DNk2y
         X2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740206525; x=1740811325;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oSaxQxuNaNvr7jWVenpv73vu1UWmnwa+JPv741TO9K8=;
        b=Ll5T1Am1yHLm88/HALUcPnwAMvgQ9Vrrmfo7lz+AVkP4dZbI3ML67e+CNgwGd4qHQG
         o2FnRFYYQspoH/c4y13jZCZ+jyIxTt9bq5QNCBjbmzpXeRhbvFlDObIdc36ceVUTdT4T
         EE/ozFyf4sTmTLWzoDoCF4oiF8lLtX79fX/+MAXekVdbIWBQzm1zDCUMwSenY8Iqzgbc
         fdIqaE+C5YF+wI2sGsY6j8BntlowE0FbamXtqvCFm8zIBT9tD171UMZj0hGUjoamKgiC
         /T9c++vfXZpGyvtIgsEd0IPSL+uu0u1qjwJoxToiLfYRNLD+iI3nzDwq6R4FMaL0Lire
         6LJQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQ2ycSxr+x9j+ciWMPsX8EBm+MsoXsImX4VD8FmhznXwI1qSwwLChilxHgLaq0dnVC8b2Y++OgN2K8vgw=@vger.kernel.org, AJvYcCXCI94qODCLxPWiNEZxt0omMP7XawNk8hUk+90zz8GvtZe6f3AWKsxQV5aKA8LriySB286gcoOyFRpbyZO1@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlvy4Juq7bZTJ4zlhWSbaGPeY4w6Uvoo3ZNNNxmxv2+mQQEWFa
	O/y2HlFbsZLntfH3zZtD42bhf/kokZqyuFcNRBPNPkHnwIJEQHe9sM5/V97LAYykXQDyhVTGmjS
	0fLKMlyF0Yy7jT+6qs8R3YF5890c=
X-Gm-Gg: ASbGnctbE2zx3r4eB6GYQ9QGx6uLgj8f/Q8xVLjTdzj3HEBfZqgy/zsGtda/gWGVTqd
	qpZMCONi7J1jdsPVZVeZzWwB2Okxy9UF0XWA8awPA8US8ZpWfCWdYc11NaX2YTQJauE1N76G6gR
	z5IA7fTH0=
X-Google-Smtp-Source: AGHT+IEUveAywgoWbMJcZ+6O4ktIym5ZwsXDVoeqsKfYbVBdGQ5yMATuk52cuIBEm+9iE2WyJ3mwLcLO0F2UQof7bng=
X-Received: by 2002:a05:6122:2027:b0:516:240b:58ff with SMTP id
 71dfb90a1353d-521ee290f48mr3236184e0c.5.1740206525299; Fri, 21 Feb 2025
 22:42:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z2_lAGctG0DDSCIH@gondor.apana.org.au> <SJ0PR11MB5678851E3E6BA49A99D8BAE2C9102@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkatpOaortT8Si5GfxprvgPR+bzxwTSOR0rsaRUstdqNMQ@mail.gmail.com>
 <SJ0PR11MB5678034533E3FAD7B16E2758C9112@SJ0PR11MB5678.namprd11.prod.outlook.com>
 <CAJD7tkbRHkb7Znzto6=RRDQA9zXZSva43GukhBEfjrgm1qOxHw@mail.gmail.com>
 <Z3yMNI_DbkKBKJxO@gondor.apana.org.au> <CAJD7tkaTuNWF42+CoCLruPZks3F7H9mS=6S74cmXnyWz-2tuPw@mail.gmail.com>
 <Z7F1B_blIbByYBzz@gondor.apana.org.au> <Z7dnPh4tPxLO1UEo@google.com>
 <CAGsJ_4yVFG-C=nJWp8xda3eLZENc4dpU-d4VyFswOitiXe+G_Q@mail.gmail.com> <Z7lv6JLax4S8vTtD@gondor.apana.org.au>
In-Reply-To: <Z7lv6JLax4S8vTtD@gondor.apana.org.au>
From: Barry Song <21cnbao@gmail.com>
Date: Sat, 22 Feb 2025 19:41:54 +1300
X-Gm-Features: AWEUYZlmcDguna01sojniDrQEtisK2vBnZybWqL2k4nT4V6CyMWa08LH70YV7m4
Message-ID: <CAGsJ_4yAQxjTnSALZHAJZDdUnXKAYFvQCcjQjHiQSUip6cJGKg@mail.gmail.com>
Subject: Re: [PATCH v5 02/12] crypto: acomp - Define new interfaces for
 compress/decompress batching.
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, 
	"Sridhar, Kanchana P" <kanchana.p.sridhar@intel.com>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"hannes@cmpxchg.org" <hannes@cmpxchg.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>, 
	"chengming.zhou@linux.dev" <chengming.zhou@linux.dev>, 
	"usamaarif642@gmail.com" <usamaarif642@gmail.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, 
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>, "davem@davemloft.net" <davem@davemloft.net>, 
	"clabbe@baylibre.com" <clabbe@baylibre.com>, "ardb@kernel.org" <ardb@kernel.org>, 
	"ebiggers@google.com" <ebiggers@google.com>, "surenb@google.com" <surenb@google.com>, 
	"Accardi, Kristen C" <kristen.c.accardi@intel.com>, 
	"Feghali, Wajdi K" <wajdi.k.feghali@intel.com>, "Gopal, Vinodh" <vinodh.gopal@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 22, 2025 at 7:34=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sat, Feb 22, 2025 at 07:26:43PM +1300, Barry Song wrote:
> >
> > After reviewing the zRAM code, I don't see why zram_write_page() needs
> > to rely on
> > comp_len to call write_incompressible_page().
> >
> > zram_write_page()
> > {
> >         ret =3D zcomp_compress(zram->comps[ZRAM_PRIMARY_COMP], zstrm,
> >                              mem, &comp_len);
> >         kunmap_local(mem);
> >
> >         if (unlikely(ret)) {
> >                 zcomp_stream_put(zstrm);
> >                 pr_err("Compression failed! err=3D%d\n", ret);
> >                 return ret;
> >         }
> >
> >         if (comp_len >=3D huge_class_size) {
> >                 zcomp_stream_put(zstrm);
> >                 return write_incompressible_page(zram, page, index);
> >         }
> > }
>
> Surely any compression error should just be treated as an
> incompressible page?

probably no, as an incompressible page might become compressible
after changing an algorithm. This is possible, users may swith an
algorithm to compress an incompressible page in the background.

Errors other than dst_buf overflow are a completely different matter
though :-)

>
> I mean we might wish to report unusual errors in case the
> admin or developer can do something about it, but for the
> system as a whole it should still continue as if the page
> was simply incompressible.
>
> > As long as crypto drivers consistently return -ENOSP or a specific erro=
r
> > code for dst_buf overflow, we should be able to eliminate the
> > 2*PAGE_SIZE buffer.
>
> Yes we could certainly do that.
>
> Cheers,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>

Thanks
barry
