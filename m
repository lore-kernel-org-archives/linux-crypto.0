Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE843FBED9
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 09:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779183119; cv=none; b=HhxYjA7K8/bLDOxCWP4TRByros8vFKp0tZFPe0sVstWNmoaXH1sUlUIWLydIipAwZWdgqg3vlePpndvG2kSXuURKaN08RsS1eKgdI2/mWfDMJSQEyvfYen62+9+IREQnt0EseQ8QhWNvazzROXttZXbSwalySzSoa1Au26VEFhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779183119; c=relaxed/simple;
	bh=Mf2XoqrYRO333qV0Pq7IeJWLfaeqZ4CVJGnnWh+JqPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nWC7Wxt2SFWemrRoTzCZtpvSLZ676JkqeXHgQc2zCEimoTDv3b8TrTvc20d86pqDhqBjAPzgHX0zh0U/8iIuLNpv0BG2a2wUDl3SreWAbZSvg5kITtv+LJ8uOc/TTtwKkLJEkjpubJ9rQdYc2eR2rEwmePKyO/ZQrmRWIIfeD88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-57512a429d1so2899676e0c.3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 02:31:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779183116; x=1779787916;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h7mLu0pQK6X8KnQDNiHLkRRuhxqkx65FdTGE5tLTcw8=;
        b=Bnps9zrc+X8Vh4M0NuqrEzDYhfxstHp5+xEPRB6UNc6DlcGFlW59mMyv7El563cg1u
         rw2fNww9fT31lCAIlQLbCx5OtVOPeSooVpH277k3dTKTaOci/GlnKdr5MAB0HjES8iGm
         l2AZ+pWGgLcEthmqNGLw3BAZ4lJnYCcBm3zm2xNSVNb087etSq1T8lezkSqShDtRD8kz
         xJ0Lx/ln4kv2LwBlrBhl4muo3T58zOGURm6FQ41AUaS18Mr9frc0aUfNI6UQA2fdQA4m
         AB7kh6yZcov4hZ0onzhOsLTVGaPit/8v6fjtQ+6C1uy4LK/QJN1ngV2ni2gsYNMmllLX
         XSJA==
X-Forwarded-Encrypted: i=1; AFNElJ9F69xsXQ+eo5Ginkab23DnFPuVcdFnucL1IxqGussA1ySd5vXKcvPrZZ//ptODWieRkAKfhh4AuFUCfmg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxqDHcNFdXmDyp7azfimY6zZEd6Uzbfiserj8By2C/DTNYVst5P
	BxM1qOLz9+iHzpjG2luyBUYdUIqPrAAFHrgdZNgrDaO30NmsDE9WeZf8JBD4+21g
X-Gm-Gg: Acq92OEiJEicq5cisvyt4BMNHG6cEItSjaC8yZYGCl28qRXBYDat7sZQvbB8iJewOjR
	VvTTK97RJsDSqxbpo2BUiQNjGEyTaVl59VfI06iujmMYqCutvL8ZzUCd//R8xWzriwE8vNV26L7
	wqcfs50AXmtOwKFiBS+zLwXQgS5h2CyBdtfdwyxDgAe/Ejg00ZOtgfJ+rCxVuRkAIh5YkUi4OU4
	wns4x0zNBiWyq48RjyDtaJPEbkuRj05GpEm0TRNW+DfdSjc5YkcIH3MFdLtnGDqPfVMXT96lCB7
	VpgTxn+2emoHLYWW+UOaMAJ5ozcEdZqnjo3lzz8BpyAHQ3mb/tCKIHVpS1eqePOeC0agAsM/HVs
	woS0OC56ohIljfxX928camS5LH9awhJTtT1cks2wArnNiTFuY8gSOwWWUCTSRQEvaOu0h77FdF4
	Cl7cOhNHPTlQd8xVp3NY2r1BV84IgVQMmY+KnxeArDx+ENNv4555i7YO2fCFR04ub4JtSTvMc=
X-Received: by 2002:a05:6122:658c:b0:56b:579c:82e with SMTP id 71dfb90a1353d-5760be9288emr9263980e0c.5.1779183116330;
        Tue, 19 May 2026 02:31:56 -0700 (PDT)
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com. [209.85.217.50])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5760fae4264sm8021906e0c.17.2026.05.19.02.31.53
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 02:31:53 -0700 (PDT)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-6312af106e3so2609654137.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 02:31:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8WqRQVhj1GHYRg1SZJc4xcWXIzag2vowZaESt8C/GbI0457y4xAxqmunDtEqB7oA5E2xCjN0vUxjBVUfg=@vger.kernel.org
X-Received: by 2002:a05:6102:598d:b0:633:d7ec:153e with SMTP id
 ada2fe7eead31-63a3fc96982mr9701042137.28.1779183113287; Tue, 19 May 2026
 02:31:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com> <20260514-clever-apricot-goose-acc827@quoll>
 <CAMuHMdUzraGnOxRU=9bsxBBBFtVqudMGisfcAegUzk+_OS2+eQ@mail.gmail.com> <657a7b16-9036-42f9-b04a-503b5349f68a@kernel.org>
In-Reply-To: <657a7b16-9036-42f9-b04a-503b5349f68a@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 May 2026 11:31:42 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXoDx2MFDvWByvUS+d65Lj6EsiecVLz5apT4oBc_Lf8KQ@mail.gmail.com>
X-Gm-Features: AVHnY4Li7rFLZVAY1sX6NRmb7UDXsqvLWq9nv7KTFBeOAp2gXjwv7toqKRqt7Ng
Message-ID: <CAMuHMdXoDx2MFDvWByvUS+d65Lj6EsiecVLz5apT4oBc_Lf8KQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Krzysztof,

On Tue, 19 May 2026 at 09:37, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On 19/05/2026 09:30, Geert Uytterhoeven wrote:
> > On Thu, 14 May 2026 at 14:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> >> On Mon, May 11, 2026 at 08:37:48PM -0700, Linlin Zhang wrote:
> >>> On sa8255p, resources such as PHY, clocks, regulators, and resets are
> >>> managed by remote firmware via the SCMI power protocol. As a result, the
> >>> ICE driver cannot directly access clocks and must instead use power-domains
> >>> to request resource configuration.
> >>
> >> Then how can it be compatible with qcom,inline-crypto-engine?
> >
> > It is a pity there are such big differences between the SoC-integration
> > "hardware" description in DT of systems with and without SCMI.
> >
> > For R-Car X5H, we proposed a difference approach[1].
> > Linlin: do you think this would be a viable solution for your platform?
>
> In the cover letter I see:
>
> "This means Linux can no longer perform various system operations (e.g.
> clock, power domain, and reset control)"

"... by accessing the hardware directly."

> I skimmed through the rest including bindings, and I do not see how you
> did it differently. Patchset is mixing multiple subsystems and topics,
> so it does not make easier to find what you meant.

The gist is in:
  clk: renesas: Add R-Car X5H CPG SCMI remapping driver
  pmdomain: renesas: Add R-Car X5H MDLC SCMI remapping driver

FTR, this is what we discussed in Tokyo last December.

> Can you point me directly how did you do it differently? And by "it" I
> mean what you comment here - "such big differences between ... "?

1. Describe the actual hardware in DT (+ a firmware property linking
   to SCMI)
   For sa8255p, that would be a clock controller device node.
2. Write Linux drivers that do not access the hardware directly, but map
   operation to whatever mechanism the SCMI firmware does provide.
   For sa8255p, that would be a clock driver that translates clock
   enable/disable to power domain on/off.

Thanks!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
