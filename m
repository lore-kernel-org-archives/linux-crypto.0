Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793963611;
	b=F0jomTP4/U2qlMpUM2n3EAHSOlOuWsAqxRiw6NeHPwrlwR9O6gedHpNdR5ODZpjK9L5P
	 SmSygZ2Zvol2dFwlcGTNZWZvOAoKb3UQ/hTPiAHKFAG8OLeA9fumfLwHnF3rw97Qher7M
	 8VHadqO8CAtMFfDYXDKxKYXy8/lk55ckMSJFc0tizks1xwbQkCR/b2YW0AR6LyZfMYcCh
	 rdB2VMiFNsc+v8Z1fuZEKVUCJ4H9upxVLGht3FcaWdg8k9nbdKHSQE62LwUWV5agZyIi8
	 +Qp0zzLjn63KSefoylSdBH39nO+e7tEhxVhRU4vWj/IEmneOIzqFJ1YALVlaHSDHK5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793963611;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ODNMsiZEnMLL1WYjHMau2I/sXNI//hE1fIb6cUY+iEA=;
	b=P4YLWiHuHX4pFfW2KSGyhxh5ybtsGqFqKMO8GTw1dUOnFrHyIRnEjnDtoty64nGwWfMw
	 4rYPjy2HuXpj3pFi0vyF8fG/lpmBL7fPQY2uit7KZ8HI/6E7BdB/Hva4o1avyJGECwWBo
	 +xj4XIKsqmP5LX/WDM/8yUhVeluuXawuN59JPL1pAmIbT0BHyflLu4TXVw8HaqVYgJFg0
	 SsO/slFQG7siH7uq48WBWiefkbMNvzI7xtPJVTQy4QdnsGmnwftmusco3GkfoExAV9isl
	 P6MECWiEuZO2zMlm66J9IgcbvNUpfXgRbhlZKst8sOQ8wtW9Vg3y+ReYghAk22PCnsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b="h/fmb8Gm";
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D043B606A32E;
	Fri,  6 Nov 2026 11:13:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D043B606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=h/fmb8Gm
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ODNMsiZEnMLL1WYjHMau2I/sXNI//hE1fIb6cUY+iEA=; 
	b=h/fmb8GmQc1Fla6JbkPYof8s9i75M3yP7+nr7gPaiL8l0dqoXxrJmZ4o46FkqWeStg+ZSj57iMG
	OnNPu/DjYYC0IBmM6kdormy0ShlP1QXnEeEC0PTVEgcHt2SpK32Uy/NzG3WzCFeSDA6hkDceRFoiC
	HUuG+nmcGdf/5m7FAYpYZToDL3bQC7N2hURGm9WhdySSs8cIgv928yRAxGiSWZZG18fxri7VxzkID
	qv5OD5moqRXd7k6peEEUAC3cgZO0aRnhTqf+C/jEdY9ruVV7dw2kR4Etd4MVc2zk0MfXksnykLijC
	ch58GzBk+GqpDOeJjbti1ZvokrwPHhznlQ5A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xPHss-0000000BqWX-3fXC;
	Fri, 06 Nov 2026 19:13:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Nov 2026 19:13:26 +0800
Date: Fri, 6 Nov 2026 19:13:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Sebin Francis <sebin.francis@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Vishal Mahaveer <vishalm@ti.com>
Subject: Re: [PATCH v10 00/15] Fix several issues in DTHEv2 driver
Message-ID: <au22VnPj-y7cgSYS@gondor.apana.org.au>
References: <20261016124456.1802080-1-t-pratham@ti.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016124456.1802080-1-t-pratham@ti.com>

On Fri, Oct 16, 2026 at 06:14:41PM +0530, T Pratham wrote:
> This series fixes a handful of independent and mostly benign till now
> issues in the DTHEv2 driver which were flagged by bots and AI agents.
> Except for the fifth patch in this series which was found in an
> internal testing.
> 
> The Sashiko review on DTHEv2 hashing driver patch series v5 pointed out
> some pre-existing issues which needed to be fixed [1].
> 
> One of the issues had already been flagged by kernel test bot and a fix
> sent on the list by Mert [2].
> 
> I included this patch in this series with minor edits. Then the Sashiko
> review page for [2] had more comments [3]
> 
> Overall this resulted in a bunch of fixes patches which would have
> deviated the DTHEv2 hashing driver series had they been included with
> it. So I clubbed them together in a new patch series which is this.
> 
> Signed-off-by: T Pratham <t-pratham@ti.com>

Please respond to the Sashiko comments on this series:

https://sashiko.dev/#/patchset/20261016124456.1802080-1-t-pratham%40ti.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
