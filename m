Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=180.181.231.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794393896;
	b=XrF9lzznfVCKPMqX47zbYIb+a/OThEHGLKsFKHwlsipvtpf0ib7HAwdZzHJM8zjsjmOT
	 T6IIhZDMKRYpLnova5FfXSGc+6vht2d5YTiXvyM0UIKA6SwWPX6+3AOpQ63/dAXjsH7uE
	 nDm6egqME2J4QLfUQB5TyVXBJWvOIWO7l5JpisZ6I+HL3iC111gRpg2ngFK2VXGn2J3aA
	 go1qFt6bwvy7Q1KF/JXg8ZUKu7FGWmnL93zPhLHl0NBE7c36if/yiC3YTTkOnSNrtTJyv
	 qDmfiZQtpRtV/xGq+WLgX6IBxv6f4Jx1184XU6s0Bf+TJlcNLR6+cK4GMmyhOOyHX5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393896;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=QXEhi4g+1QbPElhmNqyuHB6NGR5M3lkugk5YWNvi+aM=;
	b=htHgf5as9f8LVXKCP9//yysTQWFJ9GhppRCkL2x3q53KNqNKMOMT93MtCrFzulAYm5/E
	 I2+dqJHYd9Mmz5QYqvwWiviVj4n9KmjFkY5GV6UNfqRR9mtXZvmV+S1/0D4iRSpOgoLEz
	 9WkKoEXFndEn0WElMWw2kh195C567Prkpdwoc60jHIJngN3krjiLHCy12QNiUREfsESAF
	 ehabSrneUIHDhmwYAY1eL6EuN2IyzngdohHFkSMA8FPIxwx8bc5a5ocj9f16ZcTQTSOsU
	 3FebeSFDlJdq4ap2KdyrtN4a9TT8IkarznnXohxA+BzPjK1SQIWvVgep5Z8efoHzi/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gondor.apana.org.au;
	spf=pass smtp.mailfrom=gondor.apana.org.au;
	dkim=pass header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KbRa+Eee;
	arc=none smtp.remote-ip=180.181.231.80
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D20B606A31C;
	Wed, 11 Nov 2026 10:44:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5D20B606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.a=rsa-sha256 header.s=h01 header.b=KbRa+Eee
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=QXEhi4g+1QbPElhmNqyuHB6NGR5M3lkugk5YWNvi+aM=; 
	b=KbRa+Eeeo1zU2vH++8/Ff0bpzI3/EAl29l+JDm56IiwP+sbf+AyrN9hmgX7ebEDbokJssqeBRMK
	AwVF4ZC3vGKCA4acaZLkip6jgFicG3/iYntf2SG6hkmwz2TJ7WHkLo+HI9JXmJT1q+eF8DJMow4Ue
	q7JPE8CTLRB1n84gjPFGEy5rQKYEwD2OyqFeyw4eLlhiKUj71NNeCiabT/Qhi5gf9vwgNkCbC6vFH
	9bLFdkD85vOUn88QaJraTS7qcsjn1W+s0gDbw7sEvOrFWEjAGzcVT8ieLKKCd9Etki8uRqXw70qAn
	E8u5IdNSo+4VPChLefApzzoZJjQxw/vOmb7Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xR5ow-0000000Dlpg-19Rw;
	Wed, 11 Nov 2026 18:44:51 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Nov 2026 18:44:50 +0800
Date: Wed, 11 Nov 2026 18:44:50 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Kristen Accardi <kristen.c.accardi@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] crypto: iaa - use RCU per-package WQ tables
Message-ID: <avRHIuISSNUxfAU4@gondor.apana.org.au>
References: <20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538@intel.com>
 <20261019-iaa-crypto-wq-tables-v1-3-fab67b2a1538@intel.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019-iaa-crypto-wq-tables-v1-3-fab67b2a1538@intel.com>

On Mon, Oct 19, 2026 at 04:06:22PM -0700, Vinicius Costa Gomes wrote:
> rebalance_wq_table() gives CPU n all the WQs of IAA device
> n / cpus_per_iaa. The flat index ignores package boundaries, so a CPU
> can be paired with a device on another package, and each CPU sends all
> its requests to one device while the other devices of its package stay
> idle. The table is also rebuilt in place, so a request issued during a
> probe or remove can read a NULL WQ and fail with -ENODEV.
> 
> Replace it with one table per package, holding the WQs of every IAA
> device on that package, and have each CPU round-robin over its package's
> table. Rebalance builds the whole set of tables and publishes it with
> rcu_replace_pointer(). The submit paths look the WQ up, and take their
> reference on it, inside an RCU read-side section.
> 
> - A package without IAA devices gets a copy of another package's table,
>   so the lookup needs no fallback.
> - Every table has room for all the WQs, a few pointers more than it
>   needs, so they can be sized without counting per package.
> - If a rebalance fails, the current tables are kept. On removal they
>   are cleared instead, because they still hold the removed WQ. Removal
>   then waits for a grace period before returning, because the idxd_wq
>   can be freed after that.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  drivers/crypto/intel/iaa/iaa_crypto.h      |   7 -
>  drivers/crypto/intel/iaa/iaa_crypto_main.c | 346 ++++++++++-------------------
>  2 files changed, 117 insertions(+), 236 deletions(-)

Please respond to this comment:

https://sashiko.dev/#/patchset/20261019-iaa-crypto-wq-tables-v1-0-fab67b2a1538%40intel.com

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
