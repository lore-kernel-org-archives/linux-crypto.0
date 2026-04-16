Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F14B3CE4A7
	for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 13:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776347084; cv=pass; b=hDdF91O2ve88nDUOioKeBN6Zo/vMLhjPK1zAbiRorypn/DnTXWRN5qDhe9610NNx4OSUECDVFjNiwu2PEdyI7aNHPWg4FwArtvsvp+Oyh3yhtd6tat8nAxSsE3zomr8Ov0qBoj2ImUfM2WQpsJXV3vZFuLURmVC0lmgUOL3+3So=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776347084; c=relaxed/simple;
	bh=mTVpBdjjI9oKXuDpma/uOA+GO9QV+eMtEK8P/UbJDZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P1GusatU0Opkg7zwVqhWqGopbI9wVa5YQ8O9J0MhzBihlTsJ/xevfJzK0kNRLM2q/QaXwLBB7uUz8B2aF8c+k02+NFQbWLJyIR0kDCq9ul0as550oQIGShCXUX8piEbl+HKdq0GG/FuzUmkbTtpTWltc5JO6L9J9K4ITs/UeJ9c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com; spf=pass smtp.mailfrom=vayavyalabs.com; dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b=dvILqsjE; arc=pass smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vayavyalabs.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vayavyalabs.com header.i=@vayavyalabs.com header.b="dvILqsjE"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8d560ede296so938178185a.0
        for <linux-crypto@vger.kernel.org>; Thu, 16 Apr 2026 06:44:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776347078; cv=none;
        d=google.com; s=arc-20240605;
        b=A0UG5KKNgAqqyZ0BgNQhYa3sZqTuUMeSj8CklbV2ckhHWnf0TQj6tr9Bz+YnrDtuAW
         gbnC0aRq4KrecuVdPaQY2RDMvZkzU7wJYxGe0S11bQ0W4yNcWWUP9JcvF355GjmzTRP6
         GlrHijVlj+PS40iiPlaXwuzZWmb+odWsjPsu1MSvoHod1oAIbE4q9O+rMjGPsNA38fe3
         I8GLfOwQattGOeArsxN1Tj8Irw7IiWwSlhGx7yLomF6tk0EUSqaKiqh7jj52l6HY9Ve1
         yLmNxqDPx6qMzVYFfwPqZjsh0cYq+7s8w7rCkeuiFOy2A7FB/zqcGGm1bot3TnUktQ05
         DE8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vJytEO4edAXWK8urZx0Wgyg6Umc0OrtkWTX64gcjRrI=;
        fh=RIaseGxQFyc4BaNbPfLN0YMYNmMpnfffvXGYEP5tTL0=;
        b=Eh7RidOJjj6OlIQLDFpp7D+5dLxNr80XDmh2nBckF6V5lOduR30VOwka8grllkb7e6
         y5Rp2cpfCkvYptLHJPZBaFkuP4rb1u6Of3e8ShdI+zHeKkIdPYg4eqBdiXvKymfLEWTg
         +goxPdNqJM0fPEtX6/xWe1JUXdO5voMcHfaz4mF/8GUuJt+rNAnGCLPbT3TEmtatV5a+
         mN7Yx3Lq77+Q4KbtMKu7+GGU60KIq4eDLF0HgFcCY+/0O9pwBXAJCBd26kIVZWVYYu0k
         CH3c1U1QxMnVZWP96wT87m2tHH66dB+QEu8YZKHQa0eVEk1lSW3SzwWkJJpg38oJJfSJ
         XBug==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vayavyalabs.com; s=google; t=1776347078; x=1776951878; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJytEO4edAXWK8urZx0Wgyg6Umc0OrtkWTX64gcjRrI=;
        b=dvILqsjEArZ6xXUf9nYlPSJ++t74PRSTEGhkELZj/hAPpLmm+he1LJGGmc1g6jnUO7
         FLP+kppvDjX59dgv+y8Y/tqp05UZuxCaa+7IPUQHhLwH9xdY0PmuStcYVkjsrVIhOJgm
         RpHJJ07mJFAB/rKshCNOe8rbDtXLImY7xVKtw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776347078; x=1776951878;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vJytEO4edAXWK8urZx0Wgyg6Umc0OrtkWTX64gcjRrI=;
        b=JQ7fYlCygxmDyze+ULr/oL1Q8BwWGuVJ7daUwa5HeUpXH5yxGeWuMvR6vXh3DBRIY/
         QGf1rPzTzDEL+0qfiGCUe6pf0bFXKAR6UmFAdd+RA9g1qeXsuaqzbbmLH5DvPJBmx8SP
         aeds/uIVzJt5cq3aA64/Uy1FLF8poRwD3gpCun3E6KldEv2+sa4oPqRJhwh6s48mr5KZ
         OnhvYA7i305lSqE3moff6QjKC8aEJp3Peq1uEb3zJJj7hGWOcOgfujnBezMMHtJIyCZH
         hH+GnXgHk6NqefTHChxNStllw1q+6BoxQyW95aXUcTZ4HmwKJeAaPAFp38yXH01YOmB0
         1OOQ==
X-Gm-Message-State: AOJu0Yz9MAYsWeYisJYUoe/aKpkY96Ei57wg5CXvId9+PPxA2D9qD4SZ
	Z/l+TE8tGaZz6IFgQ/O6tWRPGi06fRfogEdyQG45wYqF2AY5hmNd0MG+Yy/PhQBCVe/kkrpBBfE
	FZTfinfzkcG6etJTOVlQ15WdVft4OTrw6aa7ANRC8lQ==
X-Gm-Gg: AeBDiete4EWbXAV++kYpID0N1z5ciPHlKezVLlLEQmUoPNtydNWL7UMFAWNH9jL8ttC
	pZ6X1/oARSK2r5fweXGubh3PyaidQB6bgUwEjCoL680fhTB75uNPBcqXuZlsOSJTVqmxN9d0FFQ
	l+fOp0xH5i1IcaDZgb9BUJr4CMpnlDErnrn7hyJSHBTfQm6Qx7lIb1/XYYT5yWgIQYSwvj1sNcp
	wvuwkAUCsTbKfSM9S6tuG/i8DTKsJumEZzQ70YEQ6Aw7G/PZaEoS7STUA/Aac9/oy+3e54CEurR
	9eACXc2u2k0mpEtKnn68pFvz01YZFGM8AGnY5/BRUFuiX0/1HB87hC4NWGfIUL0+H4Ge6REHQ3A
	1Ttdg1vHUPNByQxM7EnAfWKrEbCKQzVuOOH1KBgd2sBCTNn7jyNdpxKJ8Vg==
X-Received: by 2002:a05:622a:244e:b0:50e:5db:ec5c with SMTP id
 d75a77b69052e-50e05dbf7f7mr213657131cf.52.1776347077910; Thu, 16 Apr 2026
 06:44:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260318071808.817074-1-pavitrakumarm@vayavyalabs.com>
 <20260318071808.817074-3-pavitrakumarm@vayavyalabs.com> <acZL65nbtfMCPHhq@gondor.apana.org.au>
 <CALxtO0nFEG2Lm18Fnb=YVQfy4-Qjb5+WtOxsHNOwYTy2Kzyb4g@mail.gmail.com>
 <CALxtO0kj4JfL94qY-radGcLwMeTnq4NQF7vPqs6giuhBinvALw@mail.gmail.com> <ad4iJhEM-ZwgadBh@gondor.apana.org.au>
In-Reply-To: <ad4iJhEM-ZwgadBh@gondor.apana.org.au>
From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Date: Thu, 16 Apr 2026 19:14:26 +0530
X-Gm-Features: AQROBzDWPjMyI40iDcqRckFcLA4-wp9ja-BQn6tZCrNmb6YScm7vzgbCOU3Mfcs
Message-ID: <CALxtO0kZX58X1Yk2cmGuBJa98Gcroy0b-wPxL=1h+ph5rT9ebQ@mail.gmail.com>
Subject: Re: [PATCH v11 2/4] crypto: spacc - Add SPAcc ahash support
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	devicetree@vger.kernel.org, robh@kernel.org, conor+dt@kernel.org, 
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com, 
	adityak@vayavyalabs.com, navami.telsang@vayavyalabs.com, 
	bhoomikak@vayavyalabs.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Herbert,
  I have pushed the V12 patchset as per your inputs. Dropped SM3 for
now, added other code improvements.

Warm regards,
PK


On Tue, Apr 14, 2026 at 4:47=E2=80=AFPM Herbert Xu <herbert@gondor.apana.or=
g.au> wrote:
>
> On Tue, Apr 14, 2026 at 03:58:16PM +0530, Pavitrakumar Managutte wrote:
> > Hi Herbert,
> >    If the above snip looks good, I can push that and some more code
> > clean-ups/improvements as part of V12 patchset. Do let me know.
> >
> > Below are the code fixes and improvements
> > 1. Multi-device safety handling - All packed up inside priv
> > 2. Minor code polishes
> > 3. memzero_explicit inside setkey, spacc_compute_xcbc_key etc.
> > 4. Algo registration clean-ups
>
> I would prefer if you left out sm3 for now.  If it really mattered
> someone would move it to lib/crypto.
>
> Thanks,
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
