Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16A62CA7
	for <linux-crypto@vger.kernel.org>; Thu, 15 Feb 2024 06:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707979620; cv=none; b=eVWoLSGrZqnrKlvBbghgLvS6GuApPVb7wE5ENK2AhP84lZAzDK8eW9A0XNLe6wSHESFHZnvykC3xBZOCQXAPxntwCEabUMNg3+m0ub/IkT/AfNPTmbFZ85iMcbL6HB02F7XhoWyUHOVv5Wjs+MqSS3q0MW31XvHf/ebJwdoCjDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707979620; c=relaxed/simple;
	bh=tZ1AiBNKWK3q0AfxhMlRIC9dbh/wZFhMMGyNejBJPXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TaTe2CHTAh/t0AhSStGwbLcd6aItgPVv/LfcK45MrtFJHsXByYx4irCHmc5efwyTx82V9f/wYc9cU8gDGf3U2XedoBHolhKCuT3QMECSP1K4k5ySbs+MDD3qLZz/mH/cI6myLFpt+DKP8gnTdgJvnD9jAlZB+oSCdzHXs5ODxVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
	id 1raVWH-00Dpy5-At; Thu, 15 Feb 2024 14:46:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 Feb 2024 14:47:07 +0800
Date: Thu, 15 Feb 2024 14:47:07 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH 06/15] crypto: algif_skcipher - Disallow nonincremental
 algorithms
Message-ID: <Zc2za7szGC+nxEHM@gondor.apana.org.au>
References: <cover.1707815065.git.herbert@gondor.apana.org.au>
 <a22dc748fdd6b67efb5356fd7855610170da30d9.1707815065.git.herbert@gondor.apana.org.au>
 <20240214225638.GB1638@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240214225638.GB1638@sol.localdomain>

On Wed, Feb 14, 2024 at 02:56:38PM -0800, Eric Biggers wrote:
>
> Shouldn't they still be supported if the data is being read/written all at once?

It is supported, or at least it worked for my libkcapi tests on
adiantum.  This error only triggers if we enter the code-path that
splits the operation into two or more (because the user didn't
write all the data in one go).

> Also, ENOSYS isn't really an appropriate error code.  ENOSYS normally means that
> the system call isn't supported at all.  Maybe use EOPNOTSUPP?

Within the crypto subsystem ENOSYS means that a particular
functionality is not supported.  I'm happy to change that but
that should go into a different patch as there are existing uses
which are similar (e.g., cloning).

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
