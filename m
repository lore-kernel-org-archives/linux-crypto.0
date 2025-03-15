Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89691F1931;
	Sat, 15 Mar 2025 09:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029735; cv=none; b=KV3KUgi4A/wJrrO54/PmW98fagi/sYNh0/4y+vkgXaDTqis8Yxv0LO43L8P4rwUgSQRiDnq31n++2Vs2on6sW7KuLvw/ALyKo1y+A64aNEIjvGkHvhAILPWZyIW8QUmNCQBhllODRfjXv6sGTOSayEP5mU3j5OwSjrARQr1+ygo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029735; c=relaxed/simple;
	bh=DidN3Oe43Goh95nzDLlR5qrplfiV0Dv3ZE7KkgV5yMI=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=AWgnYy/K/uYEJcZsLbtYv6hw/XImBuLqJK7DCWPANTg264RN9xlloB8XS5eUkM4YehV7fEiLKSXOzzUBv69Eho4rA6/ZyGVtK8NriVRcxodjhfhGMe+PdE6JXzY1QqyrBT65AZCo4JjP/8NI7JZDaUUSa/ZPp5ezPc5/nbSm2nE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=XtMP7FMJ; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="XtMP7FMJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:Message-ID:Subject:Cc:To:
	From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1Ddsh8W4auY9OrEgdm/jXGKf7ZYAP4cY17EApb6gK/g=; b=XtMP7FMJFaLwXbKFL0N18/HK6e
	2Iv79IwqJscBJsnLRDpcNiSaBcuL7oH27o+5gyDXOCopBTGT5nzWrwdAD3vob/moJJCPWM50Qwht1
	etJPVXcO33i0WAxga0MOvIns6OvIqlkOYaBfOzFGFPORdf8+24h/DP0qq3cfeC9eAKua6zxgwZxx4
	MjDs2hR2mgVNPhPJKTRd6BAo4goEGCP8NfJXFahqd3wLCmC7pVZHQuzMaUBXm8N43R0GZQN+i+Q1I
	yEySS48VKTDFZkVrUnizy9JRLE7o6yifXxurqOCZJG9lbvc2DSiattch10Z42QGbtq6jgeXqIBP9n
	k0baQcRg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ttNVc-006nyg-2X;
	Sat, 15 Mar 2025 17:08:45 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 15 Mar 2025 17:08:44 +0800
Date: Sat, 15 Mar 2025 17:08:44 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: David Sterba <dsterba@suse.com>
Cc: torvalds@linux-foundation.org, dsterba@suse.com,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	terrelln@fb.com
Subject: Re: [PATCH] MAINTAINERS: add myself to co-maintain ZSTD
Message-ID: <Z9VDnNxx72FComdE@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250304124700.24574-1-dsterba@suse.com>
X-Newsgroups: apana.lists.os.linux.cryptoapi,apana.lists.os.linux.kernel

David Sterba <dsterba@suse.com> wrote:
> Recently the ZSTD tree has been removed from linux-next due to lack of
> updates for last year [1]. As there are several users of ZSTD in kernel
> we need to keep the code maintained and updated. I'll act as a backup to
> get the ZSTD upstream to linux, Nick is OK with that [2].
> 
> [1] https://lore.kernel.org/all/20250216224200.50b9dd6a@canb.auug.org.au/
> [2] https://github.com/facebook/zstd/issues/4262#issuecomment-2691527952
> 
> CC: Nick Terrell <terrelln@fb.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> ---
> MAINTAINERS | 1 +
> 1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
