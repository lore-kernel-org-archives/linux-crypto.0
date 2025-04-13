Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04CC7AD51;
	Sun, 13 Apr 2025 08:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744532445; cv=none; b=TT9IQhwG/Bpw4w4lI1mFE3LsjPfwySQCy9mHhu/HAX/KHVm86emz5NbbzEwamq/EABiCCLG6+dIfJVWB9tp61IpawGWfnunXsbe4GslsCwMLjC164xFAiKSA5uH7kdldE6ZPz4dO9trYBUND/bWXSlNOJvtjISrQBbwBcBM0Wic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744532445; c=relaxed/simple;
	bh=DcWshjfTC1lMC6YXHeeUL4bjuPWPxBzwpr8Rq5Zmfnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bcjQdvYc23kNnmOczl/QVTQhHLt7uqJiZCWeE4WrqcYSo0SsG5yImThplvBK7HX2QkRp8bEWVQRaSJ7XkKZbrQA8S03F0ckF8vQlJ/TAYmIsomkfLLWkW1Pgsgl+7tuMBO8QK1k21xRELrraJegfHHI43LMymVUHyOtv7oRHK8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=exzryWU/; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="exzryWU/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1744532439; x=1745137239; i=markus.elfring@web.de;
	bh=DcWshjfTC1lMC6YXHeeUL4bjuPWPxBzwpr8Rq5Zmfnw=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=exzryWU/R0uk0fdqTP5OPLHzIJm4fdYAX0IolxCopzBwWYsoo+5Pnz8Z07oaUtlO
	 ZJOMwHt+XJzDA9rUjSkKjdWp1TBEEEjiEowI6o4EyVwQ1PDtuBXNzZ0MhhgCothyh
	 HGKRBTPDSfiFfUR9lz6ZZxoSasgRd8V7ZCg1YT7xPabWYQL9YmHt69s4enkwUROtS
	 G9VH4cYchnpEYydNLz5jwMCBeDgGbtb6EuC7Wki1sBL3FtjO1UxaCfmYKh+gtpL8j
	 FX/jverm+icguogZ+pAqDu8HbICHVonIi4ox9qgbzWioLxgLQVKlQf9dtfaIILEhJ
	 QgC1KztyMwYYC31jlg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.67]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MPrPT-1tgxyG33UR-00SVpJ; Sun, 13
 Apr 2025 10:20:39 +0200
Message-ID: <18573488-ca37-48b8-adae-1728712aec0e@web.de>
Date: Sun, 13 Apr 2025 10:20:27 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: crypto: sun8i-ce-hash - Refine exception handling in
 sun8i_ce_hash_run()
To: Julian Calaby <julian.calaby@gmail.com>,
 Andre Przywara <andre.przywara@arm.com>,
 Ovidiu Panait <ovidiu.panait.oss@gmail.com>, linux-sunxi@lists.linux.dev,
 linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Chen-Yu Tsai <wens@csie.org>, Corentin Labbe <clabbe.montjoie@gmail.com>,
 "David S. Miller" <davem@davemloft.net>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Jernej Skrabec <jernej.skrabec@gmail.com>,
 Samuel Holland <samuel@sholland.org>, LKML <linux-kernel@vger.kernel.org>,
 Julia Lawall <julia.lawall@inria.fr>
References: <3727de04-7993-4b81-80c0-adb40b847307@web.de>
 <20250409133610.59d42bec@donnerap.manchester.arm.com>
 <e10ecbe1-d8c3-444d-92cb-647a1c54675f@web.de>
 <CAGRGNgUV6Dq6ZR9bcgomzj1PMQj4vLq9qJCy0dxVd0vQoPWYXA@mail.gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CAGRGNgUV6Dq6ZR9bcgomzj1PMQj4vLq9qJCy0dxVd0vQoPWYXA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:oVb/K4rokwXrOqYsrdIDmqG4XKpI3nnVM8seiRqbzdcw0cNOV+a
 tYO6eLyzCj6OLXXbZMczd3yXVNlYRA6sf6kr5LSDhn3BPJbQiAD2KlXT78QnSyXWnKwwYeU
 gSQ5jAeoUy3PMT/+dp7P3eR+URUZfBNidvEQAQo0PQHhv1Lje+ktvIdd+qFJogodywkwrkA
 8u1H/eG5FM+Yk1KnkhQzA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:DWeY799sZOI=;JbD2Tgww7jyD7iXyT4Kkb+3BuGr
 Os8Bfuzy0I/sbD/raQrPtbMnrxgEsx0ZtqHe7sdNeeEVxxiI4gWeJJMXvE/Zpn2Hw3KjXRACa
 YyIad+snIp9m4yq66JLptCd4Hapi/K0vJcrHIEmYaZHpMDq1kYfGy6vDHtfPqJomNvyZ4H1Ky
 8NCb+nklxF62ydIvesPtZR7wsdsIUcaKJcwUHikcXC4RCR7qmN9Pf2mbBGy/mjvsX/A0t6FCz
 mTlDHeoFonNKEH4BMFkNtB7lY/kpt21dglyRP/8c5onwQv/dx0o/ge4f3JG9Tzay04BQfHA7V
 FVS5pnvdbBGFRW7sx2IADGOdzL6Bzvoc4NSRaWYJSfLbNJcFNV3OqJOHRKV7N9Wt7SnP7KN2p
 3elYK+78v1KjT0474hKuX9iec2S6AILBYtBj6ZWo9uUpAJtYm7fbGqwN/ORc2KAUm/Hb3YbYN
 E9E29MI2sqS/daBcubIyEWyeN+AmZQ4AGgCvSq4/M3TuCmzYkvUCqI4oWnKdxvf8cyH/R4bpc
 xrqRthH9RPVJtIsCdG2aR5hvnC9UfVexc50tl/azRzGJOjcX6PkFMHkZWL6NyHp6dreMHoXpv
 iRVLPDHHpQ2cFce9o5lZ+8eNn1sX2RqS91khwtOEC9pmcoVpEQZeu9jIAK9/qvCqR+0kBkV+d
 rAbqXkiwmuvejYV5Zyp99IHa743UVWwLLcbvo15soJddp5CveU74m8caymlB7jK2ECyqHR46d
 ogcB6efDvvUN32HzjeIrIzvV5RNJ5tu6JsJHJISrNcf3KskYqrYwEnyPtHLFYaHnn0ljCw3kT
 KpT/w8QCYyV2o5PjLQx2NFKvJxaGIxM9Yi/yK7JI+UMkCeLxuGn0DfPzdnnBMaWuXBasyIJCo
 oEVBeGxWj3PXExnJsESjt1tlXh5uIvAbxjuJBoTdZIwod7nwTcw9w4Y5JU29AAjSQ/BbAxShT
 FuK2YyYCDkBu7xi+5C6iI2V+o0CpGLuT8MyHkRkgZ9Jq7BMWroUCSra3f/4jg5kVCXxvEGHyd
 sT5jvKLRyn5z9PaS73Q9I+TCQWuKvoHtMZ0dWzll0YVbM3hS0hrDc81ir0Eigt//neSSmwkx7
 MnZSJ14QReP/QfxJAQjvuNR09i63GFYi9cvNgtZKgCkkapts4srR/6yezSZJoiWvrSzIgW69P
 F3DyRXSu6nL47uI+muhUy7oPhhjv+TtlMzrT472hIDbAYQcgS74r3dJRowDN3ekiCt+AB7ais
 lrJQA6OzBUB3hnsw+x9m7hKACHpINg9d2KUiC+ETJ9k9o7DBSbD6a5WOfi7L4/jHEO5vuI9Uj
 77DIvPwnPMkEdGpkryg/JohEQIZvJ2b9tqmEEYK1xtYSX7Qbu5Fccgb1GpKrnTiCzZx54WBnZ
 kuNGrvpifM3pm2yGcxe5m5BY0FdBsd/vPHhI0RZSw7MprH640e0W0shALykpy+wV9TOaBO0GI
 vO3b+TUAEEmOut5RW8UJOiz+TnklbF17EUGmZo/qR7RJBrux0

> I note that you said you did this using the Coccinelle software. Is
> the semantic patch something you're trying to get upstream at part of
> coccicheck?

Not yet.

It might become more interesting to achieve wider applications of similar
source code analyses and transformations.

Several SmPL script variants were published which are also still waiting
on constructive review for coccicheck extensions.

Regards,
Markus
