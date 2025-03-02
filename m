Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E8D8821;
	Sun,  2 Mar 2025 08:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740903003; cv=none; b=TOJdaKimztjj4+LVN1RjB7cZGRtJHuybz5IUXRR1qqFqbq/oJw8Q+igq30SC2aTZrZ1cb1nf1XiTVXVOAAbP8/kLJKkaRQb+hFEn83jQ+53VTE8oP+5q9v+mIrCSLRoRAarrTZdGi/GTDrl+Hg8LlJNxjrCuc7wsuxPcX1IKOnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740903003; c=relaxed/simple;
	bh=4WaZsj8BO6gjrc7MhlJH5SgO+W9hSTjEwNQx18aAPyE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lZ96vh/shFbypCSi+KI0Q2f4MBfPqER3FB0h9rnWtoybNDfEGzhoMKUZAWe0nnCU6sFZYLBjdM+SteLTcOdik7fwz0w7DyfmV2Vt6vb+fwciF8O5gTv4yOaJqM8AWKiiAeIAycFzRj6hmcADdeL8vOiPABZ1940rzxuj+JQZFKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=Ye1qMfhY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="Ye1qMfhY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=U0VBAlsa1pyLoUwvVtb2Qrtu1YswaRkt5IuRWNfR1xA=; b=Ye1qMfhYNgXots+yRKCgzdfvzc
	oKf99u8sVuB1X0sZfsHa+8mZ92RwkpXzd8CGdIVC+cwVILDoo0nb7sXsFNQ91OUMy1/7E24wZYmf3
	xtDrB/Yka1kDtkDHGGWbfIRwNrYiwQQNdGa/AgmdKpuO7QwJpiRO8NEzEkMGjGFJ3mXcx7qXidGuX
	DTHpGtm+rB2Fj4OwhZLkB1uj1UP1ZZyuP6XkT80PAzB4vsuxo71sgtSxsScc98GO/VlFJoUQvkVuT
	9gYZ1iOpTxCm7zzuyIf8YfDL7v+cP4KpYQXYNmwyXZ/pGAXAX1p9PLGouQrpFb0KZ97XNCtfvxDDU
	4oq1tQQA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1toeOa-0030nu-1k;
	Sun, 02 Mar 2025 16:09:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 02 Mar 2025 16:09:56 +0800
Date: Sun, 2 Mar 2025 16:09:56 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: T Pratham <t-pratham@ti.com>
Cc: "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
	Praneeth Bajjuri <praneeth@ti.com>,
	Kamlesh Gurudasani <kamlesh@ti.com>,
	Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512
 in DTHE V2 driver
Message-ID: <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250218104943.2304730-2-t-pratham@ti.com>

On Tue, Feb 18, 2025 at 04:19:42PM +0530, T Pratham wrote:
>
> +struct dthe_hash_ctx {
> +	enum dthe_hash_algSel mode;
> +	u16 block_size;
> +	u8 digest_size;
> +	u8 phash_available;
> +	u32 phash[SHA512_DIGEST_SIZE / sizeof(u32)];

Is this format identical to the software sha512 hash? If so please
make the export/import functions translate to and from struct
sha512_state.

That way we can export and resume using the software sha512 in case
something goes wrong (e.g., memory allocation failure).

Ditto with all the other hash algorithms.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
