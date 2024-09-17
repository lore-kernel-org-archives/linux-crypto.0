Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643634594A;
	Tue, 17 Sep 2024 09:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726565020; cv=none; b=p8k1NKq33pHCMWtd1/dpiJcWjhA8B/JvY4noheF0zFwldfMNi59rg75v+89khEE6pHjtsBfItWG/LxBzvId/E1JlF8ISDAnXctscN7yRuerhU9Velt0VS6nUPO2d10NdhGaxHYq3+8FeheCB18eH5KC002Ggl5r9SsnrsJs0EAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726565020; c=relaxed/simple;
	bh=9EC1mUYx/EroOsGmXNohj96XGtqDZVeL16hUr39m/lo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VJSwgHYyr2cSbTCUg/yHS/fdsLlscJGnL3U18FqzGPlkT6HDWYyIdOH5kN5MFfGa/VRzVOD9Br7xN9X9fchnzfpc7+8SROxjTWppF5wZTUTIroFCCsbq7FcssJyArQK10KIh/m6x8bXlx/NQKoWcAQvUoQYVNmdi0w+WpLgInRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=np5WaylT; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="np5WaylT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ToXs3g7HJBc64iR9qQU8QtUwlI7/SIXzNhENd1Om6H4=; b=np5WaylTZnlGXxdh25PykrhXXZ
	1UQcPfTwD/fH7Pp2GygXpTIcWqldtb1+qWCUlVLkaLtJpfoBPsqpqrcrv6IYWaKcdZVSOmwj6PKfy
	l0jlicWPY55L21TqNmPMtx7eJSjb8kzS+IBFlbT6gb6ZhALxAa8pNj6zM8+wj110Sqh1Vh/gHl7TB
	0aPhX3071TH25lKog1brYkUdkvt49vzKc/ToX0ZMCPAulDCyI5pdTQhN82aB++TahzvkTnU4iax1h
	sVgv3T866rGq2S5vCz44/si1FalR6X1+syvk0D350BbZuF4wlZi0B/T1ZFgpD+qzqR1oKgHhdLyhb
	hVD9KqvQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1sqUGn-002zF2-08;
	Tue, 17 Sep 2024 17:23:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 17 Sep 2024 17:23:26 +0800
Date: Tue, 17 Sep 2024 17:23:26 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Tomas Paukrt <tomaspaukrt@email.cz>
Cc: linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_skcipher - Enable access to internal
 skciphers
Message-ID: <ZulKjmhsfgzmvgRr@gondor.apana.org.au>
References: <3ge.ZcSB.212DbbvIi2E.1cwKdC@seznam.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ge.ZcSB.212DbbvIi2E.1cwKdC@seznam.cz>

On Tue, Sep 17, 2024 at 11:20:12AM +0200, Tomas Paukrt wrote:
> Add an option to enable the userspace interface for symmetric key
> cipher algorithms marked as internal (CRYPTO_ALG_INTERNAL).

Please create a new bit for this.  CRYPTO_ALG_INTERNAL is used
in a number of different scenarios and we certainly don't want
those other algorithms suddenly showing up in af_alg.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
