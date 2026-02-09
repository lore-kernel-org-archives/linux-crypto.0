Received: from mail.venturex.pl (mail.venturex.pl [141.95.86.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA900313268
	for <linux-crypto@vger.kernel.org>; Mon,  9 Feb 2026 08:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.95.86.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770626197; cv=none; b=gBuWpYZ46d0KX5ssqviMF7ejcfkqZMq4hz/BD/2pK2LLfmsEcRRP9Vfa/gR3Oyya4CFdzJtL1U/EOvOTjHWBntzNWvuk6tEcs9BKkro0Dudg4TsBX2fO+v0d+guEFtgsVOUkZmNnilVK8f+8Kyq7/ZqakPOXCjL+/i55tq53QXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770626197; c=relaxed/simple;
	bh=86VIaF2unP4vg5OpX+J8tHPXWoQ8hu3kSDMcmnIkxvQ=;
	h=Message-ID:Date:From:To:Subject:MIME-Version:Content-Type; b=Og2jVUthhBsR62v1uz7Hi31wmigG4BhtFC0ir/Xhsxxp6UwBMZfygADBW3VfgD8lII4FsoUcKyJP5o2Ehgu6BGN133bs1UrKUgHgdttl5ujSyzt5VhjEZkRwGZJIPsjuUE0BGe5eJJI9z4lgHR57MliEYrrGD3zkjleorG3ZfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=venturex.pl; spf=pass smtp.mailfrom=venturex.pl; dkim=pass (2048-bit key) header.d=venturex.pl header.i=@venturex.pl header.b=Lp3Bqn2O; arc=none smtp.client-ip=141.95.86.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=venturex.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=venturex.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=venturex.pl header.i=@venturex.pl header.b="Lp3Bqn2O"
Received: by mail.venturex.pl (Postfix, from userid 1002)
	id 43D1323E8E; Mon,  9 Feb 2026 09:36:34 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=venturex.pl; s=mail;
	t=1770626195; bh=86VIaF2unP4vg5OpX+J8tHPXWoQ8hu3kSDMcmnIkxvQ=;
	h=Date:From:To:Subject:From;
	b=Lp3Bqn2OMc00aHMBK+xR9TptEtDqiSz6mb27y0BnWvsB/GkL2FHemBE9rJmUzDvVG
	 TbHmUtyh5aOMkvf1OUGBAz55rEYHfkBtUfnwyKw3IT12gwaVma2IhjF4hdh62lhDrS
	 pEx+V7rcPGfC40t7M4kB+vr9FwJ2c4iq5h8ZUUSrJwUOEV+KwT9Hy5w8IUqFQzHSOW
	 0hKGS6T/Z/6b/e/jLpLwTV/DSReShSi9JSEZxPRlhAazpdbpzrAdtc2AH9P5KIcYiA
	 r5bZnrHvQj0pcde2+/iGuUcm508aW5yGeDuBnpq/t+tMJ85lxjYYX7/mm0QGZzQfb6
	 9KIS1ECKoSeZg==
Received: by mail.venturex.pl for <linux-crypto@vger.kernel.org>; Mon,  9 Feb 2026 08:35:50 GMT
Message-ID: <20260209084501-0.1.ck.2kiir.0.dhk8h1lo0a@venturex.pl>
Date: Mon,  9 Feb 2026 08:35:50 GMT
From: =?UTF-8?Q?"Miko=C5=82aj_Rak"?= <mikolaj.rak@venturex.pl>
To: <linux-crypto@vger.kernel.org>
Subject: Fundacja Rodzina a optymalizacja podatkowa 
X-Mailer: mail.venturex.pl
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Szanowni Pa=C5=84stwo,

czy byliby Pa=C5=84stwo zainteresowani rozmow=C4=85 o mo=C5=BCliwych rozw=
i=C4=85zaniach dla swojej firmy i rodziny?

Nowelizacja ustawy o Fundacjach Rodzinnych otwiera przed przedsi=C4=99bio=
rcami zupe=C5=82nie nowe mo=C5=BCliwo=C5=9Bci ochrony maj=C4=85tku i plan=
owania sukcesji. Fundacja Rodzinna pozwala oddzieli=C4=87 aktywa od ryzyk=
 biznesowych, prawnych i podatkowych, a jednocze=C5=9Bnie zachowa=C4=87 k=
ontrol=C4=99 nad swoim maj=C4=85tkiem i zadba=C4=87 o jego trwa=C5=82o=C5=
=9B=C4=87 dla kolejnych pokole=C5=84.

Co istotne, po up=C5=82ywie 10 lat od wniesienia aktyw=C3=B3w do fundacji=
, roszczenia o zachowek przestaj=C4=85 obowi=C4=85zywa=C4=87. Ustawodawca=
 przewidzia=C5=82 r=C3=B3wnie=C5=BC liczne zwolnienia podatkowe obejmuj=C4=
=85ce m.in. dochody z dzia=C5=82alno=C5=9Bci gospodarczej czy wynajem nie=
ruchomo=C5=9Bci.

B=C4=99d=C4=99 wdzi=C4=99czny za informacj=C4=99, czy chcieliby Pa=C5=84s=
two pozna=C4=87 mo=C5=BCliwo=C5=9B=C4=87 stworzenia Fundacji Rodzinnej?


Pozdrawiam
Miko=C5=82aj Rak
