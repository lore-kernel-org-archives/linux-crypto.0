Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTic1WUZ"
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2B4AA1
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 06:23:58 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-a1b6b65923eso318024866b.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 06:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701786237; x=1702391037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T7XU6GHHiBgdkrXmdGsRu2k0uowM8mZD/GX6dh9pTT4=;
        b=bTic1WUZZIDioBcJjLFmlgmec4z3xPLXPR6cZ4cw34EWiVZQF76MaPa3cnILBZ/A0Y
         rzDOan2uT+U+C1wuN7hjfegbrspxmRu0gBIt+zOcfOU8RIrBPLgCgggnZ1+1af1Leftk
         gwNs+ea7fBlqTHtQ/n4ZOGfIEJiYzsOEPQeVRW7gZfHehFcn7KdNPWee52WGuhJHmfox
         1ykQFKXqRF3mq/gIvI7BCZDlaTQT604WS1/ukvr+1ckr3GpxdLFLIf8SpYw+t3L3zutD
         BPUEYByqCiFgi1V0adrEiCOuKoQAQGjxmwNO43m5i4ED82SyZolUa2j4BD9hqAY8GSL3
         sJZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701786237; x=1702391037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T7XU6GHHiBgdkrXmdGsRu2k0uowM8mZD/GX6dh9pTT4=;
        b=RoWikgSojcUSYgACakUnI5lHq26NwROww8ow0HMxIfvsE2THeaKH7W1FnNWE7dQtkH
         ol4TD/XbJEAbBEQxgXpVU9O1IlMa8q+sYZXiCBR2KnUaYO1MMOADJ3qVleaE+jGVTq02
         ZyIcPh91IEBR2h+mK0NP+sG11MxnNgIcWRaWAX2D4ZqCDI4vxJW1Gvnkup1+Mbibjn9r
         TzxS1QFeR8j+HL+hdCfvCkdjX7Au3n/Ye51vxYf8uZXfUKmQohXIULbQUWCWqRDZKAfi
         FJFwegbMEzbSJjWIhzQjNgSWST0X74UqWoM9E3D944Jocx9un5DLlQTToobCDXCG+8nD
         7bpA==
X-Gm-Message-State: AOJu0Yx+DqEWGBI014zJ23vH8N6UU0d/YcstMJ/K4wLAPNSncRw/ZzMI
	x+cDmHRd4HMiPAErTEF/RlhIwBRaAIGErTL8ol8=
X-Google-Smtp-Source: AGHT+IHmjQYO8Lbz0AV3t/9F250TBl3CqhhD6m/ina5u1sK3EV3LtWkK0nPmDiX1Pkv1pnEGvjIvN7xUJ/csGiAx/rc=
X-Received: by 2002:a17:906:73cf:b0:a1c:c376:85ca with SMTP id
 n15-20020a17090673cf00b00a1cc37685camr248747ejl.216.1701786236507; Tue, 05
 Dec 2023 06:23:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAD14+f2AVKf8Fa2OO1aAUdDNTDsVzzR6ctU_oJSmTyd6zSYR2Q@mail.gmail.com>
 <5a0e8b44-6feb-b489-cdea-e3be3811804a@linux.alibaba.com> <CAD14+f2G-buxTaWgb23DYW-HSd1sch6tJNKV2strt=toASZXQQ@mail.gmail.com>
 <649a3bc4-58bb-1dc8-85fb-a56e47b3d5c9@linux.alibaba.com> <CAD14+f1u6gnHLhGSoQxL9wLq9vDYse+Ac8zxep-O2E8hHreT2w@mail.gmail.com>
 <275f025d-e2f1-eaff-6af1-e909d370cee0@linux.alibaba.com> <CAD14+f3zgwgUugjnB7UGCYh4j3iXYsvv_DJ3yvwduA1xf3xn=A@mail.gmail.com>
 <d7c7ea8c-6e2f-e8d8-88c3-4952c506ed13@linux.alibaba.com>
In-Reply-To: <d7c7ea8c-6e2f-e8d8-88c3-4952c506ed13@linux.alibaba.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Tue, 5 Dec 2023 23:23:44 +0900
Message-ID: <CAD14+f2hPLv6RPZdYyi8q8SQGiBox2fYUaWwuBEjEbZKQdyU7g@mail.gmail.com>
Subject: Re: Weird EROFS data corruption
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Gao,

On Tue, Dec 5, 2023 at 4:32=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.c=
om> wrote:
>
> Hi Juhyung,
>
> On 2023/12/4 11:41, Juhyung Park wrote:
>
> ...
> >
> >>
> >> - Could you share the full message about the output of `lscpu`?
> >
> > Sure:
> >
> > Architecture:            x86_64
> >    CPU op-mode(s):        32-bit, 64-bit
> >    Address sizes:         39 bits physical, 48 bits virtual
> >    Byte Order:            Little Endian
> > CPU(s):                  8
> >    On-line CPU(s) list:   0-7
> > Vendor ID:               GenuineIntel
> >    BIOS Vendor ID:        Intel(R) Corporation
> >    Model name:            11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GH=
z
> >      BIOS Model name:     11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.00GH=
z None CPU
> >                            @ 3.0GHz
> >      BIOS CPU family:     198
> >      CPU family:          6
> >      Model:               140
> >      Thread(s) per core:  2
> >      Core(s) per socket:  4
> >      Socket(s):           1
> >      Stepping:            1
> >      CPU(s) scaling MHz:  60%
> >      CPU max MHz:         4800.0000
> >      CPU min MHz:         400.0000
> >      BogoMIPS:            5990.40
> >      Flags:               fpu vme de pse tsc msr pae mce cx8 apic sep m=
trr pge mc
> >                           a cmov pat pse36 clflush dts acpi mmx fxsr ss=
e sse2 ss
> >                           ht tm pbe syscall nx pdpe1gb rdtscp lm consta=
nt_tsc art
> >                            arch_perfmon pebs bts rep_good nopl xtopolog=
y nonstop_
> >                           tsc cpuid aperfmperf tsc_known_freq pni pclmu=
lqdq dtes6
> >                           4 monitor ds_cpl vmx smx est tm2 ssse3 sdbg f=
ma cx16 xt
> >                           pr pdcm pcid sse4_1 sse4_2 x2apic movbe popcn=
t tsc_dead
> >                           line_timer aes xsave avx f16c rdrand lahf_lm =
abm 3dnowp
> >                           refetch cpuid_fault epb cat_l2 cdp_l2 ssbd ib=
rs ibpb st
> >                           ibp ibrs_enhanced tpr_shadow flexpriority ept=
 vpid ept_
> >                           ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2 er=
ms invpcid
> >                            rdt_a avx512f avx512dq rdseed adx smap avx51=
2ifma clfl
> >                           ushopt clwb intel_pt avx512cd sha_ni avx512bw=
 avx512vl
> >                           xsaveopt xsavec xgetbv1 xsaves split_lock_det=
ect dtherm
> >                            ida arat pln pts hwp hwp_notify hwp_act_wind=
ow hwp_epp
> >                            hwp_pkg_req vnmi avx512vbmi umip pku ospke a=
vx512_vbmi
> >                           2 gfni vaes vpclmulqdq avx512_vnni avx512_bit=
alg tme av
> >                           x512_vpopcntdq rdpid movdiri movdir64b fsrm a=
vx512_vp2i
>
> Sigh, I've been thinking.  Here FSRM is the most significant difference b=
etween
> our environments, could you only try the following diff to see if there's=
 any
> difference anymore? (without the previous disable patch.)
>
> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> index 1b60ae81ecd8..1b52a913233c 100644
> --- a/arch/x86/lib/memmove_64.S
> +++ b/arch/x86/lib/memmove_64.S
> @@ -41,9 +41,7 @@ SYM_FUNC_START(__memmove)
>   #define CHECK_LEN     cmp $0x20, %rdx; jb 1f
>   #define MEMMOVE_BYTES movq %rdx, %rcx; rep movsb; RET
>   .Lmemmove_begin_forward:
> -       ALTERNATIVE_2 __stringify(CHECK_LEN), \
> -                     __stringify(CHECK_LEN; MEMMOVE_BYTES), X86_FEATURE_=
ERMS, \
> -                     __stringify(MEMMOVE_BYTES), X86_FEATURE_FSRM
> +       CHECK_LEN
>
>         /*
>          * movsq instruction have many startup latency

Yup, that also seems to fix it.
Are we looking at a potential memmove issue?

>
> Thanks,
> Gao Xiang
