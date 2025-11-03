Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFD930ACEF
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 12:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762172235; cv=none; b=nLvzbYVQxcwYQkGmIwhNpMnDa+RbPmny2UQKYLgEhMghLyblT+ax4BxaAqNaXmx2JOGVqhg0jqiTb4zuoKwX9ZT7/m+tp/DzaEUhLXKhRLfYlYGBMpWY/+QhJ76GnV5WhOIfC9Pp9hlfmOryOrf1NI6NXxdHnDKI7VVMMuS5Q6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762172235; c=relaxed/simple;
	bh=N6dzLqWRKXo3vdjPNtp4WU0RNAGv8JDAOdUXXVowYMU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=foIeBkdA+tCjDJbt1PIrg3jgd/jowjb3M878GRkKWxCOhWXD+nX5Z4S/IcJUrxS2zzcbr1xDvNTBhE7Iro5eTUg3r4ycNfMBuwS8fxWnbtUNK11bLYTI+TRquiGiigZ89qrIaGrOeQQop566lgNVbv2KEm6Vg8oicALQe55FkzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=zC9ft3RB; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="zC9ft3RB"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b71397df721so108409966b.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 04:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1762172232; x=1762777032; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNjT7Aiq5Dh6jiEB8sw52p14qgaFnxeV2nRWidKXfx4=;
        b=zC9ft3RBWag/V+c4hsCUTEoIz0cffEe3V3R2CDajBFXXkVe2pm0bDhvl7lNKRLQIrq
         spwO0fb0gLqktktSW3Mh1iTK/dS6rW582Ewl8JrbaSsAbE0syaRN+BM4SJp0d2g6ZlLq
         2xl+67Dod/VLo51R1ncoCrhoCyaCRxsNbFAlqi0CnOKodq4xLsNlEfAxteq87mULbxPU
         OzIf1wYjaaRE6AXA8Ery/wcNRvedXLjPlxS/Fue98UAVeo91zmq+yjk4bVAFzLufeF01
         WdoES5CFbHlIhtxgm/lAyDMnTYR2zJHlSk4unA+ElbdgpUT9OlSj9GjCQu6AGxZbG15Q
         jMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172232; x=1762777032;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aNjT7Aiq5Dh6jiEB8sw52p14qgaFnxeV2nRWidKXfx4=;
        b=V8O57b6MZG91mGjrLpnRwG7fRrZW1678cdz44tKpVwjEUmQTa83f9UNFQQX2e7Ju1J
         jGbbdpUwMwmP9h+hNlWnkrtxVWveH8cdO4vWtYJ0pWYbVh1jYOdZsqa4m7Xv6A4kjr5U
         1XaZTfeBe1EeQMSgh+2aEw/5eWDkWRVTYgcjoZ8e7kvOcDx8uc8UF9jaUSZq0GRw4p7N
         VP5We4Q2lR0+0J2ShjxjmY9BFlWHv3LUR7Cehb0noDdLuDVyZE0DbCH359adML3dBMBd
         u9DI2R0yNOzoRlVtVwyr/WqeU0XfC8VZSA9MR8lI5hUR5COYR/f19ebzUF8aa4tboX+I
         Z4kQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeVwgxTS3j5eNTTjtgqIVqMaKjZUU3P1n/5OpeeAXCMbMmWN6Dzc3YzhEiavCjIe8H1+rvRL4klmgw4Xk=@vger.kernel.org
X-Gm-Message-State: AOJu0YydS65CY04wdt8hgPWlQGkfL2AEn+FfsX5cJFmlA5Yr0dQ1rEWx
	OFnJOUMSTxoixoLPdkX3awn+6eCOgeF45TPvrhCy6/KHWE1Z5cQb+XR3QHGWvenmsSo=
X-Gm-Gg: ASbGncvsaSrEOzEJZVqOFcymMfcbtaQWP90wfrJrnTOI7U5ZVV1hmpASsU50uWdhlTD
	lP8Z5vc4FT0RUCVj8mB2Xpvfn/vqzT//82T+h0tOQzEn4R99jmHHSSO9pIy2pwZ3i1kHapr/yn3
	AzAmDJJTc1bG9PtsV5pY3LJi4fQsiyScfKt6IUnbHV7nY1fGyUoX3jXohUzlAM69jVRlCb3Ndib
	z4qTFEKdluiLZDx46Eo5dLCOexPBNAEchV7Y1WD28bHoaVddA76iCkrnf+XG8JD9XNkTKczO7dW
	XEKPjEJNwYe4bm4Nq4hsIGdyZ97lEXwYVoZfstJ5MMub28gNtJ/kquBnldXJD7FqqX2fJEqoZNU
	OnIeMthvDiBGcKf6Fjxu0a5mILiDaDwJBDkYhoOy18uujM3zPvc1BTmsM0cv4Qup+Gru7Nr3Hrp
	cp+2b7Ln9e2iHmQ/q1La2WuUfeqGx3/IEzBR7NKjIpGDc0shGSo7or9xL9
X-Google-Smtp-Source: AGHT+IEKZUv1KyQWAizLeoG+U9udqAbGU47hQIHv4aHNYJKhylIq0YUcjZYxg94xX07JT/Vlq4yG1g==
X-Received: by 2002:a17:906:f5a9:b0:b6d:519f:2389 with SMTP id a640c23a62f3a-b707083253dmr1286167366b.52.1762172231791;
        Mon, 03 Nov 2025 04:17:11 -0800 (PST)
Received: from localhost (144-178-202-139.static.ef-service.nl. [144.178.202.139])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70bedcec19sm332233966b.7.2025.11.03.04.17.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 04:17:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Nov 2025 13:17:11 +0100
Message-Id: <DDZ1X799V2KV.269J9YL1AGCIF@fairphone.com>
Subject: Re: [PATCH v3 0/7] Various dt-bindings for Milos and The Fairphone
 (Gen. 6) addition
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Konrad Dybcio" <konrad.dybcio@oss.qualcomm.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>, "Rafael J. Wysocki" <rafael@kernel.org>,
 "Viresh Kumar" <viresh.kumar@linaro.org>, "Rob Herring" <robh@kernel.org>,
 "Krzysztof Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley"
 <conor+dt@kernel.org>, "Manivannan Sadhasivam" <mani@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>,
 "Vinod Koul" <vkoul@kernel.org>, "Thomas Gleixner" <tglx@linutronix.de>,
 "Bjorn Andersson" <andersson@kernel.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
 <c93afd94-9d94-42fb-a312-df6e26bb2bc8@oss.qualcomm.com>
In-Reply-To: <c93afd94-9d94-42fb-a312-df6e26bb2bc8@oss.qualcomm.com>

On Mon Nov 3, 2025 at 1:14 PM CET, Konrad Dybcio wrote:
> On 9/5/25 12:40 PM, Luca Weiss wrote:
>> Document various bits of the Milos SoC in the dt-bindings, which don't
>> really need any other changes.
>>=20
>> Then we can add the dtsi for the Milos SoC and finally add a dts for
>> the newly announced The Fairphone (Gen. 6) smartphone.
>>=20
>> Dependencies:
>> * The dt-bindings should not have any dependencies on any other patches.
>> * The qcom dts bits depend on most other Milos patchsets I have sent in
>>   conjuction with this one. The exact ones are specified in the b4 deps.
>>=20
>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>> ---
>
> FWIW this looks good.. where are we with regards to the dependencies?
>
> Are we waiting for anything else than the PMIV0104 (as part of glymur/
> kaanapali)?

Hi,

From my side, I'm not aware of any patches that have any unresolved
comments, so I'm essentially just waiting for the correct maintainers to
pick up the variety of dt-bindings patches in this series, and the
PMIV0104 and PM7550 series.

Any advice to make this actually proceed would be appreciated since most
have been waiting for quite a while.

Regards
Luca

>
> Konrad

