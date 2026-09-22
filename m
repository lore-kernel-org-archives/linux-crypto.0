Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB641A563
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 08:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065318; cv=none; b=BpCRMhEswNh856xEn/g3x+hBMN0rDGxXCzveX3L3nq6BdToPXM+I/YFQCAB8YqUNMDNkr2d2sJZpeV0rlsMT2hFUnzq6BzR4KYGpVhfdsyQsvPRVY7VWwXu/Jdum3tFX50pt9FOPhA92sJH5Jca85ARB1YSalc2Wxqlte4Y50qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065318; c=relaxed/simple;
	bh=PmnKH7lV0V+JoK1QDyZ8ECRxYMKhaupXPZ4PEr3rUjM=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NGGScX68NpsFDIihbej2WbYsSljkqhfcGJgHNhs2eIUgrL6XsAMeg9XloEklKS6noqvB4J+IzbVysc8usmlgTPiLI6NkyW0uhVbIaLPPAjkKYnVTu4qaBv5cayzHy2iYIBODC6pbMVHihHe0Do6mqov8wZGc90ijJol8uq7W/qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KQ7zXqB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KQ7zXqB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C311F0089B
	for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 08:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790065317;
	bh=1YdFqoWebSHijCdc5KahaV/EzBXGxPmzQ4XgDu5XncA=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=KQ7zXqB1j1Kf2ZEWYkrHF6LB9KuvaX0ak30Bhwb/gll99KnJZrpaL2ASNa/GPoiuJ
	 7XoIMP9JRqk6LgcsOsW6OvJYk9FtIQ0ChdC5XBOZQUFHEuYY5nfdKjLifGox+85L/M
	 1Dr+e+LUh9wPpdBzvsCpwJAn9FcwSI6nucVfmnT1Y71MrgpT13FmlDTgIJJ+N06aSh
	 aezP9GBIJ1k80OC9zX1K4muzUcd61JwAU6aESh4FwwtJsoUR6PTTM5ZmsM4xo2Wk3T
	 01AQjOJnlPCVdRsnFJzGHRePubrXKoGSXk2wpxiba8Btqt332SzgGDvzOiM6iWixJt
	 HkyHew/0/Q2dw==
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a5d4688decso38683881fa.2
        for <linux-crypto@vger.kernel.org>; Tue, 22 Sep 2026 01:21:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwDYWFJlDCODspnRxOlFouQNdQkhBUcQDX9faHQ3lvmYoHffTRPrlG+/2nyEqH4uaZOxOCJTyEdv4qmtE4=@vger.kernel.org
X-Gm-Message-State: AFuF++knH8w5FlX6RhQX1ElRjDS6+3g2nrtOqVQtCh+DuAkNRNIMPIIb
	TxFPRFhVNwPQYnG6Hmtvuhc7GoSbHgKpTqKXJI7W4Ktpg1TcH4dNa0TPzkZzBoZjrFXsCA3Wwaw
	TqXWXTk9+eNnoeIee+zNH6PiLdhI/QIK5JxcdNLTOWw==
X-Received: by 2002:a2e:a99d:0:b0:3a3:7682:499e with SMTP id
 38308e7fff4ca-3a5fc0a7d91mr32468651fa.19.1790065315994; Tue, 22 Sep 2026
 01:21:55 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 01:21:54 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 22 Sep 2026 01:21:54 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260921-qce-fix-self-tests-v8-0-107537869a72@oss.qualcomm.com>
 <20260921-qce-fix-self-tests-v8-10-107537869a72@oss.qualcomm.com> <71cba843-1643-4f5e-9830-9e60b5f1c334@gmail.com>
Date: Tue, 22 Sep 2026 01:21:54 -0700
X-Gmail-Original-Message-ID: <CAMRc=MesPvie19NcaWmG6hM4zcT830JC2i9yWF6KmhqLHxyPCw@mail.gmail.com>
X-Gm-Features: AcwNN1XHY68dvq7BbAnO76WN0R6Z1v7gC4G6geUb4OdqJjOqUYaJ5RfbVzMrXq8
Message-ID: <CAMRc=MesPvie19NcaWmG6hM4zcT830JC2i9yWF6KmhqLHxyPCw@mail.gmail.com>
Subject: Re: [PATCH v8 10/14] Revert "crypto: qce - Mark QCE as BROKEN"
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Abel Vesa <abelvesa@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Sep 2026 07:42:28 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
> On 9/21/26 08:58, Bartosz Golaszewski wrote:
>>
>>  config CRYPTO_DEV_QCE
>> -	tristate "Qualcomm crypto engine accelerator"
>> -	depends on (BROKEN && ARCH_QCOM) || COMPILE_TEST
>> +	tristate "Qualcomm crypto engine offloader"
>> +	depends on ARCH_QCOM || COMPILE_TEST
>>  	depends on HAS_IOMEM
>>  	help
>> -	  This driver supports Qualcomm crypto engine accelerator
>> -	  hardware. To compile this driver as a module, choose M here. The
>> -	  module will be called qcrypto.
>> +	  This driver supports Qualcomm crypto engine offloader hardware. To
>> +	  compile this driver as a module, choose M here. The module will be
>> +	  called qcrypto.
>>
>> -	  This driver does not have exclusive access to the
>> -	  hardware, causing races with the secure world.  It
>> -	  is also slower than the CPU.
>> +	  NOTE: This driver does not have exclusive access to the hardware,
>> +	  causing races with the secure world. It is also *slower* than the
>> +	  CPU for the same algorithms. Use at your own risk!
>
> Would it make sense to clarify that this is only an issue if you pass
> do_register_algos=1?  With do_register_algos=0 (the default), the
> driver is perfectly safe (unless you made a mistake elsewhere) and
> saves power, so most people want it on.
>
> Also, if I understand your previous messages correctly, Linux currently
> doesn't use any of the features that would cause the races with the
> secure world.
>

Yeah, I guess it makes sense. Sashiko still says the series fails to apply, so
I need to see with Herbert if he wants me to resend or if the change you're
requesting should be a follow-up.

Bart
