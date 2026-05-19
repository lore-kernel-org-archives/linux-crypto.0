Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5E03D8116
	for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 07:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779175822; cv=none; b=IuoI3YqVUCZlFKVYRTognVDopE9QlIp41j8jvWy+GsjMvDnFm8iM5sF6GAvCTvv2lLsvYkk+HSLGTo5XgaDI+p/BNu5EyrNFmmIJEquZvGUCU3kp2gG2X/rXTIpNEx/lmUDknHggrpbwFA9GbAvzUFqFRgs/bRTxMY2VfIjLATY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779175822; c=relaxed/simple;
	bh=EP+l3Xsf/02TI72QB7nqXNUQUPtcxewjH2cpp+hAG40=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lrV6NmKbMdhi2+C44IjdbaROV1OzTtRuaCAIaMIfnNXnKXeedZB5KRYJjQKYc9d5lQg41LpIvKaUcuZm3F9+evQcwkI/TTggFE/TkQtOY93XYWL5D+jsBace5OzBN8CByuUJbvSrJIzJl1ZldfrfDlAcLaUkinsEyy/6Pzk+3Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5753a289955so1002719e0c.2
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 00:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779175820; x=1779780620;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+1Ydpi64imhfiW3BOCP/037yrb9bXbwCDPHAO9TSn2c=;
        b=PwtHUfLSlk9BcldrHfnN3iMMdzQKdfOLXTWL1GV1Je4fu0tGxR5kcV8hSte9PpsZgz
         hh395UA00LkOMop2rs3uOTJT3ve+Ov04wg/R45+GLpeRwj5u71G0T1Bu/HGhnU8d6P1U
         Saoxxk4y1aP+u/syUoZRm+Edf84RlY1i5hnjP2THgJT70YGfGJTycnmotmN/REVXzIvk
         3q1VId0EcK56km+HnH41vlpmdX9zoLSvC4hxXmR61VvXWQdMcLyCBFejISHjoNCtu8WV
         x6KrsLfidA72W72OFc7pABKMfZtXP3hNPT7khP49Y/8E2r/1iu6MQMvPN3mAa9+4JFOJ
         f9Tg==
X-Forwarded-Encrypted: i=1; AFNElJ+BqoLLJeuId7k0gPzbNgb8OjoeANdniFSXhKAix56RKZJ1vtf05MIcLFizvH0D5YgdRl60GddA3svJnKk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy40OG1CRLKbbRST8AqTkPbuqjOZBQ3ctEDQ+QwOQfkb4iguk+q
	0xYCI1aV4jsiOG2QkiHlSDGw6gdn6CoAfzWoWANR8XcNpNmxPB3kKkrawUTvGmo0
X-Gm-Gg: Acq92OHUw3k6nboh9T+c6+AAzADJPKKdqoFXMLDm9Mrptl+o0MELcd4I+tdor78Q6XQ
	ZfdRV7JnCVCO1tCu1qc0EUTOA0pI80ey3jN72dSEYsxEVgUnla58CRAOBowluoOcAsWZeKYjWfv
	TEtQ76WwM0OtVH06UrTGfQ68nqbFSle4jVjN+Kojlau/vfOP8I9YwQ7I9Ow+Oy89UsmZATE4CXG
	pRGJFk4UHrAje9SiG/i0JXWVqEiQL0m/xCdvAIeR8sKX+83xCGLvfiYpfRy1eGxmVC+fJmReaJ/
	NTbx2ITsA1VSyl6cGaKCz8VjaIhD6DLpIjboGLTc7xL/fBCpoEBUhFOKoovOpV7Le023cJVF4GD
	IQrRqysmYd+d5lX0ARMMCg1xIWMwKpyIIw61MMBYZdNzdML2tOdh8IJm1OKsQbcrleftHhROzT+
	Jb7A2CQcf6kANXseq3oay6FukgkwjXiioDw+8T5DJURjqZ/eMf5/+yF6eZfIm2
X-Received: by 2002:a05:6122:1c05:b0:573:a6f2:65f with SMTP id 71dfb90a1353d-5760beaa1cbmr9179204e0c.6.1779175819738;
        Tue, 19 May 2026 00:30:19 -0700 (PDT)
Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com. [209.85.217.46])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5760fa5c021sm7459817e0c.11.2026.05.19.00.30.16
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2026 00:30:17 -0700 (PDT)
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-6314adf187fso902818137.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2026 00:30:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ81Cb9ud4xGQp0wQK5Oc006YfX6jeUJ+PcudKWtrnYzCcyJW8Nsf06AMeS8uW9j9cgvhFjaC4iDIDk1rNc=@vger.kernel.org
X-Received: by 2002:a05:6102:598d:b0:5ff:cee8:660c with SMTP id
 ada2fe7eead31-63a3fc94452mr8770872137.31.1779175816720; Tue, 19 May 2026
 00:30:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-2-linlin.zhang@oss.qualcomm.com> <20260514-clever-apricot-goose-acc827@quoll>
In-Reply-To: <20260514-clever-apricot-goose-acc827@quoll>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 May 2026 09:30:05 +0200
X-Gmail-Original-Message-ID: <CAMuHMdUzraGnOxRU=9bsxBBBFtVqudMGisfcAegUzk+_OS2+eQ@mail.gmail.com>
X-Gm-Features: AVHnY4Lg6L73kxFzoZy6C0Wkwm0pix0KrxlB1EVn8QM9gs7VsfrBk977OYQBtOQ
Message-ID: <CAMuHMdUzraGnOxRU=9bsxBBBFtVqudMGisfcAegUzk+_OS2+eQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] dt-bindings: crypto: qcom,ice: Add sa8255p support
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Linlin Zhang <linlin.zhang@oss.qualcomm.com>, Rob Herring <robh@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 14 May 2026 at 14:56, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Mon, May 11, 2026 at 08:37:48PM -0700, Linlin Zhang wrote:
> > On sa8255p, resources such as PHY, clocks, regulators, and resets are
> > managed by remote firmware via the SCMI power protocol. As a result, the
> > ICE driver cannot directly access clocks and must instead use power-domains
> > to request resource configuration.
>
> Then how can it be compatible with qcom,inline-crypto-engine?

It is a pity there are such big differences between the SoC-integration
"hardware" description in DT of systems with and without SCMI.

For R-Car X5H, we proposed a difference approach[1].
Linlin: do you think this would be a viable solution for your platform?

[1] "[PATCH/RFC 00/14] R-Car X5H Ironhide SCMI CPG/MDLC remapping"
    https://lore.kernel.org/all/cover.1776793163.git.geert+renesas@glider.be/

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
