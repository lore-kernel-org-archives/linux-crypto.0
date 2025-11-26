Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975774C9D;
	Wed, 26 Nov 2025 05:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764134188; cv=none; b=AhFpAiYZ08xFfAfaBGRKeJbO+2lWJsLi9iYntxKZaZMYzAFsIIP9T+r8VNR7ED6Y9c1QDkktyGQmIBxxNGXO2fF85wZjNM/nx5FzjH92VJNXtae1o0uEh4QNiQIPDst7YrNuDujDTaxOSpnFg8K9x+PwDMJb83GfqqbuErJGhQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764134188; c=relaxed/simple;
	bh=KwCJFNdunM+WCQ7GYq8a4nZKbvgFCToND+WAn2yV22o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ac6E4a7FbIDCTYAJ8A4kl1l794ZVIj6u5doUZKRbxXtK56UoKR+0tlEhpgCJk0GBb55TsOiJB5sZ1oSwxPH3Dq37ws4JPFBTMIzaGwvM97e1GyLQQLVYljBujj+z0e+Nmz9XQZLtUqflNOo8Wv6uJ77oxZotXDqJVRiGFgX0Uxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=qBimrzYA; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="qBimrzYA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=yPwIPiKkFkevqnFhcN4kykowxr+JEWNDh91hvscemg4=; 
	b=qBimrzYA5tUA/x58SvrtqPAx65d7WtGP+EMq8/YqnERFBgWh2wGuNNmE4Fksy2JHIMTmgf6Ff78
	I8uvBcc8iPntB27yeXM272Efsb6AEGBOrI86LTXm5YijnSf0/1P2IOAc0dkNUXx6P5MynjWi+zj/D
	THdec+2RNfdcv40pJdDFRDHhiRSxdEXw5laEpmhUQZgjkjsmT87DwwFCnKp3emAZPkwdaPVMkNLmE
	BNnsGiyZceFOxxkBA0EgCKxYb4btZgA2ez2XJSki5vtq22orXW/Zu+7M3XXLB76zbDg7+njFRbVWM
	Qo02OvI2JgZ3A1incfToA90Y4EA1FomIiiGg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vO7st-0061h9-07;
	Wed, 26 Nov 2025 13:16:08 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 26 Nov 2025 13:16:07 +0800
Date: Wed, 26 Nov 2025 13:16:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Ingo Franzki <ifranzki@linux.ibm.com>, linux-crypto@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>, dengler@linux.ibm.com,
	linux-s390@vger.kernel.org, dm-devel@lists.linux.dev,
	agk@redhat.com, snitzer@kernel.org,
	Milan Broz <gmazyland@gmail.com>, guazhang@redhat.com
Subject: Re: [PATCH] crypto/authenc: don't return -EBUSY when enqueuing the
 hash request
Message-ID: <aSaNFzW1jPp7zVLU@gondor.apana.org.au>
References: <e1e420d5-dc00-14d0-fdef-635d6ef70811@redhat.com>
 <bb68f9d6-8180-4291-9e6b-33bbdcef780f@linux.ibm.com>
 <8cb59ed5-1c9a-49de-beee-01eda52ad618@linux.ibm.com>
 <1af710ec-0f23-2522-d715-e683b9e557d8@redhat.com>
 <f799d7ab97470f2529b8dcb5566fd673@linux.ibm.com>
 <e26aedc6-7132-46c3-78f3-a3582b1c4f9a@redhat.com>
 <aNIYTm6neC3lC6dP@gondor.apana.org.au>
 <194f9d1e-b6b0-54c7-6eb8-37ac0c0c1f9d@redhat.com>
 <aNK6IMzUgslPVi3x@gondor.apana.org.au>
 <7c1b844a-443e-9fd3-3aa9-0dacbc381812@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c1b844a-443e-9fd3-3aa9-0dacbc381812@redhat.com>

On Tue, Nov 25, 2025 at 03:02:06PM +0100, Mikulas Patocka wrote:
>
> What's the status of this bugfix? I searched the git history, but didn't 
> find it.

It's in cryptodev:

commit 96feb73def02d175850daa0e7c2c90c876681b5c
Author: Herbert Xu <herbert@gondor.apana.org.au>
Date:   Wed Sep 24 18:20:17 2025 +0800

    crypto: authenc - Correctly pass EINPROGRESS back up to the caller

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
