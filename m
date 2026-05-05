Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEBD31F99F;
	Tue,  5 May 2026 09:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777973155; cv=none; b=k6162JhAQ5bLfyDqg9MsJREvFtTaKHACJlW3C9kspCpScrZKMzpx2ME6kd2eOgp1WCLPXpgFRVYs+ARzzk3mUfcU9Hi+DqYXeezQOklg5yevu1vQTXHUY/bJnqCgbErzm6lV/IqNYN0aqAp0CZ5akQuSF6LfEpuuRh4bwQJ4uxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777973155; c=relaxed/simple;
	bh=Ly6qDU95n7CEGR9S6IuN7ufML+LFXz6wpEvAIF4Xrpw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=riocPNM+9/gfLLvAPSlV6CN+2/PpODM0CvnMjhgznCZ0jTB+YEMIa7m3ZIQbTLgFz+Ju4HJB9W6CKHWhKtORAu3izt/kIH8dV41fT7i1aFESQmQIDfvVpKrlisIoKN37GAuio0izRgruzZuYb8sv260AR3MwKjvHMNc054qqZ4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=K4HmjReC; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="K4HmjReC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=9nukT3K5jxN3AsFjPXiIq8SCvRYtR+WGeD1RMvpEcdI=; 
	b=K4HmjReCBYQa3sNC6yt/BuyMhUGZWjAkOvB2h8Au64iZJow6Q/KBZRasXF7rYxM4ZMwkOi50CzI
	Wu7nmuE5J8iQPDjg85In/8cRstucUTcbKnT8xGGE9HqIBDO/blJW7eK1V6oJybuhQlTC6oG0xyzGu
	nwziHhdCPxSGB3xUNptY4G3ho5OuwV7PwsCzavI8NQyEU9FxjdrJQRUCyhrPjZjsU0YFYBhSUhGZD
	UsLkalm/jsLlyHZdu288N2GSZztDwJBzhAjb+gC58h+2oRcH7tnU6e1lD4hWj+GS0D+hduN6rg+2G
	ZWcdS+grvugTVFBvuiJOHTb5rB46MTOAAnbA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wKC2F-00BNrX-02;
	Tue, 05 May 2026 17:25:48 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 05 May 2026 17:25:47 +0800
Date: Tue, 5 May 2026 17:25:47 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-crypto@vger.kernel.org, Srujana Challa <schalla@marvell.com>,
	Bharat Bhushan <bbhushan2@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: cesa: allocate engines with main struct
Message-ID: <afm3m3X_6bJSy-Sx@gondor.apana.org.au>
References: <20260425023247.475233-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260425023247.475233-1-rosenp@gmail.com>

On Fri, Apr 24, 2026 at 07:32:47PM -0700, Rosen Penev wrote:
> Use a flexible array member to combine and simplify allocation.
> 
> Move struct mv_cesa_dev down as flexible array members require full
> definitions.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  drivers/crypto/marvell/cesa/cesa.c | 11 +++-----
>  drivers/crypto/marvell/cesa/cesa.h | 42 +++++++++++++++---------------
>  2 files changed, 25 insertions(+), 28 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
