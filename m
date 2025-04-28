Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D51CAA6C;
	Mon, 28 Apr 2025 09:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745831501; cv=none; b=OpX4ACb6GVbd2U+E8JSZjglkGN+zmVPLcElfOJqSCf7N3Bf2fOhIWtUmVj524qTZERg9misCOmXpR/79XB/p2kEAhsR/GixBzGEb/QTVP5L7PTzy2KsVCZu59QfkZO/SJsWJ+vZmMlvE2MZFwATpwLgzJgrI2e31ot6OJEszzgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745831501; c=relaxed/simple;
	bh=7m0tP+q4T5mcm3kYzYk7AvWbv0g1gUih3/SFHpcXZHU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S/tZ2y6WgbpopsYpFM6SliNCk13QapXTYCKXUdAXdF5AVQZXNLYccaIozQhE9gPspCrv+jUJ4a3DHBWbMYNGQ24ScR9x5Djod89aXMH0LiaVquAz9kjqvAvZlTW2aVoCR2Oqqf9aUpbI7YQomzU5t7HufQDKvk7+adnG1TK1huc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YRg3Nghy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YRg3Nghy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115A2C4CEE4;
	Mon, 28 Apr 2025 09:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745831501;
	bh=7m0tP+q4T5mcm3kYzYk7AvWbv0g1gUih3/SFHpcXZHU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YRg3NghyMqn8irHaDhFHiyYABHnLpFnoCpsABEGAMKZ/8HEGybgmAJBEvfVb/zjPY
	 9fjMi0IAS1c7ZSgJkYEMBAN4AdDScDz++w5lbt3hZjuJae7wE/fwRdi88r6tz+BVDB
	 V0hzj7xumBfGQ6LPn46wN8yeJ4Zy3xBFr0LVGDYe/Z6OIcvBAXhQ1E/fpQUOuCupg1
	 cynOMhdvmOxLLJ22vUp2pkdvGsGh94jyjZ0ndbSwQFX/BmZWBVsUCcME+OdOrvyJ1H
	 7zxYBbLfPwFtx0gS7L5x3Yf/dD2UcpykUfxotWrokpzsP8xKHJLEnJN9EQmT/yvfjN
	 eT4OghP0/l52g==
Message-ID: <628faa57-f135-4f62-9827-5c98d9265391@kernel.org>
Date: Mon, 28 Apr 2025 11:11:36 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/6] dt-bindings: crypto: Document support for SPAcc
To: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
Cc: linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
 herbert@gondor.apana.org.au, Ruud.Derwig@synopsys.com,
 manjunath.hadli@vayavyalabs.com, adityak@vayavyalabs.com,
 Bhoomika Kadabi <bhoomikak@vayavyalabs.com>
References: <20250423101518.1360552-1-pavitrakumarm@vayavyalabs.com>
 <20250423101518.1360552-2-pavitrakumarm@vayavyalabs.com>
 <e5f47f52-807d-45ce-bd62-090f4af72b3a@kernel.org>
 <CALxtO0k0jeZF=Y5Ut_yhX8DxC3hVHWpnrcdJeBXP_GpA=O5T4w@mail.gmail.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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 fv0=
In-Reply-To: <CALxtO0k0jeZF=Y5Ut_yhX8DxC3hVHWpnrcdJeBXP_GpA=O5T4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 28/04/2025 10:13, Pavitrakumar Managutte wrote:
> Hi Krzysztof,
>    My comments are embedded below.
> 
> Warm regards,
> PK
> 
> 
> On Wed, Apr 23, 2025 at 6:23 PM Krzysztof Kozlowski <krzk@kernel.org> wrote:
> 
>> On 23/04/2025 12:15, Pavitrakumar M wrote:
>>> From: Pavitrakumar Managutte <pavitrakumarm@vayavyalabs.com>
>>>
>>> Add DT bindings related to the SPAcc driver for Documentation.
>>> DWC Synopsys Security Protocol Accelerator(SPAcc) Hardware Crypto
>>
>> These IP blocks are rarely usable on their own and need SoC
>> customization. Where any SoC users? Where are any SoC compatibles?
>>
> 
> PK: This is a new IP designed by Synopsys, which we tested on the Xilinx
> Zynqmp FPGA (ZCU104 board).
>        This is NOT a part of any SoC yet, but it might be in future.
>        Could you offer suggestions on how to handle such a case?

Hm? How is it possible to use it outside of a SoC?

Best regards,
Krzysztof
