Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F9E1BDAA8;
	Thu, 10 Oct 2024 09:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728551592; cv=none; b=ZJRvKVngb9osCClg5NA0O9llqIHtENO6yZcw27uyv7GDPftIyLgnIMEf3k1GBadAmxcXl5gk92oc9FMP4t+k/xLOaoZVB3hpCcKL50YBr3o0OAhUXaG3ZAJt8spt7fgxN8QQ3QAgG1VJ5tOySgwy5FiY8Y5LjNKvBiHssA81wEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728551592; c=relaxed/simple;
	bh=JnG7Ha37Gyk1JZLSXNvpMMNDknl26yyyCJ2AXfMW/ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o9dy0/ne4XFkdwRvjS26VUjwDYK7IBLzX9k3Tk7ND4w22KYNDhYEkLsfXgsYzioqVpEW9i7UsDwpfemrTKSrgWPngPi0SwXtCfHIOhUIHL7JEpo8fCFuvCc+Mmn7/QpGhPetcnf33iT8VN49NaNxk805Az5IZY1coDH8uM/iRvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=myN6RGux; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="myN6RGux"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uF5hLVGTp7i4/leNDXC1c60gE4SRtG9l5adozKe4k3w=; b=myN6RGux2s90jql6bflx2+wHK/
	U3Snl4cJoW4nngo/LP1OaHq29I6SrniuVuTCqzCBO4em+fJ2um6b9YOdqgXR7jyI5PkIur2PWa1VS
	RjjCs02lwoXekukZZMaqKt1bzNz+xOEZWNapVz0aUYXU+ofMdvhPmmaoggn0407QzHEz8SeUcX4g6
	ydvZYYObxJ3dAvFckK9r27NP2Esjv67cxehRcB1o14ca5xo/Z/TVzlrp5oXUDor2IJlquoFCxetjs
	P1pphiY9DRq9x9HsfMshNSmlATN6IxtHKzCJgbWimM5Yf+fLFuPYEDG7PxH3BUPK8dVRZNyzWI/Mm
	rfVWP9rw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1syp3q-008I9K-0x;
	Thu, 10 Oct 2024 17:12:32 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Oct 2024 17:12:31 +0800
Date: Thu, 10 Oct 2024 17:12:31 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: linux@treblig.org
Cc: davem@davemloft.net, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: x86/cast5: Remove unused cast5_ctr_16way
Message-ID: <ZweafztLaD8mlzRe@gondor.apana.org.au>
References: <20241005231358.304682-1-linux@treblig.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241005231358.304682-1-linux@treblig.org>

On Sun, Oct 06, 2024 at 12:13:58AM +0100, linux@treblig.org wrote:
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
> 
> commit e2d60e2f597a ("crypto: x86/cast5 - drop CTR mode implementation")
> 
> removed the calls to cast5_ctr_16way but left the avx implementation.
> 
> Remove it.
> 
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  arch/x86/crypto/cast5-avx-x86_64-asm_64.S | 76 -----------------------
>  1 file changed, 76 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
