Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1E7E415F0B;
	Mon, 14 Sep 2026 08:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789375806; cv=none; b=iXw0AqeEU40uRgZeKfXPyCPah2b4syGDgFoyFXIE5zIqvZtlYIGrY87iIkE5+n0th6pMbTqrpEiGGpg9sQezoval+x9O2f+afcG/kjrSSt1eDbOacanUzA822vM4ZMsDLJZxGdbB5ynJsWIGIpIUbNvz4ygE0zNA3VdH0jW0/ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789375806; c=relaxed/simple;
	bh=G82i5OysJvIOYK3OQcyb81XjH/zlcwbiwmtQ5kFvcNE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=X3CHcwfGxIs3OoZcHcoj7UQmujqi4vuRRO1Eh4PRq8UxpLe8aca1Qxyyp2DJJkp5sUGwDBPfe/u/CXFRkn7skyHgwMdXlV2Y/xDFEdbVndXgkdTNGE23e2BpsFBfYBeXZ43KfiTjvyQwFZLalDwX8jvBO/28WrT6bQv+VmkPAo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hoXxCRLz; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hoXxCRLz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=MoMrHX1ELw+N1CtqJnUoCCISv2Dk43iGQkE8bkJTkbg=; b=hoXxCRLz5TQSChrIfuVCJEUcD6
	W2QZPaFTO9CqwmqSPzTt23VdPl0177HYerkj04dAwcKoZNEMxNTWdEbQDyECZgXkjHbxQJSz0YUxU
	euFONNJm20+xs1WvLPoomjUUybFtZCT5OFXxQLsAOtEKwliZ0e0a0kvg9P6UkCbfnn0SaRMzLFpJd
	0vobP7kb5vLRZnwkQjpT76bv4KU0QleXWWNh6bphSRSvXlsIiLgXwt3IwdZ8BAjqGah9vZwVaG0NK
	rqDuK1xKRqnGN9WG8lNfW206Dq6dDyo3yHOY6IY6Zp95+RzBYhBzORWc78r6Kzj3RqpZEcOyph2Ks
	U/iA7/pw==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x62Nl-003UtF-2k;
	Mon, 14 Sep 2026 08:49:46 +0000
Date: Mon, 14 Sep 2026 01:49:40 -0700
From: Breno Leitao <leitao@debian.org>
To: Thorsten Blum <blum@kernel.org>
Cc: Nayna Jain <nayna@linux.ibm.com>, 
	Paulo Flabiano Smorigo <pfsmorigo@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, linux-crypto@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: powerpc/vmx - clean up includes, metadata, and
 p8_init()
Message-ID: <aqe1F5CttAHH0ORJ@gmail.com>
References: <20260914081500.65737-2-blum@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914081500.65737-2-blum@kernel.org>
X-Debian-User: leitao

On Mon, Sep 14, 2026 at 10:15:01AM +0200, Thorsten Blum wrote:
> In p8_init(), remove the goto statement and return ret directly.
> 
> Remove any redundant includes, add a missing space in MODULE_AUTHOR(),
> and join the MODULE_DESCRIPTION() strings for better grepability.
> 
> Also remove MODULE_VERSION(). It has never been updated and the kernel
> release better reflects the module version.
> 
> Signed-off-by: Thorsten Blum <blum@kernel.org>

Reviewed-by: Breno Leitao <leitao@debian.org>
