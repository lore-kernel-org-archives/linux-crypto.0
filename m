Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455673FFD
	for <linux-crypto@vger.kernel.org>; Tue,  9 Dec 2025 03:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765252731; cv=none; b=FEcuwv9vKscPMQiZYI3LjKoAmkIRWGz+Z/eLX2yNkas5Mz97XDNAA9D6gImEwgOCcjUz7MSoikW73qLJhR6vi06UaJ+jR2FTT2pvNUDmig9BelZKWECycBUnAPxZyfD+RsP1efTvqqRRV3LYAg/iyVw21/1A5jYG2hFZC0Go3CA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765252731; c=relaxed/simple;
	bh=xrL0b3D0tLMVgulX0p18WGlj1rRG8WCU53TVha/dRDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KI9wqT0N3T4SnX8zqZ1rr7qMq3RAoUNLWnf+evH5Xn6Em2p6g9iIr7qhklkKfNxRMUfvVutQ43fLRtLO9O4KUewAxrEK8dlJ8or/c2MxsadYidiprHm2jjLcZuaFmATvc7j0ltItLCano6w7MpkOoXDBO/G4G9WooOG7NSTRowE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com; spf=pass smtp.mailfrom=sifive.com; dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b=J8nSU464; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sifive.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sifive.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sifive.com header.i=@sifive.com header.b="J8nSU464"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-37b99da107cso47153261fa.1
        for <linux-crypto@vger.kernel.org>; Mon, 08 Dec 2025 19:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1765252727; x=1765857527; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=68/wGPpw31Zsca7N/+VQlyekwf34nB7RqEj959Ic/fA=;
        b=J8nSU464x2i20JnaVJ5XkxFky4b3EzonDEEFa5fbpBCHwikGHqjb2xMeryMN/g8jBn
         YHq0hSnZT3yLoEas5HT5DqwdMJiuQVZ56HP3mVwwXJxosyMupvAb8KAVaF4Adw4Lzd24
         S3t8SDy4fN1QUiIIkGOiQA/1cEEANc3cTI/p0f9xtKlfpk2Fqm7VQpULI4lqdIJeLFOn
         8RojMRkOAgWxER7TQLu899bYx/toq+7TEj+Xkl2iHhxxdcgUALNyQyQm94nlqWMV27fL
         UpdDV/IGrtMmxUewMH6OQNocXC+I60VpRosfXe4d097FtQOpWIOb27WigTeT+qqno5hw
         aomQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765252727; x=1765857527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=68/wGPpw31Zsca7N/+VQlyekwf34nB7RqEj959Ic/fA=;
        b=HD8TVwfe4cZccR5RaezDQFm4rqrupZx1fy/KmcwmYr1HeDT6J+napb/izyIUhZucMu
         c9RPBdb9gzoFDPRqJBuRsXVxmtylY8RcCQLkZeVweYdyCyjRf/L2F270XyH1HNKkIPtC
         ifN7IQQUoi7mo9cpmPoOFFlN3bpd0EgS8wUbcUMXglZ5Qcn6gTU6qVu2qIip0K6zQAir
         FsejS08QnLM76SBKqdsAHd3FdzHR0yAt47f91I7WgdQf/0Sl7slGfBGWoD0AMYN5aR7W
         UccRNVqaaRpwcBeODMtkDh+WNE2mDYVgh9GgaoRv1Xdjxi1V8RIgQBAnwn27VFd/nTCV
         FlyQ==
X-Forwarded-Encrypted: i=1; AJvYcCWu7wTD60bPhIexkYViNUyU4cyeNZY5DluMyixT3opJg/rnhmao9T1WdQDhRI9V/rGvF9yOjR391OWyVjE=@vger.kernel.org
X-Gm-Message-State: AOJu0YzGKJikJMR04KpNFp2Xr7IKRlXaQQk665RCVaSSuFUFaJyO0ogv
	YYjiBsBbhcReFalViW2M9HraKPaHO/nzzEhndVjuYrxjXv6HDtUN4h2oyJqP7x8gdjwISPDFH2Z
	RDrQBbEluTrdQRptDDAnA0fnFbkhtAOtfhzeW5HezNg==
X-Gm-Gg: ASbGncteU1E2kXawDsz3s6kYfhMm5eUWQJd97fEqxWGKPN3/uXZb5tgo4ppNB2qePde
	8OT756q/t8E4WCkva4+F39/0HX3KmK9x2ytfheAWAjbjpOyO1hyAIlA/iPKleQxNZeJzcdN8xzW
	6d2IdtshfUU86K5z5U8QmwuUPdYj2bt1CLe6XlmP+gqJyRM73GmesrM4lpPSRn1bhEMixYR6mkT
	+yQ8roChqcn0cJN6zO3TDLEcAT3beIBE3rBdvzqSHE6//mdkGbnFv3Skn71S7JpRaEtQOomO21n
	68HU0Sh0JiDz3Pwm7CxQKorNl+/Q1GyNdszAckAQRybgFXg/BjrntXzR7vc=
X-Google-Smtp-Source: AGHT+IH53WqkegnmUuZtSz3OxfPTw0gXTVMOxw+PpQSsNiistyltCGiN5RmD6N+zp9c/bk3NrIul642oWgUASFoHLMY=
X-Received: by 2002:a2e:a9a9:0:b0:378:ea85:7f06 with SMTP id
 38308e7fff4ca-37ed83c443amr26245881fa.36.1765252727360; Mon, 08 Dec 2025
 19:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251202-riscv-chacha_zvkb-fp-v2-1-7bd00098c9dc@iscas.ac.cn>
 <20251202053119.GA1416@sol> <80cb6553-af8f-4fce-a010-dff3a33c3779@iscas.ac.cn>
 <20251202063103.GA100366@sol>
In-Reply-To: <20251202063103.GA100366@sol>
From: Jerry Shih <jerry.shih@sifive.com>
Date: Tue, 9 Dec 2025 11:58:35 +0800
X-Gm-Features: AQt7F2pLuo8DbBX8z9TNAwyIqxu_BbB3rPdB4AVoLwpPolWPdQVYum8-_cu6fbk
Message-ID: <CABO+C-DAuguO4svhi4o5ZgybizzgnADRbzJWZNBTb4-096c10g@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crypto: riscv/chacha: Avoid s0/fp register
To: Eric Biggers <ebiggers@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	Ard Biesheuvel <ardb@kernel.org>, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, linux-crypto@vger.kernel.org, 
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 2, 2025 at 2:32=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Tue, Dec 02, 2025 at 02:24:46PM +0800, Vivian Wang wrote:
> > On 12/2/25 13:31, Eric Biggers wrote:
> > > On Tue, Dec 02, 2025 at 01:25:07PM +0800, Vivian Wang wrote:
> > >> In chacha_zvkb, avoid using the s0 register, which is the frame poin=
ter,
> > >> by reallocating KEY0 to t5. This makes stack traces available if e.g=
. a
> > >> crash happens in chacha_zvkb.
> > >>
> > >> No frame pointer maintenence is otherwise required since this is a l=
eaf
> > >> function.
> > > maintenence =3D> maintenance
> > >
> > Ouch... I swear I specifically checked this before sending, but
> > apparently didn't see this. Thanks for the catch.
> >
> > >>  SYM_FUNC_START(chacha_zvkb)
> > >>    addi            sp, sp, -96
> > >> -  sd              s0, 0(sp)
> > > I know it's annoying, but would you mind also changing the 96 to 88, =
and
> > > decreasing all the offsets by 8, so that we don't leave a hole in the
> > > stack where s0 used to be?  Likewise at the end of the function.
> >
> > No can do. Stack alignment on RISC-V is 16 bytes, and 80 won't fit.
> >
>
> Hmm, interesting.  It shouldn't actually matter, since this doesn't call
> any other function, but we might as well leave it at 96 then.  I don't
> think this was considered when any of the RISC-V crypto code was
> written, but fortunately this is the only one that uses the stack.
>
> Anyway, I guess I'll apply this as-is then.
>
> - Eric

The 16-byte stack alignment is in RISC-V calling convention:
https://riscv.org/wp-content/uploads/2024/12/riscv-calling.pdf
It says:
In the standard RISC-V calling convention, the stack grows downward
and the stack pointer is always kept 16-byte aligned.

-Jerry
