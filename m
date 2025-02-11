Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9ED261564;
	Tue, 11 Feb 2025 17:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739296366; cv=none; b=nD5gN3yZet0TPtjfasFQ7RlhnptYZpNy4P/W2s4REZncyRx0qCsPlxaVLe4q1AeVoy5gLzjuXrj7j+kJGBKNglW6+RW6gwp5oRh4K9f/smiBjysB3pMmYX093eP4Ia2nPXTpbZtmEnqkFKnnymQKSrmH/FjIhW0uH6FvSS5sLXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739296366; c=relaxed/simple;
	bh=Gls7ZslF1W+313UhYUN4pkhQXNUWceUe93PWKZiH2Gk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QBOq+US6bXjfWFuoK78oOBZ3wtmT4KwnHkdENrC34cSXgK1IrO5KwMfDHRYP+dK60ZTsxy0Ad2zOPnaWD+86M68IrabOZK5MEepDXUxhpXMOVyCsaq9IGUd5BkF84rtejO//UJdmYPejGGC9HdFK6u7LasPOFkaneww9n3gORoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CP3LfzXQ; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CP3LfzXQ"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7c0155af484so767107885a.0;
        Tue, 11 Feb 2025 09:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739296363; x=1739901163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alxnJNPbq/1DdW4EjlxryX0UCz6LPOMWVCLdewe/w6A=;
        b=CP3LfzXQzRQrO/taTyzrDJV5LlGe+KNJS6AvYxNIF/X9wsfLD/zmSMn/Ccp8NNuSRU
         T12CyXhs8aZ3Qtyej4R2I2aDCnss8B5Wolo+NbC6IA2EYz13yyXpxsErBM+U6+B7XMxk
         2H9IFDfXcTQg4nTBC1qmUTUgbkFSDX5/B+kfW6DlMd279OTmoR1PGyTjCosT2rQ2P3Mr
         GMWXXd6t2t/GxNJHq184hhAgsk5xaugiH/dXfJ8AU8h5YVNHUVZt2vnbBzH3JptUBbdo
         GLlHPN9zbxg3RJwAouOvFb1JQIegUVpQhUUrBe3M/83p5q0favya47eUef4hhLE3wf4D
         U6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739296363; x=1739901163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=alxnJNPbq/1DdW4EjlxryX0UCz6LPOMWVCLdewe/w6A=;
        b=rgK6x3XzQQ5ejTWIlOgykoFHFZ0YP4FZtBsxexN+ZWOt1wt5aYyWDo5OPdw6oatt3r
         f8j715JUUDz+bcE9rsgOQeCRE0VUVhvi1oRckCFIKLlMaOk2uJCY0zTw//SINmbPUYpq
         FI28NU0UWega2EEI9lSObs7AR6XtW2W9GC8JkfJdl2nt2YWiEniF55Z5l1YW+De+p5FO
         wEDL84nU4yLxpq0Bkw52XIO15spilzKkN3+YhCvbp7pFHUF/wO3EWjLvI2bYmmdk6hgr
         Zj+8VmoqIhAnSnHEIfrMWW5Nm+KFt3xKzWpH6eDAPVfweHTRBf1UAVhm844IZ18YbD3x
         hKMg==
X-Forwarded-Encrypted: i=1; AJvYcCW2Pji6zjV6eUEUphvanjQfqwTz/gOlDCvCg7/GNoVPMC1WjcEZ89aYF7Md0+Fbn6DZojP6CFnqVvDt0meC@vger.kernel.org, AJvYcCWI8s3Eg03w7Nm7j7G/mwzqvoOJbF8ghcBDYtoKHrAiE5WzaEROcdRTZotzp64dGCKQ1S2n/s/2oZFtcFk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxp17fWepkBDxYXQuobTu6FuejvAvCW2j8HsBEHxO3bZmr0CkLE
	K0iGS8FYDIBsVqB2q3MGvZECqkG7eTCQt/x6yehroQvFq0YcK79U8DiqY71xZpx+U3MPY4315Nv
	iMl40Vrhq6aPmoSqR3TykFvemVP8=
X-Gm-Gg: ASbGncuf15C6d3gfI55kYvmmY/fYzFSK0dr5fjY9O374V1Y47rYcGFQXdrhy5S8p2Hn
	jUUNsEZHBKrpjdQph8dNB2UbCkx5RCjHR6aZJHIU2rKNihi7VYJ1XXrbmHcoO5W8+SYLsRvHVk+
	tOfLidwMQUHEp9d0IpcbuouhubmFHU
X-Google-Smtp-Source: AGHT+IE3VPNOnU63mQthg4Oyhovmexbq09LRCaEDUIKUz/i4EAR1nU8AN5MdiuFBRNFyRDfkrKCEN5igQcBrWu/GWxo=
X-Received: by 2002:a05:6214:1c49:b0:6d8:846b:cd8d with SMTP id
 6a1803df08f44-6e46edac168mr3233286d6.30.1739296363271; Tue, 11 Feb 2025
 09:52:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206072102.29045-1-kanchana.p.sridhar@intel.com> <20250211170513.GB1227@sol.localdomain>
In-Reply-To: <20250211170513.GB1227@sol.localdomain>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Feb 2025 09:52:32 -0800
X-Gm-Features: AWEUYZlcOdbZA9SqNCGkgKNQARGdRy_FNFi_eHNg0PXmpnE9bsAdcYk9s4FLLwY
Message-ID: <CAKEwX=PRzZEYOuTECjjqYbUDXUjMzOc-R5s14-iX8qevDxGBpA@mail.gmail.com>
Subject: Re: [PATCH v6 00/16] zswap IAA compress batching
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, hannes@cmpxchg.org, yosry.ahmed@linux.dev, 
	chengming.zhou@linux.dev, usamaarif642@gmail.com, ryan.roberts@arm.com, 
	21cnbao@gmail.com, akpm@linux-foundation.org, linux-crypto@vger.kernel.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, clabbe@baylibre.com, 
	ardb@kernel.org, surenb@google.com, kristen.c.accardi@intel.com, 
	wajdi.k.feghali@intel.com, vinodh.gopal@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2025 at 9:05=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, Feb 05, 2025 at 11:20:46PM -0800, Kanchana P Sridhar wrote:
>
> So, zswap is passed a large folio to swap out, and it divides it into 4K =
pages
> and compresses each independently.  The performance improvement in this p=
atchset
> comes entirely from compressing the folio's pages in parallel, synchronou=
sly,
> using IAA.
>
> Before even considering IAA and going through all the pain of supporting
> batching with an off-CPU offload, wouldn't it make a lot more sense to tr=
y just
> compressing each folio in software as a single unit?  Compared to the exi=
sting
> approach of compressing the folio in 4K chunks, that should be much faste=
r and
> produce a much better compression ratio.  Compression algorithms are very=
 much
> designed for larger amounts of data, so that they can find more matches.
>
> It looks like the mm subsystem used to always break up folios when swappi=
ng them
> out, but that is now been fixed.  It looks like zswap just hasn't been up=
dated
> to do otherwise yet?
>
> FWIW, here are some speed and compression ratio results I collected in a
> compression benchmark module that tests feeding vmlinux (uncompressed_siz=
e:
> 26624 KiB) though zstd in 4 KiB page or 2 MiB folio-sized chunks:
>
> zstd level 3, 4K chunks: 86 ms; compressed_size 9429 KiB
> zstd level 3, 2M chunks: 57 ms; compressed_size 8251 KiB
> zstd level 1, 4K chunks: 65 ms; compressed_size 9806 KiB
> zstd level 1, 2M chunks: 34 ms; compressed_size 8878 KiB
>
> The current zswap parameterization is "zstd level 3, 4K chunks".  I would
> recommend "zstd level 1, 2M chunks", which would be 2.5 times as fast and=
 give a
> 6% better compression ratio.
>
> What is preventing zswap from compressing whole folios?

Thanks for the input, Eric! That was one of the directions we have
been exploring for zswap and zram. Here's what's going on:

The first issue is zsmalloc, which is the backend memory allocator for
zswap, currently does not support larger-than-4K object size. Barry
Song is working on this:

https://lore.kernel.org/linux-mm/20241121222521.83458-1-21cnbao@gmail.com/

Performance-wise, compressing whole folios also means that at swap-in
time, you have to decompress and load the entire folio/chunk. This can
create extra memory pressure (for example, you have to either allocate
a huge page or multiple small pages for the folio/chunk), which is
particularly bad when the system is already in trouble :) I believe
that is one of the blockers for the above patch series as well.
