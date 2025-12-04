Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A9342DCF4C
	for <linux-crypto@vger.kernel.org>; Thu,  4 Dec 2025 15:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764862581; cv=none; b=AUVWm3VBd1nxTT0DAHj/a9pnAWU8ivMDtp5mE+KbGWgcT95uFerAR/dIXRdG1wsmjBi7yk24vSFTRQJmYVgu1JCBO04d687UxsA0zHITeYgUJszuXY4oH2t2irNJvuG2YZTTf8gTxVF4j0fDtwbLmi7NooDDtqyo984A4n9IpnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764862581; c=relaxed/simple;
	bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gUzmeUjgg+t54AaVVECn8XMeP6dWhLmATPn1iP68swD5zQ12ZTQ2uV/tyB+vl6t1l3D52Zk8wbltodTn2500THWQeAzriLoSqknRjhyiNqo1aOwrkXOkCsgPjN9HjjCRO0TIO+n3hmIW1779VtShnhfuuvhzFSw4+0lUknODrs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=plpDhXig; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="plpDhXig"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29853ec5b8cso13713255ad.3
        for <linux-crypto@vger.kernel.org>; Thu, 04 Dec 2025 07:36:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764862580; x=1765467380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
        b=plpDhXigluz+VxyxbzstzVRw014UWhTnpLl8HbfJtTbswBPRyMcIv9m6sOeR0Z02WT
         wbU8KH6971xIgHjupyNcVOwKV7xg/BcxryjrjFpz+imuvfpiL7lalp3VxlEHcCK4Vhq7
         9/2qg1sE4rkA4NVqEhPoO9nvy6nIN2cnZJjlYB6DFaIdwc80lK+zOypUZl6PPg6P7WLi
         xWqxVZj9RpKLw/lKTsCQ/6ZmYk5uiUdjZET72gxvSGEknV3zSudTqs8V76guS/c+nDf3
         3fE1ta37wYh2a++LjCUDucNmDjFSe3KMNC4O6VWswxqxwxVy2uplRTKKWNEp32rfBtcf
         kykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764862580; x=1765467380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LWBFD2aC28ujRjWCANBBdmEOHCG4fNF+CSlRr6FISyA=;
        b=BVEDTcuPk+T1qHW5V+mktnQd0FbdB8ST5X445LE6imitzpjFwWmPekg4TcsiecBARZ
         uwFQPtiQK+IBNuVXtkjpU+lj5gE2LxLNMPpilTp5G0WXsPDOSF9Xeq9haq3LrO7Eplvy
         S/IqGMFIurcrwvR/XdRr3ea8+0cuA9DW23q8rnN95q30m/Ynv6Cu++f6eFxMWpOVTOUq
         drdwOECJtPJ2lPgQHHKm70DrViNBj70DL2Aw1vC4vhaLbPdhm0BQDXWFKpdp7crYQ8uc
         aZojNYjaXKLa4HT8HtMvX/PLuUg440G+bK7H6xiYXeK63h52j937LV2WTukbYydz1kXt
         I11g==
X-Forwarded-Encrypted: i=1; AJvYcCUIqUiVOQjcGUqnpndd+e5YgwOOF1CehAgNDR3nnB51S6GzscM9vku5QwkLBsZzsYnBd07w/ad9QG346mY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwjOPjJkRKTQq2WTkhMe9EdATLdC6ScKvypkH+Cy5ElmYs10NS7
	80AMeka/pJAlCQsT0c5eIn7xAD7kEO4hKdgHuZcm9IfzBCRYaUDG4Sa1dyIcrv/vETHcbhFsBNH
	P1PriB9Em2s6Xzd3KwRe5eiZ0dFc90MENf4jfMH1z
X-Gm-Gg: ASbGnctJycpD+qsSzGKRDpoAJEOhKv2BjczeD3SBYKudGopDIN3d0WosC0z/yGYzeKZ
	w18hPeElnfV83iD3DAMfaiiRx3xGgX3aaJ1lM6YkERfiUJX4cgth9TWvo2URmwH8uFKvlHCiVoJ
	/Zfv83xQwpOt1OiHH3/I5zotBOGkufIBbPR1wu2yOPy7qVVQocFGbJtKhLzxMIHVdeZBxPNwj4I
	f1zQTh7D3Yc8lDYnxl475+LR9YoeUVUUicer8ouSrbRHqQQzZ16Sp5//LzIqtw6B4f6pPf9QASH
	EJlhjmOTs1rr6AK2tcdHym5azw==
X-Google-Smtp-Source: AGHT+IGBl6pFyllPB28xMA+DusowF0FZL/6bu20YQM6WiubZmRKCdd7ntPDUD3kgpQhMnE6Fh5MlZMr8FMe2M5WQkqg=
X-Received: by 2002:a05:7022:2584:b0:119:fac9:ce12 with SMTP id
 a92af1059eb24-11df0bf6409mr5437809c88.13.1764862579414; Thu, 04 Dec 2025
 07:36:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
 <20251204141250.21114-10-ethan.w.s.graham@gmail.com> <CAHp75VfSkDvWVqi+W2iLJZhfe9+ZqSvTEN7Lh-JQbyKjPO6p_A@mail.gmail.com>
 <CANpmjNMQDs8egBfCMH_Nx7gdfxP+N40Lf6eD=-25afeTcbRS+Q@mail.gmail.com> <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
In-Reply-To: <CAHp75VfsD5Yj1_JcXS5gxnN3XpLjuA7nKTZMmMHB_q-qD2E8SA@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Thu, 4 Dec 2025 16:35:41 +0100
X-Gm-Features: AWmQ_blR-jXZjBSUNwkZ-Kj8R77y7Gb2w-LzAguJomE44k13qlmxusnxd-LQq3I
Message-ID: <CANpmjNOKBw9qN4zwLzCsOkZUBegzU0eRTBmbt1z3WFvXOP+6ew@mail.gmail.com>
Subject: Re: [PATCH 09/10] drivers/auxdisplay: add a KFuzzTest for parse_xy()
To: Andy Shevchenko <andy.shevchenko@gmail.com>
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

On Thu, 4 Dec 2025 at 16:34, Andy Shevchenko <andy.shevchenko@gmail.com> wr=
ote:
>
> On Thu, Dec 4, 2025 at 5:33=E2=80=AFPM Marco Elver <elver@google.com> wro=
te:
> > On Thu, 4 Dec 2025 at 16:26, Andy Shevchenko <andy.shevchenko@gmail.com=
> wrote:
>
> [..]
>
> > > > Signed-off-by: Ethan Graham <ethangraham@google.com>
> > > > Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
> > >
> > > I believe one of two SoBs is enough.
> >
> > Per my interpretation of
> > https://docs.kernel.org/process/submitting-patches.html#developer-s-cer=
tificate-of-origin-1-1
> > it's required where the affiliation/identity of the author has
> > changed; it's as if another developer picked up the series and
> > continues improving it.
>
> Since the original address does not exist, the Originally-by: or free
> text in the commit message / cover letter should be enough.

The original copyright still applies, and the SOB captures that.
