Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A27CA5A
	for <linux-crypto@vger.kernel.org>; Sat, 18 Jul 2026 01:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337142; cv=pass; b=QB8S9raapUJ30XlqZiHfQsHEhVjwRudLvHqYK/wqxLhnioLzO6q8l/Sm+hxdgBHQuHuQA/dCdIoqi4HwEQ5+5P2X0vvzQk5jAHV8964oasSqAOYQR/FaItsUzinHHEUNxCewzJq9hrqrIRMOTAcPsUNeDgvg5CEMdfTcAEKI0uk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337142; c=relaxed/simple;
	bh=5y8SLgIbDqWDIOjckjEdgiJz4O1rBiqrCJhqTHjKcqY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g9xGe9qomLNdQQvfjnK48GKUA374hFeYvY02PsBjWDHbGW24JOp7bmZMgyb4Hk9R2b0lZUaBg3aGzvpv/YI1ZOqsT5X+agvM7Yevc5QJTzZryiGxeTXyIfmo+2TNSTW21Hr3eRUehx7w59gqZ1AN6EsDR6CEU/v8w3PGqHwSsIU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E8jUQxyl; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E8jUQxyl"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6983f20a8bfso13577524a12.1
        for <linux-crypto@vger.kernel.org>; Fri, 17 Jul 2026 18:12:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784337139; cv=none;
        d=google.com; s=arc-20260327;
        b=VECKzen9JYyeSwnxBI73TU+DPps6a1bxsbRjBBxtmJxEDgFcNO8R6+rYx2Kkdwe1Z1
         EeHCeGBtaSRTM2mWsZNkIfuVlyHEKqBfbQkemrvAIoa5nYpBaCtanUOB6HcnA6LUAXiB
         vTDomLczS+p22enJcyG9C2lOvs/6KBUBM31dWI0nL2BrRw+OckAoCTBDogLNO3IIK94W
         QfyFfmRIfen5OsK7zU0KeONiRKFfFn1IVxWp0F5wHuHuFBoFKl2F1oCshi4GvyHIn4id
         KPFuLSwMgYvb7Wcbb3U63HUysMo8VBCHi8/15iW2drU+WfWbnzF2ms83e0W6lDda3AD/
         OWBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PFhhUqUWr8eMFvSXCH7fVqM54Adl85IGqyaLRtDp2oU=;
        fh=qIRwsod9AeCAo9qO13t8E4dpDw5L9t2Poy11r08ehY8=;
        b=MmVL+63p2+kp7ZQjrQ1WZ96LGZHPyiMOtTOWCeUNDUFLTWIJnZmMYnPNN6uwh88a2s
         ERUQBEBjAWonMijNx9HBbFQkP9Y8Hq8/RmXu6avBHv7x4TEn90+e05uS3D5dr2J9M9h3
         C9mZnHlXueUO1Jzgay21rGM0IzMD8NsCkLhS+UYzbzMKSkSrK5vMaLR8OIZlcTpK//l1
         s9hLUI68wkWiNdHcW9DE1Rx3Q2obMn4u8s5VO2GfTItkOASe32BIlxEjhL9lH/IJ8x1A
         aCOmsbCSOla5tR59OuXvB4R5TaP07n4mTg0AAHmCnRfAzrKgcQIgsCml+whbhMRIbev4
         H1Aw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784337139; x=1784941939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PFhhUqUWr8eMFvSXCH7fVqM54Adl85IGqyaLRtDp2oU=;
        b=E8jUQxylvi4AlvyhnPAMOVVj8Y3uLXh0mcNPuE4YzwCjT03wc4GVkWp2MBWT7CU936
         MG3rJE1cnTItJymVYUJEoRN1tGwGY4tYnYBWzbu+NSDO2eUIg5LFn0naQabzsOETf4Lr
         XFErfxGSYyz8SkwAM7LloWgsSlbyN9D8eV7XybPM7WhK7uKrbGHV6hTyUWmYP2/LXuKn
         NIyM97hAIfKiYvW+dhFNX1U3IgLjElDaQ0q5wqK7ppaJ2lmc0ojjwnEq28MQtV1LD1F6
         O4EFKfl5X/gniN+M78yRtPd6FfHEAkpoSUvTBk5DIceABJT+/j9r/EbD/r6MQrV1w3VM
         NhuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784337139; x=1784941939;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PFhhUqUWr8eMFvSXCH7fVqM54Adl85IGqyaLRtDp2oU=;
        b=M+qgU1sr681iaPPb0o4ooNTN9h9Hz4uCgiP/Ya0edJA4sutXsdZ4d4pXA5k1c674jr
         d9cNR3/nq7QT15UkKQqBGCBFAr5baEoH1zhh6ohiXpA2J+JwWwevZRAWIqeL46q5hAqB
         zxVuca1/kehZeZp4rWebJ8eQoMW3wnOs2Lxr3oFLsfgW6ho8aNwWiXCgzm/SqKq+pmi/
         3zh9B7m6pLy+lEb11x7OZLNA8DZaBSM9YyzY4rGycNG+jOP+3TCvqaLFyTISBMy23H0o
         UF/leYICuWHxC8KImi5cWo6/wyjAJFVkbOZAuev+Xe/ojER/6kOgeYJu36iJaIQLjE2T
         eZ3Q==
X-Gm-Message-State: AOJu0YyjZK7BQGFZ9RiMzf1DdfEdFTPvu35oo5I+LHYufCt8Y0VT3Xvr
	6ZQa8VVglr3UGXRZt5eXcLirKRMsDS5HPYujVF6ICo3d5GluT4xrAcYdgx9gf0w40GSBQIzLOmy
	2MNXCKbLE3B69uKRAOcIDAvMb2V1zQvc=
X-Gm-Gg: AfdE7cnEyg7BO4GK0oA6CuXXAYOZ0nEYwVof9DYG3rND2RkegVoyUwleLb5rLZZ62mC
	FqOpVgoo7WtrMMIiTTHORHUkqBC3AI7+t60pexhj3v2uz7qL3n72gSzYBLHotIE8kxwvzMAs2xj
	uPm4AyamCI3Ts54ESF60PwXI/NnpG4CxHd3cfCHo6eDxvqezYIOT0qFoW80SgYsLvwxfSqSDYxf
	u2lwDypb/Dkbs9AnSIYDDFPhP7lt1dnljVLaKHZ/ag0ssg/+jmMU/5531s1IeBQYPkVoaRSxgsP
	0Z69ytRXcpaGRwbR0yKsWxhEHfNVlKuezCkoTJ6RglhmZ8kl2Zi9i4lMbRw02D3vc/mdDig5bRB
	3ZWJvnSgQuvhBgT0hov9MsBaf0e7JNI5sRNL5rUvF/31ulnEl9QTWnmszMbUNSebP6JyZkQoD
X-Received: by 2002:a05:6402:4595:b0:698:3b7c:7e44 with SMTP id
 4fb4d7f45d1cf-69e652dd9bdmr1880429a12.36.1784337139037; Fri, 17 Jul 2026
 18:12:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260713031532.2458000-1-rosenp@gmail.com> <alnimCxfVcHqhHNE@gondor.apana.org.au>
In-Reply-To: <alnimCxfVcHqhHNE@gondor.apana.org.au>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 17 Jul 2026 18:12:07 -0700
X-Gm-Features: AUfX_mxA1OauvGdPWxLQG8jOd7jIL8Zu_pRTD9ejVKxVQNFawZwmAqIg_Z8qjlU
Message-ID: <CAKxU2N_8zMCj4NCp8dgsf_JAWU=7UBTOfRsZ2CX3sQGyPJzEkA@mail.gmail.com>
Subject: Re: [PATCHv2] crypto: cesa: switch to non-devm IRQ to free it earlier
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>, 
	Bharat Bhushan <bbhushan2@marvell.com>, "David S. Miller" <davem@davemloft.net>, 
	Boris Brezillon <bbrezillon@kernel.org>, Arnaud Ebalard <arno@natisbad.org>, 
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 17, 2026 at 1:06=E2=80=AFAM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Sun, Jul 12, 2026 at 08:15:32PM -0700, Rosen Penev wrote:
> > Switch the IRQ request from devm_request_threaded_irq() to
> > request_threaded_irq() so the IRQ is released explicitly, allowing it t=
o
> > be freed earlier in the cleanup path rather than deferred to device
> > teardown.
> >
> > Add the matching free_irq() and irq_set_affinity_hint(NULL) calls in bo=
th
> > the probe error path and the remove function to release the IRQ and cle=
ar
> > the affinity hint set during probe.
> >
> > Fixes: f63601fd616ab ("crypto: marvell/cesa - add a new driver for Marv=
ell's CESA")
> > Assisted-by: opencode:big-pickle
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> > ---
> >  v2: fixed Fixes tag and reworded commit
> >  drivers/crypto/marvell/cesa/cesa.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
>
> This makes the code more complicated.  You need to explain why this
> is desirable and the explanation needs to go into the patch description.
I agree. The goal was to backport to stable kernels. But probably
better to fix it by going full devm.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
