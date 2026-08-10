Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C4A53A1E81;
	Mon, 10 Aug 2026 08:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786350371; cv=none; b=NQKE3iib+aVfk5S0mnJgWEJj+HmF+MRRYsNh2SiTSnqa9Xh4jtsWZT9eOPc6WRmUV27E6qnG+Fko9Pk/PBHVfqF7lqo0/HjrYyBmHPlSTqiIFy8P0a6GX31dtzSIvx5kCZWJB9RdaqtSnPX7NiSE7rISk/jXK0G3Be6hBtApQYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786350371; c=relaxed/simple;
	bh=xoBWPEDH4u8LHQLkqKqC+X87nmx6MySI/U43uPTpCp4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S5u3cFN+VkIDjBSr/+dmAsTKyDTemyNyPbcVp2Lke8yE8vmKd8dY/CwMYQdqdmT/6qVC7QJvpWeeBeQGgYWHg4ercXpXIDC2BQPGSYh5i5zyYW+2fTFVaPZ4s7ZOS5JcYVHgZ5Joke1+Dy2Eolv/UrGe19WhAwveg6aoSU3w9m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=DVKHC/wu; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="DVKHC/wu"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=8zhUpHeRV/R4nYHSqnSrFJHAnBWg4C48IHBrKysAW8Q=; 
	b=DVKHC/wuLIoZ6C/1wqdiae8YL0DaqIwZaQjgjJtakBAHRV58IlcrDNvgHzUUCkDYtH86SDJeuS6
	KGvDpjEwueaTZ5nID1zu9Mm6kdNz14aTtgH/4PpXZibYVHskIRw6YUd6adIbLh8PJXamrvjHR9k05
	r7Mu1lnkQGnK3WfbsjtMoHXonE5xaUv9YfL/rKfEvKFgvgvdUkcl04+wGlof6BS5ZKGyHN6eKlKc6
	In3Qcv2/e91muqUwsdoBpIOziVjOX/ZQV6v3ZKyLGHBkga9GQhwQ7qu8GUOo89pUeqt6iVrC3xgNi
	ha9yOcLUa6jvmiysIcs01aTxPEXc92fA/yhA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wtLKd-00000003Wac-2Xbo;
	Mon, 10 Aug 2026 16:26:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 10 Aug 2026 18:26:03 +1000
Date: Mon, 10 Aug 2026 18:26:03 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] dt-bindings: crypto: qcom,inline-crypto-engine:
 Add x1e80100 support
Message-ID: <anmLG7we8hUowHcj@gondor.apana.org.au>
References: <20260728-hamoa_ufs_ice_change-v3-0-293c7c6c2ae5@oss.qualcomm.com>
 <20260728-hamoa_ufs_ice_change-v3-1-293c7c6c2ae5@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-hamoa_ufs_ice_change-v3-1-293c7c6c2ae5@oss.qualcomm.com>

On Tue, Jul 28, 2026 at 05:53:55PM +0800, Wenjia Zhang wrote:
> Document the compatible string for inline crypto engine found
> on the Qualcomm X1E80100 SoC, used by the Hamoa IoT EVK board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml | 1 +
>  1 file changed, 1 insertion(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
