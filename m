Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y2Qs3m+j"
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 454EF1A5
	for <linux-crypto@vger.kernel.org>; Tue,  5 Dec 2023 06:43:22 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-a1b6b65923eso321342466b.3
        for <linux-crypto@vger.kernel.org>; Tue, 05 Dec 2023 06:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701787401; x=1702392201; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pjdtv/qvcvmV2FJZ6UPMjLsxM4qKAp4v+YD1JDpGKIs=;
        b=Y2Qs3m+jCk/6Xiqq1HmdzpsfbONVCvtgN70xwXKmjkw+7HKBpIfaxMwyI/XToN3aP6
         IAkqjtBQtvG+ouJnWMbaYRhR/qK/9ARHqRk4D30ZeRwp16MZrGW9F+jRbmckCBCrF3t0
         5mJaJjVWbhCVk2AbmwK4nn9I6pR6AWGFmoDclZxQyr2/EOiUXPkIlHhsy4RzJAcWdHwJ
         y22gcmwNAHG8waoGzOpnqIPnW1+c2XC+0xJSa5/NAlD33QQAh7cY83bxxyM39p+fWOsI
         F4rSp+s7U52BSnuHh/ZQu+DZj1hJT7nL9XUByv1mp1dfYGSl5jNmMbE+aS1RSZSwVBlj
         auSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701787401; x=1702392201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pjdtv/qvcvmV2FJZ6UPMjLsxM4qKAp4v+YD1JDpGKIs=;
        b=ZWmfQ27d9bTaDQJekwxsa3uuUsZcb+CARnvFz5bg/gqiF1eBGH/P+FX+s1PawSAovj
         e57TgHkM2v+3DXaAGZP4BZOxtfzKUnONraJAMgxhV2xTsz+7W+OLmWA3SbY1v2HYTWuE
         jnFeg9Og6iPTnjdmUMMnqutaGAZ+7koGtJ9cUNFSSSrD5p21yWlY4rTgM1YQpA62ZOST
         GgfHsp+DvSD+04LqaCWfO/3d7fpeV81VheNELXz13Hxtdb02iJbnzk4Xt8jsSQMVYxVG
         15NdWW3RQBTrk4orTWV4pa7UOhT9IWBpoX1WpIRqcD72uHgfdM0ZBdZGVxfcUqo5rFhh
         zcBQ==
X-Gm-Message-State: AOJu0YxVl8+Wm4BVcagPdZRk69HmgE5bKMibptmetIlKUF5N0JoSJMUX
	nFCY8GKMpidVzqZJ51pKTn6gyxuQoodjcwaA+N8=
X-Google-Smtp-Source: AGHT+IFZsX9IXLFnPNc9Rx54fslZziVSWrbY5/kOYJ57W0poZKWrP5UGdXe4yOR7qOdaDR+TPxV3/fo9PXmFNtXmlVM=
X-Received: by 2002:a17:906:3f4f:b0:a19:a19b:4264 with SMTP id
 f15-20020a1709063f4f00b00a19a19b4264mr306280ejj.207.1701787400500; Tue, 05
 Dec 2023 06:43:20 -0800 (PST)
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
 <d7c7ea8c-6e2f-e8d8-88c3-4952c506ed13@linux.alibaba.com> <CAD14+f2hPLv6RPZdYyi8q8SQGiBox2fYUaWwuBEjEbZKQdyU7g@mail.gmail.com>
 <8597c64c-d26a-8073-9d00-b629bbb0ee33@linux.alibaba.com>
In-Reply-To: <8597c64c-d26a-8073-9d00-b629bbb0ee33@linux.alibaba.com>
From: Juhyung Park <qkrwngud825@gmail.com>
Date: Tue, 5 Dec 2023 23:43:09 +0900
Message-ID: <CAD14+f0PJiKVToxH6oULL6KuKqbKN+j6rcdwh7dpH8dHNZz42A@mail.gmail.com>
Subject: Re: Weird EROFS data corruption
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: Gao Xiang <xiang@kernel.org>, linux-erofs@lists.ozlabs.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-crypto@vger.kernel.org, 
	Yann Collet <yann.collet.73@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 5, 2023 at 11:34=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2023/12/5 22:23, Juhyung Park wrote:
> > Hi Gao,
> >
> > On Tue, Dec 5, 2023 at 4:32=E2=80=AFPM Gao Xiang <hsiangkao@linux.aliba=
ba.com> wrote:
> >>
> >> Hi Juhyung,
> >>
> >> On 2023/12/4 11:41, Juhyung Park wrote:
> >>
> >> ...
> >>>
> >>>>
> >>>> - Could you share the full message about the output of `lscpu`?
> >>>
> >>> Sure:
> >>>
> >>> Architecture:            x86_64
> >>>     CPU op-mode(s):        32-bit, 64-bit
> >>>     Address sizes:         39 bits physical, 48 bits virtual
> >>>     Byte Order:            Little Endian
> >>> CPU(s):                  8
> >>>     On-line CPU(s) list:   0-7
> >>> Vendor ID:               GenuineIntel
> >>>     BIOS Vendor ID:        Intel(R) Corporation
> >>>     Model name:            11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.0=
0GHz
> >>>       BIOS Model name:     11th Gen Intel(R) Core(TM) i7-1185G7 @ 3.0=
0GHz None CPU
> >>>                             @ 3.0GHz
> >>>       BIOS CPU family:     198
> >>>       CPU family:          6
> >>>       Model:               140
> >>>       Thread(s) per core:  2
> >>>       Core(s) per socket:  4
> >>>       Socket(s):           1
> >>>       Stepping:            1
> >>>       CPU(s) scaling MHz:  60%
> >>>       CPU max MHz:         4800.0000
> >>>       CPU min MHz:         400.0000
> >>>       BogoMIPS:            5990.40
> >>>       Flags:               fpu vme de pse tsc msr pae mce cx8 apic se=
p mtrr pge mc
> >>>                            a cmov pat pse36 clflush dts acpi mmx fxsr=
 sse sse2 ss
> >>>                            ht tm pbe syscall nx pdpe1gb rdtscp lm con=
stant_tsc art
> >>>                             arch_perfmon pebs bts rep_good nopl xtopo=
logy nonstop_
> >>>                            tsc cpuid aperfmperf tsc_known_freq pni pc=
lmulqdq dtes6
> >>>                            4 monitor ds_cpl vmx smx est tm2 ssse3 sdb=
g fma cx16 xt
> >>>                            pr pdcm pcid sse4_1 sse4_2 x2apic movbe po=
pcnt tsc_dead
> >>>                            line_timer aes xsave avx f16c rdrand lahf_=
lm abm 3dnowp
> >>>                            refetch cpuid_fault epb cat_l2 cdp_l2 ssbd=
 ibrs ibpb st
> >>>                            ibp ibrs_enhanced tpr_shadow flexpriority =
ept vpid ept_
> >>>                            ad fsgsbase tsc_adjust bmi1 avx2 smep bmi2=
 erms invpcid
> >>>                             rdt_a avx512f avx512dq rdseed adx smap av=
x512ifma clfl
> >>>                            ushopt clwb intel_pt avx512cd sha_ni avx51=
2bw avx512vl
> >>>                            xsaveopt xsavec xgetbv1 xsaves split_lock_=
detect dtherm
> >>>                             ida arat pln pts hwp hwp_notify hwp_act_w=
indow hwp_epp
> >>>                             hwp_pkg_req vnmi avx512vbmi umip pku ospk=
e avx512_vbmi
> >>>                            2 gfni vaes vpclmulqdq avx512_vnni avx512_=
bitalg tme av
> >>>                            x512_vpopcntdq rdpid movdiri movdir64b fsr=
m avx512_vp2i
> >>
> >> Sigh, I've been thinking.  Here FSRM is the most significant differenc=
e between
> >> our environments, could you only try the following diff to see if ther=
e's any
> >> difference anymore? (without the previous disable patch.)
> >>
> >> diff --git a/arch/x86/lib/memmove_64.S b/arch/x86/lib/memmove_64.S
> >> index 1b60ae81ecd8..1b52a913233c 100644
> >> --- a/arch/x86/lib/memmove_64.S
> >> +++ b/arch/x86/lib/memmove_64.S
> >> @@ -41,9 +41,7 @@ SYM_FUNC_START(__memmove)
> >>    #define CHECK_LEN     cmp $0x20, %rdx; jb 1f
> >>    #define MEMMOVE_BYTES movq %rdx, %rcx; rep movsb; RET
> >>    .Lmemmove_begin_forward:
> >> -       ALTERNATIVE_2 __stringify(CHECK_LEN), \
> >> -                     __stringify(CHECK_LEN; MEMMOVE_BYTES), X86_FEATU=
RE_ERMS, \
> >> -                     __stringify(MEMMOVE_BYTES), X86_FEATURE_FSRM
> >> +       CHECK_LEN
> >>
> >>          /*
> >>           * movsq instruction have many startup latency
> >
> > Yup, that also seems to fix it.
> > Are we looking at a potential memmove issue?
>
> I'm still analyzing this behavior as well as the root cause and
> I will also try to get a recent cloud server with FSRM myself
> to find more clues.

Down the rabbit hole we go...

Let me know if you have trouble getting an instance with FSRM. I'll
see what I can do.

>
> Thanks,
> Gao Xiang
