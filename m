Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40DD417A319;
	Mon,  7 Apr 2025 05:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744003559; cv=none; b=fewGf+C3fFFjLqST4XP3qusn5QNaAaTLYBe8eo+CQxUK8ACDNsJssckncIU6C9907wbbtoUnTxmWCivrKk4nVxyrJd4m0juvKW+TcSMWrCVTFH1OW2UN7cWdiiripmJAsZiavD2hh/xEfiE4TM3d2pTp66tufwBSue9aVVHALwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744003559; c=relaxed/simple;
	bh=KnjDwxRDUfyvsO7uFRb3Pp2G7gppQWcSowKPNqSkopo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=apZaluicDL4MRAV3YjkLxMgSI6Cqirp3st1l2E98CjNzHB4LHCLUbMqv/13ldEWUfw2CbmqBoL8AYDEZt9GfDj7+8H5jkJwmzHnX8i+yCNlo42wdX+yLkG2Xyqh/E7YaLgVjE5XtdVdNmkGgSapR6f1X93EIpBEfyhhkybI4jMo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c6duTLmf; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c6duTLmf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=NtLdpFzz3zr0IVYju3J6fdkc9uGBWhZ3xjz7AnJbp6c=; b=c6duTLmfZoI2PtQscWhbAhltpO
	4c/reiTVleORfYTfm7t0yxkZ0dEckD3ttVSqSnSYHG9wylFpF+R8BC6rli9bqUEpX3DIHZ7XdN5z0
	WcIOZBAllOSYRJ1fkcIe5rICO2giZbcw9WiYcRUELODKivtleA85TMQJfgWTW4flvA5mtjvnWvbqK
	q+YKA3z1DHkYsf61XdwDyaVCw4IZVHCsxXhxUfOfsDq8tmMMsfD3F/3Sp7PzmkjugO9FR6hysdT7O
	IcvXtwvedHJnYfR+nSii7N/JHy6VINC3RgFXBBdeuFbKOY05crWdCH9VN0FUVv+HkSS/X17Eq+9U3
	s/dw9RqA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1u1ezW-00DNKD-1I;
	Mon, 07 Apr 2025 13:25:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Apr 2025 13:25:50 +0800
Date: Mon, 7 Apr 2025 13:25:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Colin Ian King <colin.i.king@gmail.com>
Cc: Christian Marangi <ansuelsmth@gmail.com>,
	Antoine Tenart <atenart@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: eip93: Make read-only arrays static const
Message-ID: <Z_Nh3mFcVgrSEW0d@gondor.apana.org.au>
References: <20250402111347.409795-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250402111347.409795-1-colin.i.king@gmail.com>

On Wed, Apr 02, 2025 at 12:13:47PM +0100, Colin Ian King wrote:
> Don't populate the read-only arrays sha256_init, sha224_init, sha1_init
> and md5_init on the stack at run time, instead make them static.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  .../crypto/inside-secure/eip93/eip93-hash.c   | 20 +++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
