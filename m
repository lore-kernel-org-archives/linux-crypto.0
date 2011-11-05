From: Varun Wadekar <vwadekar@nvidia.com>
Subject: Re: [PATCH] crypto: driver for tegra AES hardware
Date: Sat, 5 Nov 2011 16:14:51 +0530
Message-ID: <4EB513A3.5080608@nvidia.com>
References: <1320405256-29374-1-git-send-email-vwadekar@nvidia.com> <74CDBE0F657A3D45AFBB94109FB122FF173F9A4E83@HQMAIL01.nvidia.com> <4EB4EFC0.1060702@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.hengli.com.au" <herbert@gondor.hengli.com.au>,
	"davem@davemloft.net" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
To: Stephen Warren <swarren@nvidia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3643 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab1KEKoy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Nov 2011 06:44:54 -0400
In-Reply-To: <4EB4EFC0.1060702@nvidia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>>> +	/* Initialize the vde clock */
>>> +	dd->aes_clk = clk_get(dev, "vde");
>> That clock doesn't exist in the mainline kernel; "bsev" exists for device
>> "tegra-aes"...
>>
> We need to use the "vde" clock. I will submit a patch to add the "vde"
> clock. "bsev" might not be needed at the moment.

Just checked and we have "vde" as a duplicate clock for "tegra-aes"
