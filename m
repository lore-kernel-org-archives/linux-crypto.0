Received: from mail.andi.de1.cc (mail.andi.de1.cc [178.238.236.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2C62D7D47;
	Fri, 18 Sep 2026 12:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.238.236.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789734609; cv=none; b=qxTuqscInj/EVWoomFpnxLkkSPdAl34wNeIAqrwkQ4SVHQuPb91iG2fhGhSqrFqMRJcrq+OUf11XotMwExvVgD8zcdhtZeW556p1GTKX1EnzBgWHVJASHSwdP+gJAAwGiOCOZZa5QP0cIZkG8DeWPD3IVFZdnD2EurED9yl6ySo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789734609; c=relaxed/simple;
	bh=q3OtbvxEGcNijZk5ARoz5WxMps7sUrNhmMFGujmXco8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qcu0fpfWRoRg8hLo52FXYxIolQYAaw+ufMDgqe/JtdTwwI1zt+75qMKchghKGJ4iNroa/QjO84q7LzBrjk0NRlr1GTlM0HLpIMGWijWoJx0ivbNo4csE/TQofJ1u88QUjrPcMpibF85Oqua7wvWt066g3a4hbtpAXAFadx1eQSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info; spf=pass smtp.mailfrom=kemnade.info; dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b=UYp9KK13; arc=none smtp.client-ip=178.238.236.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=kemnade.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kemnade.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kemnade.info header.i=@kemnade.info header.b="UYp9KK13"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kemnade.info; s=20220719; h=References:In-Reply-To:Subject:Cc:To:From:
	Reply-To:Content-ID:Content-Description;
	bh=Lob4P2Sd9aJySQ4n/cpr+H4v6scV4EPGCa+LDBJ4F1g=; t=1789734608; x=1790944208; 
	b=UYp9KK13wWSG3qEAO6xtyIexDa9xE3Ma42QG22K7vaaR5u7triE1SxjR70r1huPDVEQ40vJm6YY
	OeOawvbvhwUuDkWATJmmWEtORDfaJfPo6n2/a5AyGk8gytUbGmwYwLJ5ltNWg8hVWkKhB8J+a3lk3
	QXCCcAYHrwiljZ50YEk7TREg7vldBa8Ng/fWhlud0Wi1O0brHqAQCOfn9u5hbqUD1bK8AYVmr5xcm
	937os48hCwQzlMEbE7qVsXCQUEraZC4sElkLzbYMq7yzQFq4nf+8FlaX5fyZQvnfRG5+0piF31sGo
	z0qDbQ86qO4y6W7FF+nxuLL2jEeqHfboMedw==;
Date: Fri, 18 Sep 2026 14:29:33 +0200
From: Andreas Kemnade <andreas@kemnade.info>
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Bhargav Joshi <j.bhargav.u@gmail.com>, Aaro Koskinen
 <aaro.koskinen@iki.fi>, Kevin Hilman <khilman@baylibre.com>, Roger Quadros
 <rogerq@kernel.org>, Tony Lindgren <tony@atomide.com>, Rob Herring
 <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, Animesh Agarwal
 <animeshagarwal28@gmail.com>, linux-omap@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/4] dt-bindings: crypto: ti,omap4-des: Remove
 redundant clock properties
Message-ID: <20260918142933.2f28d31c@kemnade.info>
In-Reply-To: <20260918-jolly-honeybee-of-improvement-601ad0@quoll>
References: <20260916-ti-dra7-omap-sham-fix-v2-0-4eadb60081e5@gmail.com>
	<20260916-ti-dra7-omap-sham-fix-v2-1-4eadb60081e5@gmail.com>
	<20260918-jolly-honeybee-of-improvement-601ad0@quoll>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; aarch64-unknown-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Sep 2026 10:46:57 +0200
Krzysztof Kozlowski <krzk@kernel.org> wrote:

> On Wed, Sep 16, 2026 at 02:29:38AM +0530, Bhargav Joshi wrote:
> > The omap-des driver doesn't use the clocks and clock-names properties
> > because clock management is entirely handled by the parent ti-sysc
> > wrapper. files omap5-l4.dtsi, omap4-l4.dtsi, am4372.dtsi doesn't use
> > these properties either.  
> 
First a simple idea about reasoning here. Start with the assumption that
Linux does not exist and there are random operating systems. using devicetree.
Try to justify your patch that way. 

> This is not a correct reason alone to make a DT change and it is
> explicitly documented in writing bindings doc. If hardware has clocks,
> but driver does not use them, they must be documented.
> 
This is a lot about how to define several things.

Hardware is described by splitting them into some power management part
(compatible "ti-sysc") as parent and the main part. Basic clocking is
described in that ti-sysc part.

But the situation is a bit different here. The clock to be removed is
different from the stuff in the ti-sysc part. So it needs indeed some more
arguing.

Regards,
Andreas
