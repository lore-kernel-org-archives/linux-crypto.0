Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9465E218E81;
	Wed,  2 Apr 2025 13:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743601836; cv=none; b=CAubWOqDCp/B621GS+i064NRoNojY+PiwxZXSpLH+BFlTlBEvnP/Vu/83pIVYvL+iAkh3UnivKJBu9rSf4SSMph6clHPpnkXjH7SCpCyS3b8gl9w2sMw3m3zXf69amvi8SRyt+JhzL1mbL/t3+E8rlbWCPPDw3mnUoB8TJ1V1VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743601836; c=relaxed/simple;
	bh=JlLaTbHf4oHPL/8icSsg5+1rqqNZF0QN0rJmybj3LA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WmeEqevSZsov3lJ40ElRa/RRpcEL0qzWFxBhj/VmgtAhHlXdd6VSnhOB1GczjVPILDD6DvIy0hNZSwd6tYpLbAS/yz4kCu/TIhw/9ple/p9zrhJSZD1E2rtFAo0Wx977xoTtes40NUsQiHlNPoeO37atUmkGyUkJX8qQk4YD5Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=QSFgAZ2n; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="QSFgAZ2n"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=67n5syAY6lEp3kEv2SR6CynYFeXqlyBl5z35Fm69tjQ=; b=QSFgAZ2n26Ui8KQTLJErn4Td/R
	TVxwxuQGHYJGxIIW766xgoS9na2geg2xOIESRvAeCWf0O9mKGvdW0+HrMlUiamQMOlLePkWroitiU
	oiFiBYnpNrXJZdA08DcDHc1+L68Um16kwcrAHyAmssi1mT0ob2iUzLoglHj5AUIjrSbqqhtY1Eff+
	khXe+ZyMER3n7ALcs6HsWwhhnFU7AoElLk9wMjGzQpsxZLK4dhy9UoPnJSFHtvsbdEdv+Pmfaicsc
	Pv4v3pLWp8ZijZ9abvrMp1n6L4/7OZrHygaWIJs71Dye5s5dSYGK7D5Y1ZFl56ZPZTu1e6JCkHs/C
	v/TLcwxg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzyU1-00C8iE-0j;
	Wed, 02 Apr 2025 21:50:22 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 02 Apr 2025 21:50:21 +0800
Date: Wed, 2 Apr 2025 21:50:21 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 2/2] crypto: ti: Add support for MD5 in DTHE V2
 Hashing Engine driver
Message-ID: <Z-1AnemlJ1k8GeLp@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-3-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218104943.2304730-3-t-pratham@ti.com>

On Tue, Feb 18, 2025 at 04:19:43PM +0530, T Pratham wrote:
>
> +static int dthe_md5_cra_init(struct crypto_tfm *tfm)

Please stop using the obsolete cra_init/cra_exit interface.
Use the typed init_tfm/exit_tfm interface instead.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
