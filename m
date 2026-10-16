Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F80438F642;
	Fri, 16 Oct 2026 02:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792116820; cv=none; b=qdiuwmkbgC7zvpeSt9mDMdyevQg8SuHxAJAVhec5MlFEFRxH6zH000rR2TDNt1dBcK0bG3zIzFdqF3OdSbit70vBGxhdWSQt9hDYyozjdCtP7+gbRwTqBTNvt9IzcHoEtIWV622Mi5PxtDlKejPH80NDJkIYKU4X6lcjV54L8SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792116820; c=relaxed/simple;
	bh=kZjsAJHj8CTHkgRxhId8BGhTxOMssuyN9ZnbTAi4Kr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qIZd+MYgw5KjM+QSLEYgjW7xPXDPr+GLr7hu3PSEYjOnvUvENBtfnMMh5Tx8p85d6llHRDflDs3PUIxgkfwYI/XLKPtC9lvdQrgT17VBolMYZoEwS2awTIB0wqpmQL0T1WIrffy3u5wH/I9/j+yRmYtfBb5EU8iymqJvTm16Zkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=hqbMw4Yi; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="hqbMw4Yi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=qkp4jay+o+y4zeLWoukqHKozl3d4n6FA7irDLE50Ec8=; 
	b=hqbMw4YirU+MRKpetYrDAM4kI2ncizNSLaFlxYgwmdQFHQP0YPKpd6kfgFpSXv6Z9HFA+TXy3Pa
	Jc+pkwXcC/fTJlCHXpjVn7aBL3OpMJmhOXjGTC2/hRADCj0hbcrBYJpqPgrH73OMb9dP1cLvAPfKl
	5ORpKkvGQnOI21toZuXWdjv02DXO9vtvStLxJxXD1687m7oqizRR4NbTt+6SL3JoY0OVSVRxbpVe6
	cO2H6pG2oe0Yyp235D2r1BZc6T46AEtJc6Zay6MWQeOWXkFwRgZE/L8fPWcC/9+g/Bgcv2Q9RLrwt
	QvXEuOL/WByZbMa53T6aEVcafB4YO2KV5VMA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHXRl-00000004O8F-3lKX;
	Fri, 16 Oct 2026 10:13:27 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Oct 2026 13:13:25 +1100
Date: Fri, 16 Oct 2026 13:13:25 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org,
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Stanimir Varbanov <svarbanov@mm-sol.com>,
	Eneas U de Queiroz <cotequeiroz@gmail.com>,
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Abel Vesa <abelvesa@kernel.org>
Subject: Re: [PATCH v10 00/14] crypto: qce - Fix crypto self-test failures
Message-ID: <atGIRTRuhFILV9pz@gondor.apana.org.au>
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
 <CAMRc=MejhYpC6QNXwK_cG_NuJs5XpOviK2NPsEwtnK0RxDi61Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MejhYpC6QNXwK_cG_NuJs5XpOviK2NPsEwtnK0RxDi61Q@mail.gmail.com>

On Thu, Oct 15, 2026 at 10:49:37AM -0400, Bartosz Golaszewski wrote:
>
> It came back with some more issues. And seems I have a build failure midway
> in the series so that needs fixing too.

How about breaking the large series into smaller chunks?

Just make sure that each fix is independent and makes an
improvement without regressing.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
