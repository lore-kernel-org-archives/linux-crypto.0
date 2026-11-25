Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795589817;
	b=4zq/PIAC+DZbr/osemv0WsovTVIZsSCv0ZJQkOAevGBRc2PLbXYZlIwMVMpoS+vw3+42
	 VBU/naneNSVuAkXjqzuKOhpujON2IGTaTAyNZvPzLDJTnfgbL1Tr3Qe6vgoRj4H2XLa5J
	 aHi9tPHfw3rPf0stPflSVHERgXZuNrGB7nftBwIyFyR3sNQyEZ8kds3eUbmorbKSKpENR
	 Wa1YCPYKWUslIKh7iE1iOy+Zu/pvsrpCaNd7xfjm30e6Se8EL6aLDq17ER4ukE97ypG+X
	 EJmbVTW7kE7UtvnXMfkwI/d6jdKspKZSi2xVS3DeAJyeEWRSR9lKlh7V7niLdVYqVQw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795589817;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
	b=5NPYRrUfVAW3DKQX02Q4CWOd3tMXTuySWilQiFp3PF7xZUwulQ5pZ+uLRyY5GR8g7BIz
	 iAKHHT4XqYe2M2Jp42T0gO1Sl7Cednf1RBncWi4JfoaRGXag36shSHahiXDAcmQCLhBUF
	 7cl38OvtV6cfHjtseVMugknD96zDVrAGD7PxcG1qZ//2zMLTjz3USe59YY8O1xXXN9miM
	 3wfP8EfPjAY58C2MjlVs0ks0fzamzyhr+9YgTf7lG8vEfkMqOWqurl65dTQ94eqnHdZpv
	 idOzVT683DLNMzmt27RKhz8a39Y48Bjv509sVSf3hZdPtxQ1T8W7ukf41CmxBhai3SQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tLsJlmkx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.180
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3BC606A688
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 06:56:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6C3BC606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tLsJlmkx
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-3ae0a5c1715so57647441fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 22:56:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795589815; cv=none;
        d=google.com; s=arc-20260327;
        b=HMuNUn8Q9XX6/oJ2b5r4NAfAzl7iYt9+SBxUBK/yytmuAyoNAPKRQRaNCly8BVY03l
         lkutKOOMtPiVNnS2P2b7O/iiZ7bMK45SJDXVjLL+Ug/haEok+kgLw2Eu3aTvtEmwq7bm
         F4PHMVpjYA/z9q2XOOu2KmCdeK1NJqcizW1c8374eK7Ju3CGwBCY/+5a+iRJwmBsCDXs
         Kp41JL8bR4zF8TUMxsF9U5dQguBIDAsOkE4YurU+OMelTKV7ff0cX8f38bgqorvB7EjT
         U0PeyrnVIy0K4TYCiRXU9rhvHiuhYlDndk+5JhyFQDxKIkXNF/2AUbb+mm3cMTOu7k0E
         AjCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        fh=SJWH2kdc+9MaGpzqx1sXNCfw+RVXOwz67IUvSBIPMSc=;
        b=be1ssM+dhgyRr/ORWIhH2waJxUE+/+WWWbz7e5o3bzECcytLN+GyW7FiJ9XPjD79cZ
         Lyeh1Q8rX/LoFcHCd17QPanmiueBwi7GmZA4etl1ZM6maGdah4WY5TqHLWmIM17FfvmA
         B4YiFVOYZ3y/cLijTn1OUflQGnpC8V5AiMizdsOpKZd+gkTYFBySYsmro7hUc1cZU83w
         fWJAReh6rSHxmQbaaG5saCTG5EesvqBY167ZGVRZC26muvreXik1MlPiQSgaT6U5TyXH
         frZo2P2VMjJBAHGNJnVIIyeXLmXPxlCDHqQAbdjUXk1qxWl0WbV/5YjtLhTzSE+8R7Fg
         EaAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795589815; x=1796194615; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        b=tLsJlmkxpDJTnl9s4bJIiGkuOHZxAqOHM0X9P9aHyiMegrdaQil0S1kpz3GDfAJZBr
         MCoII6vPCt1Xt0m6bTZ1s4WtySV1T+2qnKWbfrouxpJbAbeTcyRRsOYlK6yoxb3MgDWS
         XWoDNK/ai5ZKdRSPlBis2ejr0AA+OG0CFWE+dnasrut0RK1a4MN2s8x5h67say4QlNLO
         l77okbjuLOvwmrdHyNa3uK59cSko8rVNq4EpoGJ3urIZ7JRylggERJrIBxPqJkXx4iOH
         goHUsdX4OYoBgCdervqTIQBmKdaH/eLeeA5mS7k5bntxoyiS2C43EIEN55QZqNjYzSRh
         /s8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795589815; x=1796194615;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ha1sD3FIgKbrRu6a6kLtp+uh7BrvdOhtuCwLJhvS3Z4=;
        b=1JPV0bfat/lTmD/f54syfvEibbPs/Ij4wFFfmdvlqD7U8zsUnwlOH/xaaVwq18s/fO
         PWp+TixSROPCgNoEetX22/C4Vsa10mrfhsIMdoCFk2aPtUeRaH+JsoqXApvPDGWDJpiF
         Rox9dRIe9B6gIATUbc9sfzCM6qcfadICveL00j8dbURs7aYMzOFszuAVT8VGeQ6+9WER
         K8JaYuH4Kuy5PeKAW6Kij47tNjAJ1S5UJcQGLKODXG/wiVLPoz6kdVfpr/qRaHJDQyHy
         aOAbGuqvXvICpIbA1HIlYj88Z6d7zhd/YvEortz+yUGlsjAMSPZqVBR9xFdHCCpIFKIy
         yQjQ==
X-Forwarded-Encrypted: i=1; AL+hErHsPQlio6M8CsJXVx+THNwKiebmMq48CGM4T6mFtdglcmUFO+bdL6PtpkzfaXshn+6E42pDznJEStMDpj4=@vger.kernel.org
X-Gm-Message-State: APuU4Z+RPpvHnO698jpakuDMR38ZSvfIW8vtBBwANUMSyk64/ku7KnpS
	M/DygADa9lCKorC2qcIFRb+RcENKDhtt+W6ww4DFg9vuVr+QBIZQCUSdTOk2J7TQWFz7lcO06xl
	E+nE/vCoJ1+rxlzdP0QH9DV3NS94X5mw=
X-Gm-Gg: AZFdTZc430S2g7CWWOTwJOf5OPEhBdr7R5/nAVeqf3KCUmeEFQl+RsuYid4HNFjghpu
	aM1wTcBGNH4Pb62oTEPuzhGAjn3qCbkisFXM92nnk+toEHimoFw/vv6KJMpScKOGXajEiLlz/RT
	DjxCEnpzhGNNLfiAaX6OqShGki5nhMmIK1xbJmdgp1YaZMajKOjzhr8wWVkV6vijHZ9Kvv8Hf3S
	ElkI5OaTD9jIxc3Q2DRxSTCXMzaIaxMDnTBsbvPnaIKvTuiTEc7vfhPZe3pEz/YfSIScxUjGnWW
	Qep9//izTg4KVWv9WtOSRiSWGG+5VKg8IV5MlD3c0HTrhkCB6FilEl3RqQA5Gss72uoUsujFx9k
	BdPgR/6cQgtui9+OLU7PFbPzqHLUHkGQTBnv0
X-Received: by 2002:a05:6512:104f:b0:5bf:ca51:e25d with SMTP id
 2adb3069b0e04-5c1bc85debcmr4552963e87.11.1795589814181; Tue, 24 Nov 2026
 22:56:54 -0800 (PST)
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
 <awYsDfYqrS2ldOTw@google.com> <CACpmpofsU3f=PVQF4moe6n=_qit1ZGyo4FMjyM-sVgumfyN0iw@mail.gmail.com>
 <awZt7P_p-GNZ3A2i@google.com>
In-Reply-To: <awZt7P_p-GNZ3A2i@google.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Tue, 24 Nov 2026 22:56:42 -0800
X-Gm-Features: Aa3M54oXzyeaRv6QCCuUq_sp7X_zsNBqLra3JmTQYx5ozeA7YpvDzRVEZ_mU90g
Message-ID: <CACpmpod_87WY_PcOsNmPZvFzmJyBtCpyvvq1a_BqmZgGmO1e5A@mail.gmail.com>
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

On Tue, Nov 24, 2026 at 9:51=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Nov 24, 2026 at 06:10:25PM -0800, Kanchana P. Sridhar wrote:
> > On Tue, Nov 24, 2026 at 4:59=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > [...]
> > >
> > > I think the real gain comes from making the freeing path faster. What=
 I
> > > am saying is that we should optimize the freeing path rather than
> > > batching stores to get better locality in zsmalloc pages, as this onl=
y
> > > speeds up the freeing path when most data in a batch falls into the s=
ame
> > > size class in zsmalloc, which isn't the case for real data (e.g.
> > > Silesia).
> > >
> > > I am not arguing that usemem results are not valuable, I am arguing t=
hat
> > > there's more to the data than just usemem latency/throughput being
> > > better with the patches.
> > >
> > > The hacks were just a way to test the theory by eliminating zsmalloc
> > > class contention. I am looking into proper optimizations for this pat=
h,
> > > the goal was just to see if optimizing the class lock contention in t=
he
> > > freeing path would achieve the desired result.
> > >
> > [...]
> > > Yes. I tried rerunning usemem on a similar setup to yours, and
> > > aggregating throughput, total sys/wall time, as well as write/free ti=
mes
> > > over 10 runs (write comes from throughput lines, free comes from free=
ing
> > > lines). I did this at the baseline, with patches 1-7, and with patch =
8
> > > on top.
> > >
> > > usemem30 (usemem -w -O -b 5 -s 10 -n 30 10g):
> > >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (=
KB/s)
> > >       base     2355.6 +- 25.3       94.24    55.62    26.82    212,23=
9
> > >       p1-7     2366.7 +- 22.9       94.65    55.91    26.90    211,10=
8
> > >       p1-8     2197.0 +- 37.9       89.65    55.48    21.66    212,85=
3
> > >                (-6.73% vs base,
> > >                 -7.17% vs p1-7)
> > >
> > > AFAICT the speed up happens on the freeing side, not the writing side=
,
> > > so it's not really zswap stores getting faster. In the freeing phase
> > > (66%-100% of the run), ~90-92% of cycles are spinning in zs_free(), a=
nd
> > > total cycles drop from ~1.64T to ~1.30T (-21%).
> >
> > Can you please clarify what "write_s" and "free_s" refer to, and how
> > are they measured? If you are referring to the gettimeofday() reported
> > timing done in user-space by usemem, these times measure child
> > processes' fork, do_unit, join, etc. : IOW, not a reliable indicator
> > of zswap_store() performance.
>
> write_s and free_s are from usemem's output.
>
> Without your patches, here's the raw data I got:
>
>     12079595520 bytes / 36047550 usecs =3D 327247 KB/s
>     12079595520 bytes / 36221811 usecs =3D 325673 KB/s
>     12079595520 bytes / 36539948 usecs =3D 322837 KB/s
>     12079595520 bytes / 36554520 usecs =3D 322709 KB/s
>     12079595520 bytes / 36630659 usecs =3D 322038 KB/s
>     12079595520 bytes / 36705879 usecs =3D 321378 KB/s
>     12079595520 bytes / 36795396 usecs =3D 320596 KB/s
>     12079595520 bytes / 36844030 usecs =3D 320173 KB/s
>     12079595520 bytes / 36936923 usecs =3D 319368 KB/s
>     12079595520 bytes / 36989604 usecs =3D 318913 KB/s
>     12079595520 bytes / 37063935 usecs =3D 318273 KB/s
>     12079595520 bytes / 37065296 usecs =3D 318262 KB/s
>     12079595520 bytes / 37158608 usecs =3D 317462 KB/s
>     12079595520 bytes / 37188329 usecs =3D 317209 KB/s
>     12079595520 bytes / 37176041 usecs =3D 317314 KB/s
>     12079595520 bytes / 37222619 usecs =3D 316916 KB/s
>     12079595520 bytes / 37277605 usecs =3D 316449 KB/s
>     12079595520 bytes / 37382137 usecs =3D 315564 KB/s
>     12079595520 bytes / 37485910 usecs =3D 314691 KB/s
>     12079595520 bytes / 37506482 usecs =3D 314518 KB/s
>     12079595520 bytes / 37582493 usecs =3D 313882 KB/s
>     12079595520 bytes / 37654025 usecs =3D 313286 KB/s
>     12079595520 bytes / 37804401 usecs =3D 312039 KB/s
>     12079595520 bytes / 37872179 usecs =3D 311481 KB/s
>     12079595520 bytes / 38139663 usecs =3D 309296 KB/s
>     12079595520 bytes / 38148594 usecs =3D 309224 KB/s
>     12079595520 bytes / 38149377 usecs =3D 309218 KB/s
>     12079595520 bytes / 38207236 usecs =3D 308749 KB/s
>     12079595520 bytes / 38442241 usecs =3D 306862 KB/s
>     12079595520 bytes / 38445731 usecs =3D 306834 KB/s
>     11147897 usecs to free memory
>     16392260 usecs to free memory
>     22879204 usecs to free memory
>     23382635 usecs to free memory
>     23518192 usecs to free memory
>     24023442 usecs to free memory
>     24176849 usecs to free memory
>     24461635 usecs to free memory
>     24232157 usecs to free memory
>     24571926 usecs to free memory
>     24498438 usecs to free memory
>     24500253 usecs to free memory
>     24197624 usecs to free memory
>     24424616 usecs to free memory
>     24128275 usecs to free memory
>     24646461 usecs to free memory
>     24390349 usecs to free memory
>     24522151 usecs to free memory
>     24563204 usecs to free memory
>     24270881 usecs to free memory
>     24232957 usecs to free memory
>     23980870 usecs to free memory
>     24180573 usecs to free memory
>     24068183 usecs to free memory
>     23758087 usecs to free memory
>     23799366 usecs to free memory
>     23512788 usecs to free memory
>     23749313 usecs to free memory
>     23829669 usecs to free memory
>     23532371 usecs to free memory
>
> write_s would be calculated averaging the time in the ".. bytes / ..
> usecs" lines, and free_s by averaging the time from the ".. usecs to free
> memory" lines.
>
> In this run:
> write_s =3D 37.31 s
> free_s =3D 23.39 s
>
> With your patches, I got:
> write_s =3D 37.03 s
> free_s =3D 18.86 s

I am not sure how useful it is to apply user-space gettimeofday()
results that time many higher level C code API, as an indicator of
zswap_store() performance.

>
> So most of the improvement is in the freeing time.
>
> > Also, there are no calls to zs_free() from zswap_compress() and
> > zswap_update_entries(), so, it is not clear why "free_s" reduces from
> > patch 7 (26.90s) to patch 8 (21.66s), if what you are saying (as I
> > understand it), is zs_free() results in the gains.
> [..]
> > Is this perf run at the workload level? Can you also share the
> > zswap_store() perf breakdown? I don't see any zswap_store() callees
> > here..
>
> Here are perf reports collected with:
>
>     perf report --stdio --children --sort sym --percentage absolute \
>         --symbol-filter=3Dzswap_ -g graph,1,caller,function,period
>
> Baseline:
>
> # Total Lost Samples: 0
> # Samples: 923K of event 'cpu/cycles/P'
> # Event count (approx.): 5783481013054
> #
> # Children      Self  Symbol
> # ........  ........  ..................................................
> #
> 52.06%     0.26%  [.] zswap_store
>         |
>          --2995798359281--zswap_store
>                    |
>                    |--2724723679947--zstd_compress
>                    |          |--2639614263267--ZSTD_compress2
>                    |          ...
>                    |           --66562348127--ZSTD_initStaticCCtx
>                    |
>                     --217649410880--zs_store
>                               |
>                                --126618473697--__pv_queued_spin_lock_slow=
path
> [...]
> 40.26%     0.01%  [.] zswap_invalidate
>         |
>          --2327775248737--zswap_invalidate
>                    |
>                     --2322317048724--zswap_entry_free
>                               |
>                                --2233301817626--zs_free
>                                          |
>                                           --2178824329486--__pv_queued_sp=
in_lock_slowpath
>
> With the patches:
>
> # Total Lost Samples: 0
> # Samples: 863K of event 'cpu/cycles/P'
> # Event count (approx.): 5420333292095
> #
> # Children      Self  Symbol
> # ........  ........  ..................................................
> #
> 55.49%     0.17%  [.] zswap_store
>         |
>          --2998025641673--zswap_store
>                    |
>                    |--2724254313681--crypto_acomp_compress
>                    |          |
>                    |           --2718237550253--zstd_compress
>                    |                     |--2634756568606--ZSTD_compress2
>                    |                     ...
>                    |                      --62825503508--ZSTD_initStaticC=
Ctx
>                    |
>                     --206719808793--zs_store
>                               |
>                                --142932151337--__pv_queued_spin_lock_slow=
path
> [...]
> 36.25%     0.01%  [.] zswap_invalidate
>         |
>          --1964269438386--zswap_invalidate
>                    |
>                     --1959142544382--zswap_entry_free
>                               |
>                                --1874286346020--zs_free
>                                          |
>                                           --1828012531673--__pv_queued_sp=
in_lock_slowpath
>
>
> You can see that the cycles spent on zswap_store() are almost the same,
> and the cycle reduction happens in zswap_invalidate().

The cycles spent in zswap_store() should be normalized to the # of
zswpout events that these CPU cycles represent, for this to be a
reliable measure of latency improvement. There could be an increase in
reclaimed folios for any number of reasons, all of which are not
necessarily due to performance-improvement/degradation of
zswap_store() itself. IOW, more work for less latency per unit of work
is not always indicative of a performance degradation in this case.

A realistic scenario would be that with zswap_store() becoming more
efficient, the 30 allocating threads cause more memory.high breaches,
that causes more zswpout..
This would cause more CPU cycles in zswap_store(), but the fact
remains that zswap_store() efficiency has improved due to batching.

>
> > > Adding some instrumentation I figured out that ~all memory from useme=
m
> > > ends up in the same size class, hence the better zspage locality from
> > > the batching in patch 8.
> >
> > What does this have to do with batching? All usemem memory compresses
> > to the same zsmalloc size class in the baseline too. Can you elaborate
> > what you mean by "better zspage locality from the batching in patch
> > 8"?
>
> With compression batching, pages in a folio call zs_store() in a row, so
> they have a higher chance of landing in the same zspage compared to the
> baseline.
>
> In the baseline, each page's zs_store() is separated by ZSTD
> compression, during which the other 29 processes fill up the current
> zspage. With the patches (especially patch 8), 4 pages are compressed
> first and then stored via zs_store() back-to-back, so they are much more
> likely to land in the same zspage.
>
> I used an LLM-generated bpftrace script to map each folio to the zspage
> its pages end up on (~450 folios sampled), and aggregate the results:
>
>                                          base           patched
> Distinct zspages per 512-page folio:
> mean +- sd                               510.6+-2.8     321.8+-24.0
> median (p10 - p90)                       511 (509-512)  322 (302-341)
> min - max                                483 - 512      215 - 407
> Avg pages of same folio per zspage         1.00         1.59
> Consecutive pages hitting same zspage      0.27%        36.16%
> (same-zspage adjacent pairs / 231,483)   (618)          (83,709)
> Contiguous same-zspage run lengths:
> len =3D 1                                  99.7%          62.8%
> len =3D 2                                   0.3%          22.1%
> len =3D 3                                   0.0%          10.9%
> len =3D 4                                   0.0%          4.2%
>
> This causes zs_free() to run faster (i.e. shorter lock critical section)
> as the zspage (and its metadata) is hot in the cache during freeing.

All these seem to be good kernel improvements caused by zswap store &
compress batching. I don't see an issue here.

>
> >
> > >
> > > Here's the bpftrace data I collected, I don't see a material change w=
hen
> > > probing zswap_store():
> > >
> > >     zswap_store() (2048kB PMD folios, 178.9k calls):
> > >       metric         base           p1-8           delta
> > >       p50            10.76 ms       10.85 ms       +0.87%
> > >       p95            11.34 ms       11.40 ms       +0.59%
> > >       p99            12.15 ms       12.05 ms       -0.82%
> > >       avg            10.80 ms       10.84 ms       +0.40%
> > >
> > >
> > > Also if I run your modified usemem with Silesia like your previous
> > > versions, the improvement goes away (because data no longer all goes =
in
> > > the same zsmalloc class):
> > >
> > >     usemem30 + Silesia (usemem -w --read-silesia -O -b 5 -s 10 -n 30 =
2560m,
> > >     memory.high=3D38G):
> > >       kernel   sys_s (mean +- sd)   wall_s   write_s  free_s   tput (=
KB/s)
> > >       base     1779.0 +- 8.5        72.84    55.34    6.92     53,290
> > >       p1-7     1775.7 +- 7.3        72.81    55.29    6.86     53,337
> > >       p1-8     1771.8 +- 7.8        72.58    55.19    6.83     53,435
> > >                (-0.40% vs base,
> > >                 -0.22% vs p1-7)
> >
> > Is this with PMD mTHP? Also, we would get a better idea of concurrency
> > by increasing the memory allocation duration by allocating 10g per
> > process, for 30 processes under memory.high=3D150G. 2g gives much fewer
> > samples to be helpful, imo.
>
> Yes, with PMD mTHP.
>
> 2560m with memory.high=3D38G was chosen purely to stay under the default
> max_pool_percent=3D20 (38G on a 190G host) with zero pool-limit hits or
> disk swapout, since Silesia compresses ~2.5-3x instead of ~7x for
> unmodified usemem. Because ZSTD on Silesia is heavier per page, the
> write duration is actually the same as 10g unmodified usemem with ~31M
> zswpout per run.
>
> >
> > [...]
> > > I am not saying there is no performance improvement, I am saying the
> > > performance improvement is a side effect of locality in zsmalloc, not
> > > faster stores, and that it doesn't reproduce on real data.
> >
> > I don't see the connection between batching and "locality in
> > zspage/zsmalloc" since compressed size is a net wash between baseline
> > and my patch series. Are we drawing the right conclusions?
>
> See above.
>
> >
> > > If we want to address lock contention in zsmalloc freeing we should a=
ddress it as
> > > such, not by batching compression.
> >
> > Lock contention in zsmalloc seems like an independent optimization
> > that is good to solve. What I don't see is a way of explaining the
> > gains in this series based on zs_free() lock contention, and hence
> > drawing a questionable conclusion that this series does not optimize
> > zswap_store(), and further that batch compression is not attributing
> > to the gains. I have provided ~10 reasons as to why the combined
> > zswap_store_pages() batching and zswap_compress() batching improves
> > zswap_store() performance in [2].
>
> See above. I think the performance improvement is a side effect of
> calling zs_store() in rapid succession for pages in the same folio, and
> more pages in the same folio ending up in the same zspage. As I
> previously mentioned, this happens because all pages in usemem end up in
> the same size class.
>
> The right thing to do would be optimize the zs_free() path. I am looking
> into batching zswap entries freeing, which I believe is the right path
> to optimize given those results.

If I can restate what you are suggesting, and please correct me if I am wro=
ng:

1) [Data needed]: Normalized zswap_store() CPU cycles to # of zswpout
vmstat events in baseline and patched.

2) [Data needed]:  Normalized zs_free() CPU cycles to # of calls to zs_free=
().

3) If (2) confirms that zs_free() has become faster, then that is a
beneficial side effect of batching, per your analysis above.

4) Why are you suggesting that *instead* of acknowledging the
beneficial side-effects of zswap store/compress batching, you would
want to find another way to improve zs_free() latency by batching of
zswap entries freeing? I would imagine both need to happen. The zspage
locality side-effect isn't a contra-indicator to zswap compress
batching.

I will run some experiments to quantify zswap_store() improvements
better, with compress batching.
