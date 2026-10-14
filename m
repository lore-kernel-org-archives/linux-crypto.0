Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0B248C41B
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 07:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791963557; cv=none; b=rE6o/Uwq3nFn3AXN07l2y0ZM6ye4s2I+EBw51XF7DI55KvLrYp57vQK3T+7qeCvLPaEf9byEPmKaMf2sU/2Xpj/b1rik4KknM3gBzZz3/CMLM+u0cpT6RjPqPJy4mQEI9KEnQXLuzfo/Tq7J2nP2RqguWysXD7Ywl8w8AvBXNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791963557; c=relaxed/simple;
	bh=OGqY9OeuSuI0aEthSsiU7JsrWFGKoAcXGOm0ksXcQTg=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWoYbjek+8mfBa0jrJx5faVeqoNfOS6p+2ThprnDM+JwNHbfdDfx48y0YDYoOGzyfoj3QnjKwuk3QyK+npbobEB2n8Hm4lBei29PNZeGysoJf7jQQKWBvxhZYTj5RnKF9wj87oPI2Km5eT+nuksQItEeSIRiTJtQhiozbm6XhmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WqRkRRom; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WqRkRRom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B6451F00898
	for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 07:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791963555;
	bh=OGqY9OeuSuI0aEthSsiU7JsrWFGKoAcXGOm0ksXcQTg=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=WqRkRRomO92WDiOUWic+S1zHuVNhXsWSqhTlNhkdarMyTWSgdXSEKVpoFMKUT4usk
	 XUv8PpKBAUMM6AJl2xktCaqgYC12xkTJQvFn2v1THERUM0W2tXYkba4Lj55kBYj+Ac
	 5C87fGKNhL860wPdWdqDtVbLoFUeD6toPIMc+3HvWKQ7FLIYZ/mT3jF4egkVCKG0QG
	 WJ5YQV/oeau4uugnNfeKQz+6SSDba1pMWUsneUuVr1skiU3ju4hzL204tnmnoRmMli
	 oP7bX8upeOJAIr0OXqet5ynKIT3t3G5P5h3DXO0ebIzteQGtw+Havul+HG0PZwtiN7
	 TCW9BfnBWh49Q==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3a7754c2471so33363641fa.2
        for <linux-crypto@vger.kernel.org>; Wed, 14 Oct 2026 00:39:15 -0700 (PDT)
X-Gm-Message-State: AFq9FYKY7Z9e3c2D/rbSLW4hY3cZCTTQwwqfnKD6KwJkbEX9Q0AjUzg7
	u2ZhO1VTJ/B68YalrrCIYdAOwll+Ha3hYc0kkHfQIXs+HD24K4lKC80ppe40IMAZbxxkksSy2kn
	DIqhzdRTaFwTwisMty3rNcqUMTYXI68aUhJdWpsfWAw==
X-Received: by 2002:a05:6512:401e:b0:5b8:ef11:922d with SMTP id
 2adb3069b0e04-5bcde6cae88mr4673476e87.39.1791963554104; Wed, 14 Oct 2026
 00:39:14 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Oct 2026 00:39:12 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 14 Oct 2026 00:39:12 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <5e221ba3-fea2-4663-80a9-94fdd5135e89@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261013-qce-fix-self-tests-v10-0-57162a38a554@oss.qualcomm.com>
 <20261013-qce-fix-self-tests-v10-14-57162a38a554@oss.qualcomm.com> <5e221ba3-fea2-4663-80a9-94fdd5135e89@kernel.org>
Date: Wed, 14 Oct 2026 00:39:12 -0700
X-Gmail-Original-Message-ID: <CAMRc=MdqwrTGVtnZuVUsn8onTMxxhbysVfUPtmABL2a1Avd2_A@mail.gmail.com>
X-Gm-Features: AclHuK_y_qSg5r7k-9srjbMx_1U4_7rx7a-kKL338uumbIkGOujVoeMBFDNQ3IU
Message-ID: <CAMRc=MdqwrTGVtnZuVUsn8onTMxxhbysVfUPtmABL2a1Avd2_A@mail.gmail.com>
Subject: Re: [PATCH v10 14/14] arm: multi_v7_defconfig: enable the Qualcomm
 Crypto Engine core driver
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Pankaj Patil <pankaj.patil@oss.qualcomm.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Demi Marie Obenour <demiobenour@gmail.com>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Russell King <linux@armlinux.org.uk>, Abel Vesa <abelvesa@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 14 Oct 2026 08:19:23 +0200, Krzysztof Kozlowski <krzk@kernel.org> said:
> On 13/10/2026 11:57, Bartosz Golaszewski wrote:
>> The QCE core driver should be enabled by default as it binds to the qce
>> device node and scales down the interconnects if no child auxiliary
>> driver is using the IP. Add it to the multi_v7_defconfig. Disable the
>> crypto part of the driver by default.
>
> Missing use case/hardware (see maintainer profile).
>
>>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Tested-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
>> Tested-by: Pankaj Patil <pankaj.patil@oss.qualcomm.com>
>
> Drop fake tests. You cannot execute defconfig on the device.
>

Ah, dang it. Sorry, didn't verify b4's actions.

Bart
