Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C23E443C19;
	Fri,  2 Oct 2026 08:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790929321; cv=none; b=jFOlJggABDxlsasIdVn/caIzZCoIsgjdf+PBZWNrYiq1/BMY7GetzX0I46jN420zaVL2Dnut6vxAwneQV2t6BjCgGJCwgeOhqSAgty0c7z79n3O+WUOOeNK628QvUUEqnBD85J/kvwyXCD4lTYKKU0aTLP56/GFLBuGrieoeLwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790929321; c=relaxed/simple;
	bh=NqmIdOOl4FuLzeQUPQSUrqrh/s3QDVKtCFQwUL77cjU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NMWsgUr4Rw2Rg5DAUY8B0bisx0bKOw0LDcfmtlcabPAz2uYhr3aSjSgUoCqWUp1TRht60a4pewxGeexBZrLkBanXLzawvw1CVlvvokdLt5BQQucK5J+1ao34Orage2SsZYnpKw0dqDgnlbmn7F+Qhrlq80GncAF5DmAuurUVPYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=Qfp54zQh; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="Qfp54zQh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=C2l/w1/cJtGJsDYl8CqQ6vSAImyUr3hMkhvRN65B828=; 
	b=Qfp54zQhoixoCFlxVrDLFxGBc0HoMqLKbl0AZMv1HsPy3CO8DbKVrOQgCqa4Y0H0o/6LXhZgcsO
	EZV6ytea8VJiSMA7a4QHpGzY4/x5yvr0kQL6bCNyqMHBMxRAY7CwTNKYzbV+cP5V1YTenPwlsHoQp
	pAdExIxs5jototGTZkCCA8NdJkuvscPfYx4+u4WU3M+jWjt9XnqjrqeAgD6PQKjdTQH8vtKUNZM8p
	ykw36km27G705FoYbB0uXEBQmtk3DX/ZbCGY6zbFiFUbFuglhiS7thVOYC0f4FNSLeQQTSVPTQGlf
	SjJR1lxcCgdjK2F2jwiZJJrkLIlS8dYO5e+Q==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCYWV-00000002maY-2W3N;
	Fri, 02 Oct 2026 16:21:44 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 18:21:43 +1000
Date: Fri, 2 Oct 2026 18:21:43 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Bartosz Golaszewski <brgl@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	stable@vger.kernel.org, Thara Gopinath <thara.gopinath@gmail.com>,
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
Subject: Re: [PATCH v8 00/14] crypto: qce - Fix crypto self-test failures
Message-ID: <ar9plydRjLKihyij@gondor.apana.org.au>
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <CAMRc=MdWZhLy7AXd2OiVsaT92xTh1EF+B+LNo2b-1D2TO3rAmA@mail.gmail.com>
 <arJGAjRRC-5EPjH6@gondor.apana.org.au>
 <CAMRc=MdMbAw5pfOOnV0ppdZyKqFe8c+ypt0e92vZqxhO4dSmGg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMRc=MdMbAw5pfOOnV0ppdZyKqFe8c+ypt0e92vZqxhO4dSmGg@mail.gmail.com>

On Tue, Sep 22, 2026 at 04:52:36AM -0700, Bartosz Golaszewski wrote:
>
> Yes, this does help but does it mean changes from cryptodev/master are not fed
> into linux-next?

I don't think so.  I just checked the latest linux-next and it
contains the top commit from cryptodev/master:

https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/commit/?id=d4930f6e1546a78d77ed881fb022965441eae937

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
