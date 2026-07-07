Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E022D7DDB
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 08:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783411349; cv=none; b=Mwjr/JqoelQMXZ0K6tp/HBPH12bWkOOIlwWICfkUFwzCnzu2N2iDHf/8Q98uqgo6Hb1fBUQ1WzUedg8nyxep/ueZzWU1zBxQ+YUnTH9hhkaHwjSMFLWJ7FycAzz04lBW8KHGUrmIoIZQke44HY31hRny0xseWQsKVHhDyOLCI00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783411349; c=relaxed/simple;
	bh=RNOqw8Ps1o+BrY3YPEei+ER/o21TPawJoWd6c2rChTk=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oq0R7pa2jiZogMwhMP9ndvJIRMh8nmS1E7f2DzREzw7PQzVlwv3wnLqY22BEdiPZ6Fh541fCXszW74L4RIJfwpE3Esijk+cCC2fylBCvwx7DJcBBmQ1iZaCi6t3Gm5MWCcFhOArtQRNbM1Jn3+2Mwba55mIyuMQixCxvei/NHvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N7LxVKxh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N7LxVKxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 046731F000E9
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jul 2026 08:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783411348;
	bh=RNOqw8Ps1o+BrY3YPEei+ER/o21TPawJoWd6c2rChTk=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=N7LxVKxhNMCf/JmgsMtOHQtV4GE/RmJOj8WppTHyY/6+1QLLfUw61gnwm7zyCKog9
	 Lw+RDbxgRW3n5FKEBo4Rz5je0Uw6TTkxvWuqwvPdJ5e5a9h93qEOEXx48d0Q27Ej8K
	 9By4fQND28zppra1RWemleqfWsP45i77h0egBlRcaGCrI8u8ifoq0dxQi9GY7yVcjs
	 BpfcLtXGPiEc/H7hUkXEdhdGYaNGfhlEYiNQS1E20/GIVB9Frnz4pguzPTUzkERGxn
	 prje/NW/1vhCjUXNRDxqDlQBEsAOm53Y209Z4vBA77f+UNUKag5zmqz3jJNgSBSXG6
	 MhbL+nWE2qgsg==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-39c610a7ab9so6797391fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 07 Jul 2026 01:02:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpq1d0ZwODbf00z4JWowTRe+ATvs6LlnxNxD/q6tdSA/nkwkFvoPSeTxH67tqIkqSJ8i7f2WwwHMdAmpW0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz/s7+XOAVu1HecnVe33Rb+oIr975MLvVfxrophhFevExIMEgl6
	mGIS/rOfVJeq/s72iF8hYeBhjKeiWG97GZeYeYqPAid/g4pPVydIsFC64F9qJxUOW/Q0npuq3Qy
	1g9pfvz4YXSq0XhHWHyUHyAkpq2ScqRIOmMfinIva/Q==
X-Received: by 2002:a2e:a584:0:b0:39c:6d1f:2f13 with SMTP id
 38308e7fff4ca-39c6d1f3fedmr2151241fa.13.1783411346782; Tue, 07 Jul 2026
 01:02:26 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 01:02:25 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 7 Jul 2026 01:02:25 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <549ff994-6b6d-49c3-a764-4c1e134a4a14@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260704004408.2303468-1-shengchao.guo@oss.qualcomm.com>
 <b693a9d2-4f1d-4c17-8a63-99c7ac79ed41@oss.qualcomm.com> <20260706-busy-grumpy-limpet-c59789@quoll>
 <CAMRc=Mcg-6XajFJCjTDgGACQ7YLGggw5TEtHv4QMEA=dFLOhTg@mail.gmail.com> <549ff994-6b6d-49c3-a764-4c1e134a4a14@kernel.org>
Date: Tue, 7 Jul 2026 01:02:25 -0700
X-Gmail-Original-Message-ID: <CAMRc=Mdi=DYPhCw2N1=9ta29BqA0PuS5umT6K5OguRiPomshFA@mail.gmail.com>
X-Gm-Features: AVVi8Ce31WTWFijLWnEr5GnAdn4iakMt2Frqq6sDI66tuX_5i8eBs1dJEw0B1UI
Message-ID: <CAMRc=Mdi=DYPhCw2N1=9ta29BqA0PuS5umT6K5OguRiPomshFA@mail.gmail.com>
Subject: Re: [PATCH RESEND] dt-bindings: crypto: qcom,inline-crypto-engine:
 Document Nord ICE
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: Shawn Guo <shengchao.guo@oss.qualcomm.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Bjorn Andersson <andersson@kernel.org>, Konrad Dybcio <konradybcio@kernel.org>, 
	Dmitry Baryshkov <lumag@kernel.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>, 
	Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>, linux-crypto@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	Harshal Dev <harshal.dev@oss.qualcomm.com>, 
	Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, Bartosz Golaszewski <brgl@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Jul 2026 19:33:37 +0200, Krzysztof Kozlowski <krzk@kernel.org> said:
> On 06/07/2026 19:13, Bartosz Golaszewski wrote:
>> On Mon, 6 Jul 2026 08:54:22 +0200, Krzysztof Kozlowski <krzk@kernel.org> said:
>>> On Sun, Jul 05, 2026 at 11:15:45PM +0530, Kuldeep Singh wrote:
>>>> On 04-07-2026 06:14, Shawn Guo wrote:
>>>>> Document Inline Crypto Engine (ICE) on Qualcomm Nord SoC.
>>>>>
>>>>> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
>>>>> Reviewed-by: Harshal Dev <harshal.dev@oss.qualcomm.com>
>>>>> Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
>>>>> ---
>>>>
>>>> With below patch, we don't need nord entry here.
>>>> https://lore.kernel.org/lkml/20260702-b4-shikra_crypto_changse-v2-1-66173f2f28b3@qti.qualcomm.com/
>>>
>>> Patch has conflict. This (Nord) should go after above one, with this
>>> fixed.
>>>
>>
>> The other series still hasn't made its way upstream. This one's simple, can we
>> queue it now and rebase the other one?
>
> This is not point of rebase, but conflicting work.
>

I'm not following. This applies fine on top of current linux-next. Whatever
ongoing work conflicts with it, will have to be rebased when this patch makes
its way into next. Am I missing something?

Bart
