Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE9A13A3ED
	for <linux-crypto@vger.kernel.org>; Wed,  4 Feb 2026 00:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770165064; cv=pass; b=bUnkw31TKjQqHsgjw2oF08lRJyKJD/IPcrEfxrIqJTpFLVruY0WAeq5XkCE80ODdGdaXZUcWNGeJv2h/8Z1B3ruc6bn3CiA3vrNqSKu6OijqragbL4ZoxNQ1Fe8rLfsddIxm8KNCeFmjEGzOqiRiJgMeraCxnXtjYP8cNaiQPuY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770165064; c=relaxed/simple;
	bh=NrO+zlR1fnqBwWGf7ZmD38wMFEMXvJAW+Wx6V1Q/QNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B0HBi43929+jiW6DJpUkruVmGhGp049S59kxcrm69J1E3Wv+zMUBnCret1vlg+c01bfQORAhm2DnfLlOQvs3XX/E6hbqDqW+UfIONOZiKfqAmdoksiYYTzi96xq9tSOibyBDtO5TJLultCAZF0E5ZPA30Jxfc1Dje5VKB2hCPu4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DUo6IbuP; arc=pass smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DUo6IbuP"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47ee07570deso52123715e9.1
        for <linux-crypto@vger.kernel.org>; Tue, 03 Feb 2026 16:31:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770165060; cv=none;
        d=google.com; s=arc-20240605;
        b=ZFBCPw84L1nrce48u/ZQBZWqDgCBVJGpbZT/CpliWKPt5SECNW9D+R0Ubxf7XJICSU
         u3Z2m6TvTuVfxofcVa6NyWJ3Klc6kFairgot/63/iSA6lY7cRGvInnzhxZggqD1g7692
         pK0fsNQmr7yV3i9kNIB2A5EG2CzYA2w3pcbMjGrII26agOv7lrnH0vyGjLu5h1AIyLpV
         TXuUCP1bsokAbZIG32LzUgrMRduAFDATb42dBHwISQSvZaI0e2VC7IQQDgEZxZvSU02O
         pKl2r7ybbflTbE/K77pVTuX7qiQWkFIW2dUPWM4LxxV/SGVDVpqurU3ffC4Jp3MetNQ/
         vMQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        fh=zI/sgmjC9hbFipfgXEu/TSrQa5RBdRl7eifGHqU6+AE=;
        b=Sfs/fbgHHHmoyboGAFmh2kv2k+87X+LvCjzI32r+CGpjz3j2F3BpQBEpr0RM6smslY
         uuD4ji9lRmYcxTBH1fYkWajFqTFXr9NiFYgFnewHIVpPMYrdU2wClyruBlKkxz3Z6LIa
         RtBR0ytQA+cU5yCN3v8nBg/huzO148N6rWKZpsyb27oT9DQxj5k+VV35S6eHiu5KNK7H
         IJvBfgiLl+dzURQqZAy7Yamh21Uzq2QsOWRsflDjRsUaN9ilc+6NEJ5gTqUT31UPJkwQ
         qGNt8Ky0QMZjLT4EoCtV8XFJ5sfWsx+BeFOM2E7kw/WCHxYwLlnK/OBzbsp2oSvAk19B
         9l+Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770165060; x=1770769860; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        b=DUo6IbuP2XZiStErnNxZIM/GQWhEePVcD58nPS/R1MTujfwzyFRJ8bh7Fi8QTtQMfX
         3r6ikdmsXNA3tZm/f2qtUcUtO2ezNPb8+ADBhBDjAbeMmCodud5qZs9tB7v9zTcQTuM/
         B98MLdwO4GcAwO0/4ejEKqHVce/Ht51gHbZkckp5mGQTswe4y9JaduO3GoTWYxl1L/yn
         MaGSmnN+m9TEgDCS8FTCa+ntn4tsvSbDUK2HhKpuYhac9Uyv4ctKvRdyfEBW/+T5DlUU
         Qk/s37vHe6cLT30zPBXNH1zqAenPjOe/Np0D+bKXCwW2tWbuzmTtPzwPxoUzf09WosQA
         clpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770165060; x=1770769860;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xY5wTmiCswkMmPvh75RWgYtJAzsSO43XuB0w+uQS4FA=;
        b=YMv4zJUVGAfSkyvn24D3YuBzZM1v3X8CAwFxInxGASHRjrPULdgYDi/EcjLF9pZ6SP
         sz4K7z6INhhgz/rSXBO7X3G3kgnxP8EL3o0kLqmcO9c4cNGP9LkBAuKdxElDI8zQ6Ah9
         znPLfDTLWuN3+dqStWsjVdqRafKByyLIZtnP3Dyei2HQq/Rrkz72YGYP8AAjUyxKWMw7
         c2rucZ6E1Iw5CXJh6HWJWD3s0aoE3HAfMuBIFCuBPZEKfqc8MTPTHUYiAvMhshyy3PR3
         FHirk7GsTMMXQjEWHfbBHybylIYvC+Np/9/TFLN2pZQrHjCo5c5t5LEcReErUUJFRquh
         TAOg==
X-Forwarded-Encrypted: i=1; AJvYcCUUFk0DX0ZSTqeReu8AZe6TCdLwa/JFnMHaCjlmEjTn7q/0HqiDriy8+7soDtL+3asZbLeUBZsslnSam3U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy+3wm260/OFqnztInRRLVNx9HtgaMyTxgiVkyxLSp6gq4qnZrv
	DB8GKwoo+OqwLsTSqP/KBpNYsOFHXrGRnosheyh9vfglHyIxLkPHagW1pbX/n54TRkf/QVw6iOs
	hEepyDXGe7Ij+kTN79iqu2n0233+b9Z8=
X-Gm-Gg: AZuq6aJqG3v0Vkyj4sZqspG2wImmFS5VphpvCiS+CuBV6s2yXDTmteM/B4Cyl33qs97
	FoIC4q++A8vs5veCs34pB3/+dTCsvbaalrSKU0eDMUKEjVOOCQGeSr1nrCPy9kMGWHtTugTeMhR
	QY9IGnllCPjEru765hesJ5OR1MBha1/r/ctQLFyVWgBnW6CS/TMzDfP0BYe0k7igm413dVX66ji
	S7s/+k49YVClvW1iBoKRQzOa4N0iWOLq7ufSkGWFhVms/AXNjacq+4E1VJ+iQKtfu07VXe0MJd1
	rZoU1sxwBdGk3K5Rg0r6NhDvXQ4qEWScNh9DflXA8n4=
X-Received: by 2002:a05:600c:608a:b0:480:1c2f:b003 with SMTP id
 5b1f17b1804b1-4830e98607dmr15919085e9.20.1770165059835; Tue, 03 Feb 2026
 16:30:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-27-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 3 Feb 2026 16:30:48 -0800
X-Gm-Features: AZwV_QinecwTwjS7ZtoR1qbAef5xnGG7aR5i9DJ793lYmiWYAme_FwqdZZcbA3w
Message-ID: <CAKEwX=ONeMBRwr+4mJt76+zWZ4dXL+LCEAMELYeT6Nx-hej2-g@mail.gmail.com>
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
>
> Architectural considerations for the zswap batching framework:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> We have designed the zswap batching framework to be
> hardware-agnostic. It has no dependencies on Intel-specific features and
> can be leveraged by any hardware accelerator or software-based
> compressor. In other words, the framework is open and inclusive by
> design.
>
> Potential future clients of the batching framework:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> This patch-series demonstrates the performance benefits of compression
> batching when used in zswap_store() of large folios. Compression
> batching can be used for other use cases such as batching compression in
> zram, batch compression of different folios during reclaim, kcompressd,
> file systems, etc. Decompression batching can be used to improve
> efficiency of zswap writeback (Thanks Nhat for this idea), batching
> decompressions in zram, etc.
>
> Experiments with kernel_compilation "allmodconfig" that combine zswap
> compress batching, folio reclaim batching, and writeback batching show
> that 0 pages are written back with deflate-iaa and zstd. For comparison,
> the baselines for these compressors see 200K-800K pages written to disk.
> Reclaim batching relieves memory pressure faster than reclaiming one
> folio at a time, hence alleviates the need to scan slab memory for
> writeback.
>
> [1]: https://lore.kernel.org/all/aJ7Fk6RpNc815Ivd@gondor.apana.org.au/T/#=
m99aea2ce3d284e6c5a3253061d97b08c4752a798
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 260 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 190 insertions(+), 70 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 6a22add63220..399112af2c54 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -145,6 +145,7 @@ struct crypto_acomp_ctx {
>         struct acomp_req *req;
>         struct crypto_wait wait;
>         u8 **buffers;
> +       struct sg_table *sg_table;
>         struct mutex mutex;
>  };
>
> @@ -272,6 +273,11 @@ static void acomp_ctx_dealloc(struct crypto_acomp_ct=
x *acomp_ctx, u8 nr_buffers)
>                         kfree(acomp_ctx->buffers[i]);
>                 kfree(acomp_ctx->buffers);
>         }
> +
> +       if (acomp_ctx->sg_table) {
> +               sg_free_table(acomp_ctx->sg_table);
> +               kfree(acomp_ctx->sg_table);
> +       }
>  }
>
>  static struct zswap_pool *zswap_pool_create(char *compressor)
> @@ -834,6 +840,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, s=
truct hlist_node *node)
>         struct zswap_pool *pool =3D hlist_entry(node, struct zswap_pool, =
node);
>         struct crypto_acomp_ctx *acomp_ctx =3D per_cpu_ptr(pool->acomp_ct=
x, cpu);
>         int nid =3D cpu_to_node(cpu);
> +       struct scatterlist *sg;
>         int ret =3D -ENOMEM;
>         u8 i;
>
> @@ -880,6 +887,22 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, =
struct hlist_node *node)
>                         goto fail;
>         }
>
> +       acomp_ctx->sg_table =3D kmalloc(sizeof(*acomp_ctx->sg_table),
> +                                       GFP_KERNEL);
> +       if (!acomp_ctx->sg_table)
> +               goto fail;
> +
> +       if (sg_alloc_table(acomp_ctx->sg_table, pool->compr_batch_size,
> +                          GFP_KERNEL))
> +               goto fail;
> +
> +       /*
> +        * Statically map the per-CPU destination buffers to the per-CPU
> +        * SG lists.
> +        */
> +       for_each_sg(acomp_ctx->sg_table->sgl, sg, pool->compr_batch_size,=
 i)
> +               sg_set_buf(sg, acomp_ctx->buffers[i], PAGE_SIZE);
> +
>         /*
>          * if the backend of acomp is async zip, crypto_req_done() will w=
akeup
>          * crypto_wait_req(); if the backend of acomp is scomp, the callb=
ack
> @@ -900,84 +923,177 @@ static int zswap_cpu_comp_prepare(unsigned int cpu=
, struct hlist_node *node)
>         return ret;
>  }
>
> -static bool zswap_compress(struct page *page, struct zswap_entry *entry,
> -                          struct zswap_pool *pool, bool wb_enabled)
> +/*
> + * zswap_compress() batching implementation for sequential and batching
> + * compressors.
> + *
> + * Description:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * Compress multiple @nr_pages in @folio starting from the @folio_start =
index in
> + * batches of @nr_batch_pages.
> + *
> + * It is assumed that @nr_pages <=3D ZSWAP_MAX_BATCH_SIZE. zswap_store()=
 makes
> + * sure of this by design and zswap_store_pages() warns if this is not t=
rue.
> + *
> + * @nr_pages can be in (1, ZSWAP_MAX_BATCH_SIZE] even if the compressor =
does not
> + * support batching.
> + *
> + * If @nr_batch_pages is 1, each page is processed sequentially.
> + *
> + * If @nr_batch_pages is > 1, compression batching is invoked within
> + * the algorithm's driver, except if @nr_pages is 1: if so, the driver c=
an
> + * choose to call it's sequential/non-batching compress routine.

Hmm, I'm a bit confused by this documentation.

Why is there extra explanation about nr_batch_pages > 1 and nr_pages
=3D=3D 1? That cannot happen, no?

nr_batch_pages is already determined by the time we enter
zswap_compress() (the computation is done at its callsite, and already
takes into account nr_pages, since it is the min of nr_pages, and the
compressor batch size).

I find this batching (for store), then sub-batching (for compression),
confusing, even if I understand it's to maintain/improve performance
for the software compressors... It makes indices in zswap_compress()
very convoluted.

Yosry and Johannes - any thoughts on this?

> + *
> + * In both cases, if all compressions are successful, the compressed buf=
fers
> + * are stored in zsmalloc.
> + *
> + * Design notes for batching compressors:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * Traversing SG lists when @nr_batch_pages is > 1 is expensive, and
> + * impacts batching performance if repeated:
> + *   - to map destination buffers to each SG list in @acomp_ctx->sg_tabl=
e.
> + *   - to initialize each output @sg->length to PAGE_SIZE.
> + *
> + * Design choices made to optimize batching with SG lists:
> + *
> + * 1) The source folio pages in the batch are directly submitted to
> + *    crypto_acomp via acomp_request_set_src_folio().
> + *
> + * 2) The per-CPU @acomp_ctx->sg_table scatterlists are statically mappe=
d
> + *    to the per-CPU dst @buffers at pool creation time.
> + *
> + * 3) zswap_compress() sets the output SG list length to PAGE_SIZE for
> + *    non-batching compressors. The batching compressor's driver should =
do this
> + *    as part of iterating through the dst SG lists for batch compressio=
n setup.
> + *
> + * Considerations for non-batching and batching compressors:
> + * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> + *
> + * For each output SG list in @acomp_ctx->req->sg_table->sgl, the @sg->l=
ength
> + * should be set to either the page's compressed length (success), or it=
's
> + * compression error value.
> + */
> +static bool zswap_compress(struct folio *folio,
> +                          long folio_start,
> +                          u8 nr_pages,
> +                          u8 nr_batch_pages,
> +                          struct zswap_entry *entries[],
> +                          struct zs_pool *zs_pool,
> +                          struct crypto_acomp_ctx *acomp_ctx,
> +                          int nid,
> +                          bool wb_enabled)
>  {
> -       struct crypto_acomp_ctx *acomp_ctx;
> -       struct scatterlist input, output;
> -       int comp_ret =3D 0, alloc_ret =3D 0;
> -       unsigned int dlen =3D PAGE_SIZE;
> +       gfp_t gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_=
MOVABLE;
> +       unsigned int slen =3D nr_batch_pages * PAGE_SIZE;
> +       u8 batch_start, batch_iter, compr_batch_size_iter;
> +       struct scatterlist *sg;
>         unsigned long handle;
> -       gfp_t gfp;
> -       u8 *dst;
> -       bool mapped =3D false;
> -
> -       acomp_ctx =3D raw_cpu_ptr(pool->acomp_ctx);
> -       mutex_lock(&acomp_ctx->mutex);
> -
> -       dst =3D acomp_ctx->buffers[0];
> -       sg_init_table(&input, 1);
> -       sg_set_page(&input, page, PAGE_SIZE, 0);
> -
> -       sg_init_one(&output, dst, PAGE_SIZE);
> -       acomp_request_set_params(acomp_ctx->req, &input, &output, PAGE_SI=
ZE, dlen);
> +       int err, dlen;
> +       void *dst;
>
>         /*
> -        * it maybe looks a little bit silly that we send an asynchronous=
 request,
> -        * then wait for its completion synchronously. This makes the pro=
cess look
> -        * synchronous in fact.
> -        * Theoretically, acomp supports users send multiple acomp reques=
ts in one
> -        * acomp instance, then get those requests done simultaneously. b=
ut in this
> -        * case, zswap actually does store and load page by page, there i=
s no
> -        * existing method to send the second page before the first page =
is done
> -        * in one thread doing zswap.
> -        * but in different threads running on different cpu, we have dif=
ferent
> -        * acomp instance, so multiple threads can do (de)compression in =
parallel.
> +        * Locking the acomp_ctx mutex once per store batch results in be=
tter
> +        * performance as compared to locking per compress batch.
>          */
> -       comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
> -       dlen =3D acomp_ctx->req->dlen;
> +       mutex_lock(&acomp_ctx->mutex);
>
>         /*
> -        * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> -        * save the content as is without a compression, to keep the LRU =
order
> -        * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> -        * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> -        * to the active LRU list in the case.
> +        * Compress the @nr_pages in @folio starting at index @folio_star=
t
> +        * in batches of @nr_batch_pages.
>          */
> -       if (comp_ret || !dlen || dlen >=3D PAGE_SIZE) {
> -               if (!wb_enabled) {
> -                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> -                       goto unlock;
> -               }
> -               comp_ret =3D 0;
> -               dlen =3D PAGE_SIZE;
> -               dst =3D kmap_local_page(page);
> -               mapped =3D true;
> -       }
> +       for (batch_start =3D 0; batch_start < nr_pages;
> +            batch_start +=3D nr_batch_pages) {
> +               /*
> +                * Send @nr_batch_pages to crypto_acomp for compression:
> +                *
> +                * These pages are in @folio's range of indices in the in=
terval
> +                *     [@folio_start + @batch_start,
> +                *      @folio_start + @batch_start + @nr_batch_pages).
> +                *
> +                * @slen indicates the total source length bytes for @nr_=
batch_pages.
> +                *
> +                * The pool's compressor batch size is at least @nr_batch=
_pages,
> +                * hence the acomp_ctx has at least @nr_batch_pages dst @=
buffers.
> +                */
> +               acomp_request_set_src_folio(acomp_ctx->req, folio,
> +                                           (folio_start + batch_start) *=
 PAGE_SIZE,
> +                                           slen);
> +
> +               acomp_ctx->sg_table->sgl->length =3D slen;
> +
> +               acomp_request_set_dst_sg(acomp_ctx->req,
> +                                        acomp_ctx->sg_table->sgl,
> +                                        slen);
> +
> +               err =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->=
req),
> +                                     &acomp_ctx->wait);
> +
> +               /*
> +                * If a page cannot be compressed into a size smaller tha=
n
> +                * PAGE_SIZE, save the content as is without a compressio=
n, to
> +                * keep the LRU order of writebacks.  If writeback is dis=
abled,
> +                * reject the page since it only adds metadata overhead.
> +                * swap_writeout() will put the page back to the active L=
RU list
> +                * in the case.
> +                *
> +                * It is assumed that any compressor that sets the output=
 length
> +                * to 0 or a value >=3D PAGE_SIZE will also return a nega=
tive
> +                * error status in @err; i.e, will not return a successfu=
l
> +                * compression status in @err in this case.
> +                */
> +               if (unlikely(err && !wb_enabled))
> +                       goto compress_error;
> +
> +               for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +                           compr_batch_size_iter) {
> +                       batch_iter =3D batch_start + compr_batch_size_ite=
r;
> +                       dst =3D acomp_ctx->buffers[compr_batch_size_iter]=
;
> +                       dlen =3D sg->length;
> +
> +                       if (dlen < 0) {
> +                               dlen =3D PAGE_SIZE;
> +                               dst =3D kmap_local_page(folio_page(folio,
> +                                                     folio_start + batch=
_iter));
> +                       }
> +
> +                       handle =3D zs_malloc(zs_pool, dlen, gfp, nid);
> +
> +                       if (unlikely(IS_ERR_VALUE(handle))) {
> +                               if (PTR_ERR((void *)handle) =3D=3D -ENOSP=
C)
> +                                       zswap_reject_compress_poor++;
> +                               else
> +                                       zswap_reject_alloc_fail++;
>
> -       gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> -       handle =3D zs_malloc(pool->zs_pool, dlen, gfp, page_to_nid(page))=
;
> -       if (IS_ERR_VALUE(handle)) {
> -               alloc_ret =3D PTR_ERR((void *)handle);
> -               goto unlock;
> +                               goto err_unlock;
> +                       }
> +
> +                       zs_obj_write(zs_pool, handle, dst, dlen);
> +                       entries[batch_iter]->handle =3D handle;
> +                       entries[batch_iter]->length =3D dlen;
> +                       if (dst !=3D acomp_ctx->buffers[compr_batch_size_=
iter])
> +                               kunmap_local(dst);
> +               }
>         }
>
> -       zs_obj_write(pool->zs_pool, handle, dst, dlen);
> -       entry->handle =3D handle;
> -       entry->length =3D dlen;
> +       mutex_unlock(&acomp_ctx->mutex);
> +       return true;
>
> -unlock:
> -       if (mapped)
> -               kunmap_local(dst);
> -       if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
> -               zswap_reject_compress_poor++;
> -       else if (comp_ret)
> -               zswap_reject_compress_fail++;
> -       else if (alloc_ret)
> -               zswap_reject_alloc_fail++;
> +compress_error:
> +       for_each_sg(acomp_ctx->sg_table->sgl, sg, nr_batch_pages,
> +                   compr_batch_size_iter) {
> +               if ((int)sg->length < 0) {
> +                       if ((int)sg->length =3D=3D -ENOSPC)
> +                               zswap_reject_compress_poor++;
> +                       else
> +                               zswap_reject_compress_fail++;
> +               }
> +       }
>
> +err_unlock:
>         mutex_unlock(&acomp_ctx->mutex);
> -       return comp_ret =3D=3D 0 && alloc_ret =3D=3D 0;
> +       return false;
>  }
>
>  static bool zswap_decompress(struct zswap_entry *entry, struct folio *fo=
lio)
> @@ -1499,12 +1615,16 @@ static bool zswap_store_pages(struct folio *folio=
,
>                 INIT_LIST_HEAD(&entries[i]->lru);
>         }
>
> -       for (i =3D 0; i < nr_pages; ++i) {
> -               struct page *page =3D folio_page(folio, start + i);
> -
> -               if (!zswap_compress(page, entries[i], pool, wb_enabled))
> -                       goto store_pages_failed;
> -       }
> +       if (unlikely(!zswap_compress(folio,
> +                                    start,
> +                                    nr_pages,
> +                                    min(nr_pages, pool->compr_batch_size=
),

Hmm this is a bit confusing. There seems to be multiples kinds of "batch si=
ze".

Am I understanding this correctly:

zswap_store(folio)
    -> zswap_store_pages() - handle a batch of nr_pages from start to
end (exclusive)
        -> zswap_compress() - compress a batch of
min(compr_batch_size, nr_pages)

where:
* compr_batch_size is the batch size prescribed by compressor (1 for
zstd, potentially more for IAA).
* nr_pages is the "store batch size", which can be more than 1, even
for zstd (to take advantage of cache locality in zswap_store_pages).

> +                                    entries,
> +                                    pool->zs_pool,
> +                                    acomp_ctx,
> +                                    nid,
> +                                    wb_enabled)))
> +               goto store_pages_failed;
>
>         for (i =3D 0; i < nr_pages; ++i) {
>                 struct zswap_entry *old, *entry =3D entries[i];
> --
> 2.27.0
>

The rest looks OK to me, but 80% of this patch is using the new crypto
API, so I'll wait for Herbert's Acked on the first half of the patch
series :)
