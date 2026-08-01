Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48D8377EBF;
	Sat,  1 Aug 2026 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785602164; cv=none; b=dLBdREftlCSuGA4DqDhb5joFgAenjLzOentEptQ8s5uFvl2lZD4GMjyk3QnHxkWhwyJt4AT7p1w9GJp0Q/DqENSj4XvgK2UvPZhjs42duNVAduGTCI2UptwkwEW5AozT6gq7F+EPFWcaUhKt50TBiOcjNsGJXajZ9MBIube6+fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785602164; c=relaxed/simple;
	bh=vrjgGiPRuWReDGi8MKdSBQy7WGNEPeQPE7C/pRoyn5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sa7DrduPmZbp1IAk3q1CZkXEn/UtEVr15nUppBMqEirzvvLOgCh9Jyd+ppn0GaVboGhDopsdgx6DhvdCtqyNBnUdHze47exBDqpEyXRbMDsY/Fnm/W6me5yRDWMGV0/5aGS8oohmqLZlcq9edfInn0+JF+4QS3Uukw0CVdL4XrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C4oHNMJZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C4oHNMJZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8E5D1F00AC4;
	Sat,  1 Aug 2026 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785602162;
	bh=0GUXbNGBMe1qgNfT4TxSOBT73Pk8Jqt+tJKts1YkwRU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=C4oHNMJZ3AEwP44k1Ts1A1EmlJ61cjohgPdBQ3GSSLCBMtD3pwi+AoWMw29wwRgBq
	 ectkGNpNhCjBXfsAJXDfBfLNZvKv1OZOqc7RDLsUf9tGQLqyw+fY4FqqfvodHsEgen
	 1RNgLkb49dPk1yeeM/Gnp2aDzw3PXkB20W8qCdRxopIVpNLC5BsDdoE4zdaHzaO6nw
	 pFYrN1YNjvvBLlj1HD/rtNWDXIn9nkqP0NzxSi573lSz0cqQf0dfNwEXsF0LM4OYoX
	 lSTMhvOI3NgvKPzoRz1FNG73/JDkXPdDjDV2WWE9PAZW+zoE/EnBvzguiYP05HwBYk
	 L7KpwYFi9FzJA==
Message-ID: <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
Date: Sat, 1 Aug 2026 18:35:56 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>, linux-crypto@vger.kernel.org,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Bartosz Golaszewski <brgl@kernel.org>,
 Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20260731050838.158825-1-ebiggers@kernel.org>
 <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com>
 <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark>
From: Krzysztof Kozlowski <krzk@kernel.org>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <20260801162900.GA2021@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/08/2026 18:29, Eric Biggers wrote:
> On Sat, Aug 01, 2026 at 11:18:46AM +0200, Krzysztof Kozlowski wrote:
>> On 31/07/2026 20:31, Demi Marie Obenour wrote:
>>> On 7/31/26 05:06, Krzysztof Kozlowski wrote:
>>>> On 31/07/2026 07:08, Eric Biggers wrote:
>>>>> None of the algorithms the QCE driver registers with the crypto API are
>>>>> even close to being useful.  They're massively outperformed by the
>>>>
>>>> The amount of patches you send towards removal of QCE is really
>>>> stunning. Or rather worrying. This is like third approach or so.
>>>>
>>>> Your previous approaches received valid feedback, including even fixes
>>>> and committment of new maintainer.
>>>>
>>>> But you even complained that it does receive fixes! [1]
>>>>
>>>> We removed the driver temporarily from typical configurations, so no one
>>>> will be affected, by whatever is found now and not yet fixed. Still not
>>>> enough! For you this was reason to remove the driver (AGAIN!) [2]
>>>
>>> A stub driver needs to be added for power management reasons.  It turns
>>> out that if there is no driver, power consumption is very high.
>>>
>>>> This is beyond comprehension and very unpleasant, because you actively
>>>> work against the community with this approach.
>>>
>>> I trust that Bartosz can fix the driver with enough work.  However,
>>> even if the QCE driver had never had a single bug, it would still not
>>> be worth using.  Its performance is so poor that one should always
>>> use CPU-based crypto instead.  In the default configuration, that is
>>> in fact what happens.
>>>
>>> The QCE's algorithm implementations only provide a way people can
>>> misconfigure their systems and ruin their performance.  There are
>>> debug options that also severely harm performance, but they have
>>> legitimate uses during development.  The current QCE driver doesn't.
>>>
>>> I have no problem with a driver for the QCE that does something actually
>>> useful.  While there are disagreements about whether restricted media
>>> processing is a feature or an anti-feature, my view is that it is
>>> better for it to be implemented upstream than in an out-of-tree driver.
>>> However, the driver as it currently exists does not implement this.
>>>
>>> I expect that such a driver would not use the crypto API at all.
>>> Instead, I suspect it would use dmabufs for source and destination
>>> buffers and integrate with the secure world firmware in some way.
>>> That means that the driver doesn't belong under drivers/crypto.
>>>
>>> These are the reasons I submitted a patch to mark the driver as BROKEN,
>>> which Herbert Xu has since accepted.
>>
>> And Bartosz and other people committed to work on this by improving,
>> fixing and in the long term providing you with the actual important user
>> of this. All this was already said.
>>
>> And then after having all these discussions Eric sends AGAIN patch to
>> remove the driver. How many times this will have to be discussed the
>> same way? If we now reach agreement the driver stays, next month again
>> there will be a patch to remove it? And then one more month again?
>>
>> The driver is marked as BROKEN, thus absolutely NO ONE is affected by
>> any issues the driver has.
>>
>> It's some personal vendetta to keep coming after that - unimportant now
>> - driver.
> 
> Well, there was also feedback that BROKEN drivers should not stay in the
> tree and instead just be removed.  So I was considering that feedback
> too, as well as the results of additional testing and review of this
> driver, including evidence that the driver performs even worse than
> thought and is actually getting even worse; the performance seems
> irredeemable.  As for proposing the stub driver, that is addressing the
> power management issue that was mentioned on the other thread.
> 
> Anyway, it sounds like you support it being BROKEN.  Okay, but again, as
> Greg mentioned
> (https://lore.kernel.org/linux-crypto/2026071312-uncover-refining-8cac@gregkh/)
> it is awkward to have BROKEN stuff in the tree since it cannot even be
> built.  I'm not sure we can have it both ways!

Which was I think pointed already a few times that it will not stay
BROKEN but will get fixed and get proper useful use cases.

Best regards,
Krzysztof
