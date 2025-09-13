Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DD342D73AD;
	Sat, 13 Sep 2025 04:31:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757737902; cv=none; b=evJhDrCu1aiGHNhQypVUnZNmDTQYGF26xDkd4oHfnEnucdQJBtcx2/MylTUituPxjFraNXqdoRx+pS6psnf5tAsxrEHBjsYG3tQ9IL0ttoozeWuoRsBUfTZsp4HgNZ9/cbc1/H2/pXkEbFXU/XMl+cGUrE/JP3bFIHG7qzeD+1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757737902; c=relaxed/simple;
	bh=QK+g0PF/cHKNNvjmrXNqx4PT70TxhA6qR9oILnHK29I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m4OpaRNMlNiCw/P6mY2hQedytilsWHf3u5auf+pO346I+H/YVm/xbsR5RP2V8eySYvSuIUQbqSAuaKbM5ySfKrbUTSXFxx5qQSas7AJ6jFTldJtd5yRP8fP8Mpd7Z8sUcEN0ipByr0zGwPIZnILNop8jkKD8rvIEdmTKaYEslfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=TtEW+FeR; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="TtEW+FeR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=itGvPRGbLf3f8QIWZ+wcKYSy0JFxx91y0injPpdsH0E=; b=TtEW+FeRIQuJwAmxBvbd7L6f5+
	WpuxGC7DJtcFLGysq9V0wtmM7BNBKCwKCLO6zIVZtK9UZQkHdhZf5Bbbr5OmGntZ7PI18cgUAW7Eb
	HfmAwPbbkYcJZpHeNNkPCytK0hKFmWqyPWWy3OKY0mD+ujD3ol9m46llENcj4w3rnPeAH4fPcKKmR
	RaXXZHh/TWzqkXi1y/chvG3Y1m2rJcl2gmID6Hi5CT3GVioFLawSt5kDHQ65XuWfVyBT/jt1ldpLN
	TruRnzt/eP5hPGyMXvHF8V8f7PNVSpVt2Lu17HNg4x9y+ZWz9stWm6YaYEYuigfH+ZYkD2m2NBK31
	FPeB/xBw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uxHfV-0053x2-1p;
	Sat, 13 Sep 2025 12:31:19 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 13 Sep 2025 12:31:17 +0800
Date: Sat, 13 Sep 2025 12:31:17 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg KH <gregkh@linuxfoundation.org>, qat-linux@intel.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: qat - Replace kzalloc() + copy_from_user() with
 memdup_user()
Message-ID: <aMTzlemW_w2ZtjS9@gondor.apana.org.au>
References: <20250905163915.523396-1-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250905163915.523396-1-thorsten.blum@linux.dev>

On Fri, Sep 05, 2025 at 06:39:11PM +0200, Thorsten Blum wrote:
> Replace kzalloc() followed by copy_from_user() with memdup_user() to
> improve and simplify adf_ctl_alloc_resources(). memdup_user() returns
> either -ENOMEM or -EFAULT (instead of -EIO) if an error occurs.
> 
> Remove the unnecessary device id initialization, since memdup_user()
> (like copy_from_user()) immediately overwrites it.
> 
> No functional changes intended other than returning the more idiomatic
> error code -EFAULT.
> 
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---
>  drivers/crypto/intel/qat/qat_common/adf_ctl_drv.c | 13 +++----------
>  1 file changed, 3 insertions(+), 10 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
