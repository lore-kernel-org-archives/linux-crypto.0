Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD551A2391;
	Thu, 15 May 2025 02:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747275058; cv=none; b=CZqRhE7MYxnarhoU6zgD2GvrDO2OeEHK9s3HxL4EVc8SfpRkBm+IiHMkE0cRWOJ85yP15LYLQ0IWa5yO64VaepTLALR0DdzHmvRS6hyRdVgySfwFWnV1fJFo+KkbzRs5JDs6z82bqDlPgaFcaRuCwnLGVdlYBU0lrXe/j4uY+d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747275058; c=relaxed/simple;
	bh=02TAFNyi4tVZfqDZNSQHOJvCWqiOCoC90hUCMvVBnq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n0swoTL28lEw7nF5SpQ1i9yvpybv/qAQLcxjZAUV+WFRDRbXF0W8XFGDu1NSQfNGQ8N821sT9t8cyMJiRbGTkxgbSD4JB7Ukb6jRTVhlwROmSQNHxnY+vGauRA01/zJC/b/vL/cBxugKPrVVQhDvc6xt0jV5dXxfBDtxYPHufUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=p7OwC/2e; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="p7OwC/2e"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9OEU6IES7eFPDsF41jBYUq3IDtt0/P5xjuptgC1MYUg=; b=p7OwC/2e36XHYXR8OunAzbwvCI
	kBCjfhT7HyoJnPZdsg4CJBJc4JTIQLpd/G8jAGDG0sFfPWTXo+ebSX89xzR6GhdOrOe1ypgcOPuXR
	3aYV/XV6hh2OYeKBI+e2q2oDGFgJTGOIXH16y274YLhyC8pb+zQV/LUvMErOrA3RJZEKSUtJtqy/2
	igPiebsyH7dg/UEU5FO6dt83UETCQhDevJfFuTwd/MT8VrGlhDJ5MeTruGvmOHN96PIiUKetcbS9f
	o9ZMSMaDBF+8tnn9DIMhToGmGZIVzWQg5Y9RaOWUx7Wlc48NHKBuUWivDzXIprullon3Y44DKjQWd
	5gtdQu/Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uFO3P-006CgW-04;
	Thu, 15 May 2025 10:10:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 15 May 2025 10:10:35 +0800
Date: Thu, 15 May 2025 10:10:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	christophe.leroy@csgroup.eu, naveen@kernel.org, dtsen@linux.ibm.com,
	segher@kernel.crashing.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/poly1305 - add depends on BROKEN for now
Message-ID: <aCVNG2lm9x9dzu6x@gondor.apana.org.au>
References: <20250514051847.193996-1-ebiggers@kernel.org>
 <aCRlU0J7QoSJs5sy@gondor.apana.org.au>
 <20250514162933.GB1236@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250514162933.GB1236@sol>

On Wed, May 14, 2025 at 09:29:33AM -0700, Eric Biggers wrote:
>
> I didn't notice that.  Probably, though I don't have time to review this subtle
> Poly1305 code.  Especially with all the weird unions in the code.  Would be
> great if the PowerPC folks would take a look.

Of course more reviews would be great and I think they're all on
the cc list.

I did test this by manually forcing the conversion, which is how
I discovered that powerpc wasn't even using donna64.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
