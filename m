Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E472D6E5A;
	Thu, 15 Oct 2026 23:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792107353; cv=none; b=JCuEaPgABgygZdPWh01RTsCtMRVwGcDnZYQkjDbYRABPfWhc3RhP3Q5z61wbL18NZhZxGTk8KlYpDWFJSjrWDDUsDg1fu0eEA2necI6GuoeY3xUnNBZ5NxQxnnxj6K0UV40wCi+5Dt8PGrXEifjaXJ2ALpcCv6tEWSS3Bq/sdl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792107353; c=relaxed/simple;
	bh=N7czH6+JLYrWxXcHEUM4jxxOLhrUjvJHxqXYf8G3ogE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=um1bfHcCgI2DD+zVfEPjzIjNh66Y0Kun/SrQpmmLFISL7yM3Eofwfv7WZ0/QHUhqM0OENGxIC4gbMRZf++5H9rO10Krx1IRnti282XrCjaYIG1b54f50vvZKqJfWbHpyHcKcH8Ae2ZuRtFEtPWmqxC/Wq81ycWiILU1ULEUCBuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=gLlvYTtT; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="gLlvYTtT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8c67trtbYLUz+kHNyrCvGZuh7d67TMpmPIUzcyzL3qk=; 
	b=gLlvYTtTTIYlO3YICGxiIeZXLvoQTq4yJzTHbCZIiquqlxZSCtWjqRfepqJSmCOxJOqj9N370vi
	sD5OQ07f/bOu7kdtiYFW3bBg3RPETEtNpP5HbJAHJUC65S/ADTWqUzi3If5j9Hhm3txd2lPeCHHwS
	FFjmn2OEuQeiwmRV6R9JL8yfVUx6ELwoKGf+ShV/UuNKoVyr42hxeGIKi9sMDmoS8KjMRtWtDaKxY
	z33AjDxyMtkREoDx82ndhe1lsgXyf1o0OKMIDwPhkPysOZFrES9ipk1dKppIg+5WstV+Ee0DZnPs6
	QDYFZjHeZaAADMhfhkqTG4rhkHWqsrY5MdHw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHUz8-00000004MBZ-2IBY;
	Fri, 16 Oct 2026 07:35:43 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 10:35:42 +1100
Date: Fri, 16 Oct 2026 10:35:42 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: =?iso-8859-1?B?Suly6W15?= Jean <jeremy.jean@oss.cyber.gouv.fr>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: essiv: fix use-after-free in AEAD path
Message-ID: <atFjTsVQSe5z-kIQ@gondor.apana.org.au>
References: <20261015121743.3151400-2-Jeremy.Jean@oss.cyber.gouv.fr>
 <atDE7dqBGm63pkde@gondor.apana.org.au>
 <32b563fa512a97b653bd06bc9bfc0ce0@oss.cyber.gouv.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <32b563fa512a97b653bd06bc9bfc0ce0@oss.cyber.gouv.fr>

On Thu, Oct 15, 2026 at 03:33:45PM +0200, Jérémy Jean wrote:
>
> Indeed, you are totally right, this is definitely simpler, thanks.
> Do you prefer I resend a v2 or send a v3?

Please resend a v3.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
