Received: from mail-m16.yeah.net (mail-m16.yeah.net [220.197.32.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ED4C533D6;
	Wed, 19 Nov 2025 03:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763523766; cv=none; b=DpSgIUwXfQ0WQzy840W6bVBQz773qP3JmivSbz1kl57/rjliTZ72gSfgU83XmyzIwykzII2RL6Ra9mowBrHR1jKAUccNTmztptDSRxqvghsBYDDYhp8/ppI1NSUbwyrA7VFRFZ1WF9ehZdFP5z8jd7Ocx4PGdfDvgQVmRCN9ZxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763523766; c=relaxed/simple;
	bh=lTKwz55wwrHlTcz1HbXqCAQZtNu1kOrGcYrt93t5j5I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BZozt8Ee+LGNJaUPx6tPrDSa0TgiyTgP04jrRQOIWk6kcrANrfjDJbRWr+PUXTcSAIrNjcnHryN0ya+RnM0+pSLCXizcMThTjSsRZH2zSLJtRiSLwR8TpjShSTix/GjKASe+42744hrJ76m6UyBxjwFE1L2XsFfjZVlzHpfqUFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net; spf=pass smtp.mailfrom=yeah.net; dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b=C78JhhWF; arc=none smtp.client-ip=220.197.32.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yeah.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yeah.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yeah.net header.i=@yeah.net header.b="C78JhhWF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yeah.net;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=lTKwz55wwrHlTcz1HbXqCAQZtNu1kOrGcYrt93t5j5I=;
	b=C78JhhWFTb4UTrx8Z0xdzfF49GG5BmwhhO2Qj1ipdk2KlOMFsNAsbMpeSz6zOj
	surVJaYF0gM0ytDddrcX51YQ4GxF4gOwzjzxvE/6pT7yH0+j8dveGkqhXONlbwj/
	sYEueSlS8BUjJBrKsr/d32CTMaHgVno7Y1iDdeechR1vU=
Received: from [192.168.31.127] (unknown [])
	by gzsmtp3 (Coremail) with SMTP id M88vCgBH_OCLPB1pWCtDAg--.64378S2;
	Wed, 19 Nov 2025 11:42:06 +0800 (CST)
Message-ID: <75b3eda0-af44-4327-892e-71e8b4ed3bbb@yeah.net>
Date: Wed, 19 Nov 2025 11:41:57 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: padlock-sha - Disable broken driver
To: AlanSong-oc <AlanSong-oc@zhaoxin.com>, Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 CobeChen@zhaoxin.com, GeorgeXue@zhaoxin.com, HansHu@zhaoxin.com,
 LeoLiu-oc@zhaoxin.com, TonyWWang-oc@zhaoxin.com, YunShen@zhaoxin.com
References: <3af01fec-b4d3-4d0c-9450-2b722d4bbe39@yeah.net>
 <20251116183926.3969-1-ebiggers@kernel.org>
 <c24d0582-ae94-4dfb-ae6f-6baafa7fe689@zhaoxin.com>
 <c829e264-1cd0-4307-ac62-b75515ad3027@yeah.net>
 <e15e6946-2de8-4f12-8665-814bb2a9e013@zhaoxin.com>
Content-Language: en-US
From: larryw3i <larryw3i@yeah.net>
In-Reply-To: <e15e6946-2de8-4f12-8665-814bb2a9e013@zhaoxin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:M88vCgBH_OCLPB1pWCtDAg--.64378S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxU3a0PUUUUU
X-CM-SenderInfo: xodu25vztlq5hhdkh0dhw/1tbiOQ7TEGkdPI5n1AAA3B

Thank you! AlanSong-oc,

I just noticed SimpleDRM, I'll try it.

Regards,

larryw3i

On 11/18/25 16:22, AlanSong-oc wrote:
> generic SimpleDRM driver

