Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J69VQqbx"
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0019EF0
	for <linux-crypto@vger.kernel.org>; Sun,  3 Dec 2023 19:41:43 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-40c09f4814eso9614025e9.1
        for <linux-crypto@vger.kernel.org>; Sun, 03 Dec 2023 19:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701661302; x=1702266102; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=usQamIUqJZ6NZB++HaV6GhUTfmbqwQpVT+aSIq6Nbqw=;
        b=J69VQqbxU9mDZ2Gljgkt7++ZisRms6/fLYmRZ4BQXANPl/ldS2m5E4P/cd6FHydLWe
         TJ3R7h9EAdiCoMepoR6MgGIZYc8ob2OmLCv8UO71hDc1NRqlB/eGj1J1XSEdkUzoGYwN
         MlbgsyL/PZBWW1aFnFcJ7R7T+iAXciPRN0eEUQUr+uXSLG0pI0zxT2EqiTrlXdKFgciS
         Uf+/CYjN9Z3l3kWas9NGmMAxzaUfqYBtuV1YXuvS8l0GnkFjh9lsOxsn+88lfJnDiE/r
         q/EljE/wEckYY3h6Kuyr00DAYwyG0WMhEchOQEx7CUwyqHkYcgneHm067tqWFvOCcd0j
         KpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701661302; x=1702266102;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=usQamIUqJZ6NZB++HaV6GhUTfmbqwQpVT+aSIq6Nbqw=;
        b=aG0niqBSQb8IcQ37u/0qLk2Q28soZIUTfP9iMN7V58eJAYmlZqeGmy3E3JpC41dLBO
         ZwD2uhneiCmna5xFO+BYmdWHM9Efldyk3IMHf3iRsu3QgfhtpjSHtY9YqgffrCmSTMof
         Dkwn/93NuImfX3TAj3doDXevogHEhUs8lJkpGGldpVRuh2u1XSMI6/BeYm7LYtRGkdG+
         vfhRRl9IDrpHfVP4BuiCxBbD/b+4N72cMewqgO6Y32tpp2VYxssLLu2S3U/LVA2IjLrx
         cKyuZ5QdDPSQ9FZ0IdLXZXihqMB3JWEopCrWzsX7f/JyYD75yBAKwqdL24fMfySxFSc/
         Jq3A==
X-Gm-Message-State: AOJu0Yw44WmgBX2PLEclRq26NRwH92GlBMZT9GDT0P5JD0ScRqohgoBG
	43VAW6Yz2hiXmB/AHbnwMiVGNuFkdg/ISsCM2fU=
X-Google-Smtp-Source: AGHT+IG5oJnJaoA+nIclssRYj99iohYwftln0Lz/CH7rQ1GGFQboKyYj2w+QFJMZ3+/uWoKOphk4mUbKdSlkFqeEY7U=
X-Received: by 2002:a05:600c:4ba5:b0:40b:5e59:cca1 with SMTP id
 e37-20020a05600c4ba500b0040b5e59cca1mr2118600wmp.130.1701661301960; Sun, 03
 Dec 2023 19:41:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com> <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com> <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
 <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
In-Reply-To: <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Mon, 4 Dec 2023 12:41:30 +0900
Message-ID: <CAD14+f3zgwgUugjnB7UGCYh4j3iXYsvv_DJ3yvwduA1xf3xn=A@mail.gmail.com>
Subject: Re: Weird EROFS data corruption
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Mon, Dec 4, 2023 at 12:28=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2023/12/4 01:32, Juhyung Park wrote:
> > Hi Gao,
>
> ...
>
> >>>
> >>>>
> >>>> What is the difference between these two machines? just different CP=
U or
> >>>> they have some other difference like different compliers?
> >>>
> >>> I fully and exclusively control both devices, and the setup is almost=
 the same.
> >>> Same Ubuntu version, kernel/compiler version.
> >>>
> >>> But as I said, on my laptop, the issue happens on kernels that someon=
e
> >>> else (Canonical) built, so I don't think it matters.
> >>
> >> The only thing I could say is that the kernel side has optimized
> >> inplace decompression compared to fuse so that it will reuse the
> >> same buffer for decompression but with a safe margin (according to
> >> the current lz4 decompression implementation).  It shouldn't behave
> >> different just due to different CPUs.  Let me find more clues
> >> later, also maybe we should introduce a way for users to turn off
> >> this if needed.
> >
> > Cool :)
> >
> > I'm comfortable changing and building my own custom kernel for this
> > specific laptop. Feel free to ask me to try out some patches.
>
> Thanks, I need to narrow down this issue:
>
> -  First, could you apply the following diff to test if it's still
>     reproducable?
>
> diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
> index 021be5feb1bc..40a306628e1a 100644
> --- a/fs/erofs/decompressor.c
> +++ b/fs/erofs/decompressor.c
> @@ -131,7 +131,7 @@ static void *z_erofs_lz4_handle_overlap(struct z_erof=
s_lz4_decompress_ctx *ctx,
>
>         if (rq->inplace_io) {
>                 omargin =3D PAGE_ALIGN(ctx->oend) - ctx->oend;
> -               if (rq->partial_decoding || !may_inplace ||
> +               if (1 || rq->partial_decoding || !may_inplace ||
>                     omargin < LZ4_DECOMPRESS_INPLACE_MARGIN(rq->inputsize=
))
>                         goto docopy;

Yup, that fixes it.

The hash output is the same for 50 runs.

>
> - Could you share the full message about the output of `lscpu`?

Sure:

Architecture:            x86_64
  CPU op-mode(s):        32-bit, 64-bit
  Address sizes:         39 bits physical, 48 bits virtual
  Byte Order:            Little Endian
CPU(s):                  8
  On-line CPU(s) list:   0-7
Vendor ID:               GenuineIntel
  BIOS Vendor ID:        Intel(R) Corporation
  Model name:            11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz
    BIOS Model name:     11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GHz Non=
e CPU
                          @ 3.0GHz
    BIOS CPU family:     198
    CPU family:          6
    Model:               140
    Thread(s) per core:  2
    Core(s) per socket:  4
    Socket(s):           1
    Stepping:            1
    CPU(s) scaling MHz:  60%
    CPU max MHz:         4800.0000
    CPU min MHz:         400.0000
    BogoMIPS:            5990.40
    Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep mtrr p=
ge mc
                         a cmov pat pse36 clflush dts acpi mmx fxsr sse sse=
2 ss
                         ht tm pbe syscall nx pdpe1gb rdtscp lm constant_ts=
c art
                          arch_perfmon pebs bts rep_good nopl xtopology non=
stop_
                         tsc cpuid aperfmperf tsc_known_freq pni pclmulqdq =
dtes6
                         4 monitor ds_cpl vmx smx est tm2 ssse3 sdbg fma cx=
16 xt
                         pr pdcm pcid sse4_1 sse4_2 x2apic movbe popcnt tsc=
_dead
                         line_timer aes xsave avx f16c rdrand lahf_lm abm 3=
dnowp
                         refetch cpuid_fault epb cat_l2 cdp_l2 ssbd ibrs ib=
pb st
                         ibp ibrs_enhanced tpr_shadow flexpriority ept vpid=
 ept_
                         ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 erms in=
vpcid
                          rdt_a avx512f avx512dq rdseed adx smap avx512ifma=
 clfl
                         ushopt clwb intel_pt avx512cd sha_ni avx512bw avx5=
12vl
                         xsaveopt xsavec xgetbv1 xsaves split_lock_detect d=
therm
                          ida arat pln pts hwp hwp_notify hwp_act_window hw=
p_epp
                          hwp_pkg_req vnmi avx512vbmi umip pku ospke avx512=
_vbmi
                         2 gfni vaes vpclmulqdq avx512_vnni avx512_bitalg t=
me av
                         x512_vpopcntdq rdpid movdiri movdir64b fsrm avx512=
_vp2i
                         ntersect md_clear ibt flush_l1d arch_capabilities
Virtualization features:
  Virtualization:        VT-x
Caches (sum of all):
  L1d:                   192 KiB (4 instances)
  L1i:                   128 KiB (4 instances)
  L2:                    5 MiB (4 instances)
  L3:                    12 MiB (1 instance)
NUMA:
  NUMA node(s):          1
  NUMA node0 CPU(s):     0-7
Vulnerabilities:
  Gather data sampling:  Vulnerable
  Itlb multihit:         Not affected
  L1tf:                  Not affected
  Mds:                   Not affected
  Meltdown:              Not affected
  Mmio stale data:       Not affected
  Retbleed:              Not affected
  Spec rstack overflow:  Not affected
  Spec store bypass:     Vulnerable
  Spectre v1:            Vulnerable: __user pointer sanitization and userco=
py ba
                         rriers only; no swapgs barriers
  Spectre v2:            Vulnerable, IBPB: disabled, STIBP: disabled, PBRSB=
-eIBR
                         S: Vulnerable
  Srbds:                 Not affected
  Tsx async abort:       Not affected


>
> Thanks,
> Gao Xiang
