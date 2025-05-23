Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1E7225401
	for <linux-crypto@vger.kernel.org>; Fri, 23 May 2025 05:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747979516; cv=none; b=ark9Dcrqv5bRUdgUdKpNjjgdQB6/Gx0+YT6XSDl9Rd5w6RcjIU8l/qOf1lkKSJAhJxP2YIvrgC6s7LCBAJAsYs1+dzp3/tU8x0igMg/PPZH14mDyjCJaEs7SoYAFMikNjuP+cosldi92U0RxBFbi8sJYcnDm5rs0L4mYrjXfqqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747979516; c=relaxed/simple;
	bh=tlNUXvNR/DjbKQ5vLXkiBsBNHV1cHW1krhxnWQrkgyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvHgopfKwWZNxERmxKN8M4VjBiWV1rYP6LcK/pjs3pzFOv6ExpaXbv136MfF9HPShgb1oAhMk58moSqtwbu8PoUkG7GtrirOOUadZ1GNRyAC87rDHypoQLx1WpVoMc0O0/Z0OpS35E99P0Q/XVUMGnudcvgjA3qcLe+1QS/qoEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=mAZTXJUN; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="mAZTXJUN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wY8dxk4CttCAhKYmRzc21EAP7NxYwzllYwsy7fqE4rQ=; b=mAZTXJUNH71Vh0hCbN6BZ/FKDZ
	eDwfje1FaOsSTkOj9Ph6m/eniZdbHzu97ECKjz3zzzq7m2mqeNu0YvE7CN1zTavJ7NvDpM9wSfv34
	y5LyIfC+PsCR5np6cHklENcLEM5ptHCqHa+0/z1D8SmeuPWSGLJn7nDIL1fQkVBkVWXf7jJvpmOzR
	XN6NBIinkmQjpVuPcrwAhB45JqmlZqjprm0mCv7sfWiZZFDd7rsUb/M9X494GMnVDQniAw8copH4E
	x59kLjryxdnsDGNEioWfIgLiuvlqHd+6WHCNRdQOG4BYohfXwKmcb8IyV47icf0r2wQ9zooWHvoC1
	BR964yyQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uILJs-008HK8-1u;
	Fri, 23 May 2025 13:51:49 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 23 May 2025 13:51:48 +0800
Date: Fri, 23 May 2025 13:51:48 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Ingo Franzki <ifranzki@linux.ibm.com>
Cc: linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>,
	Harald Freudenberger <freude@linux.ibm.com>,
	Holger Dengler <dengler@linux.ibm.com>
Subject: Re: CI: Selftest failures of s390 SHA3 and HMAC on next kernel
Message-ID: <aDAM9LKOWSKBbIUn@gondor.apana.org.au>
References: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <623a7fcb-b4cb-48e6-9833-57ad2b32a252@linux.ibm.com>

On Thu, May 22, 2025 at 04:13:59PM +0200, Ingo Franzki wrote:
> Hi Herbert,
> 
> in tonight's CI run the self-tests of the s390x kernel ciphers for SHA-3 and HMAC (with SHA-2) started to fail on the next kernel.
> This must be something the came into the next kernel just recently (yesterday). It did not fail before tonight.
> 
> Affected modules: sha3_512_s390, sha3_256_s390, and hmac_s390.
> Not affected are: sha512_s390 and sha1_s390. 
> sha256/sha224 no longer exist as module, probably due to the move to be a library now. 
> All SHA-2 digest self-tests pass, but strangely, the HMAC with SHA-2 self-tests fail....

It's probably the export/import format tests.  Please try reverting

	18c438b228558e05ede7dccf947a6547516fc0c7

and see if the problem goes away.  If it does then I'll revert that
for now and figure out why the s390 export format is still different.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
