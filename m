Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4247318800D;
	Sat, 26 Oct 2024 06:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729925710; cv=none; b=QegljmO3UiWDIMFEBHsc9B+wDc7RNu2pZRypMQqBE3D2/wsry7IumjwyZf+flTB2hfiF5sm6TW96jH88ArezBm0Jy62uS6zCGzzz8me0r1h4fD28vlfzGbzMVL7XhXabPpJ/w3rnMN6JoVTfZXpNMynN0daISmhpkrL9gn2Q1x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729925710; c=relaxed/simple;
	bh=sog3k5Lhl5pyOz3cArvlD5PjIXy1WjyRNuz1al8Mb04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NWfMApsugwylezLeLXtffXnEzlrV23yx4gQOywPgd6v2jka24UssHmk6cSm+JG6te81AWga5z6TvKowglqWftzxorjgYRmio7FnIQO+JxtJRsjjrGF8CDz5DOPXv1rm1/8gQeR4lC0dxpJ+xNiUdKBbItgNqNsyh60E3+n7LQ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=MYLtSLMx; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="MYLtSLMx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=VkOTa/SWZM6+ykiaX+uPabQnkaL7VX7jx8dc4rKJQ4g=; b=MYLtSLMxk42fwya38Fj9XbuCm6
	QZF1msDDanUjgQiUrhTU7lmiRrcteWrpgBPCrg4QKEigj+oY62iwj2keG4Pe0IaPXMuJQoFf7Tcs9
	fcjSxoHP4paPZbVFRNT7c0WSi0kWiOI3XInd3r5gkxcCGDi4RfPTJ7SaKiJCaL2f37Gsy/veMj0JV
	kOVEMs24aqlJzb3AYjk+9BoEwOE9OQLy4+49RaUHYlekP3hNHs/w6gb9mSojUuQZAeR+UsGJ4w01O
	J2r7GgldmctKla1Q+GjyYDUVTg22QO5/YQL7Nu6Fc+MaoCjca0hoMGH745NIsgiaYQ2vFSOXBi8pv
	OxJyMA7g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t4ahM-00CFtf-2m;
	Sat, 26 Oct 2024 14:54:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Oct 2024 14:54:56 +0800
Date: Sat, 26 Oct 2024 14:54:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	qat-linux@intel.com, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Constify struct pm_status_row
Message-ID: <ZxySQPLhRbjP2P9-@gondor.apana.org.au>
References: <ab26d264baec1f3233e832c0c2fa723e3be21a04.1728935687.git.christophe.jaillet@wanadoo.fr>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab26d264baec1f3233e832c0c2fa723e3be21a04.1728935687.git.christophe.jaillet@wanadoo.fr>

On Mon, Oct 14, 2024 at 09:55:17PM +0200, Christophe JAILLET wrote:
> 'struct pm_status_row' are not modified in this driver.
> 
> Constifying this structure moves some data to a read-only section, so
> increases overall security.
> 
> Update the prototype of some functions accordingly.
> 
> On a x86_64, with allmodconfig, as an example:
> Before:
> ======
>    text	   data	    bss	    dec	    hex	filename
>    4400	   1059	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o
> 
> After:
> =====
>    text	   data	    bss	    dec	    hex	filename
>    5216	    243	      0	   5459	   1553	drivers/crypto/intel/qat/qat_common/adf_gen4_pm_debugfs.o
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> Compile tested only.
> ---
>  .../intel/qat/qat_common/adf_gen4_pm_debugfs.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
