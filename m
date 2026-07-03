Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 973DB283C83;
	Fri,  3 Jul 2026 04:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783053001; cv=none; b=XQli18jAL2MYIA+NeVv+tpNOnM8lcDpNLSG5iuowSYJE05hkh/OnuafgXOG5JiGJH3PPVf38/AgshKLSWDv+2cYiy8lxbbKqw1s8cXqxmjm4CCLVOQV3DfApPtKYzxKRzTikZjBq5FXzzSNyDk9vmKKY/CtA3V66Za//bWcMnsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783053001; c=relaxed/simple;
	bh=V1U6V5RTQ00+N1gLOgxU/BA05xZ9jOEQpfiTuQ27NIk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tVQcJsK4gTJUKe2C0D399iH6+oJ4PX6y7gErpaH46IMeBkwZNVg1NVNHeWOe/XD+Ndby/chp1EQs2LgxGFZRiYNsTYeCOC/u7uQMW/urUvfUOzoTKlixHfk/OMJhy20VrM2KyhCyE87O813D+ClVB5k+U1rsI/9y5TuIc+2EhGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=LnUuHkCR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="LnUuHkCR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=99PZeqzW+5MdCvgfPJmJCnCGVMJRxChbtP5vLiTVpAU=; 
	b=LnUuHkCRe08Aws9A0+KK3hYzEHSKjNv3gi+T4a24VfxeS0y7U57GTRR06fiLQLdfZCZhQQAhMcs
	IIY6EBL+tY2op8Ivkt0Ec3wgMv7SKJgpT5OMo+N8bqTWSOhsNPO3n5BSkNiqgNuVjnUuRKzI/X5w1
	GlITaX/QUnoCsm57YZD/DzY1eeI0s99ylLM1oZitrn0RhLpEpJ5/qXNV91YTUgBn40orwSFaJHQ9W
	MXewfiCqmvLpx3CaOuphcZCuMGZgBvcdJxq0EOQoCMP7DumxXqCltSKyKyuQXzGz8Ex9Uo2IMPG69
	SLVXgncnS+nm4J8ONWie/55sskYcPGJd/BSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wfUyP-0000000AEyl-1Mtd;
	Fri, 03 Jul 2026 11:53:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 03 Jul 2026 11:53:53 +0800
Date: Fri, 3 Jul 2026 11:53:53 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Cen Zhang <blbllhy@gmail.com>
Cc: tgraf@suug.ch, akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, AutonomousCodeSecurity@microsoft.com,
	tgopinath@linux.microsoft.com, kys@microsoft.com
Subject: Re: [PATCH] lib/rhashtable: clear stale iter->p on table restart
Message-ID: <akcyUeebmW9AWgLr@gondor.apana.org.au>
References: <CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8m9Wh559e+=n8z51gB8DrbEyCc2mc0MgGjrRR6_VXBmU=2AQ@mail.gmail.com>

On Thu, Jul 02, 2026 at 07:25:39PM -0400, Cen Zhang wrote:
>
> Fixes: 5d240a8936f6 ("rhashtable: add rhashtable_walk_start_check()")

This commit ID does not have the referrenced Subject.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
