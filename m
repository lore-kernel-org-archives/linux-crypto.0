Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3594B1E44
	for <linux-crypto@vger.kernel.org>; Thu, 15 May 2025 02:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747274961; cv=none; b=guhxnoN08SuT5uWAtxHlrBbLi+ZhJPYPg0aHt6qI1RjcS5w+Xtbn3tywlzj2n5LZ5GV/rF88sv+3k0q22K52M+xqlUP50BoamrinpMehGqesdAMml5zg/RFatg3Sz5HFhXVZ+F70QWt2cZ6p6TGrGYupruxtqomlmYSET7xauoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747274961; c=relaxed/simple;
	bh=IAiF7whJ+rcewLcMkSR32uRk0x58n9q8wdLO8oURcJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vjf39doqVFHc3U+wjsRJxkb+uflrgKa2q9WmwrRKYGAlhdlF7GinwCwN2rPfGGPskrjOqh0jSPNrHQQrpu2mVPdD+UTIh/RexpWqFMlPEVAZ8F3sFzXKhlqLz5mY5uvkELyqeDHNofcoTaLq29ufgGZxfNPX09tSXLf9sMn5KZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=gs/cEs9I; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="gs/cEs9I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/q90LxAEV4nFcnjw3KvF0jRIAtxReFJIP0D5oZeGi/E=; b=gs/cEs9I9kws1Qf6orrQ0Y6Isa
	phompdiXjgqISA49VjZXY+kAZJNv+WWOi2TVYMhMSZCTAwJk1mciJxtFQ5vUGmRPmCADPrZozYJl1
	c51Eu6t+tnjr4wxSApKPA4dWbEnWsTQnAsPgPYaBI+wanDrAdotNn7N8n+dSt6kOTcvPtnKxYYZYQ
	uKnj85Q4xrT6eNfjKYTcyJAGz1Wv9yAApDkioQcFn8uk091k3M4e9XkRhblDU+urkbB4fyl4qW+ba
	ceIP59uAzj2asDA53zUYKWB80dLYDl+1KmehfmzzgcBW+xIN6H4eTcSgr7TtzI85FekNJuKh2McX7
	7LxhSvAQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFO20-006CfN-05;
	Thu, 15 May 2025 10:09:09 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 10:09:08 +0800
Date: Thu, 15 May 2025 10:09:08 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Eric Biggers <ebiggers@kernel.org>,
	Ingo Franzki <ifranzki@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>,
	linux-crypto@vger.kernel.org
Subject: Re: CI found regression in s390 paes-ctr in linux-next
Message-ID: <aCVMxAaPW48_Hvm2@gondor.apana.org.au>
References: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ee7489d9b2452e08584318419317f62b@linux.ibm.com>

On Wed, May 14, 2025 at 03:38:36PM +0200, Harald Freudenberger wrote:
> The nightly CI run stumbled over an selftest failure for the paes ctr
> algorithm in the linux next kernel.

That's strange.  AFAIK paes shouldn't even be tested.  Can you
show me what the error looks like?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
