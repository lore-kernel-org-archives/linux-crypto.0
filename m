Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F2761E3DF6;
	Thu, 10 Oct 2024 08:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728548984; cv=none; b=RR7t953Ep/ZfnzFM2wtSibQE5adIrY6d/QEkB2Kd+dC9dflBIBLZSdMB58kGGGCB/r+533MhIcTi8i4O0mHW8Js5GUmOB963FtZb3wVx7UDiE0uOexhd7Q8NLmbrOUm9/FSm7kw5W3Nl0AuEBkXZJd4rnOMm011YWLT41pn9wDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728548984; c=relaxed/simple;
	bh=ih0n5MnDNgmXeFiXjpgX3NP3LTeWznZ1HWBgx1vwbn4=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=tyCZON78RaWZZd6zK+6LcBwtgtEqmhNTAJEiXsoSNfhjIb2QZ5b+4V6K9j+dhO4PIGxQlQQGLHcIMXj/pLuT4/rWa56RzldKcmu2LtkIbKYsKrdqxKOPFZi+6lV8EqdVKsy2tROgzxsC8S7mlndeW3npcKrIKAVqMKo7jY+H0K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=bq6JuCrd; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="bq6JuCrd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Im59ssyjwW40lSePUqHW9DJ6MO9mRhJ4dqLRPo6b0ME=; b=bq6JuCrdgBWvh+jknAK3i18pxX
	sb9eEjs+sZ0EZpOb1nDSzjVofphRDHVqDqlMtnyrGKaLSKLKBvu3VLZnEdcBTjVgQKntrYjldsuPi
	mEY0DP6ZncCaVUBeBmMA6aUO7q/jMPFHrRB5LGgvnl5bmnRnaJO0DYbDggGrzr5YfX1efojBJs6Hg
	dqa4JGAdhoF1G2La5c+tjNba81t3ZMyvLJbyOZ0NE8qXmg7IamByzBy/FvkbTEeRwFmPh1t5qEQjx
	enCZEHA1Drc60IEU6M5AwE7/VwavOs+78etJylYFA54ygtNBc/vJ9UakcF0FmSYtqXYjNuX2Jr4S6
	kI8OkFlA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syoOJ-008HBz-2U;
	Thu, 10 Oct 2024 16:29:38 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 16:29:37 +0800
Date: Thu, 10 Oct 2024 16:29:37 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, ardb@kernel.org,
	samitolvanen@google.com, agk@redhat.com, snitzer@kernel.org,
	mpatocka@redhat.com
Subject: Re: [PATCH v7 1/7] crypto: shash - add support for finup_mb
Message-ID: <ZweQcXZV9kUGgVrO@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001153718.111665-2-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi

Eric Biggers <ebiggers@kernel.org> wrote:
> 
> Linux actually used to support SHA-256 multibuffer hashing on x86_64,
> before it was removed by commit ab8085c130ed ("crypto: x86 - remove SHA
> multibuffer routines and mcryptd").  However, it was integrated with the
> crypto API in a weird way, where it behaved as an asynchronous hash that
> queued up and executed all requests on a global queue.  This made it
> very complex, buggy, and virtually unusable.
> 
> This patch takes a new approach of just adding an API
> crypto_shash_finup_mb() that synchronously computes the hash of multiple
> equal-length messages, starting from a common state that represents the
> (possibly empty) common prefix shared by the messages.

I absolutely love the multi-buffer idea that you've come up with.
But (as you know) I dislike the shash implementation.

I'm almost there with the ahash version of this, there's just a few
corner cases I need to cover due to the addition of virt address
support to ahash.  Incidentally this also means that I'm going to
scrap lskcipher and redo it as a normal skcipher with virt address
support.

BTW, I just discovered a new application for this.  The marvell/cesa
driver wants to chain multiple hash requests together to reduce IRQs
and improve efficiency.  It was doing some ad-hoc (and possibly buggy)
chaining in its queueing code to achieve this.

I think having a chained submission interface solves this in a much
nicer way.  The driver could then simply pick up a submission chain,
transform it, and then feed it directly to the hardware.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
