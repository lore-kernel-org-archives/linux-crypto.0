Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1363B9;
	Thu, 10 Apr 2025 03:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744256923; cv=none; b=HkPyN82yJA7DynLurExEF/SFbCnQdT0C4xmy+T3AZeQyBcH/1AiyDuCFWh1KoxbxmXrzJOkKOkIGYPhC2rb+XKpROL6SFnQkDdlHpMpefpARiJvZH9oFMywQeW2BsEoIgh2U1Z9dZEHaGNOHyZvR6Q5vBaQJWOGzGoFiPHMfmMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744256923; c=relaxed/simple;
	bh=oMApswGtdJIv7A90BojZG0HS4JTsBoEXPsSdK8VBUhg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RsVbuSH4vbkVx7acAGpF0PQWAAmXcdc5lDo94mv+KWQ0+w2P9dy22vh7v2pC0CkmPp1pnGBqu5d/v3TfUulpzQqjDaxcHiIhIHreWFAzQTt+2KrsESSuGFrQ6hucm7XK+J6YmFYzlyjKyvIAgNy/pdfDJoysNPilnv/uBaN5N2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=htZtMLUj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="htZtMLUj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mP9JHWc0F/ypDEA+qI4URem1tBJxVJMkRZIpFfnYXmA=; b=htZtMLUjtOdEJNyOkU6JIhuxBN
	K+yfQocgzGvePasuAsHVX8Sd4CEn2f9lYh8LkwQ8d7KMzQaShDCXzc/VsvCCxS9td57TsgRjz26yJ
	bYAj4eOatF2ARK5QVhR9WvI/IAD3UKR8t3pC1Q+bLID0VnnVmpbNMbhtkfoyFXseD8HreYHldsAcc
	g3a6vzrr3Lo+1VWJpPDL3lYfH7jmaPN2UdudwloHcp6XfCu+f9LJVOMKK30/wLsXtB7aHZu43NN/Q
	lYlODLlY8YquiVTdVZeBp30xyxnT3kvYY/toBFm2tHUpG1Up7BjNiaTADHliTWK4UZmrXSdlitrKT
	STjTgZSw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u2itr-00EQ8O-0C;
	Thu, 10 Apr 2025 11:48:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Apr 2025 11:48:23 +0800
Date: Thu, 10 Apr 2025 11:48:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
	linux-crypto@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: scomp - Fix null-pointer deref when freeing
 streams
Message-ID: <Z_c_hzEyvlqA2aJP@gondor.apana.org.au>
References: <3c239727-6c46-45c2-80e7-d6853427f72c@linux.ibm.com>
 <Z_SkEnIWk8E0mLJf@gondor.apana.org.au>
 <70ef4489-dc7c-49fe-ac8e-fc0fd58e2bab@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70ef4489-dc7c-49fe-ac8e-fc0fd58e2bab@linux.ibm.com>

On Thu, Apr 10, 2025 at 09:15:56AM +0530, Sourabh Jain wrote:
>
> The above fix doesn't apply cleanly on next-20250409.

It should be fixed in the latest cryptodev tree:

https://web.git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git/commit/?id=5322584385d938773cbb562db64d8423dd5fd026

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
