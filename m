Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0E534DCE0
	for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 13:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763473049; cv=none; b=XClWsALjjvtK+lG3O//wAcMUli8Lr7tQpQUon//DSKofk9tFto+KhItts184uHKoUagSyZTj2bAItkVg7z3NqNetcZGhrggDQkH11HaU+UU+rt6mDC9XDS6kA/RX7jpd8Q6uHjy2izKIKfdbWxzwR1DOolLOyMcoArVdvfDRJDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763473049; c=relaxed/simple;
	bh=aYLtYDuLNVEl76fJnhP2Lx52h1KY2MU3wh/+LjbIA0s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HNAO51xVZbo+Gn3+0Ws8w+DBp4RLOdECDOHWo85VqbyurNAX5gRd0+ixF7dRcDCSFi9ln6bcBoz7xAfzh1m2kS8tDBNiNWZ2siPlZNyMkMle32cTbgocVw6jepC7VQEJ4+Zq1Eer0wI6jpPHa1fEvb+t2o/09eRpRjnQyT+TOAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-5dbe6be1ac5so2244786137.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 05:37:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763473046; x=1764077846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HAgEnjBHe9vjRkHMQeQGLB6OvwD2DqiTQj/HhxtNAY0=;
        b=OUJv9LzzYybzFPeNYrWJh5f3Y2ZSDEuWEJOnEvFRm8dz5xF9xRa0kR0MwXRIqipH6h
         b4ZJ9BjAvwG+oqnP1W5TqfGHLFZyYJca9onxGR01YH2uuQOKWXgAUiwDhxt2mgfzsVpG
         g8uDKeHPqeF1vt4CF/O2zWFAkZWyXoHDsa0zMjD9L5G+0v6jb9/o4yoZSnmgWWK0Zs1z
         Rq3NrLO+sM7aosLh1z8ScRny/7aySBUYmpdIwCQaiZ/iMMPvhE8fPN6udLF66j44SJBO
         GIGvumwR2PET8zjW5YHTATDaA8BsQyxl9yS0wg+TTNl1cgm6SleQ87Bu63HHESsZoi8t
         PnQA==
X-Forwarded-Encrypted: i=1; AJvYcCXn/NoPWVVVwRJzGPOtA7dVq92OFFZinaGWmXyUNw5Fh6IF9T3ACfhW06u6x2HPNbBOP2NI3mnBgSPOzKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YzHWUN/VjI9lhw2y6EtG9rDA4tv9Lc/VDggIlU4epkbvxBUYQX0
	wn3zX2J7s/gUSG3YxKnPTjxgBeIIzZOvjUtlAfzh+oaDZf5NNgpbkFg+Ej8EOHGz
X-Gm-Gg: ASbGncvNFPWxTXkrKEXurebcWeT6Bdo7xN2q89obdzx4sajQNOAxRUGoJIzD+Wh/EG/
	OHyMsPogvHrgF2J3IbYXxw5hkH6ieCLa49/D62DPuIj9FxgIlw5SRuKNLskRV0uCodFtP0PFu4p
	/O+ohEtn8bgy6WgzznY3VIHOqX71rC1XATFU/az/ekAGBnpZaU12gpzxjrsi7uTVM68K6I49ZSw
	UQ9ULTV4RTnkte3yLtbxzZM/qb9G8/k48FIO5uPMIz2qXYkM3XAMpgM/U6koC04+8R91Eap9Rbu
	0eHu9Oqtqx62E6qsD8tyH5H7qb8y5WJMEgyoTCeXRX1wRYw/4oEoHPFGEdoHcxLtze9raSa7Aa+
	th/w06KD+xeob/puaTA9HcwC1B50PiqYP6I4OSYzRrXOSBgo8WrpfBZSlVtWyoaNhkJYXLPId3a
	5ghu1lx4zdZnIHPvyvkyIV2XlScl88aqUOfJvcSKVnrz1cbPPIG8pHUwWLW5E=
X-Google-Smtp-Source: AGHT+IHqo0HHvTl76U1SB9qLB+cI9VTfV4gqVx2Nj4TQISNBtq0DLJ74O1uiTSKoNThHZhTsM1diVA==
X-Received: by 2002:a05:6102:a54:b0:5df:c228:28a4 with SMTP id ada2fe7eead31-5dfc5651965mr5505171137.20.1763473045433;
        Tue, 18 Nov 2025 05:37:25 -0800 (PST)
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com. [209.85.217.51])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-937610d48b9sm4955277241.2.2025.11.18.05.37.24
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Nov 2025 05:37:24 -0800 (PST)
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-5dfcfbcbcc0so1352093137.2
        for <linux-crypto@vger.kernel.org>; Tue, 18 Nov 2025 05:37:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVhNtWA+wqDOie/yZe9SGGRVSYPt7GVq5ccumzlUtpk3n46X6u0jdb8rxhDbeSGh0YO4gOZjdrZ5OqN0yk=@vger.kernel.org
X-Received: by 2002:a05:6102:5810:b0:5db:ca9e:b57e with SMTP id
 ada2fe7eead31-5dfc5b94a4amr4590345137.43.1763473044116; Tue, 18 Nov 2025
 05:37:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251117062737.3946074-1-quic_utiwari@quicinc.com>
 <121a5d34-e94f-4c29-9d58-4b730757760a@oss.qualcomm.com> <283e7a7d-c69b-4931-8e54-d473f0209abe@quicinc.com>
 <306f6354-1502-4b9f-9a28-dcb7a882b367@oss.qualcomm.com>
In-Reply-To: <306f6354-1502-4b9f-9a28-dcb7a882b367@oss.qualcomm.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 18 Nov 2025 14:37:12 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXk91aKo6n97y8eGhfB3Ngu66mzqWhgwe3u86sPx2iaSg@mail.gmail.com>
X-Gm-Features: AWmQ_blb27zH5h3ZZ3oFEsGZzTMAKs0a-KLhrPwJAU9pj_AZJkAdwgdJpubgSzw
Message-ID: <CAMuHMdXk91aKo6n97y8eGhfB3Ngu66mzqWhgwe3u86sPx2iaSg@mail.gmail.com>
Subject: Re: [PATCH v4] crypto: qce - Add runtime PM and interconnect
 bandwidth scaling support
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Udit Tiwari <quic_utiwari@quicinc.com>, herbert@gondor.apana.org.au, 
	thara.gopinath@gmail.com, davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	quic_neersoni@quicinc.com, kernel test robot <lkp@intel.com>, 
	"Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Nov 2025 at 14:08, Konrad Dybcio
<konrad.dybcio@oss.qualcomm.com> wrote:
> On 11/18/25 7:46 AM, Udit Tiwari wrote:
> > Thanks for the review, please find my response inline.
> >
> > On 11/17/2025 5:55 PM, Konrad Dybcio wrote:
> >> On 11/17/25 7:27 AM, quic_utiwari@quicinc.com wrote:
> >>> From: Udit Tiwari <quic_utiwari@quicinc.com>
> >>>
> >>> The Qualcomm Crypto Engine (QCE) driver currently lacks support for
> >>> runtime power management (PM) and interconnect bandwidth control.
> >>> As a result, the hardware remains fully powered and clocks stay
> >>> enabled even when the device is idle. Additionally, static
> >>> interconnect bandwidth votes are held indefinitely, preventing the
> >>> system from reclaiming unused bandwidth.
>
> [...]
>
> >>> Signed-off-by: Udit Tiwari <quic_utiwari@quicinc.com>
> >>> Reported-by: kernel test robot <lkp@intel.com>
> >>> Closes: https://lore.kernel.org/oe-kbuild-all/202511160711.Q6ytYvlG-l=
kp@intel.com/
> >>> ---
> >>> Changes in v4:
> >>> - Annotate runtime PM callbacks with __maybe_unused to silence W=3D1 =
warnings.
> >>> - Add Reported-by and Closes tags for kernel test robot warning.
> >>
> >> The tags are now saying
> >>
> >> "The kernel test robot reported that the QCE driver does not have PM
> >> operations and this patch fixes that."
> >>
> >> Which doesn't have a reflection in reality.
> >>
> >> [...]
> >>
> > I may be misunderstanding this comment but the bot flagged W=3D1 unused=
-function warnings under !CONFIG_PM. In v4 I added __maybe_unused and Repor=
ted-by/Closes for that exact warning; I didn=E2=80=99t mean to imply the dr=
iver lacks PM ops.
>
> The case where the tags would apply would be:
>
> A patch is submitted
> The patch gets reviewed and applied to the tree
> Kernel testing robot reports an issue
> You send a fix-up patch (incl. robot's tags)

Exactly. The robot's report even says so:

    If you fix the issue in a separate patch/commit (i.e. not just a
new version of
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^=
^^^^^^^^
    the same patch/commit), kindly add following tags
    ^^^^^^^^^^^^^^^^^^^^^^
    | Reported-by: kernel test robot <lkp@intel.com>
    | Closes: https://lore.kernel.org/oe-kbuild-all/202511160711.Q6ytYvlG-l=
kp@intel.com/

>
> [...]
>
> >>> +    ret =3D pm_clk_add(dev, "bus");
> >>> +    if (ret)
> >>> +        return ret;
> >>
> >> Not all SoC have a pair of clocks. This is going to break those who do=
n't
> >>
> >> Konrad
> > On the concern that not all SoCs have "core/iface/bus" clocks and that =
this could break those platforms: i believe the PM clock helpers are tolera=
nt of missing clock entries. If a clock is not described in DT, pm_clk_add =
will not cause the probe to fail, also on such platforms, runtime/system PM=
 will simply not toggle that clock.
> >
> > I=E2=80=99ve tested this on sc7280 where the QCE node has no clock entr=
ies, and the driver probes and operates correctly; runtime PM and interconn=
ect behavior are as expected.
> >
> > If you=E2=80=99d like this handled in a specific way, please let me kno=
w=E2=80=94I=E2=80=99m happy to implement that approach.
>
> No, you're right. I took a look at the pm_clk_add() call chain and notice=
d
> that clk_get() (notably not _optional) is in there, but apparently its
> retval is never propagated if things fail
>
> (+RJW/Geert is that intended behavior?)

I think most checking is done before calling pm_clk_add() or
pm_clk_add_clk(). of_pm_clk_add_clks() also calls of_clk_get() first.
So that looks intentional to me.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
