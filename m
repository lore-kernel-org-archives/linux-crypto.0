Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9198043F8CF
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784709240; cv=none; b=ckySDD2nOh3Jj0/Ahxnn0DoNLrXfIgnuFWYhcaQ0N3k5BhOe8ZVwbmvTUoLJvKQE8D37Yy4uu05Q+kjkYDlsVI+OkEOSYDnFudphZnu54SEmf2VAiH871QZezBEMPi/CdHPgS5tYVUhAIlzawa4cKjUXovBEZoTSQYuyMwbgUCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784709240; c=relaxed/simple;
	bh=aXdU+V5rldF0JQS37txWsMh+gLQswGj4yazTp6LwgdM=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lGS1roYRDmxNn4JGETNS8aXJxysrPWzulHpBvn0nIG13Zxo1cckgy5S+SV/L+CedzgDFJgZQYSAANR65up7dKWOwIdPrAR4bHIjbchTlj4a4fWcTiA6uLjqECL1RdmcQLrFfy0VaNL6ijU4qvJ0xn9LgJJGpNP5WcSf3yRGCiMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cgzEjcrm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cgzEjcrm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674F91F00A3A
	for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 08:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784709234;
	bh=yOiMdhLhv0SVgfXHE2R9QZzVJ1NasACYuBsrPinmcjQ=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=cgzEjcrmH5PlLCpCElB1OBH6pZDb9tcKKSjkHE96/QtQnGgzkATjdho95Yq4JnPdP
	 4bseFJVqO6K/UqwJsvayCPfsj31vo72qmJADaYpyPsUaeoJUk9Y3VvB3zBQ9MFfVnl
	 Pgo+9tW3d2+aZ5W8ByPS3K29Zgbs9gUBnPODvG3nF2Lce2jWb3QM9qJQ2x07OUOUbT
	 ydCXQY5bkLo6n9jGWTTJKuhI3LOVbhcqvFEH5fuNYjWMURiweOrbFt/O0vJokKT+4f
	 2FKeQDbQVm6xRgf3UebCQkv6nB+JS+ZzMHSmhYGtWV6s3SzG+ashfYsw6Vf9Q/2X6H
	 aY92W1h16xTHg==
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5b28c91fba5so6927883e87.1
        for <linux-crypto@vger.kernel.org>; Wed, 22 Jul 2026 01:33:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqTg1I9bId9pngoQEXj4oFar0n+PHjznGBoPodIEcG5Nh2N8SxfiET0e468qIB+AiSnjGqyeq+OupyDyMA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTjmx7QPYV0Jxop5g7Hysiy4QiZfyOaNmh3ApeAlNQ0J17cJNJ
	A+y5Cdgei8AHPH/NoDpac1/hfzn3Wlp/QkmgpM2N4XPFWvlH8Jp4Dxn1/iDPh4BgtT2mCNQtOVu
	23rp06O/iBBY4pNoEPqtwKOSSMZXm6KVhiFngzunNng==
X-Received: by 2002:a05:6512:a90:b0:5ae:a4a4:b6ca with SMTP id
 2adb3069b0e04-5b2a9b8bf28mr697065e87.14.1784709233027; Wed, 22 Jul 2026
 01:33:53 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 01:33:51 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Wed, 22 Jul 2026 01:33:51 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260712-qce-broken-v2-1-b2dfff47f7f5@gmail.com>
 <alnlaCXmoLRAlr96@gondor.apana.org.au> <20260721082501.6128-1-bartosz.golaszewski@oss.qualcomm.com>
 <c826b73d-6307-4237-a065-b7a8487350ce@gmail.com>
Date: Wed, 22 Jul 2026 01:33:51 -0700
X-Gmail-Original-Message-ID: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
X-Gm-Features: AUfX_myVMTKcbCAssDxc43I4GIfVcXmrNN22ieXBDI4_jU6w43vodvQh9W2ZppY
Message-ID: <CAMRc=Me55rUmjjR+ZzdWd2ss9JJMZzJch0zKd4GqONBjCzFMYQ@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/crypto: Mark QCE as BROKEN
To: Demi Marie Obenour <demiobenour@gmail.com>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Russell King <linux@armlinux.org.uk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Biggers <ebiggers@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	stable@vger.kernel.org, brgl@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 21 Jul 2026 20:29:39 +0200, Demi Marie Obenour
<demiobenour@gmail.com> said:
> On 7/21/26 04:24, Bartosz Golaszewski wrote:
>> On Fri, Jul 17, 2026 at 06:18:48PM +1000, Herbert Xu wrote:
>>> On Sun, Jul 12, 2026 at 05:31:31PM -0400, Demi Marie Obenour via B4 Relay wrote:
>>>> From: Demi Marie Obenour <demiobenour@gmail.com>
>>>>
>>>> This driver is harmful:
>>>>
>>>> - It is much slower than the CPU [1] [2].
>>>> - It Has a history of bugs [2] [3].
>>>> - It does not have exclusive access to the hardware [4], causing races
>>>>   with the secure world.
>>>> - It register its implementations with too low a cra_priority for them
>>>>   to be actually used [5].
>>>>
>>>> Therefore, disable it to ensure that nobody builds it into kernels they
>>>> intend to ship.
>>>>
>>>> In the future, the driver will be used for processing restricted media
>>>> content.  However, the kernel does not currently support this.  Since
>>>> the driver will have future uses, allow building it if COMPILE_TEST is
>>>> enabled.
>>>>
>>>> [1]: https://lore.kernel.org/r/20250704070322.20692-1-ebiggers@kernel.org/
>>>> [2]: https://lore.kernel.org/r/20250615031807.GA81869@sol/
>>>> [3]: https://lore.kernel.org/r/20260706-qce-fix-self-tests-v5-0-86f461ff1829@oss.qualcomm.com/
>>>> [4]: https://lore.kernel.org/r/20260629-qcom-qce-cmd-descr-v20-0-56f67da84c05@oss.qualcomm.com/
>>>> [5]: https://lore.kernel.org/r/20260524204537.GB110177@quark/
>>>>
>>>> Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
>>>> Signed-off-by: Demi Marie Obenour <demiobenour@gmail.com>
>>>> ---
>>>> Changes in v2:
>>>> - Add Fixes: ec8f5d8f6f76 ("crypto: qce - Qualcomm crypto engine driver")
>>>> - Add Cc: stable@vger.kernel.org
>>>> - Link to v1: https://lore.kernel.org/r/20260712-qce-broken-v1-1-85e2bff17871@gmail.com
>>>> ---
>>>>  arch/arm/configs/multi_v7_defconfig | 1 -
>>>>  arch/arm64/configs/defconfig        | 1 -
>>>>  drivers/crypto/Kconfig              | 6 +++++-
>>>>  3 files changed, 5 insertions(+), 3 deletions(-)
>>>
>>> Patch applied.  Thanks.
>>
>> Hi Herbert,
>>
>> I'd like to ask you to back this patch out. Admittedly I should have NAKed this
>> under the v1 thread but I thought the discussion we had under the Shikra series
>> and the subsequent patch making myself the maintainer of this driver (note: Demi
>> did not Cc me on this nor the Qcom mailing list at linux-arm-msm) as well as the
>> pending series[1] fixing the QCE issues was enough to imply we should not mark
>> it as broken. Please consider applying [1] if the fixes in v6 are correct.
>>
>> Bartosz
>>
>> [1] https://lore.kernel.org/all/20260717-qce-fix-self-tests-v6-0-455775fe5f6c@oss.qualcomm.com/
>
> Is the BAM locking patchset also needed?  My understanding is that
> without it, the QCE driver can still produce wrong results due to races
> with the TrustZone firmware.  Until it is merged and the self-tests
> are fixed, the driver definitely needs to be marked BROKEN.
>

No, we currently don't ship TZ firmware that could cause such interactions.
The only driver that currently suffers from such races is the NAND driver
which races with the modem firmware and it too will use the BAM locking
feature once it's upstream. However we do plan to support DRM using this IP
and this is when it'll need to account for possible races. IOW: BAM locking
is not strictly required to fix the QCE.

> Also, what can the current driver do that cannot be done better using
> software crypto?  I understand that you have future plans to add more
> features to the driver, but those are not relevant to this discussion.
>

We can offload crypto operations to the QCE saving CPU cycles but more
importantly, the QCE provides HW based isolation which some vendors care
about.

> Finally, I very much appreciate the work you have done.  I don't
> expect that the QCE driver will stay BROKEN forever.  This patch is
> purely a reflection of the current state of the driver, the speed of
> CPU-accelerated crypto, and the small message sizes used by the kernel.
>

That may have been true when you sent the v1 but with a set of proposed fixes
it'll no longer be the case.

> That said, is drivers/crypto really the right place for a restricted
> content driver?  A driver that uses dmabufs might be a better
> alternative, and would be easier to integrate with the Direct Rendering
> Manager (DRM) and Video for Linux 2 (V4L2) subsystems.
> --

These are future plans, yes. But right now we do have active users of this
IP and now also a maintainer - yours truly - who stepped up and is actively
working on this module. With the fixes applied, the driver will again pass
crypto self-tests and should not be BROKEN.

Thanks,
Bartosz
