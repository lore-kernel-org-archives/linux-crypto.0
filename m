Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E0224249
	for <linux-crypto@vger.kernel.org>; Sat, 31 Jan 2026 01:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769821970; cv=pass; b=BjKbGWtWKPSDjSpGUXY5LZ3VgwvsVYxfWyXvuR9CQ03GNL85e1EdUIkjv33HAAXfmrhvMlenODa3AWXMp2bsnZwvpUyHQERceDFg/0q9Uwm/CfbmRXWODjEHaEPLhz6f4HBHp6xReVfE6vyjnpkcl8R1FGSQ8RvmO5HME6i9N8k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769821970; c=relaxed/simple;
	bh=TpZLQa3skR7k38YLjBgx5kYBpNGL73QnBDNDMsIMMiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K8Yg66Vx0zPHWcnMggkVTyB8YXOx8trZ0+0vO0C09bxwjCJ90SwtwzyY+s+iHnjJUt8ilGAsZ+Aib2HSCrKcoPPm1CJ7kDbkXxwb2ESmwjVQ4+WPOPHhDWndhAsLtUewdvdkVHlhVCEA4DL7FZBcSoIRBsLcvycCJNJFEVr4Lss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NQ8RoXCR; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NQ8RoXCR"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-435a11957f6so2220019f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 30 Jan 2026 17:12:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769821967; cv=none;
        d=google.com; s=arc-20240605;
        b=HxTqKbq+WNyMruukM190V/kU+DTFB+SEEYOvvbBHXTkAFWAj6NAnt6dZysRw5Ijvwl
         TWJPdPHVzR5ysu27lOA8wGgV6xyxGUOX42+fkpvex7Id1Y0RtfQ2voB+dt8WlSD0VC1g
         yPXVSMowPAUxufRL3lKSh4evrjj/BYjGqZWUJ2Lm2jNDqCcTafs63+rEIQ9V31YKlCSv
         t4CfOKdve73wJLzNZIRIe8NSsSnlZfXJQao7TfAQXxlm5auCzgFn3v2pgGfI6Q4sk6Yf
         xWsW/bXbhmWS3/uUMROmu4g3pyU9wLae29Sm1McaGCYbYTHVlQ09isTtGOAiFh4hHctV
         fB5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        fh=dxh1er8hs+M5cinIxauh18Z5cAjh13FeHAeWo5tFsTA=;
        b=kXxZq1na3/RoroDdt5AEBU1T/2DBiuqjMFIe8HD48rUf/qBMgkfVvvSBPvMfEYhTt1
         LiILPkSFGDMT+kOYbI5219NdNLPeayCuApMkFXJNgs+hby/a5h46xdTAXHiKknn9MK6w
         svg5MXydky/M1HXCs2mnYfy7k85Sl7BLmGfnqNKVVaMnx9zO0PJw2k2atNsZar/JZ5db
         zTB4LbD3bx5CSg505PTQv3IhWThrBm/HSFLNsQWsmDZVxBOqftfZQStSiR7ALJJ+OOm5
         GEtb9N3JojDu7+jkzih+fbRCky2CIqQqunR144VaqOBAlnA/FWNI6stmc+u3Ze48VAWC
         Rv3Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769821967; x=1770426767; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        b=NQ8RoXCR1FCInx/HB8pUF641VLZaGmpXb7n2zmaMYYSJCb8p/J5FReAx6B/U15Qaha
         gWtwRs01psYK6+6cLDrclnyQ6V2L96X17aqwJzmy+etVhHgaIkCkGao3xB0/QrAGyXqK
         cLbBH144HfvF+k83/rHQ/lDxUSc3aZbyEsLUNqmcwQilDJNy30u4bOK/jKq6ISnBe6p+
         JvpYrojExXPh8wAmWfdnj/2ecBdaiNNgpAUHp3V2pOXVgorTrNJXmd9wLxJs1x7OZpNe
         1ciP78gDJxfqsCECaSp5oL+W2yLXTqqfyaMEAyCnMXsas/UBSKilH7sslAmFXWkF8R2e
         d6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769821967; x=1770426767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H0wUdGyOvUQ3EWuJ6iMCj9BrJpVFkngcT6qZTlbtbSY=;
        b=uYNijhl/A9khsH/NfaxeCXsL1cAYeQL6KAsfn16nSjooQEUw8MskfDB7Og+WTsooM9
         WDg7wHr9kO1GlfnAa1tcQNg3AZP0H9cosTZsZk819nrO4LmMsvB8X6G0A8gg2Rn3aSdT
         uvXmbVEy/2YxzVZ3xgZeom6KgnyVbypJUR4Ql5GMhRudzp0GhOyUtl+I4QxIMpqp06Ho
         yurYAWJVsyockgvP9rOLG22jhT+QWAy/G9opBvJ7MtW0qzoHNTC8zLTK96GglA1P9LWk
         P44RtWctGpibjHkdXT0GTKDhjI1HIsOlr0h4jbdjE2BYhAp/XMPS9Tv2aGwHyiZ5X0Y2
         DjLA==
X-Forwarded-Encrypted: i=1; AJvYcCVH3vzStXDRXIUmEohKw7IRwP/d3snXt9XN7Z/XIcsprx8FlAejE/bC7AMjhiumY9lPDl6euKqAKeckCu4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw+2j6NkXrHHO6Nb9BAOyxVfxUJvSfc762aU9LFVZutH00g4cr6
	SqE8uPHRuVFq8zGvrhUJPjlKPXUN3EW9xZINs3WBGQanWpdiq5Sw8cDAP0PvxvSfHvxpmy/rs9+
	WMpNPrySm6CDr0CNRG/orvc87C6HBhks=
X-Gm-Gg: AZuq6aI/F7h9usUw1NepNVnnYio4RluI9KNlxQTsXBSRAP79gkmLMIunJ5S5oCW8thZ
	JkNC7oISrtHRvVIPqjFMkwPCbfXCfG4qZXYEt1zYeigcQcjeNe00velW1xh6YSjdpRLLzeD8hMJ
	jkulOmrmMOha3Utj0hcPDL5zdmDBl5y4upYoTxsQ/6sqegO2U/Bg8b66JrZuenxJgia9B6tDy8O
	pDf4s5eH1SpvfYk6oLaOq8mIqZeMlDxqC/QcOE46F0XlpNU1oB30FobkwZ1pIMrIODGgcAx6T3R
	ATGlL//QvYQ=
X-Received: by 2002:a05:6000:1786:b0:435:dd81:4f4d with SMTP id
 ffacd0b85a97d-435f3a7bf2fmr7914254f8f.26.1769821966655; Fri, 30 Jan 2026
 17:12:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 30 Jan 2026 17:12:35 -0800
X-Gm-Features: AZwV_QjYxdL4I1ZK8ZPI34ugtzfZA8QnQmmf1QCbQU_ZqeQWkHXfgCnIwUe2Q8Y
Message-ID: <CAKEwX=PS7mjuhaazydkE2TOVa5DWQu9521FqH4aXi0yptZQaeA@mail.gmail.com>
Subject: Re: [PATCH v14 26/26] mm: zswap: Batched zswap_compress() for
 compress batching of large folios.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> We introduce a new batching implementation of zswap_compress() for
> compressors that do and do not support batching. This eliminates code
> duplication and facilitates code maintainability with the introduction
> of compress batching.
>
> The vectorized implementation of calling the earlier zswap_compress()
> sequentially, one page at a time in zswap_store_pages(), is replaced
> with this new version of zswap_compress() that accepts multiple pages to
> compress as a batch.
>
> If the compressor does not support batching, each page in the batch is
> compressed and stored sequentially. If the compressor supports batching,
> for e.g., 'deflate-iaa', the Intel IAA hardware accelerator, the batch
> is compressed in parallel in hardware.
>
> If the batch is compressed without errors, the compressed buffers for
> the batch are stored in zsmalloc. In case of compression errors, the
> current behavior based on whether the folio is enabled for zswap
> writeback, is preserved.
>
> The batched zswap_compress() incorporates Herbert's suggestion for
> SG lists to represent the batch's inputs/outputs to interface with the
> crypto API [1].
>
> Performance data:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> As suggested by Barry, this is the performance data gathered on Intel
> Sapphire Rapids with two workloads:
>
> 1) 30 usemem processes in a 150 GB memory limited cgroup, each
>    allocates 10G, i.e, effectively running at 50% memory pressure.
> 2) kernel_compilation "defconfig", 32 threads, cgroup memory limit set
>    to 1.7 GiB (50% memory pressure, since baseline memory usage is 3.4
>    GiB): data averaged across 10 runs.
>
> To keep comparisons simple, all testing was done without the
> zswap shrinker.
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   IAA                 mm-unstable-1-23-2026             v14
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     zswap compressor            deflate-iaa     deflate-iaa   IAA Batchin=
g
>                                                                   vs.
>                                                             IAA Sequentia=
l
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  usemem30, 64K folios:
>
>     Total throughput (KB/s)       6,226,967      10,551,714       69%
>     Average throughput (KB/s)       207,565         351,723       69%
>     elapsed time (sec)                99.19           67.45      -32%
>     sys time (sec)                 2,356.19        1,580.47      -33%
>
>  usemem30, PMD folios:
>
>     Total throughput (KB/s)       6,347,201      11,315,500       78%
>     Average throughput (KB/s)       211,573         377,183       78%
>     elapsed time (sec)                88.14           63.37      -28%
>     sys time (sec)                 2,025.53        1,455.23      -28%
>
>  kernel_compilation, 64K folios:
>
>     elapsed time (sec)               100.10           98.74     -1.4%
>     sys time (sec)                   308.72          301.23       -2%
>
>  kernel_compilation, PMD folios:
>
>     elapsed time (sec)                95.29           93.44     -1.9%
>     sys time (sec)                   346.21          344.48     -0.5%
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>   ZSTD                mm-unstable-1-23-2026             v14
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>     zswap compressor                   zstd            zstd     v14 ZSTD
>                                                              Improvement
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  usemem30, 64K folios:
>
>     Total throughput (KB/s)       6,032,326       6,047,448      0.3%
>     Average throughput (KB/s)       201,077         201,581      0.3%
>     elapsed time (sec)                97.52           95.33     -2.2%
>     sys time (sec)                 2,415.40        2,328.38       -4%
>
>  usemem30, PMD folios:
>
>     Total throughput (KB/s)       6,570,404       6,623,962      0.8%
>     Average throughput (KB/s)       219,013         220,798      0.8%
>     elapsed time (sec)                89.17           88.25       -1%
>     sys time (sec)                 2,126.69        2,043.08       -4%
>
>  kernel_compilation, 64K folios:
>
>     elapsed time (sec)               100.89           99.98     -0.9%
>     sys time (sec)                   417.49          414.62     -0.7%
>
>  kernel_compilation, PMD folios:
>
>     elapsed time (sec)                98.26           97.38     -0.9%
>     sys time (sec)                   487.14          473.16     -2.9%
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

The rest of the patch changelog (architectural and future
considerations)  can stay in the cover letter. Let's not duplicate
information :)

Keep the patch changelog limited to only the changes in the patch
itself (unless we need some clarifications imminently relevant).

I'll review the remainder of the patch later :)
