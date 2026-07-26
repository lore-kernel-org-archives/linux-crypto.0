Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C59F3C6A38;
	Sun, 26 Jul 2026 23:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785107666; cv=none; b=tn8B0SqiA933moxDoOwIywxRa1U+7aF2rifMLbSS9eoVxaaDvJNaO3Iyom6f1beWs6tLm9Df8buFCVllyAerHmNlNxzfuW539htcecrZ3qljazEC/J4QOQ8lnJ3qFoDb6DuMEKWeGNY8RanE+ksB5SO9haVCJiLBOK23Z+8TrfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785107666; c=relaxed/simple;
	bh=Ki0i90o4HyDWwWlizaVtdX+QrbWtT4gxFRKniUkqGoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mW0FBOG2qJINUY9HMFuXHgSjWmayBK1kIlp4RfWLJtqdw8tkcLmnpUbyqnbdi50XO3x5SOj32KN5bgISvC2vauHuL9evaObyFlyGN4XILiftF+fx08h3dbNSuSjDCmp1qI6kg3CHfZXxplLkM017fDVFVt9R9xkF/eWZiCHugHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=iixc5rwc; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="iixc5rwc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=6sWviHt4+s2ljpsxxKQS2mLBrk7WK39aokMtfsNyhwE=; 
	b=iixc5rwcHsLBGFUy+8TKBkVd6JaenyaFNZnYJl8Q3Vj4YVzGjhJP74Y6X7hc57hfc5VC7trFoMc
	48ATdoGM9Dzy6do7iUuH3DeSM5kAeckszsEB2EC7WM1a7slEk5dbPDwHSl/mrR0V7nY//I5EnCu/y
	MhZxzeiqVD+nhGrh4w4GNVtKIY+OYRHCu64YtlGS2V36xJ5Xp39AaDEQbhDHO3uU8dTbCJiS4zu+G
	m4qfLNN53LZwV07Lb3b77mB+WJhKurbM2OeGX2woA1t1OF21aHncInNNqNTrQ+ysTlAHLVCI45NEO
	ooZx/we5dbvzQhK53ZykrmuNZdJYRwgdYmfg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wo82z-0000000GyNU-3yx3;
	Mon, 27 Jul 2026 07:14:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 27 Jul 2026 09:14:17 +1000
Date: Mon, 27 Jul 2026 09:14:17 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Doruk (0sec)" <doruk@0sec.ai>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>
Cc: stable@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, sashal@kernel.org
Subject: Re: [PATCH 6.1/6.6/6.12.y] crypto: rsa-pkcs1pad: Don't WARN on an
 empty digest
Message-ID: <amaUyaqDQWmqtY8F@gondor.apana.org.au>
References: <20260720191525.15450-1-doruk@0sec.ai>
 <20260721201114.0012-stable-reply@kernel.org>
 <CAPdMp1rzVAk-bq8wU6wTozXz=2oe1yW2muvoE5EwCa50gsx+3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPdMp1rzVAk-bq8wU6wTozXz=2oe1yW2muvoE5EwCa50gsx+3w@mail.gmail.com>

On Sat, Jul 25, 2026 at 02:04:14PM -0500, Doruk (0sec) wrote:
> Hi Herbert,
> 
> Sasha reviewed this as matching mainline’s no-WARN/-EINVAL behavior
> and asked for a crypto-maintainer Ack before queueing it. The patch
> only removes WARN_ON() for the user-controlled empty digest; invalid
> input remains rejected.
> 
> Would you be comfortable Acking the attached stable variants?

Forwarding to Lukas/Ignat for comment.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
