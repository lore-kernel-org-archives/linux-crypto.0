Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1795563967;
	b=ldIZbXr98xWz1+CAwb6t48xPDk4VnPpk3Tj+nl5dPySVvnANEG7yZi+I0/EzytW3X5si
	 +zEWohbRJd+gdnUp4NXxgYwtdeTnfg8HgGSlTze7jTrxqDZ20AeeLbyb4PUeXPGmYFTDl
	 FSQQO7snEvosHHBUYReZfNNTKulzqlwEgQ//q41GXPL6b5bUf5avjnxB170OQcfOQN8YC
	 ceuOPReLNL0pWgIj8A3eYAhya2itk+ecbBt9wP6iGt9TfcW3T7Vt5E4JdUPOY4DYq479X
	 lEfqcZp82wJ5fkzXUZ/z1AvAFIuh7bhthOUXaL69JglXPonIINCPYSEpCwmtGqXIU+g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563967;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
	b=hDzq1v90bPDpRzJjB0V7jIkugbJV4wUlwaFNLvdJta+tZE792qx4RvhYBeUZsFIEL2Xg
	 ZEjiuD3oZWSv3WU4GgFqdAbFT2+M+o6FuClPvVE1yipIrAO5tVStx/M2+sWXPwnXEeNh5
	 w4dIA0dvZ1MaDfcKjQc8U8HKs85qQGQTkMhAhnR5IqtsavNbfwPAg6UyKJ2obtIEN/qJ5
	 e6SJDvwYapd5qk3ul+QQlvctPwBZU156zGiSc1tCyNjVnQo8zDVisPyD+SxwYVgqodN1J
	 FyEvWS4i8OrwNidU9Rind+UE3nQ5sp74+7HRCyNJOsvDC5a8Z8+mUpH++7i2YEhExrQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="lHZOL/BI";
	arc=fail smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C0B606A31E
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 23:46:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A7C0B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lHZOL/BI
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ae85e3685cso33752611fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 15:46:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795563965; cv=none;
        d=google.com; s=arc-20260327;
        b=KUqVH4WN9kW0W07/sYlBnCJACPCXbQTZrfUIXAglupek6oSTxkcpOlUVZ0c9S+iP5x
         2Y8xBF/S2Ki+4XNzg/kjjJyrtd+/Gz+HQcKBeUXIRnj2OA2LpV31Zhosuk+B4QKHP0f/
         PvqdAqd3pUZWi7bY4K/x1yKUg+sW4RrqgkPhIPG1MHNgaZbgiKhg25AkraSwC8bTmveM
         RSWXwz77WNyJiNManLc/tZjUphYOiNfddVBZGwo872WGu6S1trhzs9qCXfUOjyMIo0Dr
         KNymfFpyqWEoLBW+5Rwb5Us7/sX3iJz53eizxSfLOqOqw8OzlJzSTV1ytrbbPIAbymQ7
         pm+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        fh=PtpNVelqSN8iOEJbNp5/1tlzkNnO7A6rDodWcemx6Ng=;
        b=Ulegcu769TqbsmLMNKDlzrIF3TOaDp4Ce8SvQxQKhhxXtd7ivVuw7yo+yCO8YMlcEu
         MMqVsW394ztaPJG2N1Pgu5qmOXXT6JFdUHa5psHEXIQ4KDKDnuQisP5TXTdq3LTxRdlT
         5uA9cjqlrVSvgAq/CrSM9VmES36s5hJWSeF7IoCrx3suVgO/YVv4UHUo66fOqGhpOtoI
         HpoSVXvz7U0onZsOVHKQ6P6uVspYCFJZ0+9n3IsU03Jv8s1gpLFn35PMMhWckQ117qsD
         8RWVS6KNrr4OwTlYSx+H2AUyTAUG72+kotR/rGvd4gSqi4uU0pnhUtBCiBJdjAMLWpfy
         7JpQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795563965; x=1796168765; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        b=lHZOL/BIQeKyj6pxe1uWsl2Doz+Q+U4P8IoSglyG6WmsPI8FzaqwGLsF6xe+OSYvkg
         ngRBe6Tk+WWnexCQnjP4HuKcwm2iIgd1NuccVNa8db7LSXOONX5PEl8CNV8ApN6/Q4Q4
         nGqwcvojTayoE3dK5uhiWdcxF6FQUpbgEBG4q9dXU1yTjJrsr+kGXScIh0Mi8AcmbBjO
         6bBg3t7Po08b8D2UjXC2IFdcEraTWEC5Dm5BslhML5aQ+a0Fg3ITqxduKirBIUIZ3Mph
         wCsUrXugDXxICbHf3dx4siub7JbVYiKYfo6VFWuO0tk5A2nprzVXK01mH8czJ8FRopzg
         O0kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795563965; x=1796168765;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bj72kE5VzukIZwPRd6gELH0mmyFkSQ8C1WZkrm6cOpE=;
        b=Szz6ZEmQdL8eiqxyqhiDEVnCx9XzBfgS/o6+5JKuNDFIeGWML5b43j1nQQrF5drPP9
         OztkMrieovWMleHLUVKZ4hmsQ1XUWFJoNivi7drdD8xhxQ5UGsEQZtvHAupND8Dtj6X7
         yrloo2I72UYOo6fXqA2D9tNzYahGr5agYI80AUJ9pRXrz3cPFiI9FyXRCzpM7aBCX5gT
         UOkC1Essw5dW/AX8qc51Ptpr+Sttj82dVoL7CB4vai9iRtmwwfTZbEnnsyiFbTqQukWf
         0HWZ0tDZPFdmbEmMiEqjSemG047fNj/catt0SHgRckAPhTbFpOfBiESSbCkbV5zhf1wK
         77pQ==
X-Forwarded-Encrypted: i=1; AL+hErE2pZHtGOflQMdb3QQyb3t1zknoGYvWvvKTdOZJzaVrYqEzS80VFSBE1xaShNjHaIGm/5kwhzLwtgYkmhk=@vger.kernel.org
X-Gm-Message-State: APuU4Z+E0egY9D6PJxQlxBQbLA0sRouIEIXzk0c8mggJ7EqQahSjqX5T
	7zyt1npaFhxZ5eoLkXrtZQiwY39S06VHcn/2fDbOKNnkLzcbV8D3evzAcdrfqQadj5tA381ZvHL
	zPfLIMZxSzkMCBbbGv5rhgGKD8YDBL7SgqmSw/2o=
X-Gm-Gg: AZFdTZfVfWLh5cT/ba0s372ZZlKnBP3MgOZAPdCqFs4aZVSRIDLnzkeokp65qo/h9Kq
	feXfW/agJIw2nfqhIUZRXQ5VyJA//yp8vYWuZwn7+mistJO1wBpmat/sAJUMbX0RfQCiDgm4x1r
	NgLAI94dped+AhlgCprAqXseVwtmAQLh43F0txMC0ZIrn00SzcMQ3e4myP6c/NLuAtJujYO38lg
	c6yuAWuwLHO2a9C92IpV6n784tSUIGDYscq90483hiKU1rDSxFhbvy3U2UyI4v/LTkco4JmwmJX
	kwoUZFO9nirh89zC3UWIE0JD2ba/it1xEK5GrUOJENLxi0HYsuAgLRw3/stOjm4ZyJSen3ryTHh
	YhE3TIyO8wf/QkucEA8dMMBpihr+Cd8SPnfk3
X-Received: by 2002:a05:6512:a819:10b0:5bc:f29b:1a5c with SMTP id
 2adb3069b0e04-5c1bc7d0b80mr3077117e87.23.1795563964504; Tue, 24 Nov 2026
 15:46:04 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com> <awXr6iHBR54wBB05@google.com>
In-Reply-To: <awXr6iHBR54wBB05@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 15:45:52 -0800
X-Gm-Features: Aa3M54qHuVeAHaNbCxo4wz47haXUGhMN7-gFVY621Bx4vmN82u_-P6KIceLACFk
Message-ID: <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/8] Batched zswap_store() framework with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, hannes@cmpxchg.org, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 24, 2026 at 12:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
>
> On Fri, Nov 20, 2026 at 03:16:32PM -0800, Nhat Pham wrote:
[...]
> > Have you tried perf-ing the store path to see what was the overhead
> > source (before and after this optimization)? I'm curious.
>
> So I was able to reproduce the usemem30 sys/wall time improvements here
> on a Sapphire Rapids machine (both in a VM and on baremetal), and I
> threw my LLM at perf-ing to figure out what the overhead was. It's
> important to note that the sys/wall time improvement I observed was on
> the free phase, the write phase / throughput (which involves zswap
> store) didn't show much of a change.
>
> Batching made more consecutive pages that compress to the same zsmalloc
> class more likely to land in the same zspage, so the freeing path gets
> faster as the zspage and metadata are hot in the cache, which alleviates
> contention on the class lock.

This is a real performance gain with batching, correct?

>
> I think the memory allocated by usemem all compresses to the same class
> size, which makes holding the class lock in the freeing path a
> bottleneck. I confirmed this by a hacky patch to shard the class lock
> into 32 locks, which caused the same usemem improvements and the series
> doesn't improve performance anymore on top of that change.

I think we all agree that vm-scalability/usemem is a
microbenchmark/standard. I am not sure I understand the value of these
"hacks", when my patch-series posts data with the standard mm-unstable
and my patch series with a standard usemem microbenchmark.

>
> I also tried usemem with Silesia to get realistic compression data
> (similar to Kanchana's testing on previous versions), and didn't see
> similar improvements (because the compressed pages get distributed
> across multiple classes). I also tried a kernel build and the munmap
> microbenchmark in [1] (which Sergey quoted in [2]), which also didn't
> show improvements.
>
> That got me curious tho, and I had my LLM explore other optimizations to
> the freeing path. I think we can get similar improvements in usemem
> as well as the munmap microbenchmark [1] by batching zswap entries
> freeing. We can batch both the zsmalloc object freeing as well as the
> LRU deletion. I am still looking into it and I might send out patches.
>
> But I think this series doesn't really move the needle on realistic
> workloads, as I previously mentioned.

Your statements and hypothesis based on the kernel hacks don't explain
why I see 6.56% additional Sys time savings with compress batching
over the gains observed with store batching alone. I am not sure how
to interpret your statement above without your posting any data.

Did you get a chance to see the usemem/ZSTD data with/without compress
batching that I posted in [1], and my analysis of the breakdown
between performance gains from store batching vs. compress batching in
[2]?

As per the data I posted, compress batching of PMD THP with ZSTD
yields an additional 6.56% Sys time savings and additional 1.12%
Throughput improvement over zswap store batching. Combined zswap store
+ compress batching yields 13.87% Sys time reduction and 3.85%
Throughput increase over mm-unstable. I think this clearly
demonstrates performance benefits to a well established
microbenchmark, run at scale, using upstream kernel git trees and my
patch series.

I would appreciate comments from Nhat, Johannes and Andrew on these
posted gains/analysis:

[1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
[2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc

An independent replication of the gains posted by me in this
patch-series, using standard mm-unstable and vm-scalability/usemem
would also be very useful.

Thanks,
Kanchana

> Regarding the bpftrace
> measurements, I couldn't reproduce them. I think one factor is that
> probing both zswap_store() and zswap_compress() makes the zswap_store()
> numbers different based on how many zswap_compress() calls we make
> (which are less with batching) due to the overhead of the probe itself.
> When I trace zswap_store() without zswap_compress(), I don't see
> meaningful changes in latency.
>
> [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfengche=
n@xiaomi.com/
> [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozhatsky=
@chromium.org/
