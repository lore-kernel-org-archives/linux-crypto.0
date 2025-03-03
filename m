Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04EB13C8E8;
	Mon,  3 Mar 2025 02:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740969561; cv=none; b=FhAPEeDEl1m1so5tAT8litOWA8mWaGtYi5QZDqNWdqLSwM03Dxcu0zUb6gASKlAgV6cAOkdxDzxOTnn8t1//gS3/WAmMj+pPF1RKNLKImZGYLtDiBL0jtTeUcVuku3TmjKgnWG1pga23Zms+tzPoLqIB7wwi4nq1N0xu49CXnFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740969561; c=relaxed/simple;
	bh=wXCJ9pzAAN/yHLcuR8PLUK5ctILCaZ25ayb1zfLjWCU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=duMZ50TP34oVYuYciFzenpduyirmI/0xB3EKXSGCgKwZ7FYToupwt5IIWdY5WIGAeKxqfadsiNL4ilvw2QjgLtcFKk/R0EluJ0wzKOAjH8bVrgjUo85QL3gR6MBWLhO/kEGQUlb/qIwkmuMtzYEQ5cXG/yn9kKPGvtX7t1f/tHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=CMFht8Yr; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="CMFht8Yr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Snrx+cINrau65cn7FkKhCpJj0e1jfkudOs8sJTS6A7g=; b=CMFht8YrNvtWYml78DBb64zqe0
	+OZEgWBbZgNLdSO/rLxlqJqUGMq+J2wpnJOZEXZ9okZe8dTXGDcQukj0+IIujceq9QmKIzb2b+3re
	MhmQdurNQp/p4eu2oxsNRDY8SggGofQIv6nBf67ZArRap0LbSkyXeph2C/4Gw/LWcNLxBSCmSvIsl
	iGBFH0X2JZi19mDW3I3x232XHb9382Ngy2/E1r4AFSTyHhkmjzo4cJHSZgO7Ygjsyw2wFy3qJk1eh
	ka7bYuGiWMybKKRm3AlhYDGfX2TG0i5xAPVSRTjqbWhtXpyP5QpId0DasBtmYGbEo2x7ZyIs8ohv6
	fd7O+/wQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tovi6-003AN5-2K;
	Mon, 03 Mar 2025 10:39:15 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 03 Mar 2025 10:39:14 +0800
Date: Mon, 3 Mar 2025 10:39:14 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org, David Howells <dhowells@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH v3 04/19] crypto: scatterwalk - add new functions for
 copying data
Message-ID: <Z8UWUnpcvh6eoX6h@gondor.apana.org.au>
References: <20250219182341.43961-5-ebiggers@kernel.org>
 <Z8P9eIGDlT3fs1gS@gondor.apana.org.au>
 <20250302213742.GB2079@quark.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302213742.GB2079@quark.localdomain>

On Sun, Mar 02, 2025 at 01:37:42PM -0800, Eric Biggers wrote:
>
> The new functions are much better than the lib/scatterlist.c ones: they have a
> much better implementation that is faster and doesn't use atomic kmaps, and
> (like scatterwalk_map_and_copy() which they are replacing first) they don't
> require the unhelpful 'nents' parameter.  My tentative plan is to move them into
> lib/scatterlist.c, reimplement sg_copy_buffer() et al on top of them, then
> eventually update the callers to use the new functions directly.

Sounds good.

> However, the 'nents' parameter that sg_copy_buffer() et al take will make the
> unification a bit difficult.  Currently those functions copy the minimum of
> 'buflen' bytes and the first 'nents' scatterlist elements.  I'd like to remove
> the 'nents' parameter and just have 'buflen' (or rather 'nbytes'), like the
> crypto/scatterwalk.c functions.  I suspect that nearly all callers are passing
> in enough 'nents' to cover their 'buflen'.  But there may be some exceptions,
> which we'll need to check for.

Yes this duality of sg_nents vs. total length was always annoying
even within the Crypto API as the driver authors would often get
mixed up.

If we could settle on one of the two it would be great.  Of course
I don't know how much work that's going to be and it could be
prohibitive.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
