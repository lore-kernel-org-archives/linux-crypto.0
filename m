Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5861E529;
	Fri, 11 Oct 2024 12:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.62.61
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728650291; cv=none; b=oJ9WtukUggVt6TmEOVVZs2WP39UT71HVthxMIVtMdxGrv15rNb2VIxoUL8y0DL/ygZbRevJu++nVNvKFZDqag4a4zHk16AOcMd1n7nI+zBvKYsHNp/LBkLlW7LuTGrSM2uq+tBGwY/XuvD+xYwR53iX3BNEBGm4uV/zesPE5F4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728650291; c=relaxed/simple;
	bh=XEFJkHU2DVLB790Dyv6luJPrprj1o11dKBrj+pYw0Dk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o09ipoX6o0YMj0hwXLPMbWwJ/7YdTqkOL1g1W5/s4gL6KBMlv1Gym95SZiyBOf0PgOTvS2k14QHJcYmQ4PcyY4fjaDN4cwJOUF1IhMrD8j1IzWWR7wX7q3sL6hRxlwtszZ0YAO6boijkggdg2446HxKp64eC39gtl/3WijSOoJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=MZVa/ZpY; arc=none smtp.client-ip=85.214.62.61
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="MZVa/ZpY"
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: marex@denx.de)
	by phobos.denx.de (Postfix) with ESMTPSA id 7E7B8892A2;
	Fri, 11 Oct 2024 14:38:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
	s=phobos-20191101; t=1728650287;
	bh=Nu7pFyBXAUwuti8JBZFKIh2w9Sx9Lu3Nd/JP7Yz98yA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MZVa/ZpYVkxmJC6P1XYYZl4sRfth56qmUDPz5aH3O3lfE5dUODIqLuso53OMapvEC
	 fEy+4JBdH3pfYOZ0GNkMQB0CTbO0zWsR3G4VzljeBmCI9GbMaMqsFIQZzeWjETxL50
	 gERhj9m9ZdKpxrHQARtb5Rtvy3gBcOX7i0lR/KQ27FjWNhSNIfQdSVCteZ57iKYTa6
	 L5JTE0ijPtV4JC+SAJmHw/6FSKfQ7IwRUYeyamyIN3MggzZXbwP0D+VXYVvmGMGxyd
	 Y0TKySd99EBXQ4YeghWXv2AJDkQ30FRAMrJoao0K7JVxlsCJ0DnMiEBV8a4aNpYnsq
	 M0HftcVOBRyVg==
Message-ID: <c59f3593-cb69-48c6-ab0e-f1275c7e5477@denx.de>
Date: Fri, 11 Oct 2024 14:38:04 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] hwrng: stm32 - implement support for STM32MP25x
 platforms
To: Gatien CHEVALLIER <gatien.chevallier@foss.st.com>,
 Olivia Mackall <olivia@selenic.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Rob Herring <robh+dt@kernel.org>,
 Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
 Conor Dooley <conor+dt@kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>
Cc: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 Lionel Debieve <lionel.debieve@foss.st.com>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Yang Yingliang <yangyingliang@huawei.com>
References: <20241007132721.168428-1-gatien.chevallier@foss.st.com>
 <20241007132721.168428-3-gatien.chevallier@foss.st.com>
 <2fad1566-49f9-4586-b0d4-8a4a12f9e69e@denx.de>
 <9283caeb-1b84-43c2-a8a4-6b43a6962f34@foss.st.com>
 <b4932f99-cda4-42ef-88d8-461ca6e8cefd@denx.de>
 <6a4cccb4-9e55-437d-925b-5f5bb1804159@foss.st.com>
Content-Language: en-US
From: Marek Vasut <marex@denx.de>
In-Reply-To: <6a4cccb4-9e55-437d-925b-5f5bb1804159@foss.st.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.8 at phobos.denx.de
X-Virus-Status: Clean

On 10/11/24 2:07 PM, Gatien CHEVALLIER wrote:
> 
> 
> On 10/11/24 13:24, Marek Vasut wrote:
>> On 10/11/24 11:55 AM, Gatien CHEVALLIER wrote:
>>>
>>>
>>> On 10/7/24 15:54, Marek Vasut wrote:
>>>> On 10/7/24 3:27 PM, Gatien Chevallier wrote:
>>>>> Implement the support for STM32MP25x platforms. On this platform, a
>>>>> security clock is shared between some hardware blocks. For the RNG,
>>>>> it is the RNG kernel clock. Therefore, the gate is no more shared
>>>>> between the RNG bus and kernel clocks as on STM32MP1x platforms and
>>>>> the bus clock has to be managed on its own.
>>>>>
>>>>> Signed-off-by: Gatien Chevallier <gatien.chevallier@foss.st.com>
>>>> A bit of a higher-level design question -- can you use drivers/clk/ 
>>>> clk-bulk.c clk_bulk_*() to handle all these disparate count of clock 
>>>> easily ?
>>>
>>> Hi, I'd like to make sure that we enable the core clock before the bus
>>> clock so that the RNG hardware block can start its internal tests while
>>> we ungate the bus clock. It's not a strong opinion but it feels better.
>> Maybe this could still work if the struct clk_bulk_data {} is ordered 
>> that way, so the bus clock are first, and the rest afterward ?
> 
> I guess you meant, the core first.

Err, yes, core.

> Putting the bus clock first with the updated YAML doc generates a
> warning when checking the bindings. I guess what you propose is OK
> then. Core clock is defined first in the device tree.

Not in DT, leave DT as-is. Look at struct clk_bulk_data , I think when 
you use the clk_bulk_*() functions, you pass in a list of struct 
clk_bulk_data, which each describes one clock, so just make sure that 
list of struct clk_bulk_data in the driver is ordered the way you need 
it to be ordered and you should be fine.
