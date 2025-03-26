Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECC718035;
	Wed, 26 Mar 2025 00:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742950507; cv=none; b=p9uDhC6vqdd6XZyi5ifYQelypd0IvypUvr6BRId/uaH4DjTMj+aIHNv+lgIwqZ1qIqvw7iCHOrj6zMyKC3wIqLhhDRADGQuADQMXEUVn6jm4XWLn3HAx2k4xyzVWW/Kcy86yHMToCbNQzhK+XsuZ5TKG8rYDrgItn1rtTjCpMXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742950507; c=relaxed/simple;
	bh=J6fE6G/0PILAz/SL3d/fYIh5EtLUu6izYMIKeNryBAs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kHIwi06VHJnv6ZsyevinX5Q9sS2k9STQfs5m3XnXSLcLS7D3DCdFOE8l3AjqOIw0dChmNZ9tu40ym2bzDt4J2DHkZ0yVvp7hawnZuKVIaWhz5qEu3akP+KJZBq8A3gkL5ROvGhKsofQuGuoLEFH3mhJ+RIWggGZKnGynqwB19mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=KLrR42kD; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="KLrR42kD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Lgwy/0dOx+jJhSK559Cgt4Aqg+eUzxXhdHH9uJNBzqo=; b=KLrR42kDW2lyUVaeD9Nz62twqN
	69sOKizDa3QAAPnTMVDEcN1uoTXQuZNULFc1Q1JIRdM4lGAt9yrMnYET88rMPiTaJWgj0Rkyy4PE5
	tMdKRM6wseie3AZ49XYEWI62LBLOcDumeR+r8/4dW+br6/cmdiOOZaBuc7ePFKfGbn2Y6tEUzCaoS
	m139mGNywacAK7e4NKscdZsDSwox8Qj8Qg1a9NYer5WQXycZFopET6rNs/CtG28JjNEDk5toFWriM
	DeQf8ZaMkUo3K5RWkO8eW0c/W9+07zPxj7afsQpXdFckA4C9g5BDE3LnaE5sH3Vgn/KhhmFO5x2ap
	PTJ95fWA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1txF2o-00A9pk-2W;
	Wed, 26 Mar 2025 08:54:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Mar 2025 08:54:58 +0800
Date: Wed, 26 Mar 2025 08:54:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Harald Freudenberger <freude@linux.ibm.com>, linux-s390@vger.kernel.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: s390 hmac
Message-ID: <Z-NQYibW4SZGjM6a@gondor.apana.org.au>
References: <Z-AJFwndherQBH2W@gondor.apana.org.au>
 <1aa33386ca1c39438fd17ea651a21903@linux.ibm.com>
 <Z-JntzkWQqc-Atlc@gondor.apana.org.au>
 <bcaa276c-3c26-44da-b06b-4935bc1384f0@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bcaa276c-3c26-44da-b06b-4935bc1384f0@linux.ibm.com>

On Tue, Mar 25, 2025 at 07:10:34PM +0100, Holger Dengler wrote:
>
> I've no idea how to set the bit on import correctly, if parts of the hmac operation has been processed by another cipher implementation. Setting it to 0 means, the partial hmac operation is counters as a full operation. setting it to 1 would mean, that the operation after an import is not reflected in the statistics.

I'll just leave it at zero for now.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
