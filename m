Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9602AD2B
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862996; cv=none; b=P9JLl97fVfiNQ6TMysNR+cXOK0C2DSOW99z7Ij/GzFzxNwBbezU8wpA1154FXDFBwNWtiO4pXtfT7N3iYTiTi0933jei2U5SRHXC6QTrTlxavhd6pTefGxtxuJaszKKouUDPgc2rC6cIN+J7xnmqjEReH/Hw6s4RulVbN8AmOx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862996; c=relaxed/simple;
	bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LfmtY0Yi8QU3w0WPFJKrbAMlmvZ/nit6VHmK2le2fK2pQLvqSi4J3v2eohXM7o9UxhNlMtudq8R+PjZ7jUjv34JFjmSDjtV6WV7+XMbftJN8wC2bTj+S2ojcszrN5R4DS3+WHFW7JeEvhtvsx226pDxnx6NiHOVR9Ash4oL5BVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B3AblIF0; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B3AblIF0"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so912976b3a.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:43:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862994; x=1765467794; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
        b=B3AblIF02eb+dIAL+Wt6sOqL2D2+kmORWJpTGfp7EX63dELAq9nnf2X3gnbWhsUe4T
         zcMfxeU0rLbkOBNo4KuYEcV86eQth5+hjWF+u9wBBF30BE+8BY/0Y8dNvKG1AcK9Ol7J
         Q2p2OOIqwMtqHnLWQVoZ2pe7UdBJqLjtm8d164/bQQbhi1zPig9aDyiZZqZh8KBytvWG
         H4MGQ97OTHUwhtPSyRaOvuo+OjJtxR0fYfReck2bFoqzINcX2f7edziDnExNs/abLxS2
         baXN1NwMhLfhsyp+y/+f4oSMA5MEoe/m0kIDi/UAmO8cfF+ApPKXKHZeH7ZrKIKtqWf8
         Ne0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862994; x=1765467794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wMOP4GkDr5ijMp2y62W7yYKXyYdN/GF/oZk8QJQ4apc=;
        b=bBmKPN/z6Mex1i6Vzcv+BLML+rshkqbY3RjOb85PCSJSPR018bQA3bXwK5MCEbjtbV
         Z6zc/kKW8Bgc3I1LU2ntrCY1nHwOZEeMdUZpEvIvDD17ChtvwcttbJmr+3AMBlLD/8J2
         5wpGvndtPo50NsmbbJ0XgNPELZie2KkL4P99YDJx7hlOLg9gL2TFS5jrt+JaboJRR/dc
         9TAMgk37XsnX0CLNix+d8hSyp7UgDmL9+lvfPN4/wdDyhpv2R5nngJHYU9mYBXLKuNRD
         qpfCwYhUCSzKsBMBbmlWIn7oSryoTnp796MKwu8H4BuJF19UR9O3KZpB5UTvwWof2Dfp
         2g1g==
X-Forwarded-Encrypted: i=1; AJvYcCUP8E06p4gU8a1ZsFWw9zx6ZmoeWSjP3BT/kwAMZPl+6jVeU3XKulr1MUAjhA+E2ySQ/1j1J5ky+HU/5Ro=@vger.kernel.org
X-Gm-Message-State: AOJu0YwJmO/kEfXPxBKV+3BbJmOIQYV97MxBZBD8xjM7UzXMAaKj5yWg
	dIc6TwTVz4BjBr8PDyTiN4Tk/YumSkCvwR//+iAi9xSeWcZ6+yq1zwVnNupNFx79llGfHOn68+5
	irrq1xpnrbqcURc8giTwiHdsVF1zU/JsARnTkhznN
X-Gm-Gg: ASbGncu8h6mQLJcpDvGGkZIBkbv5FoTmAOqOToaWomjk6F9c6OfbWBJv+KHlSg6VcmF
	d4cy+WBt/KIYm3KbRjDYMAkc6pK01mWwWmtIeJJJILlGpq7Vpdbup++LTR7amDAUmgelxPXArO0
	tpb71ga+CdXD84moArKVrVHIn4mB5WDSsqREXBKJKIxPHN3BCh4muC1abYMPlWoi/yf4T7pJovG
	QAdDNarrVf0CLXUMOxqT022sbNjNgIoNfyt4EphhjfSUDGD/kqPbkVtDR9dP0R7qVHw8NaZrqPO
	wIxHZm9CsSNIQkUzrGj4ysUT1A==
X-Google-Smtp-Source: AGHT+IHs2lXL9r27Oj25OTPLwrUpq+WjBSPrEBWJDAz2naZgENCLRnceIe8m1HwqG+PReSfilUhD4oQEt0040SIknFU=
X-Received: by 2002:a05:7022:f511:b0:119:e56b:98a5 with SMTP id
 a92af1059eb24-11df6463cf7mr1323360c88.12.1764862993857; Thu, 04 Dec 2025
 07:43:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com>
 <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com> <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
In-Reply-To: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:42:37 +0100
X-Gm-Features: AWmQ_bnyN22mbvWc2oz66fpJ7IbcLfdYObxM0FDhKEtXf6ssNmrNTIWoxgBISDw
Message-ID: <CANpmjNNqCe5TxPriN-=OnS0nqGEYd-ChcZe6HQxwG4LZMuOwdA@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, glider@google.com, andreyknvl@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, shuah@kernel.org, sj@kernel.org, 
	tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Dec 2025 at 16:35, Marco Elver <elver@google.com> wrote:
> On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> =
wrote:
> >
> > On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> w=
rote:
> > > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.c=
om> wrote:
> >
> > [..]
> >
> > > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > > >
> > > > I believe one of two SoBs is enough.
> > >
> > > Per my interpretation of
> > > https://docs.kernel.org/process/submitting-patches.html#developer-s-c=
ertificate-of-origin-1-1
> > > it's required where the affiliation/identity of the author has
> > > changed; it's as if another developer picked up the series and
> > > continues improving it.
> >
> > Since the original address does not exist, the Originally-by: or free
> > text in the commit message / cover letter should be enough.
>
> The original copyright still applies, and the SOB captures that.

+Cc Greg - who might be able to shed a light on tricky cases like this.

tldr; Ethan left Google, but continues to develop series in personal
capacity. Question about double-SOB requirement above.

Thanks,
-- Marco
