Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 167F13C1414;
	Tue, 28 Jul 2026 07:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785224138; cv=none; b=NML60LTvYoSysL81P5cc/ckOJadpY37iStPp2yZ9pWeYJplRQISj3HESKBqNN5mMRphC/6UTjLZAQrh5vOBPF69XREav0q036tq5jubC4iw20DJOHB4mE7mnJD4/rR1bmccC8LNEqsD2fblPJpDUJ62Kvl/AX+BuVK0WxD/en6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785224138; c=relaxed/simple;
	bh=HbhUB1lLYVWyaxXnYEznAQBkDv8JbJ8xzLjj7c1gMZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iVMIuCpx1m222dpJLvojCC1WNE3wuirVLZzLtOr9maW5L4DuL9mPrn2We++Oz8D9f0eIC8fJ4ELMB2UnPSBT0DMWBq0jRCW2XoQncGO+RptkxGBv2pW04Qy/D9imQrBjqOcYrC8qn7+zgbW8FzCS5IuSE+k2qICEY/xJXw08iqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=mG4V8vAK; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="mG4V8vAK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=aFgcBf0jw2mdgDHJU0EsTttc+2aTxGficXRUXpvl2RY=; 
	b=mG4V8vAK0kq8SRuy1pdqAdv8TqoLCfBD2EDDVRpwwqujGulFcTPgmJmylbHbdB3AyDt82SfdAZI
	DmBuGJmPSYJ9yLgzEZjWtrP7mjG+s72keLNNEVPeucyrZqS3xsru4Ru0kUBxlM8C75mavbBsSwQ28
	G+0srjKvNyyOCO7Kn00Tn3sRmUMZGIhZV2p1/LXiJ+UPpI4UpHZbyx57dn1YuAJWk6R7TjV4y0Wc7
	anKxYYfk3lx5LPTWVbEb259VVWB5At5I6AVx04zdCe/fAXlDYMrnGVwDpxroYH5uVFfZ83cWxttSF
	zhXTclW0cYB9KTceiOh+0N/aAFeOzbTLiPlw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wocLP-0000000HNHF-3cI3;
	Tue, 28 Jul 2026 15:35:20 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 28 Jul 2026 17:35:19 +1000
Date: Tue, 28 Jul 2026 17:35:19 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thomas Richard <thomas.richard@bootlin.com>
Cc: Olivia Mackall <olivia@selenic.com>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	gregory.clement@bootlin.com, richard.genoud@bootlin.com,
	u-kumar1@ti.com, a-kumar2@ti.com
Subject: Re: [PATCH v4] hwrng: core - Stop/start hwrng_fillfn() kthread
 before/after suspend-resume
Message-ID: <amhbtwboWHXKaBZU@gondor.apana.org.au>
References: <20260713-hw-random-fix-hwrng-fillfn-crash-suspend-resume-v4-1-b5fb4c520b05@bootlin.com>
 <amaef-KUBBjOcyMH@gondor.apana.org.au>
 <d0d77fe9-d806-4ecf-9e40-7ddab8dcac45@bootlin.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0d77fe9-d806-4ecf-9e40-7ddab8dcac45@bootlin.com>

On Mon, Jul 27, 2026 at 11:30:41AM +0200, Thomas Richard wrote:
>
> Oh yes, indeed Sashiko is right. PM notifiers are run before user space
> processes freezing.
> 
> What do you think if I lock the rng_mutex at the very beginning of
> suspend and release it at the end of resume?

Wouldn't this just cause a hang if said race occurred during
suspension?

Ideally, we want the sysfs store to either result in an error
due to the ongoing suspension, or at least fail silently without
affecting the suspension.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
