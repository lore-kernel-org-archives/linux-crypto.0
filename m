Received: from mail-4319.protonmail.ch (mail-4319.protonmail.ch [185.70.43.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CF38C0B
	for <linux-crypto@vger.kernel.org>; Sat, 18 May 2024 07:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.43.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716016570; cv=none; b=SafjztoNLz9q0ysXfqX5qUaQ9DzibiSEY3+k19R31acSY7WsY5JgW1fB8CGfa41z6jxmvQ9Gu8l9sr7thnd1qbYoMFiuc2xz/wOK5SNeBkVFIoI2O3QAZe1iwnSWw6zF7/uXGeJKy5jATbmQ8uiyZcnXmAfJqEmjeBq6aTyNPj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716016570; c=relaxed/simple;
	bh=jquRv9uiV9BJXsQNiUAElhQ0/Cda7PlUl/ZIqQZp73Y=;
	h=Date:To:From:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=ALE3/VBzqqMJ086rr4u5et98m+UrHxp2pK9BNsmSsf9vl+bX+Y4MgDfuCo/Nc2FgrJzer9KE1NwA2T1o7FxhAVHzS+ELg2JigJFfohJdFVWX5uwZT5Lt3LEmCuUwih7c2YejMSf9NTE1JLNa3nlFM1cJT7N3R//vV6mZA5NDR4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=b7vbrYI+; arc=none smtp.client-ip=185.70.43.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="b7vbrYI+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1716016556; x=1716275756;
	bh=LJ4S7wpEVtZZGstgz1fvYI6R3m57ZgqSG3N/FDoQWxk=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=b7vbrYI+bgD41Eh9z+RoLdpCqMUBorxOt+l0ovMilN+AIvnc7kr9AxsFPQJBamS2i
	 7py7SxlKJMlYjPsNQ80+6G3ZDzqZxXFjO9FW+lBzbL49pgacghH3FCvt5LxD8JPZHl
	 faOe+dF37Yc0PFDt2ZO7eK/C4C3HHICbfcOonpFRWfbOsd5AUbVZscObqNXbZr2AJC
	 5fqEHl2okpAx40Uk6X/n3zzITvPbFVxXj7WDPCJufDWXOKUMO6z5XWBXKz9+iBVnPC
	 VOYi3l1dC85SUAouoDP97rZLMaPCtRYDqiG0B19AoI4kcQxIT8wmbpEE2gnMTUw49o
	 pBx82M4JXk9ug==
Date: Sat, 18 May 2024 07:15:50 +0000
To: Markus Reichelt <ml@mareichelt.com>
From: Jari Ruusu <jariruusu@protonmail.com>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Announce loop-AES-v3.8c file/swap crypto package
Message-ID: <cgKV88KvF8ANwKPkXRSw2bQsBGm4m0oSdZ0xN8XAgoBgr_BumVgZ41z5yg4d357IIkl6245h3jjg5gMUr6n-14ehAMbSLpP2RcclvA3KZCA=@protonmail.com>
Feedback-ID: 22639318:user:proton
X-Pm-Message-ID: 3f13546f839afaa5424439154209c33fa7ddd3f6
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Markus Reichelt wrote:
> * Jari Ruusu <jariruusu@protonmail.com> wrote:
> > - Added assembler AES implementation for 32/64-bit ARM for kernel patch
> >   version only (see kernel-arm-asm.diff). That assembler code is not in
> >   externally compiled module.
>=20
> Is there a reason for that? ^^^

There is short explanation at beginning of kernel-arm-asm.diff file why
it is not enabled by default... code works for recent ARM processors,
but not for older ARM processors. As such, it has to be opt-in to avoid
breaking existing setups.

--
Jari Ruusu=C2=A0 4096R/8132F189 12D6 4C3A DCDA 0AA4 27BD=C2=A0 ACDF F073 3C=
80 8132 F189

