Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047CB43AB0
	for <linux-crypto@vger.kernel.org>; Fri, 14 Aug 2026 05:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786684714; cv=pass; b=Kwesu97mnxAevDMNNk9EbBZhMtWHD6wrt6ygZWUJIiePvfSuaROiA6X+mV5AjqJPMEVjqU5WbvggISE45su+0ZfuH+TD4Do5WI1LmwntWjPPTV/w2Yie/z3vcE87SWrV6jRLAmJ9SYAH+CjAg/Ohi0aNfjhJ0TLzz2r42tXDTnk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786684714; c=relaxed/simple;
	bh=on93K6lma23rN/3lK+z8nIO+e/iuUrJxETMFOVFdIF8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A6wugxwfoEk43X5jhcbp8we/uat3r8yIRohHSyjXGYG6aFWKzEKABvYkNlCgGo2YB13ptaIU9+xLBCmvM2EhYcg/CwVJUYEO5NFDocuev/NI2WXCzTJmbiQe8VU6Xi0y+uRRosXafil8TADO9o8boEH7ulMySbBfNeOLtf6IZW8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=Ns49wixr; arc=pass smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="Ns49wixr"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92f03daaa97so37926585a.2
        for <linux-crypto@vger.kernel.org>; Thu, 13 Aug 2026 22:18:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786684712; cv=none;
        d=google.com; s=arc-20260327;
        b=Anuf1XEek9Y8MFCckGhi4knwm78SC14J1ZMDS2We/e1gGrcssbe0gDCvVewTuIL2qz
         hppdBPZbSb7OD9T/Zdb+GgriQny08Vs0MDZ13LumLo71hcO9A6unhE+D4mYiqpgHToK3
         rUULCxwdGRYIktX61fcZNToGtydXwZSZUl3OkyCBTcXzkIzLe0ky3m4mk7vFhHErs+pa
         riPfap624HO82A1aOkwn5M4fqajEEw4aBq3Wu7DLXZ5Lr0XvHy6p/lkHKFONztoCxK6r
         HA8CvMxFpHlVLMb3t3Y11CEgJYwjlC9geBT1Y/YSL5j1vIcrS3fOmFdGwKv4eZrcJloc
         aEvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J1faoTi2s3N5+IeFjQDzLXc3uQSNXm3T5bOqFSwJTB0=;
        fh=Vi82qe5hJ2sFgJYfrFwdROCbkoZPC4wj4/e2179blJY=;
        b=oB/gCmF0x+Iweh/QuctAdxfnONgenPaxU7ppUdPnmwuiRxGl6AG5oc0JPaDHFxGqN+
         b3bOr3f+6DLJd+YdNfq+oyoXbqI0NqZ4fbYhZ551lvm4dPGqp951OkId5YYTQEC1zSpf
         VodQi7gnY8nMKdqfb/m4yql6EMDaC3w2Sv8r87A/jvGUHkNQSzIK4eUdjCL9QtUZQxgi
         xjEJG2s3+ULyjCiZ1SmH1fIBr1qVymO7cfX0cXcEVxlwc6kabYYy/uHxDG0tT9vFMDxA
         xsqUPxOSfffy5+P2y6YpUE5bCZvLv8rf8rydRxJn6HhDln0Yn/PJi95PvzIajGMcJ3PK
         +Xdg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1786684712; x=1787289512; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=J1faoTi2s3N5+IeFjQDzLXc3uQSNXm3T5bOqFSwJTB0=;
        b=Ns49wixrtljVbke0JhmYOTm57X+nNbIRZ4u3jQJozTWoKkScY+m7WU0j0T+PLS5w7w
         fvFEU1JSqIFVY2KiwyXZExUJNtSbj8IxKB5jIG5XQKz4whoAmmFbTM7GYmrzFVwwNyw/
         mG+XwgmHgoEL8KQb4UwAvBSFVsxWOcFYW1F8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786684712; x=1787289512;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J1faoTi2s3N5+IeFjQDzLXc3uQSNXm3T5bOqFSwJTB0=;
        b=LccczEFPA967syvGhLW3+PhfvMuoqlK342uadjgQ8H6049mK50Cz39HWNNZRGdEtEC
         Iy6RjbdTHBCSBXvhctLFrH/Lxh2PJirLhGbzSqzp4ulFGejICUKLKdelPgSg2jZSI7gC
         RCqmVtQ7hYNkAxRCB+GTU7UWdNvTrzhL0ffJjon18PeB3XKmnz8PMrS+5luaqOVGDtEq
         NUCd2b6+JXK1FT1HgQ21/677NR1gbEKH2261cVvt5Is78iT6F2HIx45TZJCVNchh6mkn
         2uo9XWgTfCZPTEURk8bnFf6KrRbATIHKMrW6jKyonnf5/LeNC41M0RQnVjNiAvSIrPvr
         3d5A==
X-Forwarded-Encrypted: i=1; AHgh+RrP4V/MC+dYUdGelV1/bff+kK3Y9GQwFJ6URoU1J5o6Jwyv0+r6ZSo6hSRaN1RF5wZfScpCWLVy5SEk5LU=@vger.kernel.org
X-Gm-Message-State: AOJu0YwnzA0NjZOyevLy4oS2J8bb1sZ7Pv3BF6qVVU5Kybd02Yluo87k
	NBRKMOVamqKtrpvCFvMU01gUwwh44dviEmq3RuZP19nu8H9PL2wVPqqnSq5M4LG/NOYN1XC2sfF
	tVZyRZ+7mOI5BmzNidqJ4KZ2ksbNh6y1OpI2yJAozNZC8s251PN0xdg8=
X-Gm-Gg: AR+sD12cwMOSjPVHsXT3TrlQaexcbkOZ12gt9RDZ1WYcQGQpmxRyxN1OHi51UkTEuVd
	uwCMjfWfRfDWRp9iu+KBrz4dUlO5mLOQvzkL7gRfJIWo7OLua4RwSuZEu2ohdVvT2hzVdZFoBH4
	tr7tcUhI1PJ/OkzQrajZ0sus0A+h0Dv+AV0Himld+UYH0TZKUq/rj0YQy8+Bi4wCh54kZhjhczT
	DajXj1QS3KyBAtM0e7PVRXeVEQTJGGYjTs2NMx1biCDpNLENjhrPnCi+5Fw/nl2P31GVog0P/MJ
	kGe0HSDstMOFFGv9NgBsTG0S2yCm8SWSZXysNMkFiMq+U6s6voLozAicI/75MXNx3AsIaCQk+5J
	9jAaPUPVLGpbU7kpslnQetB07FhpCRdBs6nusJx0mF6H9wD1ioL8fMEeJwDtzrHQ4uGWT+3iWZp
	PBfDQ7gXh/Cr3Y9VgWAwyg
X-Received: by 2002:a05:6214:130b:b0:8fe:40a0:7cbb with SMTP id
 6a1803df08f44-90a91d481cfmr33029076d6.15.1786684711839; Thu, 13 Aug 2026
 22:18:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260812175020.666558-1-pavitrakumarm@vayavyalabs.com>
 <20260812175020.666558-4-pavitrakumarm@vayavyalabs.com> <20260812180500.A68871F000E9@smtp.kernel.org>
In-Reply-To: <20260812180500.A68871F000E9@smtp.kernel.org>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Fri, 14 Aug 2026 10:48:20 +0530
X-Gm-Features: AUfX_mwymJ1UYin3kIQb6gK4umeWSdWimoVjM-7z_cta-d6UZMOCr_o0Lz0sYUU
Message-ID: <CALxtO0kvQp333oRZ5axaSG1-8y7E9T_q5zQX6RcsFwQb=_rdBw@mail.gmail.com>
Subject: Fwd: [PATCH v22 3/4] crypto: spacc - add spacc autodetect support
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org, 
	LKML <linux-kernel@vger.kernel.org>
Cc: ruud.derwig@gf.com, rbannerm@synopsys.com, 
	Manjunath Hadli <manjunath.hadli@vayavyalabs.com>, 
	Navami R Telsang <navami.telsang@vayavyalabs.com>, Nazim Khan <nazim.khan@vayavyalabs.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
  I need your input on the issue below in the SPAcc driver related to
the DDT (scatter-gather) DMA.
  I detailed the issue in the inline comment below.

Warm regards,
PK


---------- Forwarded message ---------
From: <sashiko-bot@kernel.org>
Date: Wed, Aug 12, 2026 at 11:35=E2=80=AFPM
Subject: Re: [PATCH v22 3/4] crypto: spacc - add spacc autodetect support
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: <devicetree@vger.kernel.org>, <conor+dt@kernel.org>, <robh@kernel.org>


Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:
- [High] Unkillable wait without a timeout in hardware autodetection
can permanently hang the kernel.
--

--- Patch [3]: [PATCH v22 3/4] crypto: spacc - add spacc autodetect support=
 ---
commit 1b02ffd964af3b1927d2fca1ccd5966f8d928e2e
Author: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
crypto: spacc - add spacc autodetect support

This commit adds autodetection support to the SPAcc driver to determine
supported cryptographic algorithms. It runs test vectors through the hardwa=
re
during initialization and disables algorithms that fail to produce the
expected output.

> diff --git a/drivers/crypto/dwc-spacc/spacc_core.c b/drivers/crypto/dwc-s=
pacc/spacc_core.c
> index b72d5072ccc58..3287e9e61b1c0 100644
> --- a/drivers/crypto/dwc-spacc/spacc_core.c
> +++ b/drivers/crypto/dwc-spacc/spacc_core.c
[ ... ]
> @@ -579,6 +1480,275 @@ int spacc_close(struct spacc_device *dev, int hand=
le)
[ ... ]
> +#if IS_ENABLED(CONFIG_CRYPTO_DEV_SPACC_AUTODETECT)
[ ... ]
> +static int spacc_check_modes(struct spacc_device *spacc, int algo_mode,
> +                           int keysz_idx, void *virt, char *key,
> +                           struct pdu_ddt *ddt)
> +{
[ ... ]
> +     err =3D spacc_packet_enqueue_ddt(spacc, rc, ddt, ddt, proclen, 0,
> +                                    aadlen, 0, 0, 0);
> +     job =3D &spacc->job[rc];
> +
> +     if (err =3D=3D 0) {
> +             /*
> +              * No timeout, not interruptible: this only returns once
> +              * job_done is actually true, i.e. the hardware has
> +              * genuinely relinquished the job. That guarantees it is
> +              * always safe to close the job/context and (via the
> +              * caller) free the DMA buffer immediately below --
> +              * there is no "unconfirmed" case left to handle.
> +              *
> +              * Tradeoff: if the hardware ever genuinely fails to
> +              * complete a submitted job, this hangs here
> +              * unkillably (TASK_UNINTERRUPTIBLE, no timeout) for the
> +              * rest of probe. Accepted deliberately in place of the
> +              * abandoned-job/UAF risk of giving up early with no
> +              * hardware cancel available.
> +              */
> +             wait_event(job->waitq, job->job_done);

[Severity: High]
Can this wait_event() cause a permanent kernel thread hang?

If the hardware fails to respond or trigger the completion interrupt, this
uninterruptible wait will never complete. If the driver is built-in and
probes synchronously, couldn't this stall the entire system boot process,
or otherwise result in hung task panics?

While the comment notes this as a deliberate tradeoff to avoid DMA
use-after-free risks upon abandoning the job, is it possible to implement a
safe hardware cancellation or reset path and use wait_event_timeout()
instead of relying on an unkillable wait?

PK: SPAcc DDT(scatter-gather) DMA has a design limitation: we can't
kill or reset an in-flight DDT DMA operation programmatically.

Once a DDT DMA operation begins, it runs-to-completion with either
  - successful DMA transfer or
  - errors out with proper error codes

Sashiko bot review has problem with both ("wait_event" &
"wait_event_timeout" usage) in code.
1. With "wait_event" the bot raises hang issue.
2. With "wait_event_timeout" it raises the 'no option to stop
in-flight DMA operation' issue.

I have tried both options, and the driver works perfectly fine, but
Sashiko bot flags issues with both variations. I need your input to
resolve this, as I'm stuck with this Sashiko bot issue. I prefer
"wait_event" since I want the DMA operation to run-to-completion.
Please suggest.


> +
> +             job->job_done =3D 0;
> +             err =3D job->job_err;
> +     }
[ ... ]

--
Sashiko AI review =C2=B7
https://sashiko.dev/#/patchset/20260812175020.666558-1-pavitrakumarm@vayavy=
alabs.com?part=3D3
