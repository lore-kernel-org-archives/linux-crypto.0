Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C83938F64C
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 08:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782116718; cv=none; b=ZQz4caiBF06btNs+X/dzG77SXU7i5vOwWFy1/S0tThSvuBCIQKTIRHN3tq9EcChs31d+PKbVcUPnl9N4bWsz0HJF+YKE5GlLJKpiUjfOv//MJfvPTunpb5oD7AtID+b1HbXmBCM0+9J2rzbA/wTNNsLVtG3ZXG5hp9ezC2kQCdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782116718; c=relaxed/simple;
	bh=X/OpTbuthlVusCSOnihn3WAb4xYSqe+YlVeJG6hFE4A=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lgRZH5yyoK3vNdN4qJU4DdVrpaSwH0pckRDY6tnHhYyDYPp+YxcbZuc1ggvj8IqO2OwsDqDipkQX4uZ95Df1p/Qix1vVcEj7kRz79iWpVTeMz/O3pYoax6ElNkzZ7caCxp9r3f1d70hxJT7ETpdhn1QY2adxz1CaUf6tWdiVQas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QSC4F7Fj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QSC4F7Fj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD3F1F00ACA
	for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 08:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782116715;
	bh=dGzB8a7uRXU43VC5H/RJSltTtPvZBBro4QCVA4GdtP4=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=QSC4F7Fjsb6UDa4UQFHkpPf01msyxFA6Bx6zSIx11l5u2hRCTnsJJsqnnKWwfS90U
	 Gvc8JsZemI27tAmK7IUkxys4/vM7INW1OqlmD73hg6M5RtME5mNP6BMdr3O0h9QprD
	 m2M3gqpc8fhwYahDbMuqFarZ3/sqhfHTlE0cp5r4S45q1yeMB4yn28bLomdxxzDF/Y
	 /W66RlS48R912piU1q4bGvht4vyavZU5QNwTBcoeiX0Kctwkcwhboe5OJks6p/cglw
	 eRhLs4bf03IZAZlREfqTjXhEl73c6B9+3rtyYPvSBz5wICmFKHlGa6wJMbzMAegEBj
	 sdlEn6pZhMJrA==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39669bcaadfso34044221fa.0
        for <linux-crypto@vger.kernel.org>; Mon, 22 Jun 2026 01:25:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8W42mycV/hy3MTmyqYbV0yKKzpobvz5dLjfSJz7vPC7FSGEjkFNcoUi/AWjaqzGGf7fZiDZOQo/Ah5xK4=@vger.kernel.org
X-Gm-Message-State: AOJu0YwVP+xgw5TYL2fWulavPuW6Qr9+hTeDDj/e3jRkH6Mlply1tQ9Y
	H9SQ0xJeOlOrZ3byAoL4MgLn8PdqUSnm/gHmQqinBhPQ8EbmscjtXxbxw1TnIOdQB6ZVGcdgGO9
	5XX2rKLuQbUtuj84vEL6yVLoyTGgyrkie9jZhDqsMxQ==
X-Received: by 2002:a2e:a815:0:b0:393:b365:6e24 with SMTP id
 38308e7fff4ca-3998bc52fb3mr30333831fa.4.1782116714327; Mon, 22 Jun 2026
 01:25:14 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 04:25:12 -0400
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 22 Jun 2026 04:25:12 -0400
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260619164506.GA3223@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260521-shikra_crypto_changse-v1-0-0154cc9cc0de@oss.qualcomm.com>
 <53b1fa61-9692-42fd-a295-98bbeacbcd9a@oss.qualcomm.com> <20260619164506.GA3223@sol>
Date: Mon, 22 Jun 2026 04:25:12 -0400
X-Gmail-Original-Message-ID: <CAMRc=MdJJRPBeNtAUr82b4zv7vLjrRQ76Q3bJHQYEigaE2Hqog@mail.gmail.com>
X-Gm-Features: AVVi8CeAxt9KMOL095y2v4UTrPSzivkzFWS7f7st5RqKHpq1WC_YJZWgEPbn2QE
Message-ID: <CAMRc=MdJJRPBeNtAUr82b4zv7vLjrRQ76Q3bJHQYEigaE2Hqog@mail.gmail.com>
Subject: Re: [PATCH 0/5] Shikra: Add DT support for ice, rng and qce
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Vinod Koul <vkoul@kernel.org>, 
	Thara Gopinath <thara.gopinath@gmail.com>, Konrad Dybcio <konradybcio@kernel.org>, 
	Frank Li <Frank.Li@kernel.org>, Andy Gross <agross@kernel.org>, 
	Harshal Dev <harshal.dev@oss.qualcomm.com>, linux-arm-msm@vger.kernel.org, 
	linux-crypto@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dmaengine@vger.kernel.org, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 19 Jun 2026 18:45:06 +0200, Eric Biggers <ebiggers@kernel.org> said:
> On Fri, Jun 19, 2026 at 02:13:28PM +0530, Kuldeep Singh wrote:
>> On 21-05-2026 18:47, Kuldeep Singh wrote:
>> > This patchseries attempt to enable sdhc-ice, rng and qce on shikra
>> > platform similar to other platforms.
>> >
>> > Previously, the 3 dt-bindigs/DT changes were sent as individual series
>> > and with feedback received, clubbed them together as all belong to same
>> > crypto subsystem.
>> >
>> > Here's link to old patchsets.
>> > QCE: https://lore.kernel.org/lkml/20260515-shikra_qcrypto-v1-0-80f07b345c29@oss.qualcomm.com/
>>
>> Hi Eric,
>>
>> As selftests issues for QCE are now fixed[1], so shikra series should be
>> good to proceed? as your concerns[2] are now addressed.
>> I am waiting for merge window to end and will send next rev post that.
>>
>> [1]
>> https://lore.kernel.org/linux-arm-msm/20260617-qce-fix-self-tests-v3-0-ecc2b4dedcfd@oss.qualcomm.com/
>> [2] https://lore.kernel.org/lkml/20260522024912.GC5937@quark/
>
> If you think that then it sounds like you need to read what I actually
> said.  The fixes are appreciated but don't change the big picture.
>
> - Eric
>

Eric,

I mentioned it in another thread[1]. This series is not adding any new features
to the QCE driver, it describes the hardware. The SoC *does have* this IP and
no matter the state of the support in the kernel, there's nothing wrong in
extending the existing bindings and adding new dts nodes.

Thanks,
Bartosz

[1] https://lore.kernel.org/all/CAMRc=MfY-tmMCdw9FVBgfkX-FvB5Nx2X06S023GhASenSCQSNA@mail.gmail.com/
