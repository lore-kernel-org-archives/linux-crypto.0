Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795572639;
	b=BeifXPRARupZWJNKhrjE4cDv3SE60tE5Wl081Kap0IFtv137X1ZsUMapOYOXoDxnalWo
	 I7+iBUaKjlA9LDudPZ/WDxgrSP/NF6GyfJ3Gapw2hS/HMdxvN9JJNl2QeCT4ihqrSjQdd
	 CLOgmJYhP8lLN34NhcxLHhF3+gYqBEMald0rAiEujRWkSRij8jo6QBJjuU+wtanwh37mZ
	 zEOjHSvSYoAi9lrCi41bLiUupTO5tM3yOuIZqktZOGRRRfE1WhhckBQHNYRuo2Hf+jtZ4
	 rYM+NRT/MEvzk/0TvSBvtH4lHJ8Kex6+B5KQmAIpW4zCz0tycHvj45vGrrLSoInhCgQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795572639;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
	b=QRY86hggeNTPnft1wpFa4gBnJawgK9PUptHWQ/6VnXQLEFg0WY0g1afuAfzt0mOr/6zQ
	 7/3JrDx+I4i99r5AuvuLYnBh0jKK6AxbTuGo1IXqpu3Y1T1p2D3omV/hgnhoKYYIvNQHY
	 m6lk5gTp3vepkeL7fPA2Zeuk6Gz0QRzJZZFegKrXCpIWJXVDNTC+rV8/erQqpXY8ix7bC
	 FM81PGGTbLdHytVPGz/LdGuMnpmTetd8oWyEG/UAZtjslnFprLRtTMOnZzu3cAdP2EpHi
	 eXYcSxjjQE2ij4PojHr2TVYbjENSWgjD1QpwaZ29W7CdcjxqBBbjAWLH51w6uuomPQQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OGwBWxtn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.45
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BA4606A321
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 02:10:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 62BA4606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OGwBWxtn
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5c08539c827so4087051e87.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 18:10:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795572637; cv=none;
        d=google.com; s=arc-20260327;
        b=HdfznudB93Z/MQ0yq8SlB6ThHXEcxzCzYhfFmPu4cnH2RSf4fl0T87yuyYaMRft65p
         28a6NB1pjtAZv5b8qfJgAiaSE8VwgaUaPw9Jj1VEG7DYabmIuBwV6LZsd1eULU0rWCBf
         cBoO0+eiTKMiQc7oYaB81A5za8BjDUXUhWL8aUP4/xhrQ6xraSubZfnFwlqOVwn9H4t2
         6FZgA1mDtb5Aa2FeuG5relc3pqIyuLiJBaUW5001X4t8uwNEZEH93YHkOH6JjxPwDduK
         KeH9m6xbiUJYbBA6YXuy9KnFkUm3iSk16rC6ddB/dniqR80WRp32UjHSbSGhKnElNvzt
         pypw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        fh=TbPGUCj++zv5iVx7OTeDBBW/1GF9IvBOm6IH054vV4M=;
        b=mbrhOa3KdRN5+vt1+3xXR+xJMIqpRND9sinHzT5JMca5sjhLfJ12jowX5lB3Nfcn6c
         jrcVGCSZYiT0EleCe8Ma3lZJiMPiSqmaVfCV2Uz0SGPJK49QlwBlLkXW52i44UElanAI
         EFskVMDHpMFBuj4H/qGlNZflWClwNJEGumhfk0dXZBYV1A1X2g69/BAfDbLASp+gw4wM
         HTcuCawU+ZylHLLv+tYOUwte0nL2Ygld8TPD5YtSF8DIC0SEiwi9xhr0YrjgSQao6Wpd
         Qoqr9Q2eTMHF/quuh5Bd0QUrOnk0TqppKktIDA7TS3UFtlNetv45PXMNdNHDs0FT8s9M
         tETQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795572637; x=1796177437; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        b=OGwBWxtn53HAeIiJeBo+RcJAQ2Tu6sU9OX4M3HS0n9wpREpWNhtuOQxYCX1bPa6VDY
         Vsld9zW6I2Frfiotq10+lyxznlH9/RZfRm9HPSzhBGA1EZZDmB5FZHaAM+uOfrewIKPC
         ACT57w9CUnZJJUhwUPQjq2709cXIcBmf7kg0QKJ/8dAT3xzgou7PC/v01Mc15sTk+77Q
         nMhKVCPtFNMqIgf/cqlyDoulmt5GlG/lyxjFdAXXr0BckikQD50zMS5hOX+uiX5Szq+8
         G0FKu+4QujmvtBED+vLXalfC/o/XA2t/uRT+cY1XyXrDRpw0zBCA2ycEAJ7ex4Lvis+x
         CA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795572637; x=1796177437;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TvZlrkg5tr9gIRROT023AZ+ik64XGCLBZ3Fbj+l0tnE=;
        b=u/aQ3aJJKcsehArr7qysuQwwjdXME6RsgJI9NnLzGVua2qVHY/bX5dDGb075xJXxio
         7R5WBaE0JUgG2Z9nSIzSJgjwOsnFCwI+gxL0CPcuZx+qw8Buf0WfPihu8WH1YBc6f4Rh
         TchC6nXrfbJaf8oK0FmZZfkW5gM1ayVdGVjJcnKz043t3CVVrLyQAdtel1vNjdck0Nbl
         K1ke9776anT53HYixCRyVvIpF2NEc0ovgFnsNrnN5ViXMysuRpIGHPOyqNwO4d8pWloP
         u64ule/gniHvbQbEe2Z23vsxrQjwJ/xjGDjTWakujWsdlsmonPrhuMuFSpaG4L01nQ5F
         Qg7Q==
X-Forwarded-Encrypted: i=1; AL+hErEZM7dGSyepXrd9n1wcWvKmNfYH1OffW+EQWSwYKQa6b9qjqZB7T6BcQU/GAWMSKeAYM02VRLbuXXg/Xy0=@vger.kernel.org
X-Gm-Message-State: APuU4Z/RevVpDkb9RlW3KipNIcFef/1ic4UOjSUxv48RHe6nC4n435tn
	gLOedeUWolSDDQxERTGKaO875w9XJ0egtyPI3rQkVA3O5EesMHurg5VB+z57FRyngNZrij6MYl1
	j3v2qIl/AatBU1B0JR68SsWlGAbV7jDQ=
X-Gm-Gg: AZFdTZeVLJ/F9WIyc8hwlxnAOsttJRfYkwvLTNMmI6VtTpjIo3qF7yy7v6mbwlvEacQ
	+927ZcgyTDI7S1jH3je8kCeVtR4X4PpVZ+Thy+WfdumfE/rkl9HSyLVV5Ctu10DZZ+Vyl9nvJic
	xZ3qK7vztuOLqmMB3Jduiwg8DRCpSVdtPldeO9f3lXGRP9L2riiZngAFYCSouCTNB2KvqyW/oA5
	elo6hhhmIbQDc9yPb6rwBkZiOBhGpYSF4QtTIoG2b5+JSqLlESw/fWq3joNCUuZQS4vrKcAZcWD
	zBHSXfxb9u8uD92RxYJ5E7oxdpFjHUAv/wXgCNV65lcH7mz9vSonl82hidOiNI7ZWqVcRKH8Zxw
	sCnxx/pjG/Hkk3kw025F0pmhbYwmo0k92+8Mh
X-Received: by 2002:a05:6512:3d29:b0:5bf:d60a:9802 with SMTP id
 2adb3069b0e04-5c1bc806744mr4597626e87.18.1795572637275; Tue, 24 Nov 2026
 18:10:37 -0800 (PST)
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
 <CAKEwX=MLrDn55wmVKKba5=PcU+qFpkEbMmN2SjGTfTBiFKX8cw@mail.gmail.com>
 <awXr6iHBR54wBB05@google.com> <CACpmpodH3UUDLEze8=5v8LWgKnZWQVrQBhzSGJFY-PwEYmHEzQ@mail.gmail.com>
 <awYsDfYqrS2ldOTw@google.com>
In-Reply-To: <awYsDfYqrS2ldOTw@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 18:10:25 -0800
X-Gm-Features: Aa3M54qALWhKRISY9YLBLu3ihm-qdLfUy_KIL1Y148EHluJ1sIurum0NLZUmUvA
Message-ID: <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
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

On Tue, Nov 24, 2026 at 4:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
[...]
>
> I think the real gain comes from making the freeing path faster. What I
> am saying is that we should optimize the freeing path rather than
> batching stores to get better locality in zsmalloc pages, as this only
> speeds up the freeing path when most data in a batch falls into the same
> size class in zsmalloc, which isn't the case for real data (e.g.
> Silesia).
>
> I am not arguing that usemem results are not valuable, I am arguing that
> there's more to the data than just usemem latency/throughput being
> better with the patches.
>
> The hacks were just a way to test the theory by eliminating zsmalloc
> class contention. I am looking into proper optimizations for this path,
> the goal was just to see if optimizing the class lock contention in the
> freeing path would achieve the desired result.
>
[...]
> Yes. I tried rerunning usemem on a similar setup to yours, and
> aggregating throughput, total sys/wall time, as well as write/free times
> over 10 runs (write comes from throughput lines, free comes from freeing
> lines). I did this at the baseline, with patches 1-7, and with patch 8
> on top.
>
> usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
>       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s=
)
>       base     2355.6 +- 25.3       94.24    55.62    26.82    212,239
>       p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,108
>       p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,853
>                (-6.73% vs base,
>                 -7.17% vs p1-7)
>
> AFAICT the speed up happens on the freeing side, not the writing side,
> so it's not really zswap stores getting faster. In the freeing phase
> (66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), and
> total cycles drop from ~1.64T to ~1.30T (-21%).

Can you please clarify what "write_s" and "free_s" refer to, and how
are they measured? If you are referring to the gettimeofday() reported
timing done in user-space by usemem, these times measure child
processes' fork, do_unit, join, etc. : IOW, not a reliable indicator
of zswap_store() performance.

Also, there are no calls to zs_free() from zswap_compress() and
zswap_update_entries(), so, it is not clear why "free_s" reduces from
patch 7 (26.90s) to patch 8 (21.66s), if what you are saying (as I
understand it), is zs_free() results in the gains.

>
> Running perf on the baseline:
> ---------------------------------------------------------------------
>     # Total Lost Samples: 0
>     #
>     # Samples: 465K of event 'cpu/cycles/P' (time slices: 66%-100%)
>     # Event count (approx.): 1636895619486
>     #
>     # Overhead  Symbol
>     # ........  ............................................
>     #
>         92.29%  [k] queued_spin_lock_slowpath
>                 |
>                  --92.26%--queued_spin_lock_slowpath
>                            |
>                             --92.17%--zs_free
>                                       zswap_entry_free
>                                       zswap_invalidate
>                                       __swap_cluster_free_entries
>                                       swap_put_entries_cluster
>                                       swap_put_entries_direct
>                                       __zap_vma_range
>                                       unmap_vmas
>                                       unmap_region
>                                       vms_complete_munmap_vmas
>                                       do_vmi_align_munmap
>                                       do_vmi_munmap
>                                       __vm_munmap
>                                       __x64_sys_munmap
>                                       do_syscall_64
>                                       entry_SYSCALL_64_after_hwframe
>                                       0x430ef7
> ---------------------------------------------------------------------
>
> With your patches:
> ---------------------------------------------------------------------
>     # Total Lost Samples: 0
>     #
>     # Samples: 372K of event 'cpu/cycles/P' (time slices: 66%-100%)
>     # Event count (approx.): 1295809013413
>     #
>     # Overhead  Symbol
>     # ........  ..................................................
>     #
>         90.75%  [k] queued_spin_lock_slowpath
>                 |
>                  --90.72%--queued_spin_lock_slowpath
>                            |
>                             --90.03%--zs_free
>                                       zswap_entry_free
>                                       zswap_invalidate
>                                       __swap_cluster_free_entries
>                                       swap_put_entries_cluster
>                                       swap_put_entries_direct
>                                       __zap_vma_range
>                                       unmap_vmas
>                                       unmap_region
>                                       vms_complete_munmap_vmas
>                                       do_vmi_align_munmap
>                                       do_vmi_munmap
>                                       __vm_munmap
>                                       __x64_sys_munmap
>                                       do_syscall_64
>                                       entry_SYSCALL_64_after_hwframe
>                                       0x430ef7
> ---------------------------------------------------------------------
>

Is this perf run at the workload level? Can you also share the
zswap_store() perf breakdown? I don't see any zswap_store() callees
here..

> Adding some instrumentation I figured out that ~all memory from usemem
> ends up in the same size class, hence the better zspage locality from
> the batching in patch 8.

What does this have to do with batching? All usemem memory compresses
to the same zsmalloc size class in the baseline too. Can you elaborate
what you mean by "better zspage locality from the batching in patch
8"?

>
> Here's the bpftrace data I collected, I don't see a material change when
> probing zswap_store():
>
>     zswap_store() (2048kB PMD folios, 178.9k calls):
>       metric         base           p1-8           delta
>       p50            10.76 ms       10.85 ms       +0.87%
>       p95            11.34 ms       11.40 ms       +0.59%
>       p99            12.15 ms       12.05 ms       -0.82%
>       avg            10.80 ms       10.84 ms       +0.40%
>
>
> Also if I run your modified usemem with Silesia like your previous
> versions, the improvement goes away (because data no longer all goes in
> the same zsmalloc class):
>
>     usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 2560=
m,
>     memory.high=3D38G):
>       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (KB/s=
)
>       base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
>       p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
>       p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
>                (-0.40% vs base,
>                 -0.22% vs p1-7)

Is this with PMD mTHP? Also, we would get a better idea of concurrency
by increasing the memory allocation duration by allocating 10g per
process, for 30 processes under memory.high=3D150G. 2g gives much fewer
samples to be helpful, imo.

[...]
> I am not saying there is no performance improvement, I am saying the
> performance improvement is a side effect of locality in zsmalloc, not
> faster stores, and that it doesn't reproduce on real data.

I don't see the connection between batching and "locality in
zspage/zsmalloc" since compressed size is a net wash between baseline
and my patch series. Are we drawing the right conclusions?

> If we want to address lock contention in zsmalloc freeing we should addre=
ss it as
> such, not by batching compression.

Lock contention in zsmalloc seems like an independent optimization
that is good to solve. What I don't see is a way of explaining the
gains in this series based on zs_free() lock contention, and hence
drawing a questionable conclusion that this series does not optimize
zswap_store(), and further that batch compression is not attributing
to the gains. I have provided ~10 reasons as to why the combined
zswap_store_pages() batching and zswap_compress() batching improves
zswap_store() performance in [2].

[2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar2026=
@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc

>
> >
> > I would appreciate comments from Nhat, Johannes and Andrew on these
> > posted gains/analysis:
> >
> > [1]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar=
2026@gmail.com/T/#m33e586ec89ed46790da284e7a2f6d99b50c9f935
> > [2]: https://lore.kernel.org/all/20261120041906.5785-2-kanchanapsridhar=
2026@gmail.com/T/#m51d7d13809d508a9116904c01bf3c94fdf2981dc
> >
> > An independent replication of the gains posted by me in this
> > patch-series, using standard mm-unstable and vm-scalability/usemem
> > would also be very useful.
> >
> > Thanks,
> > Kanchana
> >
> > > Regarding the bpftrace
> > > measurements, I couldn't reproduce them. I think one factor is that
> > > probing both zswap_store() and zswap_compress() makes the zswap_store=
()
> > > numbers different based on how many zswap_compress() calls we make
> > > (which are less with batching) due to the overhead of the probe itsel=
f.
> > > When I trace zswap_store() without zswap_compress(), I don't see
> > > meaningful changes in latency.
> > >
> > > [1] https://lore.kernel.org/linux-mm/20261016120927.3191690-1-hongfen=
gchen@xiaomi.com/
> > > [2] https://lore.kernel.org/linux-mm/20261123054746.2579253-1-senozha=
tsky@chromium.org/
