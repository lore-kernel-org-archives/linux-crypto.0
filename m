Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com [209.85.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE011344021
	for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110641; cv=pass; b=mG/oE9/JB9KtUferiA97U/LGVeAJ0x3OR2s7KI2GaWZkMQ2/QFaQMcEzTVgK069NfC3e7mTPGgLqKvxnc6oO4xVPiTAJdRiwXRydgpZESdrVwlUEOL38uGT9dgBSjcRDml3vVR15YvdNorQGbEKqX/NeHkJvlD8k6MLd7O8iE0I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110641; c=relaxed/simple;
	bh=6K6RM2gJWpYnx4m1W8Ibuw2HXTgpRjGku8yocxCd2X0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sO1AGymqlDv/u4MirXJfM+iBzA2Oc93D42wCMk4fYM7gie8Y2/qSX3DRbFJQ1eCULzDXdJaCrSvKCGBRhbsiLVkTJ4SlesjMWzncojNvBgQxYc6eQrwOdVyNzINaiOTrpzjO7Fq0lnrb8/kWbzNq/5zKGYUXk153zsMxeuzkYog=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b+AN00dt; arc=pass smtp.client-ip=209.85.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b+AN00dt"
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-7dbcb505578so87364137b3.3
        for <linux-crypto@vger.kernel.org>; Wed, 10 Jun 2026 09:57:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781110638; cv=none;
        d=google.com; s=arc-20240605;
        b=lGcHqb0yVgyjsTBOD98EvYPbmT5oPvls4KuSQkQkX9c2Yd2qPOA0iiADLon0UUbfn8
         UlfnPeiPOcFtF4VfdjKR2CB3CdvDH8Q5fnf1HZsuJ4pmpBVRyrh+oVxoZ6zJdzAKJMZv
         b7ZXA7eXDVRMHAzVWqAms3moXqALHz2PW2WydZjUGffT6DfrycmLooJPdRBFs8sMmzkN
         x9y1+NgP5zNc/tZ3CeTXUvsDu98KmrTViAqVcwaEBtHrhiZZOhZaIhv3xzh17eko4Hyi
         Li6ALLUXAKKCSnlHUyLMYNTDOstfsExgjWTakYtYjVTUY3o/wAWqmLMnAQPDc2FN8du+
         rWvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wCHlxS432TosTwKI9Ji3RuUwzBRg9dGupWbTgwWC7MI=;
        fh=8fJjr4ekXQwr+tj8rpiQafL8p5QuVWFn8nsDAUf34B4=;
        b=Njz9dMc3jUbrE8RFXUSz28OzguiYZD8y8Bk2wMCcqAbEfZnYdVwfY89uAtojL07pjY
         UniUub2+hfEDsy1v7I8xE6teq1t9nVNUaBAwH7VFAdgbFo4/9ihiEOb3aKPcKciGDbh2
         MBtoqioIv+qK4hGYf73CLqvKT+p8eETHZtMtv2pvhGvQakGGeehMjjIQ9kGT3RpkZCZv
         DzFwJKOZwuPPVPfZiTR1EUEY88YZ9lcn47NXrwRzNgerITbg9fkVh0yNTbf/zJRZNVNg
         tmI2wZfXcJCfjjzRrfWUlWpPLQbeJVgGjEd9W7Uw/MdYXqPiXNiRbr/HVkZuIaYZ22VY
         PPow==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781110638; x=1781715438; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wCHlxS432TosTwKI9Ji3RuUwzBRg9dGupWbTgwWC7MI=;
        b=b+AN00dtJCpFsDT0mYUckTRhXslYP+WS/ssa6behS574CXVi5a4x3HwAqQKreONBqf
         1FjyghBi5NFaHaq7Sgq6KrrRVu5k9oiIdJSM2OnWXwk/kPijLYFAXrXbPvFnNUP4uqPl
         qfmv8RjaCX+uQHA1f5SMMqe3YjqRCdx4tHixFFoABY++DE7IfowyKs2K1Eg5f5u9Vpbt
         BbU3Mv1k1itXvYHVbRWSlDpnivUu2J4lfF7NoRSh83bqcC5ZLcGxHwEU8eGvCbDwLFVX
         Gg2r2Cf6aRpROs1lfp4nm0JMo7ZXB0do4aca0705hwrEkkiuYCswRxFkJZ+Z2/JISwuV
         9PpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781110638; x=1781715438;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wCHlxS432TosTwKI9Ji3RuUwzBRg9dGupWbTgwWC7MI=;
        b=Ii+D2RaECRlmeVGpomPqzSAi4lqnjZ8RtOTVJNBfk29dopaLOe8XRDFmIvn+zRRBGd
         flu9ZUBTx8XN/9QnqGX60kRS2d+Jfvxaq4kg0f9BNTsJ9wvisxjLF3maFLcTVgLk0VZg
         UUmRvyaOZdWuMc3x0eReFHu4XeqkJNhNgILA5azGRkHfx/D3Xqj2uwrfIXASPpyAb7DR
         ZkaWcKL6c62H3n3sEiTOUDgkWAWcZ75oylHQs8CbE8ZWJ6bOTcQu0jY0v0zhDS2iGeee
         I/x3nL3+Lk6weQ9I+LWtFfHnafkWyoGdTNqh1EApjpFplxb0QD249rWWrTDJSoEwzIL6
         aAfg==
X-Forwarded-Encrypted: i=1; AFNElJ9GzsO99+2rYW+PRMSbA2Ak/fadwlijJJbHDpa0V/DE1yQWSdGIfvC1AI7WDLo0HpSb56xqDQUfu1lCkOg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7sHkoCT5e0+2rhS5DUGN9CmvQ4P02XI+kV0ckbNBb1T1yWU9z
	yzugE64kvgBqc0JS0YU2X0cTVQtuXtVwSN/VLJXXQPrHgVHG+9+jQ6XwXW4pJrGnYXq78zZtLIC
	QmQBum7SC3/wfoBSI9O+Yc9dBJUQ+A2I=
X-Gm-Gg: Acq92OGYZJJ/t4KOuzZT41g9QNBXoBswuGRDtr/yKZgFsahWj4kH+jkepeibh1sTk4o
	7Pv5CYhbTuMMT2hTa4VY36Hm1iMxEM5+qvd/q93NiuYgFDzPE/YLZ8KfVLUovaDtAins0T7xsQu
	LMvs795tW6x6rjxDWWc95W6cNlOmhZ0b70TZ/SRxfnkOXtXX29wPJGls8CiWeMDfanc7ZugP4fn
	0QoroDnPDmh+vKgdk90M5G9lf73FqEjxRDuTPPa+VoHtHCpkZoXq9SrZAQ5rg/WuwsMbnyoqrcp
	p3McW643M/1Rn7YTIjqvFgvSTvrSMPAuA3DU/HRZD52GkVAiI/Kz1AwV8oGoNRM=
X-Received: by 2002:a05:690c:4447:b0:7b3:3a49:752 with SMTP id
 00721157ae682-7ed108ca2e5mr278537897b3.41.1781110637662; Wed, 10 Jun 2026
 09:57:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260607112435.42804-1-fabianblatter09@gmail.com>
 <bd992448-8ded-46f8-bf91-97792b9a11ad@linux.ibm.com> <CAGtAT=nJOAxecN+eYVwkzQAUcr2BaBhAO=ni9hWqdRKUQ06=fA@mail.gmail.com>
 <af632d11-baea-4314-ac17-d81502240a5c@linux.ibm.com>
In-Reply-To: <af632d11-baea-4314-ac17-d81502240a5c@linux.ibm.com>
From: Fabian <fabianblatter09@gmail.com>
Date: Wed, 10 Jun 2026 18:57:06 +0200
X-Gm-Features: AVVi8Cd3o-dynJYvlTZnmfQiTVEKU-tAtXdO-I1mQjcR0Xi0f_fDnikv6WAPiwY
Message-ID: <CAGtAT==CRiLqt641wS481+2gwZ3noFqfSyxGwGPvN5CXGLHjWA@mail.gmail.com>
Subject: Re: [PATCH] crypto: ecc - Optimize vli additive operations using
 compiler builtins
To: Stefan Berger <stefanb@linux.ibm.com>
Cc: lukas@wunner.de, ignat@linux.win, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 10 Jun 2026 at 16:52, Stefan Berger <stefanb@linux.ibm.com> wrote:
>
>
>
> On 6/9/26 4:51 PM, Fabian wrote:
> > On Tue, 9 Jun 2026 at 20:58, Stefan Berger <stefanb@linux.ibm.com> wrote:
> >>
> >>
> >>
> >> On 6/7/26 7:24 AM, Fabian Blatter wrote:
> >>> Replace the software carry flag emulation with compiler builtins.
> >>>
> >>> Even the newest compilers struggle with taking advantage of the
> >>> hardware carry flag. Compiler builtins allow the compiler to
> >>> much more easily achieve this while still remaining constant-time.
> >>
> >> It looks like you made vli_usub and vli_uadd constant-time now because
> >> otherwise the loops could be ended early once borrow == 0 or carry == 0
> >> respectively. Are all the other functions that operate on the private
> >> keys constant-time?
> >>
> >
> > Thanks for the reply,
> >
> > My primary goal with this patch was performance optimization.
> > I did not add early exiting because the original version didn't either.
> >
> > To answer your question: No, some other functions in ecc.c
> > are not constant-time. For example, vli_is_zero and vli_cmp both
> > contain early exits.
>  > > My patch does remove the branches in the inner loop,
> > however, the original ones were already constant-time in practice,
> > because the compiler replaces the branches with cmov's.
>  > > I am happy to make any changes to this patch if you like.
>
> ecrdsa calls ecc_is_pubkey_valid_partial -> vli_mod_square_fast ->
> vli_mmod_fast and then may call vli_usub or vli_uadd via
> vli_mmod_special2 or vli_mmod_barret.
>
> ecc_point_mult operates on a private key and will call vli_mmod_fast and
> for some non-NIST keys it may call either one of vli_usub or vli_uadd
> via vli_mmod_special2 or vli_mmod_barret.
>
> Due to the private key operations it's probably better to keep the
> functions constant-time for now.

Agreed.

>
> > I could also look into making `vli_cmp` and `vli_is_zero`,
> > or others constant-time in a future patch.
>
> I wonder whether it would be practical to suffix constant-time functions
> with _ct so that it becomes visible whether the call paths of functions
> operation on private keys only call _ct functions? Sometimes one could
> optimize functions shared by private and public key operations for
> performance -- call them with 'bool ct' in this case and suffix them
> with _oct (o=optimized + ct) indicating that they support both variants?
>

I am unsure whether constant-time operations are even slower than
early-exit variants by a significant margin. vli_uadd and vli_usub
don't seem to be called that often anyways. I believe this probably
doesn't justify the resulting binary size and complexity increase.

Let me know how you'd like to move forward.
