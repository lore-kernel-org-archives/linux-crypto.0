Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB2E86353;
	Tue,  1 Apr 2025 10:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743502090; cv=none; b=qRlh9gijaLdtY7MyvRVu2eTr6t+jLR40TBxhH+vVCO1x0wJSGKw1aSY7cRBd5YGgCkm45BUh/BUnMe4DHMkBVt9FFYoVG2rzsf4S/WV5xzxxsx/Akybg0A9RS8VXI8A4YudjDZTekzkTA6HKsIzbswwTISP+3EPFk74QPacdSGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743502090; c=relaxed/simple;
	bh=yFugp1Rxc0cYPpzVQW0lXNtg3bZ1WXxxGOShRPNRlI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k758aPpQEvenihjPa1ONn12/97Z7Dgs+p8RTiamuBSrx+9LwJf6BOM0b+QT7vWMsTHrDwK9AZut0lc7crxLTBRL0Nn0uc1/MWZToigYo1SPhZdL4jyv2KrBFJV25iHE+4+d8jzJgusrpRPr1hn6AcinmBa+B8APnNPce4wAMBYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=O8kjUBs9; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="O8kjUBs9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=1CdL+I+oUVedjIT0cAcvp9ljxK5oTh72oUB4C6PM8GQ=; b=O8kjUBs9C4EOJKpQJ/H3BYdKwx
	T7J0tArm6EEWUgJs4/OdJfdjZy2UlWT03G5X3ZA7idO4tnwa284QOJiceHIIP8AbeSLpzV3m6F+vl
	6X1UxsVeZkPspgMXAVSrJOlIoRfzLpH+oYNvP27WxA2WmfmtEFAemPPDjswYB/01orGfIQVzKqcJf
	KZCw6NaAKWI4mFdldWyeWcSDn1LSLLHYt3iY/4kLCktHVTVNCoKAVLjd/QB+u6elsCoeiCIgwG/r/
	RDTGB21m9MpuOfUxYAkrDjLl5F6F//BYRfc72sM4D8YTPXxt1QdlYxLNcF99zJAb3PHiYrEMmT3Jv
	5sOz0pJQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzYWy-00Bnnp-0r;
	Tue, 01 Apr 2025 18:07:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 18:07:40 +0800
Date: Tue, 1 Apr 2025 18:07:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z-u67D7xl2_SR-hg@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
 <20250114123935.18346-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114123935.18346-4-ansuelsmth@gmail.com>

On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
>
> +static int eip93_send_hash_req(struct crypto_async_request *async, u8 *data,
> +			       dma_addr_t *data_dma, u32 len, bool last)
> +{

...

> +again:
> +	ret = eip93_put_descriptor(eip93, &cdesc);
> +	if (ret) {
> +		usleep_range(EIP93_RING_BUSY_DELAY,
> +			     EIP93_RING_BUSY_DELAY * 2);
> +		goto again;
> +	}
> +
> +	/* Writing new descriptor count starts DMA action */
> +	writel(1, eip93->base + EIP93_REG_PE_CD_COUNT);

Why is there no locking here? Shouldn't this be under ring->write_lock?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
