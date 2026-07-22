Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A150844CF22;
	Wed, 22 Jul 2026 23:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784763066; cv=none; b=lmhKEvAQfidLxUvrmDF0XkfnhUieiVqq+xJ4MxmkGfU453D/IIBCVKF3udtzb87QNbTO9gXtxpO3+BZsL9OlXo14E+Pe1nhFdljPUv4uCUeFm4qaVdYoqjG1ZnJua2rEJYIRs3jjTKpL8dJN58jKSVvo6Hyceek8Y/agUlKdqZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784763066; c=relaxed/simple;
	bh=hWmSvVA4k7ETmCZuvmtqctvCGfhe3XMocDFOc1x0/7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UOB+VwCddI8J3+5Gqw9+je7uQwyFPzEWOiUmmn9ElOkHwxidhtuBtirnIzU1A9BiXvxL9+9JX6NuwIAZYL51esfsHBtMpNfVDQAf7024gonZ+m4JsV0jY61YiwjmA2lf1zxLZslk29GnV6iY/BuMdn4rYKWxo8ql3otbbmWKKDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [IPV6:2400:2410:b120:f200:a1f3:73da:3a04:160d] (unknown [IPv6:2400:2410:b120:f200:a1f3:73da:3a04:160d])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id B9BBE3F53F;
	Thu, 23 Jul 2026 01:30:50 +0200 (CEST)
Message-ID: <d45ed4a1-da22-44a3-9f9e-78041dd338b1@hogyros.de>
Date: Thu, 23 Jul 2026 08:30:47 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: pcrypt - Remove pcrypt
To: Eric Biggers <ebiggers@kernel.org>, Hendrik Donner <hd@os-cillation.de>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Steffen Klassert <steffen.klassert@secunet.com>,
 Thomas Huth <thuth@redhat.com>
References: <20260713223234.24812-1-ebiggers@kernel.org>
 <20260713223234.24812-2-ebiggers@kernel.org>
 <37ecba68-947a-45ad-9ec4-361facc06a05@os-cillation.de>
 <20260721195004.GA3383223@google.com>
 <19613c3e-9756-45fc-84b6-b650ba3723a7@os-cillation.de>
 <20260722194023.GB2118@quark>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20260722194023.GB2118@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 7/23/26 4:40 AM, Eric Biggers wrote:

> So while maybe pcrypt does still help a bit on this platform for now,
> the approach does seem quite dated and largely a workaround for
> inefficiencies elsewhere in the stack (including systems where the
> optimized crypto code is accidentally not enabled).

There is one additional aspect: offloading frees the CPU to do something 
else -- and that is where even offload engines that are slower than the 
CPU can still be beneficial in the big picture.

    Simon
