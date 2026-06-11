Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7452A36212D;
	Thu, 11 Jun 2026 08:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781168027; cv=none; b=qJAT0IiF2ZEeKHgvX375uBtKbk8ZTPrRBN8iHTW9Kmtp578MRFafNTHee9lzsWFY6yAUChW0NV0Q4ZboWPbZozLRn872MVHRFGgC4MGaQ71uBMYucWJLQR5BY82YnQ6jUjVWcfkRqNlSRWGhTTkDToCRW5XnZfLgWreJ9013t3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781168027; c=relaxed/simple;
	bh=jBEkwGT0OVZPgOGXE98t5kMgDSiyjc/PBxqdhP1GYsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wi96V1fTmRxVxsLBF6pc/s03fJDL9Xdsjals3gGPLb+YYVSM14TF1f0AgE+gzyLBjJVe5DDsY0Z3yyjfhxZ/xZ8agvkdYTknC7IuwMAkmOr67iwuzYt62/E6tiGzc7Io5oHlPwGksLvfqvBX6yZ3y05yg7dPchonzr8YfWq5jzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=c1bxvP5j; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="c1bxvP5j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=kf6pvYnNiHlI9RfaXR6uXvxpuZeaNojFoeb5Pt/WyrI=; 
	b=c1bxvP5jUq7GUznMrTlLwzAnV6ow37jJlmUYiYB7a1ovArr0+88ywetzZSu2ctE+qnJY+joO50b
	fv3bTHawhhu4VmYUg9DZrOxMND/99E5XG2g9UW5k12dnWtgHcy8cYgjlN6KbIMH/aeBd871HA5iYq
	n4GUOwUsjDOPjnoggxZv/CCasqlQuQU3EMPmSBe9RFaISusx3E5uLo3m1kLsD24ACdLi+B8q6TssJ
	AXU0Rw2BTVbN0PVxMtecktDFiwAcRnsgc1hW2brlFeCNhhtIkKkqsm8ReJXADTdGS2LTzLWttz8tI
	oHO/75KDdr2654/xgadDWODOXzq5VIbY6jXg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1wXbAS-00000004XbK-3Bp6;
	Thu, 11 Jun 2026 16:53:41 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 11 Jun 2026 16:53:40 +0800
Date: Thu, 11 Jun 2026 16:53:40 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Cc: Demi Marie Obenour <devnull+demiobenour.gmail.com@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, brgl@kernel.org
Subject: Re: [PATCH] MAINTAINERS: make myself the maintainer of the Qualcomm
 QCE driver
Message-ID: <aip3lGs0Ka8flKnk@gondor.apana.org.au>
References: <20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602-qcom-qce-broken-v1-1-a4ef756089e0@oss.qualcomm.com>

On Tue, Jun 02, 2026 at 02:46:56PM +0200, Bartosz Golaszewski wrote:
> Qualcomm wants to keep supporting and extending the crypto engine driver.
> Thara has not been active for many months, so change the maintainer to
> myself and upgrade the driver to Supported.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> ---
> I've considered also marking the driver as BROKEN but decided not to.
> Next week I plan to address the failing self tests as well as go through
> all the ciphers it provides and remove ones that are known to be weak or
> deprecated.
> 
> Regarding the series that proposed to remove this[1], let this be the
> official objection. Qualcomm's clients use this IP, we have support for
> new features planned and intend to refactor it significantly.
> 
> [1] https://lore.kernel.org/all/20260523-delete-qce-v1-0-86105cd7f406@gmail.com/
> ---
>  MAINTAINERS | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
