Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EF32C2377;
	Thu,  2 Oct 2025 09:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759397462; cv=none; b=BWDcau//Y+w17z46MLhuiNzPiEBDOr2tUqfDlFz8grIqWWAXgZbBcNGJMTyU+GcCzvy6fO7HNf87MvkL/+NzTfPxlIodzqdPP4d2UkhtrDnQcgNFaXrweP64r5dsgXRJckgHwC6IAKYPC0POuA9lPigF/PIDqeGlQvxqoiIXGiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759397462; c=relaxed/simple;
	bh=7/lNIphM1u4rJbHDT3TaAUnqlB5GXQ8JuGLtR8eq58I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QZAyk0SQDU16ajvuQlfQL7oSLKDcBuiWP1wPxYn/oXNtl7vuTRNVzB0Xx7cDF1RHmIhqyq3XPIOQUw6gqSsMCG7/D3bPw5BUsxNNyx+M05gG0FeSfLmWE6yM2dgA6gV4KuBOhvqMmyGdlX0Gbj2YnkFIyiw5rsS/tm1C84Rw8QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=javH87rq; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="javH87rq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:MIME-Version:References:
	Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:from:
	reply-to; bh=Xnb7npDOrQlWbYFZ2duc3KM7NvyZ4FCzogrr0RiwCIc=; b=javH87rqnxD9zfIm
	IdmjMS/487qUVIyh/iqXXgX/N89NkGYBKTqTwPl9POx1w5+tv/ef4ajVYrbVENAAJDc9dZK1SLf2x
	YDS1h9W9Ehrjvmx5nGLOu8a9VCqUvpx36a98pYOwD9hIj/34rX6CrGAfgcRJ2DWvdQzUhotbsaLr9
	7lGuvE/1N+rmpUmeWmvHgvyJJMHPLKNiMHcaOL3dtS7lVh9nW6C16jN+m9fTuY6097vNsuuAJo8pl
	57mr9bfPVjpPXbf3g+3mb3+H4qKHGx+i36X0CwqeE6bmiomW3Bc82UFQG2U2I0KvwBXK3eSblOQtp
	yN9H41o6fe1Bsanbdw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v4Fdz-009z9b-1s;
	Thu, 02 Oct 2025 17:30:36 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 02 Oct 2025 17:30:35 +0800
Date: Thu, 2 Oct 2025 17:30:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Vegard Nossum <vegard.nossum@oracle.com>, netdev@vger.kernel.org
Subject: Re: [GIT PULL] Crypto Update for 6.17
Message-ID: <aN5GO1YLO_yXbMNH@gondor.apana.org.au>
References: <aIirh_7k4SWzE-bF@gondor.apana.org.au>
 <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05b7ef65-37bb-4391-9ec9-c382d51bae4d@kernel.org>

On Thu, Oct 02, 2025 at 10:10:41AM +0200, Jiri Slaby wrote:
> On 29. 07. 25, 13:07, Herbert Xu wrote:
> > Vegard Nossum (1):
> >        crypto: testmgr - desupport SHA-1 for FIPS 140
> 
> Booting 6.17 with fips=1 crashes with this commit -- see below.
> 
> The crash is different being on 6.17 (below) and on the commit --
> 9d50a25eeb05c45fef46120f4527885a14c84fb2.
> 
> 6.17 minus that one makes it work again.
> 
> Any ideas?

The purpose of the above commit is to remove the SHA1 algorithm
if you boot with fips=1.  As net/ipv6/seg6_hmac.c depends on the
sha1 algorithm, it will obviously fail if SHA1 isn't there.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
