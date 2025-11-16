Received: from mail-m16.yeah.net (mail-m16.yeah.net [1.95.21.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7543B2D9780;
	Sun, 16 Nov 2025 15:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=1.95.21.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763308307; cv=none; b=pN7PKpvjGEtP/1v2N+croAjXNDVq6KpXpS8XUe5jXIp65aS/uazDPgLHa3wl/fwEubUBYbvm8//0DUiIU/r7LOS25XOH/CLCyaA5Yysc2y4jX4JRTejbAonfomNG+BuRYNIz9jY+8skdbkRhMv5svbovcR9UIpEIwRr2wAQaNhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763308307; c=relaxed/simple;
	bh=wket2NOOQTOVyDVdAUt1BdoPt1Alj4OUK2WsCbloDZw=;
	h=Message-ID:Date:MIME-Version:To:References:Subject:Cc:From:
	 In-Reply-To:Content-Type; b=op78GnnJeAIT39tcdKUXZwbJrWERlz7f6c39kK4jLVmfnwj8POvheejrbEbfN/gUh+Dop3ww8IiXqMt/ZFTte7ld5K0bZww7jn/3EggirYsGIAxviGhUBZ+azNZfl71Hs+KCPeWMhSszJnFT9bqcpUpeW0p0f3LnMFfkMtpcrWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=EFk1tY2a; arc=none smtp.client-ip=1.95.21.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="EFk1tY2a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Message-ID:Date:MIME-Version:To:Subject:From:
	Content-Type; bh=wket2NOOQTOVyDVdAUt1BdoPt1Alj4OUK2WsCbloDZw=;
	b=EFk1tY2aNgkLuyy61E4vucpg2Oj5flbxksbKRf5QT5d9yrK3PkEKHl825HdcmG
	kC5KzxUs8eCf1rcQKN15DDISS/GIYayAd3rCV/XRSB0USLhhU0fbW5gbQO8WwBMJ
	Sr2MIVAw/RfQsPqN8BdeYoYILe1tOPx25Ig4IJlYPtzy8=
Received: from [192.168.31.127] (unknown [])
	by gzsmtp1 (Coremail) with SMTP id Mc8vCgAHxf_Q8hlpJt09AQ--.15818S2;
	Sun, 16 Nov 2025 23:50:41 +0800 (CST)
Message-ID: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
Date: Sun, 16 Nov 2025 23:50:38 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: 1113996@bugs.debian.org
References: <a1ed50c2-7338-4c97-8c36-84d2fa83d018@yeah.net>
 <a1ed50c2-7338-4c97-8c36-84d2fa83d018@yeah.net>
Subject: Re: linux-image-amd64: self-tests for sha256 using
 sha256-padlock-nano failed.
Content-Language: en-US
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
 linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 CobeChen@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com,
 GeorgeXue@zhaoxin.com, LeoLiu-oc@zhaoxin.com, HansHu@zhaoxin.com,
 1113996@bugs.debian.org
From: larryw3i <larryw3i@yeah.net>
In-Reply-To: <a1ed50c2-7338-4c97-8c36-84d2fa83d018@yeah.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Mc8vCgAHxf_Q8hlpJt09AQ--.15818S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUxZjjDUUUU
X-CM-SenderInfo: xodu25vztlq5hhdkh0dhw/1tbiNhKRzWkZ8tKOqgAA3M

On Sun, 16 Nov 2025 23:11:17 +0800 larryw3i <larryw3i@yeah.net> wrote:
 > Doesn't anyone care about this bug? The kernel version is now
 > "6.17.7+deb14+1-amd64", yet this bug remains unfixed! The KX-6000G,
 > KX-U6780A, and KX-6640MA all exhibit this bug. Hey! Friends from
 > zhaoxin, what's the matter with you? 😅
 >
 > Regards,
 >
 > larryw3i
 >

