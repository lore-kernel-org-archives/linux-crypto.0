Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513BD54763;
	Thu,  3 Sep 2026 07:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788420974; cv=none; b=IHv9cFgA6LwpK/lrdhhr48cxTiXfszpjIbh9u8PMY2fosMNwfSIvGMwr5LFNvdqJSLal2fmeX6n8DS2VpsEuTu+gj72QwE9QSHA2Bt0XfNak8SOjvH69Du3fYjTvzoKKFk3f1W4pdaLXm+4vPzVfqDnTKCxXEXFcQeLyUF6hThw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788420974; c=relaxed/simple;
	bh=38ngV1LLtJsF2T6Dvd5c/D9qnUaMy7ezGOmNL2qgvU4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fyMgUwKVYy8HBXhbApSA2pVSyQmsNif+smIkzxZzpzON8pnNfmm6gFLL78wJFv6KbCbvsYgdQXkeIRrBsk9ffZ7M1LHkQSlWKh8iJvrjMxm1gjWWW167wBahBjWu1Pua75QZzlg/N+MNA4sXpFyEqYwuMTcVwHvZs4RxNQ4BaMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=OxtpLIsj; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="OxtpLIsj"
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hbBGw1d6bzKmTr;
	Thu, 03 Sep 2026 09:36:08 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1788420968;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Pc/i3R0EsXUJAT9pg0+rOwqYu4pBq73rKzE1QpfopW8=;
	b=OxtpLIsjA7dmdhW4ZtU2eVetk7xtkvucKCvf0IpwuBWmFWJX8U2WmyyPU2SiutjZQHqlvy
	UalX1wTEMs2DYOkRJGbjtrDiClXWZu6fnB2e6Qz+v9K4blKnEHFJyGPxN0sRdDuiafZg44
	+mlojOVhvK0wJe8txf3wg44RUsE+GD+Bhy0znABmaM20chgQLaA/90r7bsczJwKPaWV+g1
	PmwmDSJhEw+XeZ8KmU89vQCtQPRfvC8Vmkz7Rq3S2/g2oha8xs0sAVmzau54zvXolu8UDE
	5NAP1gq1Z7+qfnnKFWTrGmEAIQyZS9Oyt+56vdjZYJB9f+/R345dGIaIogGR8w==
Message-ID: <4695582913c5f171a1b887eb0e3d2d4883d319d5.camel@mailbox.org>
Subject: Re: [PATCH] crypto: arm64/aes-neonbs: transition to kmalloc_obj()
From: Manuel Ebner <manuelebnerli@mailbox.org>
To: Kees Cook <kees@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"	
 <davem@davemloft.net>, Catalin Marinas <catalin.marinas@arm.com>, Will
 Deacon	 <will@kernel.org>, Cheng-Yang Chou <yphbchou0911@gmail.com>, Eric
 Biggers	 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 03 Sep 2026 09:36:02 +0200
In-Reply-To: <202609021314.8A9C0B8@keescook>
References: <20260830101714.625728-3-manuelebnerli@mailbox.org>
	 <202609021314.8A9C0B8@keescook>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MBO-RS-META: s7pfz4jjsjbq71k4ut1jabpb7qjd4p8w
X-MBO-RS-ID: 0a912c93b982c91050c

On Wed, 2026-09-02 at 13:17 -0700, Kees Cook wrote:
> On Sun, Aug 30, 2026 at 12:17:14PM +0200, Manuel Ebner wrote:
> > I have a couple similar patches lined up but they could be automated or=
 maybe
> > the script is already made by Kees.
> > Kees can you make a script assisted commit (again)?
>=20
> This lead me down quite a long path to try to figure out why the existing
> Coccinelle script (scripts/coccinelle/api/kmalloc_objs.cocci) didn't
> catch these. The answer is the cleanup.h macros and poor interaction
> with Coccinelle. I think I've got a work-around built now, and I'll send
> a new tree-wide change to Linus before -rc2 gets cut.
>=20
> Thanks for noticing these got missed!

I think they got introduced after the big '+_obj' commit, this commit 652a3=
017c485
("crypto: arm64/aes-neonbs - Move key expansion off the stack") is from Mar=
 6 2026.

I did git checkout this commit and run checkpatch.pl (from Mar 6) over the =
commit:

WARNING: Prefer kmalloc_obj over kmalloc with sizeof
#37: FILE: arch/arm64/crypto/aes-neonbs-glue.c:82:
+       rk =3D kmalloc(sizeof(*rk), GFP_KERNEL);

So the recommended workflow should have caught this.

Thanks for handling this.
 Manuel

> -Kees
