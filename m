Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD2B7FBA2;
	Tue,  1 Apr 2025 04:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743480896; cv=none; b=A9Ug6aXtLbym6Piz+gO0LkPbeJk+uiujzQX6vToDjM/qogQsEFaWX7gIUkOjJYejMgz5OTPgLjLg235cpS2WPsfoEQq3YOG9Ms0puuZYpm050LDbCSKf1IvRlDpL/32v8xB0Gs17RW3zerg1eUoKYyFZ0CgIQT57tsiD8LFXZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743480896; c=relaxed/simple;
	bh=FL7Hqi61NBS44sV+XpIlnlyKNycSohb7eU45vc1dK3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GLJ+k0RI3lZPssvrE4J25bADcdAQX1yo41UwzAJji1Yn15B9e8h5cMwL8zJJvS5POzRglShgHvpP38ezEucdZY4MtDweTbFPtxZd7tvj6rVrgM5OR7YEBgr5w7J06JBEAfUrZnyBWwNYdVk5+iklqihHFxcP8cNOv7zhLacmUVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=JaK6xeIq; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="JaK6xeIq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=+2RqO8vlf6EF5PqjrROYwLheViYaWVwm+Q/3XlSbR0w=; b=JaK6xeIqAWV5lQDIMKJhlAa/Eb
	qcGvG4FUu8T3C7E7DnbgDZ5gHfn0Mso/tTz+S/7PjwHiu/B+E6iWiLGTMJOHJVJ8i8t8xUv0kVNwO
	TNTEQ9SUdhbx/yWxagPpLkZtsUp06Wv6LJhlJFQgl5oxQf5lpkZHW03j4SqxFvwq7iXjWE/zdUCn8
	fcirNKWRnBwr+l7Bawc1WxgkW77TByt0VZQ7zOuv6FdYY5JA3tNiH+y79uKOsNwRcXe3lE2tdYBSS
	/0yfjoDyjMBwHdCOQUdk2NlY2c2Wt+k64zAtYgau54YeT1UBGOpsm8FbzdLy9Mxg50olghJOrHeE5
	eS9vOFWg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzT1Q-00Bk54-08;
	Tue, 01 Apr 2025 12:14:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 12:14:44 +0800
Date: Tue, 1 Apr 2025 12:14:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: Re: Chaining is dead
Message-ID: <Z-toNJtPYsOmRcFM@gondor.apana.org.au>
References: <Z-NdGvErMGS5OT7X@gondor.apana.org.au>
 <Z-NjarWmWSmQ97K0@gondor.apana.org.au>
 <20250326033404.GD1661@sol.localdomain>
 <Z-N55Yjve6wTnPqm@gondor.apana.org.au>
 <Z-itc_Qd5LLn19pH@gondor.apana.org.au>
 <20250331165630.GA3893920@google.com>
 <Z-tTEjCzpgDr9a-3@gondor.apana.org.au>
 <20250401033303.GA56851@sol.localdomain>
 <Z-tjluCx71ti6Ngq@gondor.apana.org.au>
 <20250401040852.GC56851@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250401040852.GC56851@sol.localdomain>

On Mon, Mar 31, 2025 at 09:08:52PM -0700, Eric Biggers wrote:
>
> Interesting seeing this argument coming from you when the whole Crypto API is
> built around forcing software crypto to use interfaces designed for hardware.

Perhaps you should take your rose-coloured glasses off? :)

> aes_expandkey() if we switch to that) for every I/O request.  The blk-crypto
> interface could be reworked to support pre-expansion of the key, but that would
> differ from what actual inline encryption hardware needs.  So this is just
> another case where the needs of hardware vs. software diverge...

If we're going to converge on one interface, then it better put
the needs of software crypto first and foremost.  Now that doesn't
mean throwing out support for hardware altogether, but hardware
does need to take a backseat every now and then.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
