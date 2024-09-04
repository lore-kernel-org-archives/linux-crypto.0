Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF6A4A15
	for <linux-crypto@vger.kernel.org>; Wed,  4 Sep 2024 03:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419319; cv=none; b=BoN78qw3elTVDohgOF0MOdkvA63xUYqK8PV6YJGkHr3oG4+07aWJ18ICLF30PaTYRFDIWsHA6fuqrn3WSCp5JgTXltXgbtakBa9ici0NbBxbhgmkJBkBXdBpxKeoatYj1iFVmaN5Sd1RZEv2IquPJDJq1dy5rKOM7/OlHi9Z/ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419319; c=relaxed/simple;
	bh=aKCpT90NikITKcJlSn8eZ/B66JR6yuQTj0DJM7z1aNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FqGHFSLpjLzSPAf9qnRpRAdYJBbw22SWdzLzIy0KxvS4Qp9Y+MXJWRPvYpDiX6gK7mxTqZwj2UvHZ3Ov4s47OPIa/v2snSrRrjZfYUnLenMebW732/OWIgtw0HwPd6w2jAOzl+az6fx2jsgrRjJgxKN6OdLOkFyGzP8czhoUtm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mdhs0ENb; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mdhs0ENb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0AFme1x6TP1gudb7RdiQk6LHYTvh6CEw5EDi9AlqncE=; b=mdhs0ENbOpCk7RLD12z8IIo/6i
	WC0scXH/kEHB0vSg+WwuMZ784ZMSLU8DXgfrzjfiIiujkUrSVwbarR1+z5aP+clMowILoGvu97nPz
	C0UEoVBDB9qGuRGlvcg+AwTOw21ZHwOuqTsASUmIKPnwEFsl8el8EdByV/SEN60ix3JKflMpDJvAC
	2ok+QJbfzhf1wG0o28Ibvf0Mt7NwtClQ/OKe4u+HMPiRqxahUFJ1FyYeNqDrwRuEU3jFm6jlVEwHV
	9Y3aTJRDNor4LAu/YbDlP5lupmVjW58TI9T6RmQ9jsZypwFutbj95nDHqg9+pQi5yUZLPLnl2Nf08
	lD/jpiIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1slgNe-009VzS-1l;
	Wed, 04 Sep 2024 11:08:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 04 Sep 2024 11:08:26 +0800
Date: Wed, 4 Sep 2024 11:08:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: Rob Herring <robh@kernel.org>, linux-crypto@vger.kernel.org,
	Ruud.Derwig@synopsys.com, manjunath.hadli@vayavyalabs.com,
	bhoomikak@vayavyalabs.com
Subject: Re: [PATCH v7 0/6] Add SPAcc Crypto Driver Support
Message-ID: <ZtfPKi-qDD_uJDx7@gondor.apana.org.au>
References: <20240729041350.380633-1-pavitrakumarm@vayavyalabs.com>
 <ZrcHGxcYnsejQ7H_@gondor.apana.org.au>
 <20240903172509.GA1754429-robh@kernel.org>
 <ZteU3EvBxSCTeiBY@gondor.apana.org.au>
 <CALxtO0n9gjX80tGEFtA_6FH+3EtxuVje4Ot58WvQXXNtDwSSkw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALxtO0n9gjX80tGEFtA_6FH+3EtxuVje4Ot58WvQXXNtDwSSkw@mail.gmail.com>

On Wed, Sep 04, 2024 at 08:22:31AM +0530, Pavitrakumar Managutte wrote:
> Herbert,
>   I am pushing the DT bindings.
>   We had a crash with the changes, we were root causing those.
>   Should I push the whole driver once again or should I push just the
> incremental patches?

You will need to start again from scratch.  Please make sure
that you include all the fixes that have been posted.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
