Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A19134400
	for <linux-crypto@vger.kernel.org>; Thu,  6 Jun 2024 02:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717639314; cv=none; b=hB6xZezWkjYmbcX+EaD3L9fENifViUThrr5aBNb4slMstXn2PE6+7LLrivg2NRoi5/8DweYT+iOcG9cIz+BH8l3hHdIwHyAAP1U3oYN62W4yLUxuWlLK+8NzTd0sJCrm3fgKoaOGl8cyb/lTfcwFTU3QoeTySIURgY5J40Yn6bE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717639314; c=relaxed/simple;
	bh=m8dZ++P6q53RssFxY8sGZurmJYlynMrS5G5iChVBJBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sM4Su8IfUjR5pXGF3hzURApTEe1Pqxoq4hTHSaT9SVkNmNmIsh3Lf4OUeioj9Lrhzmqw0D7K/1JN/Xk/yCUJc9esVsxaNTVV0OEROl9I63cePeHccE0sIlHXfwZxEPaoVMxNjbJIbQPMrmuKR6MNFc5Qwkoyuv4JTUQ8C+4q76M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sF2Rk-006Dnq-34;
	Thu, 06 Jun 2024 10:01:46 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 06 Jun 2024 10:01:47 +0800
Date: Thu, 6 Jun 2024 10:01:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, vigneshr@ti.com,
	j-choudhary@ti.com
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
Message-ID: <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
 <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Wed, Jun 05, 2024 at 06:12:22PM +0530, Kamlesh Gurudasani wrote:
>
> The way I understand algif_hash calls the digest function[0] if entire
> file(file whose SHA needs to be calculated) is less than 16 *
> PAGE_SIZE(4 kb for us) 

If that is the concern we should explore increasing the limit,
or at least making it configurable.  The limit exists in order
to prevent user-space from exhausting kernel memory, so it is
meant to be admin-configurable.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
