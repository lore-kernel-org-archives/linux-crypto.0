Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67460279787
	for <linux-crypto@vger.kernel.org>; Tue,  6 May 2025 06:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746513214; cv=none; b=sN1VFxnlLTWjgNtx2bj6/YkaRrrKcNGwCILJdkH3b3Aj3XWg1C6c1WN1rcjZ7rrZQJk5U4QTraW0URkE45gH82Y4VKUVYQRX8JBNGRNW6yFRVX0tx2gsCPAtTptitCwWUziLLCfiRKKqj7i4o9w0MEAzjB6rs2JiDV5kYM+xrko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746513214; c=relaxed/simple;
	bh=ZbfaNYhylkE84/orsTBNrABjmfGALTYOqyDcN5wBiJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d+aXJn91M24/vJp0sUrYtgQyYwwBUJvvXvtdCgWsknm+hSu4eSl6IAnMx3yYxoDmMMAH4fdM2Mk/uxhIndcR+lQ+OrbKlyZGh4L1OpuUSeae+HrhBn6j9jAE8AgRZgnCUZPPOevzJ1f18T4KQb5vzhAaks4DN6210zW+DIDRZ0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=QHz+65z/; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="QHz+65z/"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-7099bc957d9so308647b3.0
        for <linux-crypto@vger.kernel.org>; Mon, 05 May 2025 23:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1746513211; x=1747118011; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UXx9UG0NcgMBqkRTz272hPUucW27iAIqCFPb0LfA65Y=;
        b=QHz+65z/Y+D0z5uC90DrHMdALXN48Vg8EGajcbZ1UgLUjTAANZG+NTV5uTvXe7T3JU
         rkNrI+fGQRbNkDYGp2uU7o5C4w+084jS8Zvq53AAXe56t2X1vWDbDzqBwykWLsrR5XKe
         epbCpyBszlTO9z3KXJVbrMfCW2IDsNvVeIYuE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746513211; x=1747118011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UXx9UG0NcgMBqkRTz272hPUucW27iAIqCFPb0LfA65Y=;
        b=YxFjxJv1CHhDy2mqRLz02yF4miCjp+Qa818mbttt7/KXus6I1TCbMBj9iXc0/WORDr
         6XsBiWx+7s215xApj4tQieu4Si4GKESMYSlUjtnUUIrcFJ5lvmAF8Dk9/c0A6MzbqW4w
         yj25qIXnsjngFjXhgdpq9Afm2BPb/3HCfwfCYqSwXqTcmGBGdaveOgAmuDY4J99LmQ1p
         Jn2HdRNHntK2WmCletC8PajxAD6HtzBhmMKbJD3GSVVFyFwTuOHQbl17cs0aCTx65Top
         JktSOvnwc0IwifF+c0XN7EUBLHKemi9DDDgJOhFhpkKBqsYJgtm4FJCH/NStBoOkzNTC
         x2Cg==
X-Gm-Message-State: AOJu0Yy79mkAWcVJ55uqG/0ND2oe5I/XvliaL/1npljQJwRqtVgUuX3c
	+swIkJIsnhPASIuNon7revGwXL4mqqxlhRReUyi5muYz7OR+ff59fE/t5Yvzx2SiRxJowqagHx8
	RB0gCr2KZT3OyP14G6NGfgDBfdwm13F4COz3yeQ==
X-Gm-Gg: ASbGncvShMNFVaZLOkQ5VecVc/pnlSyMyIZ+8ONfa/2yOSourOf6cpjX23sZtS3UwpV
	m0i7AgHYzNSmbXTwNRQ3n9nI9qRsRZZnnu0H7o132/CMFR22RYTn7Q2ooBztJ8tzYiSLUVfpTeq
	kYlDEr37wefJmMouzQ37v/23gS2O7D3ReFW9tIu/QWG+BGZ4YTA1wZfuRT
X-Google-Smtp-Source: AGHT+IEzplNLh/W8XF0UXBTH2d6CbQzPrIugR7245xJcn67FnR5vMLrB0ITgWQx6Y2MzSwZNHhJR5JcRuH3xYCmtzRo=
X-Received: by 2002:a05:690c:9c0e:b0:6f7:50b7:8fe0 with SMTP id
 00721157ae682-708eaeb3560mr142555577b3.1.1746513211289; Mon, 05 May 2025
 23:33:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250505125538.2991314-1-pavitrakumarm@vayavyalabs.com>
 <20250505125538.2991314-2-pavitrakumarm@vayavyalabs.com> <5b6c66e8-3fac-408f-980c-f261ccd3fefd@kernel.org>
 <bcf5c5de-e649-491b-9849-21eeaae0b64a@kernel.org>
In-Reply-To: <bcf5c5de-e649-491b-9849-21eeaae0b64a@kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Tue, 6 May 2025 12:03:20 +0530
X-Gm-Features: ATxdqUEW5XJBvrgIU4fNn6KtzeRiLwWfaYVl-_cyBfqL0wQWAjG5RACq9Gq3lPA
Message-ID: <CALxtO0=jB9L4WvaZNjP5qVB1tc9UfhjC5-u7e1dhveaQF=AOEQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] dt-bindings: crypto: Document support for SPAcc
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	herbert@gondor.apana.org.au, robh@kernel.org, Ruud.Derwig@synopsys.com, 
	manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com, 
	Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Krzysztof,
  My comments are embedded below.

Warm regards,
PK

On Mon, May 5, 2025 at 9:22=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.org=
> wrote:
>
> On 05/05/2025 17:48, Krzysztof Kozlowski wrote:
> > On 05/05/2025 14:55, Pavitrakumar M wrote:
> >> From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> >>
> >> Add DT bindings related to the SPAcc driver for Documentation.
> >> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
> >> Engine is a crypto IP designed by Synopsys.
> >>
> >> Co-developed-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> >> Signed-off-by: Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
> >> Signed-off-by: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
> >> Acked-by: Ruud Derwig <Ruud.Derwig@synopsys.com>
> >
> >
> > I do not see any improvements. It seems you ignored all comments, not
> > single one was responded to or addressed.

PK: Addressed all the below

1. SoC Bindings: We dont have any SoC bindings since its tested on the
Zynq platform (on FPGA). So I have retained just the Synopsys SPAcc
device here. Also added a detailed description for the same, which
describes how we have tested the SPAcc peripheral on Zynq. This was
based on your inputs to describe the existing hardware.

2. snps,vspacc-priority: I have removed this from the device tree and
now it will come as a KCONFIG option. Let the user configure the
vspacc-priority based on his needs. Its a static configuration for a
serup. This is needed as virtual-SPAcc is used in heterogeneous
processor environments. So we bind each processor with a virtual
SPAcc.

3. snps,vpsacc-id -  Descriptions updated as per your inputs. I had
mentioned driver usage, its cleaned up.

4. snps,spacc-wdtimer: SPAcc Watchdog is not a traditional watchdog,
but just an internal counter which we have renamed to
"spacc-internal-counter". Its not a watchdog in the traditional sense,
so I have not used the existing watchdog schema and its property.

5. interrupts =3D <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;  - Updated with
macros as per your inputs.

6. Herbert's comments have been addressed for skcipher, Aead and
Hashes as below for the completion callbacks into the Crypto
subsystem. Since we use workqueue for our bottom half, which is a
process context, we disable/enable the local bh as shown below

HASH:
local_bh_disable();
ahash_request_complete(cb->req, err);
local_bh_enable();

AEAD:
local_bh_disable();
aead_request_complete(cb->req, err);
local_bh_enable();

SKCIPHER:
local_bh_disable();
skcipher_request_complete(cb->req, err);
local_bh_enable();

7. Herbert's comment on "mutex_lock" usage in my bottom half is
addressed as well. I am using a workqueue for my bottom half, which is
a process context. I have mentioned the same in the email response to
Herbert.

8. I have updated the changelog from V1 -> V2 as well, detailing all
the above changes.

> >
> > NAK
> >
> > <form letter>
> > This is a friendly reminder during the review process.
> >
> > It seems my or other reviewer's previous comments were not fully
> > addressed. Maybe the feedback got lost between the quotes, maybe you
> > just forgot to apply it. Please go back to the previous discussion and
> > either implement all requested changes or keep discussing them.
> >
>
> Hm, actually I see now email you responded to some but ignored several
> others, so still a no.

PK: I am and I will be addressing every single comment. Looking out
for your inputs and feedback.

>
> Best regards,
> Krzysztof
