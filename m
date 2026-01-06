Received: from mail-m16.yeah.net (mail-m16.yeah.net [220.197.32.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8676324B10;
	Tue,  6 Jan 2026 14:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767710941; cv=none; b=AU14RtLVn+73T+zKlxGIOkqiRp4546nCPf0/cpP5jejcAD4/3bSAnPJjriyUFIPbO6sN+YT8fBx0xRSctIX0OtJ9vIXYh7GJ4vH2tr3yj55J18PlPxqup2jEbisWo51lBuEYaUTVu26aSjkcrIPKIJHJZdkgH/oD2MuLhvchQwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767710941; c=relaxed/simple;
	bh=WhhPzEg0llQgbuaDG69D13KYal+JIKL/+GJTbfbIhvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmkt614VPRHpFotY1nMoU4nKmZB+pUq6s7unOWpm8ajLjRheHC2/wTAKhilOUPj62KujVKw3AwmF74wlh6gv3Fy7YfhAcBHdyh8J41szfk87E2RB0MhSd5331DFoDn/urDytrnL/kX25NThdSW7cT5j3QhBPxoI3pBiZ5O8NcSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=lMNHzUNs; arc=none smtp.client-ip=220.197.32.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="lMNHzUNs"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=xNXqZSGEezRe9KPgNiAGwbleSkcYt5PAI0iN8P8EOXE=;
	b=lMNHzUNsCpvQXF4SgKADN/pt5WeomgY5tEfqCmXLBSP62QTWyCLjsxY3FpNtBX
	tzqsB6hHnHVM2anTVuFs77inrtCFDmPwRPgD+a+pNCpEjCkgClDe2mX3MutrPC0c
	3DUvFNWTXWSZNZMWCMRfA8R77B7YFODJBt1keo8P1siHc=
Received: from [192.168.31.127] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id Mc8vCgCXmMm_IF1pB2esBA--.50800S2;
	Tue, 06 Jan 2026 22:48:33 +0800 (CST)
Message-ID: <e3b70f03-34b7-40a0-a335-7c4cf9d09cba@yeah.net>
Date: Tue, 6 Jan 2026 22:47:45 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, CobeChen@zhaoxin.com,
 GeorgeXue@zhaoxin.com, HansHu@zhaoxin.com, LeoLiu-oc@zhaoxin.com,
 TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <aRvpWqwQhndipqx-@gondor.apana.org.au> <20251118040244.GB3993@sol>
 <cd6a8143-f93a-4843-b8f6-dbff645c7555@zhaoxin.com>
 <aUI4CGp6kK7mxgEr@gondor.apana.org.au>
 <f82e5d10-4300-4f7a-befe-fed524b52d92@zhaoxin.com>
Content-Language: en-US
From: larryw3i <larryw3i@yeah.net>
In-Reply-To: <f82e5d10-4300-4f7a-befe-fed524b52d92@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Mc8vCgCXmMm_IF1pB2esBA--.50800S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUwmhFUUUUU
X-CM-SenderInfo: xodu25vztlq5hhdkh0dhw/1tbiIQLpJmldIMIWcAAA3c

Dear AlanSone-oc,

Can this patch 
(https://patchwork.kernel.org/project/linux-crypto/list/?series=1034934&state=%2A&archive=both) 
be accepted before the arrival of the Chinese Lunar New Year? My beloved 
laptop hasn't been turned on for a long time! ~zZ

BR,

larryw3i

On 12/17/25 17:04, AlanSong-oc wrote:
> Sincere thanks for your helpful suggestion. I will add ZHAOXIN platform
> support to lib/crypto.

