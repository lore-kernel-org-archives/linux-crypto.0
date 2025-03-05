Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA45C1C6FEB
	for <linux-crypto@vger.kernel.org>; Wed,  5 Mar 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741194450; cv=none; b=tFeJKi0j+wb78d0+fd0MYZoVxixOYf4Il1eDjoI2/l5B67nEt3jbyHDe8SMi0fOnoCmbfySclF+K78IYUX3iWfhnjqS2vjitPMEC7WZzMECR5ikMkNBSNsU76JXy6EfWMGinfue0WeyShePWIT7Y9G7eE0irboRIMmOF3MH10XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741194450; c=relaxed/simple;
	bh=IrDAdDeLwUuVeMKM0cQi7AzhOD4W0udt5kGWGBqKvzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cfFSS+huqdZdMLuMONXRR1BAk/hG3rs96TCmhgqqEeQzKWuKNjBgoMuGkFZ4EiFTQ8HPVnTQrIxN+8yeO6Fw2hTJaGKBtKrzyS+PI55ffmvFaPzBjhLj/Nf+JOB+dHpeqJuZKa8bEQC+OXty96OESytB1vDC1eK7/KiVFfMbPTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a9W2Hpgw; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a9W2Hpgw"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6dd049b5428so62693416d6.2
        for <linux-crypto@vger.kernel.org>; Wed, 05 Mar 2025 09:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741194447; x=1741799247; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IrDAdDeLwUuVeMKM0cQi7AzhOD4W0udt5kGWGBqKvzg=;
        b=a9W2Hpgw5AcgjqDdTelM4E2uONYflCcC1isOvniVPUegIPnErH01oJVRnGroxa/CpB
         9bBHKFC6Ezv8fO352CZzEguCyPnWvvytYlu7j/pzmf16FeKUmtSc1bnThqnN1sUnqRdv
         Bu6C7sEkjmjrRbR7T9M6xm/lqMOxVFRuviAMHwWBkOPAfWEjj4cBwI26ynAXWbwbaW0n
         rZpgYZumaKqyGBQPJlT+QBrZorsArDZeMUYAmUgu05c1CqBsp378qey6k+NNa2Myu6ML
         JPomwezZUz7ewDvf1LQQNPtJz9CdzjTYCdymziErC7PQSwXdPGmFF7PX8ei4leD2lgyL
         xusw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741194447; x=1741799247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IrDAdDeLwUuVeMKM0cQi7AzhOD4W0udt5kGWGBqKvzg=;
        b=Up2utAx+wnbCxDEv8OnqE6QminyfEHgOPDjd+v4iyr88PA8gpKy34qWEJBHy6TrKBM
         Xpb2ISOxcGiwNr3PR4YqK4NqXQXoqt5jt11tJThmmcCOHLxjy56Al0l/oECOLfKzJm9t
         eLvO6o6/BRV09KQiUvQya02oqrFlgrRMJ+jeYjgsvmnPgFvIcEhEenUVIAL3lfMzEl2/
         Y9ZhfyqMvKMBKZAYNfa3JR+yWyuK5CnM9MlmFSoyguMq8KF631EOeqScIkFKcfVJzswB
         xLQpV+z4IDuK4DsWpt8EMmKVKQ2uBUQVqlpPrFxFne5NBBJNwhtDRgmUtf/Q2iJt1WPP
         raYA==
X-Forwarded-Encrypted: i=1; AJvYcCWkT9HSRiMwdgHbaEfQBUiu7XfWocX0Qg0AFMf1Z6w8JdHuDXUkbHA2D43zERUQP6ZFoTeoeXqaS/M3O/s=@vger.kernel.org
X-Gm-Message-State: AOJu0YwFqy/G658ciplZrBpO3Cofon6ZOJV3UG6QX7AW0ki6jZDbts1X
	gHVXtgo4E6LnSCxr1uWdPUtFIyrwGRj6Io/REYI6eJI6MT77iOUCjSl2x2BSbY9Cw7hZxSF3AuU
	JM0VN3SYlOREveGNilwnNKHCcXFhZxQMc
X-Gm-Gg: ASbGncvOOCHJmMs4/yQLUgYhE6kEy42FkD0HdPmmrTiZpg9W9VPZReJv51o+47sA85Z
	NzGgfbQjtspShs/cZYYFShpefKPnhYnUbxWutwy7rfCsunsGHsFPLi3ppNfRf5hvQ0yMkmIZysU
	RjM3QOlTnzZkWrf2luxlDsmSDD3Cby4EnDcCX81BIKiV+c4LqBYp9OXqbr3A==
X-Google-Smtp-Source: AGHT+IHlGvKj30q2ZD6D1kyBWgqCsWE7vSW6M9vMSiVPKsTE+7Hv+cxY7wDuZ60gtMIkmMT2a0TwPz+VQM/eRw9aB0c=
X-Received: by 2002:a05:6214:2241:b0:6e6:602f:ef68 with SMTP id
 6a1803df08f44-6e8e6d1065cmr51868466d6.10.1741194447552; Wed, 05 Mar 2025
 09:07:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <Z8KrAk9Y52RDox2U@gondor.apana.org.au> <Z8KxVC1RBeh8DTKI@gondor.apana.org.au>
 <Z8YOVyGugHwAsvmO@google.com> <Z8ZzqOw9veZ2HGkk@gondor.apana.org.au>
 <Z8aByQ5kJZf47wzW@google.com> <Z8aZPcgzuaNR6N8L@gondor.apana.org.au>
 <dawjvaf3nbfd6hnaclhcih6sfjzeuusu6kwhklv3bpptwwjzsd@t4ln7cwu74lh>
 <Z8dm9HF9tm0sDfpt@google.com> <Z8fI1zdqBNGmqW2d@gondor.apana.org.au>
 <Z8fssWOSw0kfggsM@google.com> <Z8gAHrXYc52EPsqH@gondor.apana.org.au>
In-Reply-To: <Z8gAHrXYc52EPsqH@gondor.apana.org.au>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 5 Mar 2025 09:07:16 -0800
X-Gm-Features: AQ5f1JpUxMxJTN0qiM9PWOcfL5HuHUGuSk3KYsWuMOncT2xkIkYFnpZEKpYKz1c
Message-ID: <CAKEwX=MoiqOCDt=4Y-82PKUg92RtFxR1bOXOottSC2i1G7Bekw@mail.gmail.com>
Subject: Re: [RFC PATCH 7/7] mm: zswap: Use acomp virtual address interface
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Eric Biggers <ebiggers@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 11:41=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Wed, Mar 05, 2025 at 06:18:25AM +0000, Yosry Ahmed wrote:
> >
> > I think there are other motivations for zcomp. Nhat was actually talkin=
g
> > about switch zswap to use zcomp for other reasons. Please see this
> > thread:
> > https://lore.kernel.org/lkml/CAKEwX=3DO8zQj3Vj=3D2G6aCjK7e2DDs+VBUhRd25=
AefTdcvFOT-=3DA@mail.gmail.com/.
>
> The only reason I saw was the support for algorithm parameters.
> Yes that will of course be added to crypto_acomp before I attempt
> to replace zcomp.

For the record, that's also the only reason why I was thinking about
it. :) I have no passion for zcomp or anything - as long as we support
all the cases (hardware acceleration/offloading, algorithms
parameters, etc.), I'm happy :)

Thanks for the hard work, Herbert, and I look forward to seeing all of
this work.
