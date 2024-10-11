Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F2198A0C;
	Fri, 11 Oct 2024 16:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728663529; cv=none; b=hXFbec0w/9W5lZ9NhLyMLqBew42YKD60IXqO02YHLBB9Jlo/p9yb533tJ1BjYXYjsB8qoOcXnVXD8Q12IlGV/n3u7Uqh7BdognsXCrMlJbbr0XUtZyPe7trOV9hpGOvpHxUkX0O4Jdj2Xc+7JfYtHJiJSc++Cy0kWwGcP39N1dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728663529; c=relaxed/simple;
	bh=Pm4bodHDAXwxb1Q80RwouKpT8Ucyao2pryFw6Kvk7ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jWyzLH9eQy+hqoT9pfC48sESAQdyXfKaJaBdiILYsPpT7AyizJUCGpspT1kPooyLPuL3RKD8XEw5EtsonZ0DfTuBHrNqdmxzxGi7ddPdAwKQQAIfv55HLLwJoqkoVxyvzEBhHAu4v+G2GBIvDDMoQcaPfdU1bOsmdbxrh9yAnxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=gQqcnntD; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="gQqcnntD"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 45A6789380;
	Fri, 11 Oct 2024 18:18:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728663526;
	bh=7OnMDRBBif/ifvRdujrBF2mJgQF6N6AT/gVMCXwQu30=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gQqcnntDv8SZ0MTLiKmxBawB44JNAjL8RVEWWLFgLQUzpojBtVeLQi9K7x/xP045H
	 mz5WT4xJOzqpLcIoYvmXVCN7lzqmah0+rqR60X+/JFen+Ei9jQLPUge1e08TBZQVqO
	 +DEngWSmGiH0ZITBphyZs6EbHNejX0GQXq/OHIkeugm3+9243fX+1sQyzL4TV12YAu
	 iLoMKtg2U1Jltj8mKAUHTQKwJktd4h5KpxNEdoBN/BJ+Dk+1Mly5El5YzlIrQUIHgl
	 EwOlzviJNtuO8Mkqen3yVqrICHkfwfMSJWievwg0IQaGfaT76ojWyUdOFs4kn+nT2Q
	 8BFrsg5qP4lDQ==
Message-ID: <9c957e5f-91a2-4ff8-8f17-3d79af56949c@denx.de>
Date: Fri, 11 Oct 2024 18:17:35 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] arm64: dts: st: add RNG node on stm32mp251
To: Gatien Chevallier <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 Lionel Debieve <lionel.debieve@foss.st.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20241011-rng-mp25-v2-v2-0-76fd6170280c@foss.st.com>
 <20241011-rng-mp25-v2-v2-4-76fd6170280c@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <20241011-rng-mp25-v2-v2-4-76fd6170280c@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/11/24 5:41 PM, Gatien Chevallier wrote:
> Update the device-tree stm32mp251.dtsi by adding the Random Number
> Generator(RNG) node.
> 
> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
Reviewed-by: Marek Vasut <marex@denx.de>
