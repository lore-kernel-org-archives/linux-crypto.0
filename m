Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7EFE274FC2
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 18:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773252948; cv=none; b=Zc/apTGl2LcY1k0CI9jFf5tbjUxHu7k4LR7LmQUMy9W5ocJ0CynO898xuNoj8qCJFeCNAuHlnYKxRSPI/IGJZPRCqD2GSZ4Lwri71bUb0Lv50SLabWKSwVYsPZEeE+vzqJLzMp9ZGZzwRBYoZOIzqW+C0vPNyZcEYaXtcLVKVW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773252948; c=relaxed/simple;
	bh=Jjq49ouwOstajWDDHsipi40+8r2DGwcxFw4hkhofWGU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=YY+qOv2fvQ+DMQiIGNOdHosbo99W+AcKfW062fFZHLowDGh/WeJuRzEoLsbKCSjbHQZ0+NmlBjG6d/s6e6Moy5fcagL8GL/iZmr+g3W5LQ7r2I0a6wiH9JOaR5TKb8gFPD4fyDcLEwT3WBclNJxpIIelAyyOdj+5dyh3WvRHJsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YRmUOewu; arc=none smtp.client-ip=95.215.58.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YRmUOewu"
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773252935;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Jjq49ouwOstajWDDHsipi40+8r2DGwcxFw4hkhofWGU=;
	b=YRmUOewu0aO319izp478Y0xTx7rGxwboIxXbrhev80N21WY8O3DvaGE9epGDrrLNs7li+F
	WhBuL59DlXs0ZajuRcVMtcd9oTzASTPmzKWa8Wl8/x1K+qfm/+5yPjHZzKrJ3VxI0ARc7h
	gL4aIP6QSdvrgtldxvJBfntRA77FeRo=
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81.1.4\))
Subject: Re: [PATCH] crypto: nx - fix memory leaks in
 nx842_crypto_{alloc,free}_ctx
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Thorsten Blum <thorsten.blum@linux.dev>
In-Reply-To: <47dd8932-7347-4744-be8d-79106bc76f4b@app.fastmail.com>
Date: Wed, 11 Mar 2026 19:15:00 +0100
Cc: Haren Myneni <haren@us.ibm.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Dan Streetman <ddstreet@ieee.org>,
 stable@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2169F556-EB9F-449E-AD21-BAB1D34E81B7@linux.dev>
References: <20260311150922.382941-3-thorsten.blum@linux.dev>
 <47dd8932-7347-4744-be8d-79106bc76f4b@app.fastmail.com>
To: Ard Biesheuvel <ardb@kernel.org>
X-Migadu-Flow: FLOW_OUT

On 11. Mar 2026, at 16:16, Ard Biesheuvel wrote:
> On Wed, 11 Mar 2026, at 16:09, Thorsten Blum wrote:
>> The bounce buffers are allocated with __get_free_pages() using
>> BOUNCE_BUFFER_ORDER (order 2 =3D 4 pages), but both the allocation =
error
>> path and nx842_crypto_free_ctx() release the buffers with =
free_page().
>> Use free_pages() with the matching order instead.
>>=20
>> Also, since the scomp conversion, nx842_crypto_alloc_ctx() allocates =
the
>> context separately, but nx842_crypto_free_ctx() never releases it. =
Add
>> the missing kfree(ctx) in nx842_crypto_free_ctx(), and reuse
>> nx842_crypto_free_ctx() in the allocation error path.
>>=20
>> Fixes: ed70b479c2c0 ("crypto: nx - add hardware 842 crypto comp alg")
>> Fixes: 980b5705f4e7 ("crypto: nx - Migrate to scomp API")
>=20
> Thanks for the fixes.
>=20
> Given that you are fixing two separate issues that were introduced ~10 =
years apart, I think it would be better to split this up.

Yes, good idea. I submitted them separately here:

=
https://lore.kernel.org/lkml/20260311155645.397083-4-thorsten.blum@linux.d=
ev/

Thanks,
Thorsten

