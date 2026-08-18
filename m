Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2058939EF1F;
	Tue, 18 Aug 2026 07:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787039270; cv=none; b=DrpOCGI5qFSRYc+/KylTj5k3Gu7VMR1+A+Fk/8eY+ZrRWpQFg3k2cvWxml+u6io1MpTeFVGB1sKA2o1Uc49FntdcIJNw0zZWEYs2NMf/lnbVliuodo2PuMpOhLTM45P/KLGYfjvCjcvevfUTwWvooFTtbkGqRYeIAnggWic6ilI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787039270; c=relaxed/simple;
	bh=ilTTLe/wC7IrgUGD+/wPmc689ydrd7VgIu8rGFv/4BA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mrgC9FRZPe6swcQVJ+jTSr2Od/aI8LohwX9VwH7l83wkgKg8ydYJXeavWFb9bjtSefXwyv77I0GnxdftXQ9IpwJVRpxXwD/Fi8l7giE9Pn2X+x9LHPxD/5Bbu3qdVfsBsJ8h5BiIj0exmW0lubdF9jrUXZXwLe8hIcAS5FNNkLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eCF0c+nr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eCF0c+nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840701F00A3A;
	Tue, 18 Aug 2026 07:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787039268;
	bh=djpfRDucXyIg8quSnWbcOKzA6UPGYee2c4kpZs7sk0U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eCF0c+nr0OK5DMjKVNaoEOUTrOiIvUkYBVhQXjxFez+SYoEI6A+Sv/okeCLM0Sl2h
	 1PMdFUIBpsYn0VoSQhfEkL8XiHQzWOvWgE4QjyQd1uKZCsoRaxmdPoJ+x+sVkkM4Db
	 eLIu+nRFEYK7DMHSAH1XC59TG60zBlntkbjU7QNNQh124BUPxDJXx/qXG8ptH3pRNi
	 niKlbS7an/t1z1LCSOLvbwLlcB4P2ahZeNmZ3QkfbEDO9RW5duQbYJP3DIRt0wluXQ
	 o5IvLHhxHZYaWlHT8eU0glTRriV6P/YG96/1q5Iy5vd8VjifTMLSZHMWhYfKJwwDtd
	 EwqB+qsJOwYQw==
Message-ID: <b740a4b6-deda-49a4-9313-c8bf844b8bc3@kernel.org>
Date: Tue, 18 Aug 2026 09:47:40 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] soc: qcom: ice: Enable PM runtime for ICE driver
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>,
 Rob Herring <robh@kernel.org>, Conor Dooley <conor+dt@kernel.org>,
 Bjorn Andersson <andersson@kernel.org>,
 Konrad Dybcio <konradybcio@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S . Miller" <davem@davemloft.net>, devicetree@vger.kernel.org,
 linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, Neeraj Soni <neeraj.soni@oss.qualcomm.com>,
 Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
 bjorn.andersson@oss.qualcomm.com
References: <20260512033750.3393050-1-linlin.zhang@oss.qualcomm.com>
 <20260512033750.3393050-3-linlin.zhang@oss.qualcomm.com>
 <b07a3634-a7a6-4f28-994b-fc900be26879@kernel.org>
 <01578e6a-d10a-46df-bb32-fd45ecb365d7@oss.qualcomm.com>
 <f0b90edc-6584-4b30-a2d1-e72139983fdb@kernel.org>
 <60b775b0-5482-4b95-b37e-ba5764efc0cf@oss.qualcomm.com>
 <ed4c6700-57be-4975-9ff9-bb33098766a1@oss.qualcomm.com>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <ed4c6700-57be-4975-9ff9-bb33098766a1@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 18/08/2026 09:35, Linlin Zhang wrote:
> 
> 
> On 8/18/2026 3:30 PM, Linlin Zhang wrote:
>>
>>
>> On 5/15/2026 10:48 PM, Krzysztof Kozlowski wrote:
>>> On 15/05/2026 16:22, Linlin Zhang wrote:
>>>>
>>>> Hi Krzysztof,
>>>>
>>>> Thanks for the review.
>>>>
>>>> For the SCMI-based platforms (e.g. sa8255p), the ICE resources such as
>>>> clocks are not controlled directly by the ICE driver. Instead, they are
>>>> managed by remote firmware and exposed to Linux via power domains. As a
>>>> result, the ICE driver cannot use clk_prepare_enable() directly to
>>>> control the hardware clock.
>>>>
>>>> The intention of moving the clock handling into runtime PM callbacks is
>>>> to align the ICE driver with the power domain framework used on these
>>>> platforms. When the ICE device is attached to a power domain, invoking
>>>> pm_runtime_resume_and_get() will trigger the provider (remote firmware
>>>> via SCMI) to power up the device, which in turn enables the underlying
>>>> clock and other resources.
>>>>
>>>> This design follows the guidance where the runtime PM framework is
>>>> used as the common mechanism to abstract both:
>>>>   - direct clock control on non-SCMI platforms, and
>>>>   - firmware-controlled resources via power domains on SCMI platforms.
>>>>
>>>> In both cases, the runtime PM callbacks are responsible for performing
>>>> the actual resource enable/disable:
>>>>   - for legacy platforms: clk_prepare_enable()/disable_unprepare()
>>>>   - for SCMI platforms: power domain on/off handled by firmware
>>>>
>>>> So while it may look like an additional layer on legacy platforms, this
>>>> approach provides a unified mechanism without requiring separate driver
>>>> entry points or special handling in the upper layers (e.g. UFS driver).
>>>>
>>>> That said, I understand your concern that introducing runtime PM solely
>>>> for clock gating can be seen as unnecessary overhead on existing
>>>> platforms. I will revisit the implementation to ensure that:
>>>>   - the runtime PM integration does not introduce regressions for legacy
>>>>     platforms, and
>>>>   - the design clearly justifies the common abstraction for both SCMI
>>>>     and non-SCMI cases.
>>>>
>>>> In addition, I rewrite the commit message as the following to make the
>>>> intention more clear.
>>>>
>>>>   On some platforms the ICE device is placed in a firmware-managed power
>>>>   domain. In those cases the ICE core resources (including the clock) are
>>>>   not directly controllable by Linux and are instead toggled by the power
>>>>   domain provider (e.g. remote firmware via SCMI).
>>>>
>>>>   Wire the ICE device into runtime PM so that a single pm_runtime
>>>>   transition is used to bring the ICE device up/down. When the device is
>>>>   attached to a PM domain, pm_runtime_resume_and_get()/pm_runtime_put_sync()
>>>>   will invoke the PM domain callbacks and let the provider manage the
>>>>   resources. On platforms without a PM domain the runtime PM callbacks
>>>>   continue to perform the existing clock enable/disable locally.
>>>>
>>>>   No functional change is intended for non-firmware-managed platforms; the
>>>>   change provides a common control point that allows ICE to operate when
>>>>   resources are owned by a PM domain provider.
>>>>
>>>
>>>
>>> Nothing here resolves the comments. Also, it's top posted. Honestly, I
>>> won't be talking through you with LLM, so consider patch NAKed.
>>>
>>> Best regards,
>>> Krzysztof
>>
>> Sorry for the late due to personal matters. 
>>
>> At that time, I reviewed your comments one by one and provided answers, then
>> let AI polish the answer.
>>
>> I'll add new replies after your comments point by point.
>>
>> Thanks for the review.
>>
> 
> Alternatively, if you would prefer to review a revised patch series that
> incorporates the changes we have already agreed upon for patches 0/3 and 1/3,
> please let me know and I would be happy to prepare it.

You received review which you did not implement. Reviewing such code
again is waste of time. Pasting excessively long, unparseable LLM
outputs is just another way to waste time of reviewers. Pasting here
result, intention or instructions for LLM is another thing not to do,
recently there is plague of this. We are not your LLM. We are not going
to talk with your LLM through you. We are not going to receive your prompts.

NAK

Best regards,
Krzysztof
