Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329A315AACA;
	Tue, 17 Sep 2024 09:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565402; cv=none; b=OeAEYN0rBjOlljq0nploKH6p8svn0Ojay2767b72AsppxomJhtVDlZ93mQeXuBdDDvx/6oGKPDtNAvhtIKInVCXB4KTNUI/rCO9cXbEE7dMYgWAgSxWc8S3AluhhKV1zCciupdcBAQlURC+ECsWR/aci5YqcbkBWFQSm57/JEnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565402; c=relaxed/simple;
	bh=iFsJMuuB6nIdY0B4hTbzSydoeGNar2b9qo5McTeyPRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kZsO6gtIFcoDIsUFy6K+OkVqknGXXBK3zfrXBFvXRcp/nuB9aquy5QUFGRIWXP0jI23bYiHbpmB+9ptBYcvxY6QeK/HbbmFCdOU69o+O1QdP33FlWgytDSz68dQniydtOhl6v0FWt0MWc1Vr88oi6W/aln7Yto7YMdDutw18jkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=d/RGz7Vh; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="d/RGz7Vh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tovlWAhaRbwHQHapoM1FqKG/kEAdaSIHVAEaP5lTn1Y=; b=d/RGz7VhYPWcspHF7RAOe7DgG0
	Wp7NfXtOVjreeBmtZcLsLVXNxJlQJHpJ2xUsopCbqfEMJNNzlpeMji/JppFQAtlY5pfQDKebU2aOL
	C6zE3PTrKLSQltHNm+pSTsoGVREdxWnlBpN8moNcQkxTWR8dwYAzhOkgXoFmymOlep76q/VH2rUuM
	Qm9KCAJwsHiZcB3zKwk/zFenDjiHY2FzT9p2eJ83esbNZc3IT6suWTD9MJcj4r5WvTJZ7Fu32M3yf
	yOXU/KLuivZDt6nMIZet5I2NQTiq5qKRTuXAcKjWVk6Edvx9zjDea3OOpSQv/360OoBOCoHKdsvPu
	78QYJXQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sqUN3-002zHP-2O;
	Tue, 17 Sep 2024 17:29:56 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Sep 2024 17:29:55 +0800
Date: Tue, 17 Sep 2024 17:29:55 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-s390@vger.kernel.org,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: linux-next/crypto: Problem with loading paes_s390x kernel cipher
 since commit "crypto: api - Fix generic algorithm self-test races"
Message-ID: <ZulMEyvIWNtbZJHD@gondor.apana.org.au>
References: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6399cdf3-3bf4-4623-8be6-cd8978d11770@linux.ibm.com>

On Tue, Sep 17, 2024 at 09:31:30AM +0200, Ingo Franzki wrote:
> Hi Herbert,
> 
> we noticed a failure on linux-next in our CI that came in within the last few days.
> We do a relatively simple command to open a dm-crypt device using the s390x specific PAES kernel cipher:
> 
> # cryptsetup plainOpen --key-file /sys/devices/virtual/misc/pkey/protkey/protkey_aes_128 --key-size 640 --cipher paes-cbc-plain64  /dev/loop0 enc-loop
> 
> This fails when the paes_s390x kernel module has not yet been loaded with the following:
> 
> device-mapper: reload ioctl on enc-loop (251:23) failed: No such file or directory

Please send me your kernel config file so that I can try to reproduce
the problem.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
