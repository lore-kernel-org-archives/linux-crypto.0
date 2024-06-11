Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 207F6BA42
	for <linux-crypto@vger.kernel.org>; Tue, 11 Jun 2024 03:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718076007; cv=none; b=oIBk+onwldQKvFVAaNRMkcWkAlu+aLQfVVeJcVtKEGoUh4Fouj9ZDl/m8zOlgQc1TAXvnvuIp64PBFJqPrM0evGsn4FZWIH+hSgzdPBzJWV6tKZNkRNBANsfwrFsFOWt5f/qTm4xWzhd2mYChtnZGJ1qtSSNaSWzZsZcs9pgKAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718076007; c=relaxed/simple;
	bh=Tu+U54gEZN8znWyhkbN4x706daty2hci2sYqs5IkZLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao6gV9491Yg2ephHoYRsDKoWhXM5XfIZ1b3rGp1O2ZHaKrjaym+1rUE8IdHnIGhRKBkIAB9xF5IiZZyMYH8UmPPAWiqcgyoAILUdBbyI2ms+J9/HnZeBoQJt5WOL28n6i6GfQJ/qdL4oy1XZzykzdJTASn6ezwpkVW9c4pJJ4Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sGs3D-007s0p-1H;
	Tue, 11 Jun 2024 11:20:00 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 11 Jun 2024 11:20:02 +0800
Date: Tue, 11 Jun 2024 11:20:02 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kamlesh Gurudasani <kamlesh@ti.com>
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org, vigneshr@ti.com,
	j-choudhary@ti.com
Subject: Re: [RFC] crypto: sa2ul - sha1/sha256/sha512 support
Message-ID: <ZmfCYsE-2ID9cmxo@gondor.apana.org.au>
References: <878r02f6bv.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <Zlb4SHWuY9CHstnI@gondor.apana.org.au>
 <87bk4fa7dd.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmEYiw_IgbC-ksoJ@gondor.apana.org.au>
 <875xum9t2a.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
 <ZmLZ2Zl8HUQc0jST@gondor.apana.org.au>
 <87wmmx7xni.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wmmx7xni.fsf@kamlesh.i-did-not-set--mail-host-address--so-tickle-me>

On Mon, Jun 10, 2024 at 06:38:49PM +0530, Kamlesh Gurudasani wrote:
> 
> Increasing the size of sg list will sove our problem to certain extent,
> but not completely.

Wait, I think I'm missing something.  You said that the hardware
keeps context which cannot be exported, but how could we possibly
use this for anything other than digest without creating trivial
DoS problems?

For example, if any user can start a hash process without finalising,
then they could make the entire hash offload device unavailable for
other users.  If somehow your hardware contained multiple hash
contexts to alleviate the problem, it could still be brought down
easily by starting a large number of partial hash operations.

So I cannot see how this could possibly work at all.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
