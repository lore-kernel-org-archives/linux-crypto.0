Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02B013664C
	for <linux-crypto@vger.kernel.org>; Fri, 31 May 2024 10:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717149853; cv=none; b=J8kNN7JMoGj/IVZvviboLitokE7YkrO5P/ALLeTyS/Up3pHlVcgvEmS5qMx2Q6XkvwXpRhsuA37Z6xHxr5X5appnpU2AB/WpcjhEiYLngMJDfc2aid1EQQbsUacW36BvNKCn0R9av2z6hddD63/RCrwc/rpg7PdZ/lrddOike0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717149853; c=relaxed/simple;
	bh=6FFVaDj2Wh9HT++ohzHlC98/EJ52YxrG32nQJX66Ubs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QK/eroIw3OkvrnSvpbXK3FFGgZSI9daxZbVIn3U3ZJn3gzYCEAv+4XNhQqlXd4hXf4lnJZ++z7sHGeu4uVg2+SXMT+p6XevWnKEv486oJl5z+DSMqsfkCfujHPO+Cf6bf/c8FCVuvNZdPqS5trYxhjt/1bMASfrfDXDOLDYZ9JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=oeaE7Yt6; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="oeaE7Yt6"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 786F48869E;
	Fri, 31 May 2024 12:04:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1717149848;
	bh=9GPw1umK/mB9EDut1kKlrkCFOEdOSCsqYb2hH2z3l2U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=oeaE7Yt672PKDzAwIDlx9j6005P9UKBVIt1SeB/CBXN2mz4BXXSWa21bMQ/+N6Wo7
	 Jo9JP5poC8xX2A+PS6KKtlNIQJ+vxaswyL/2xkU7qj2TQAjJDAsAcWV8QI+e6KkAxJ
	 mDNxhdBrCrtwbxqWrT7sLW5r2MuSkxbYax1342GvpWNzE4VOLzTRAiU/lReMuRFjOY
	 xgr5yF7ObZxgq/kgOK+iCm+KGZrO5yDZsN/yX26hYWgSmjrJPiftKroXf3BJZ4u2v2
	 L5PCHc62CD8HWxqj94Me2kna4KPYPtrfg4n9mAVKW+RW4XB9PELffe4TEIIZL0rKsd
	 502f4eU1vwbDw==
Message-ID: <693df34f-c387-48a5-bbb9-1fa2e3077da8@denx.de>
Date: Fri, 31 May 2024 12:04:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] hwrng: stm32 - cache device pointer in struct
 stm32_rng_private
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org,
 Gatien Chevallier <gatien.chevallier@foss.st.com>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Olivia Mackall <olivia@selenic.com>, Rob Herring <robh@kernel.org>,
 Yang Yingliang <yangyingliang@huawei.com>, kernel@dh-electronics.com,
 linux-arm-kernel@lists.infradead.org,
 linux-stm32@st-md-mailman.stormreply.com
References: <20240516193757.12458-1-marex@denx.de>
 <20240516193757.12458-2-marex@denx.de> <ZllavXc2lscS9TRc@gondor.apana.org.au>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <ZllavXc2lscS9TRc@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 5/31/24 7:06 AM, Herbert Xu wrote:
> On Thu, May 16, 2024 at 09:37:41PM +0200, Marek Vasut wrote:
>> Place device pointer in struct stm32_rng_private and use it all over the
>> place to get rid of the horrible type casts throughout the driver.
>>
>> No functional change.
>>
>> Acked-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>> Signed-off-by: Marek Vasut <marex@denx.de>
> 
> I think you should remove the assignment of rng.priv too as nothing
> should use it anymore after your patch.

Fixed in V3, thanks.
