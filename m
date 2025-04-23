Received: from lithops.sigma-star.at (mailout.nod.at [116.203.167.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBC151C863D;
	Wed, 23 Apr 2025 07:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=116.203.167.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745392521; cv=none; b=jK3i9/6J+dJKkHFxXtlXzLrUjmY1kyJXEAT0xu18Vr9f+YH4VkgWKY02ds03Fg2mO8/ujXxh6ZeRcLpD5N8tgg5pUOTUk78BUHDeLxjHXZyvKt7DdHJrHJOksEdEWM0mx4SS2AaVm5DplN3xpRls2s4tr2xHjZiTD3PhVY+T6ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745392521; c=relaxed/simple;
	bh=7BeiM33tIFbOTRutD30UoZt7L8uwqjMGY6dC3PxiqfE=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=GOLp+2FJz0yiqWrsuP09iGErvzC1CZl5pn6uaBo9nK0Hd2erJNTQgwc0+GVV5LZHhGtaLeYFZJmF1+HA//3dJ/BpGHB8MMvveCnv4xq/hH6Iv84cqxkfuGGzW5EA6u/MrDzkKo4XDKLnj1r8cYkDd1Pmd9RAJAyVV9v3Q8QXLfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at; spf=fail smtp.mailfrom=nod.at; arc=none smtp.client-ip=116.203.167.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id CDA28298562;
	Wed, 23 Apr 2025 09:15:10 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id DZHaED16jdEb; Wed, 23 Apr 2025 09:15:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 71C9B298566;
	Wed, 23 Apr 2025 09:15:09 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id BBTVQAOqKOEG; Wed, 23 Apr 2025 09:15:09 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 43B6C298562;
	Wed, 23 Apr 2025 09:15:09 +0200 (CEST)
Date: Wed, 23 Apr 2025 09:15:08 +0200 (CEST)
From: Richard Weinberger <richard@nod.at>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, 
	chengzhihao1 <chengzhihao1@huawei.com>, 
	linux-mtd <linux-mtd@lists.infradead.org>, 
	Matthew Wilcox <willy@infradead.org>, 
	regressions <regressions@lists.linux.dev>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Message-ID: <1915007212.329812247.1745392508953.JavaMail.zimbra@nod.at>
In-Reply-To: <20250423065432.GA4811@francesco-nb>
References: <20250408082018.GA23886@francesco-nb> <20250422175409.GA877874@francesco-nb> <aAhAylotNK_zHl0C@gondor.apana.org.au> <20250423065432.GA4811@francesco-nb>
Subject: Re: Linux 6.15-rc1 regression, folio/ubifs Oops
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF136 (Linux)/8.8.12_GA_3809)
Thread-Topic: Linux 6.15-rc1 regression, folio/ubifs Oops
Thread-Index: aSEnPblkZA1AkRc1OuHeR6xBDkS3zw==

----- Urspr=C3=BCngliche Mail -----
> Von: "Francesco Dolcini" <francesco@dolcini.it>
> An: "Herbert Xu" <herbert@gondor.apana.org.au>
> CC: "Francesco Dolcini" <francesco@dolcini.it>, "chengzhihao1" <chengzhih=
ao1@huawei.com>, "richard" <richard@nod.at>,
> "linux-mtd" <linux-mtd@lists.infradead.org>, "Matthew Wilcox" <willy@infr=
adead.org>, "regressions"
> <regressions@lists.linux.dev>, "linux-kernel" <linux-kernel@vger.kernel.o=
rg>, "Linux Crypto Mailing List"
> <linux-crypto@vger.kernel.org>
> Gesendet: Mittwoch, 23. April 2025 08:54:46
> Betreff: Re: Linux 6.15-rc1 regression, folio/ubifs Oops

> On Wed, Apr 23, 2025 at 09:22:18AM +0800, Herbert Xu wrote:
>> On Tue, Apr 22, 2025 at 07:54:09PM +0200, Francesco Dolcini wrote:
>> >=20
>> > On Tue, Apr 08, 2025 at 10:20:18AM +0200, Francesco Dolcini wrote:
>> > > I do have the following regression on single core system using UBIFS=
,
>> > > dual core seems not affected, any idea?
>>=20
>> Please try this patch which will go in today:
>>=20
>> https://patchwork.kernel.org/project/linux-crypto/patch/aAW8E9NrKWq1Xk2w=
@gondor.apana.org.au/
>=20
> Yes, I fixes the issue, thanks.

Thanks for testing this!

Thanks,
//richard
