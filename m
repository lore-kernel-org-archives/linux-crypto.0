Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1091A4749C6
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 09:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789465351; cv=none; b=bsyqQ9rqlwf3V8iraG5mSbWT9P0xDeDYcQPAM084yhp8mCfc3dTFsBLwgxAOVdbt78N5SPWdGJettXl80WpG45Ccs8em3iRmnKDH6mof55cuLOG6UJJEATQfLDfEQ4fqbWU5Z06McUjgjyOuiAlwOJyu3+fzM+DwYUHDpE7ySs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789465351; c=relaxed/simple;
	bh=Dtsw2jRRFQXkxa7dgV6KxVRgcUhLSW62NygQfZL0d/0=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dgUIE8mQPkNhar/AObgpNMcned84R4lQxiaKaueHNIKqjuewFiRf/t7+2fQ7bJkp1NlRljF960u2jlKD+c5hjM+xkNrWdX1uZFjshhbqxC62/dBsdC/+AMCgQUzPdoxHZnRe/L8mITb+lCWSZ2a3zyQu35//jPkNiQ1kJWyVCIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OSurg9qL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OSurg9qL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D093C1F0089B
	for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789465349;
	bh=IAWcs2+jgJniRfPcDxguAhr6z0wCyj+/raYf2jcKofs=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=OSurg9qLd4v0JVaP//W+MeArgk2xkRmh7fVqp4guE1SEE5nB9R2LyEFv//rzhjlgb
	 79Fam3g4l++WgMO/nzuvJl1HDwkWM7Y/e1tVPLB5YKyKsWMFpk2uhoQrY7r08AaqFz
	 +B/09RQ2YXis8iKdcZLuLcLUGzjE1x7EQj8KpsQfA16UUi/rqfxXac1MhJf/nyWwZb
	 6cXmouIxVXiqnpR0uhR6Oxn0kv7omkVFHy2MQjkpIZ6nERCKKVHaxuCdeHyBW2s2P6
	 rNCvWZdEPSq4tBkptfOctvTp5sv8ZOYWT1pcU1VgqkKVdwTdMXFBguJGskO88MC74H
	 fmGmTYCPttMGQ==
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5b5e4f15b7aso3364518e87.3
        for <linux-crypto@vger.kernel.org>; Tue, 15 Sep 2026 02:42:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwb1p4wVLHn1Za71J6nC79BhZWgzkvw3s+42mzlyXzuUeatoTwVQ90tfuss5rI0hSYhUXIGQWK07PAWF2o=@vger.kernel.org
X-Gm-Message-State: AFuF++kelq7b97+iZWit6jfrllKKymOch17PpmDOtycvev9yKXmCUp8q
	tPsPXjwB387puFgXLNJHA3IuO3GUGuFZyBE8fV9Obics9p/vVJGS0OGfDlat8gdIbRvr+AIQW0y
	wFb+96kFqgA8Kup9IdqFSjCR/9BgBlO105MH3PPNkhg==
X-Received: by 2002:a05:6512:3c87:b0:5b6:421:a8fe with SMTP id
 2adb3069b0e04-5b8ae8a71eemr3220367e87.30.1789465348346; Tue, 15 Sep 2026
 02:42:28 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:42:26 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:42:26 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910-qce-fix-self-tests-v7-0-cdbd2718af14@oss.qualcomm.com> <7e1b4800-258b-4410-8e88-2ce49505689e@gmail.com>
Date: Tue, 15 Sep 2026 05:42:26 -0400
X-Gmail-Original-Message-ID: <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>
X-Gm-Features: AcwNN1WFu7OKIWnYNDJOJ45qVWn6DlSRIE6IYiW9ZjvE6EJLrN4IQn3AQpsM5Js
Message-ID: <CAMRc=Mdd-_t4HniR0k-xhyS4aMD1gnqJPYgS2cEY81b0dwDZGA@mail.gmail.com>
Subject: Re: [PATCH v7 00/12] crypto: qce - Fix crypto self-test failures
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Stanimir Varbanov <svarbanov@mm-sol.com>, 
	Eneas U de Queiroz <cotequeiroz@gmail.com>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Eric Biggers <ebiggers@kernel.org>, Bjorn Andersson <andersson@kernel.org>, 
	Konrad Dybcio <konradybcio@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org, brgl@kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 11 Sep 2026 20:34:39 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
> On 9/10/26 09:00, Bartosz Golaszewski wrote:
>> This iteration - in addition to the previous fixes - proposes to split
>> the QCE driver into a core part necessary to bind to the QCE DT node and
>> enable runtime power management in order to allow to drop the
>> interconnect votes, and the crypto part registering the crypto
>> algorithms. The core module is then enabled in arm64 defconfig while the
>> crypto part stays disabled by default.
>>
>> The QCE hardware crypto engine has several limitations that cause it to
>> produce incorrect results or stall on certain inputs. This series fixes
>> several bugs and adds workaround allowing the deiver to pass crypto
>> self-tests.
>>
>> The failures addressed are:
>>
>> - HMAC self-test failures for empty messages
>> - AES-XTS returning success on zero-length input (should be -EINVAL)
>> - AES-CTR: partial final block causes the engine to stall, output IV
>>   derivation was incorrect
>> - AES-XTS with key1 == key2 is not supported by the CE
>> - AES-CCM: partial final block and fragmented payload both stall the
>>   engine
>>
>> All fixes were tested on an SM8650 QRD board with
>> CONFIG_CRYPTO_SELFTESTS=y and CONFIG_CRYPTO_SELFTESTS_FULL=y.
>>
>> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
> For stable, would it be better to not register the algorithms, thus
> preventing their use?  Another option would be to replace the whole
> driver with an always-on stub driver that just does power management.

A module parameter called: really_register_algos that's disabled by default?

Bart
