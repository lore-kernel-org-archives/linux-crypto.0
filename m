Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B37318A92D;
	Fri, 15 Nov 2024 23:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731711954; cv=none; b=fDjo1GyZ3pCgDN2uHJ5/FD1CYhMQ3f4Wr1mC+gwfEa7goWGAWNlI9eRDYbZHddpUFfJR7ODhO2myv7zxwgI1HAJ+KEJCDkBC1C8LD8w2mmOecYX4EwmEfPP+wQggeH2GLEVepCcqL8Zp7FCLa2sqHmCGmH1zxA5sxJTce4ONEaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731711954; c=relaxed/simple;
	bh=GM8RftUMNxoU4hzxmn4JTX8MZKYxjBFPF/mx9Z+p+zc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KSsBIQIpihpyNb0cJ1SdeNP5i0OxDhYsRijigbmNtReHaGMKjO+tQOqrlYHkuDVG1h28MYGjASQGJ1SgJ6w+sDIQAeW6GTja6oy14Ov6V55Spmy9WfvS26FuxwCbjVY++dGga9+aCzhm9E/CTu9w0RsmYgGL8YGGkWIkWJO6kL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Jdd6g3UP; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Jdd6g3UP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=iNrmCujufagul09VCWaNFQr74RFfyRLFySNKzZRpBgk=; b=Jdd6g3UPvqg6mftQzYyWAlcPRs
	S59qVZ5zEswJ+LhakJwH6d5jiDo6uQHmY2CJt4lGr97qHN74BCYzzBvldNtdt4KVUn45YjZ56Rb9I
	SpFFElvjLn8X9WqV3iKYmStGETYCfgggYit68/3w/F98q+ZxwKjpFwhcdOmPRO1chO5t8P+ifZPKq
	PIupu+2TQ3ASe8YAMv3En9kCxZgAQV9E5YNE8U1VpoIL3E2iNGA4H7tk8Su6I7w5JK1Pw1aqwWz/W
	0pLNcI4JEiS6FniyQdoLVYqnU3wndlEjrlc26csAx5PZr2YRV/hLqKY4Wu3YISLGkNdsAK9WEGiPB
	JyHtqVCA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tC5Nk-00HBOg-0Y;
	Sat, 16 Nov 2024 07:05:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 16 Nov 2024 07:05:40 +0800
Date: Sat, 16 Nov 2024 07:05:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: dengler@linux.ibm.com, davem@davemloft.net, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 3/3] s390/crypto: New s390 specific shash phmac
Message-ID: <ZzfTxNSOmXDz8iQG@gondor.apana.org.au>
References: <20241115144724.12146-1-freude@linux.ibm.com>
 <20241115144724.12146-4-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241115144724.12146-4-freude@linux.ibm.com>

On Fri, Nov 15, 2024 at 03:47:24PM +0100, Harald Freudenberger wrote:
>
> Please note also that this implementation actively checks for
> non-sleeping context before attempting to derive a protected
> key from the given raw key material. This is due to the fact
> that it may be (in the future) that this process has to interact
> with crypto cards and thus requires IO traffic - which requires
> sleeping allowed context. So there is a check for in_task()
> and if this fails, -EOPNOTSUPP is returned to the caller.

I don't think in_task is right.  You cannot sleep when spinlocks
are held and in general there is no way to test for that:

/*
 * Are we running in atomic context?  WARNING: this macro cannot
 * always detect atomic context; in particular, it cannot know about
 * held spinlocks in non-preemptible kernels.  Thus it should not be
 * used in the general case to determine whether sleeping is possible.
 * Do not use in_atomic() in driver code.
 */
#define in_atomic()     (preempt_count() != 0)

While the Crypto API provides a mechanism for you to determine
whether you can sleep (CRYPTO_TFM_REQ_MAY_SLEEP), I don't think
it is acceptable to just randomly fail because you got called in
a unsleepable context.

The general solution for this problem is to make your algorithms
asynchronous in the unsleepable context.  See how we handle this
in crypto/simd.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
