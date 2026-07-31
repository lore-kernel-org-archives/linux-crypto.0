Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A613CF204
	for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 11:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785498326; cv=none; b=oXl/s+/73tveEnFSOHcjwYQtMxyRqku985Z92sdHU8SPkZNuUsdiY+7sp+8/6PwyPgZx2au4316n2re9yz15FdND1m76OfmuxAW5CGKs2u9QPeBrWJPQuTQIBNzVJe/sMBVW+9aiQU1O9xKlBNVr0TbbsHrkM5srh7BlxHjTD3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785498326; c=relaxed/simple;
	bh=FXAhG4vJqgCaP+SaD+oigXn7L+3ul44ZqBjXWjjgnO4=;
	h=Message-ID:In-Reply-To:References:From:To:Subject:Date:
	 MIME-Version:Content-Type; b=l2tsGSt3LfrWbdsgMro2aqBPMP8sQjtAOz1w03lNJpm8F+TT4Lj25vcyVbNjvIEODW+Wm/08E201yhJyk6LcLhwY9YLONuopo+t/T9iNPxOVB+q2mLNMEymbuxv4cwqg4eR/tjblm4HXBlu0bqnWbq81zYpEWjfAaFLsEyJKWoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com; spf=pass smtp.mailfrom=gosalescloserapp.com; dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b=k6KGwlzt; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gosalescloserapp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gosalescloserapp.com header.i=@gosalescloserapp.com header.b="k6KGwlzt"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c8e2e39easo7233571cf.0
        for <linux-crypto@vger.kernel.org>; Fri, 31 Jul 2026 04:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gosalescloserapp.com; s=google; t=1785498323; x=1786103123; darn=vger.kernel.org;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FXAhG4vJqgCaP+SaD+oigXn7L+3ul44ZqBjXWjjgnO4=;
        b=k6KGwlzttMkHdGHa9wwb2Gw0vqc0b6NFa955/n0GlstO34ZrtVz2jvkbgEDhzvKCu0
         I4wE+xCwi3E4sQg82xzgDabbN0nIIiatODIc0JzkgQsHCLP0t2byVulRvw3kkCl3ZIjf
         50DaY/Um0+FaEhMZqDFFlHuNCoifAa2c+XA02YV5tV3GCTSZI5FNPK9nVzdkIhdKqr1I
         PcqoWnCUe74NAdAEugRmn29oGuWQgrc2IgDWSNn/jNQd+QKbUFvRC4+hZPgHD7IJSLyv
         3DHbeqAutta8+QX072tpU5NVk/5oJvI6ZyZv7u4lgbfmgOl0rxmKK1vhTVDr8sUdKrqp
         KuQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785498323; x=1786103123;
        h=content-type:mime-version:date:content-transfer-encoding:subject:to
         :from:references:in-reply-to:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FXAhG4vJqgCaP+SaD+oigXn7L+3ul44ZqBjXWjjgnO4=;
        b=Wy8KRv3HPF3MCBosgHd0MJUr+saJWMsPaC8JaZO2cL77uYzUvJ4weytfOpZSKAo7iu
         RpPHfHH6/jRS2r4g4uAfXtx9XIK249BgfljIfbqTvLGzyTDcLPWHVlD494lx5i7JeYiM
         KZAYmIQQ5ldJR8nsthq88Zqssncm1NL9Inu8CgcIyJCV/E/QoHCd/GHvNL1tVB/Irmfl
         Cifz/k6BZCza46mEspwqyHIhGnKw0Z62k2jcks8bauIQBmPMKL6E5jVdomg0B7CRHNbx
         aLyAixcam9CKlc3uO6fU7nMIpH92dDuyQkWlsbiGfvdoXSjm8KuY6fYO9XJn/tFYId9G
         Gs6w==
X-Gm-Message-State: AOJu0YwzPabn0ZAcr7Kx+zEbAW7hBRrFIu7fpWRnsMHGWrCYFtf1WhWb
	z4iTMe00pfIgZ7mMyOxCdtMyRAHmO7NOJI7QBylMBYNTzItrxkxffryHn+33emN6WdSr9za60RD
	LXrrPCA==
X-Gm-Gg: AR+sD10ftFHhVDFytrA0po9qHPFOyjeBEkuE2t2SmkQ6YcHFmM2t6DaJ+2rt4ELuAoY
	m4tM07f3m6cNKnCSWfHPSx/zgrDgzEcX/NYvMKoyt80eEsnPd/K7tWA+D2kbR1kItHcBU+kYGO4
	5G72iD4ABcdhbRPcGXUpfwGDimJ7+QmvpXNMOAcUuzG1pktLXsykUJE0ikdpDGnJMxsfWJ3+arZ
	1UE0tBFwS2qL/Sok1+FrOM/Wx8eUdlAtn+GKqKrP5NC+2AtwYiajJ56TZclstbvEWz2wTZ59G9I
	Yy18TvYCkBAr7jFnkS3+f05aW0TgaW5t6QEQUlxW18QoffiQKoulLbExEK1lj4ACzjWt97BorkC
	PdQmLVUKbOd0KB6KTJcq/2BuVZ1/OJ9iGUU6wiphoHAYs+abjDFXLclTmz3auImYiYehjd8jx9P
	p6dEX8rsXz4D017wjLbhI681lPJ8tEJ3Lohq5ca0SPTZDCXHTjSTRb5JQ2wowWtQNmI4c4Ta3pK
	q17mZ8+2/mIA/sE7Dk/NwkLon8jUDSJj5IeCsE5dHXddd+xmKuWvaO/ut9GE21h08cSEqkUAqkO
	p3dQdkJtj5rTddVnTSPGmsDW08BY8anzh891nPKN
X-Received: by 2002:a05:622a:17c5:b0:51c:f04:4aa9 with SMTP id d75a77b69052e-52b4af2b25bmr24058551cf.32.1785498323447;
        Fri, 31 Jul 2026 04:45:23 -0700 (PDT)
Received: from 019fb7fe-45e4-74f8-8902-d177df85f972.local (ec2-44-222-217-204.compute-1.amazonaws.com. [44.222.217.204])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52b4e7ee1b7sm6221631cf.5.2026.07.31.04.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 04:45:22 -0700 (PDT)
Message-ID: <019fb7fe-45e4-74f8-8902-d177df85f972@gosalescloserapp.com>
In-Reply-To: <019fa884-d5bc-7b61-a635-8158a97459d5@gosalescloserapp.com>
References: <019fa884-d5bc-7b61-a635-8158a97459d5@gosalescloserapp.com>
X-Mail-Abuse-Inquiries:
 https://app.instantly.ai/privacy/report-abuse/019fb7fe-45e4-74f8-8902-d177df85f972
From: Emily Cooper <emilycooper@gosalescloserapp.com>
To: linux-crypto@vger.kernel.org
Subject: Re: Yale Blockchain Initiative sales
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 11:45:22 +0000
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8

Hi,

Still curious if managing client calls during volatile markets is a =
challenge for you.

Happy to share a quick example of how fintech teams =
solved this.
=C2=A0

On Tue, July 28, 2026 11:38 AM, Emily Cooper =
<emilycooper@gosalescloserapp.com>
[emilycooper@gosalescloserapp.com]> =
wrote:

> Hi,
>=20
> I know schedules get packed fast.
>=20
> Would a short call this week make sense to explore how others in crypto =
use AI for smoother client handling?
>=20
> On Sat, July 25, 2026 12:13 AM,=
 Emily Cooper <emilycooper@gosalescloserapp.com>
> [emilycooper@gosalesclos=
erapp.com]> wrote:
>=20
> > Hi,
> >=20
> > Just checking if you had a =
chance to think about the AI platform I mentioned.
> >=20
> > Would you be open to a quick chat to see if it fits your setup?
> >=20
> > On Thu, July 23, 2026 12:04 AM, Emily Cooper <emilycooper@gosalescloser=
app.com>
> > [emilycooper@gosalescloserapp.com]> wrote:
> >=20
> > > Hi,
> > >=20
> > > I noticed how the volatility of Bitcoin=E2=80=99s price can =
make it tough to stay on top of client communications and leads in the =
crypto space.
> > >=20
> > > An AI-driven platform can help manage calls =
and meetings smoothly without stretching your current resources.
> > >=20
> > > One of our users in fintech found it easier to keep prospects engaged=
 and schedule appointments even during market swings.
> > >=20
> > > Would you be open to exploring how this kind of support could fit =
into your workflow?
> > >=20
> > >=20
> > > Best
> > > -Emily
> > >=20
> > > P.S: let me know if irrelevant.
> > >
