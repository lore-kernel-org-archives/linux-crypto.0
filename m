Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF043009C4
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 12:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762172859; cv=none; b=HrFe9k/GoHP4fZP90riVVB5+8uqijx32EyPrSV+BaiNcv9V7ePAsqzDnw+Fx3/+1fTNGsnDFyhkueP9RWzDxfwKfJFMcYdtaZIiYyGOANk40/J+wOKWkH6BJZlgIX9sQmOdRvmzIGlDC/gx6THZlG8UlYrFlbJVbjhn7KefIVeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762172859; c=relaxed/simple;
	bh=yaE3waDSHbugCSGkUwyAGQoN36hcWzHi1nzoJVJHs4Q=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=LqHg5LU4TDGeoFszlZYjo191nDql3uEoGixb9mzVXY9Ttyk17syYCxtstuzbQjH3YWsO2pnW6yEKjosGRLMfg4o5TJQycAHWcRelIfAk0P7kvUOjhMDTAk32tgLqJYdb0bNXB4T56scjc0l16pYVnGBiLH4y+tBJDwupSBChpmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=UxFSrtPC; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="UxFSrtPC"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b6d78062424so864123266b.1
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 04:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1762172856; x=1762777656; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoGEKixiOf6+YbSpHpvXgbHu1MiS0fbcnkKp3M0gywo=;
        b=UxFSrtPCRZaQCPRwxdSo0StEpyhByP8lFVh5QezkmgLTDerEbkDiptJ3fT6m7zxCzK
         +SNntZ/+EUssDvJYH7p+1YbyrR3XwIPqiEW2OmiCnnrGaaDjcrCHlnvEEqEbL2GGP4Xb
         VYmAu4unJod26yp+USib1mgLcxXa1zwJ9ymZmxNySAIIDLpN2YbZf/E/x25+J7aYaatu
         Syb3ezcve0bZ7F0FrP6XIw1momDtIxd3UOO08lRjUidVeC6HadchyelzLtzZYNSLJG8Y
         ZOPPqdZtNymtL3QMBPUcG/K/Pjlc+qHnii1aAUSqU/iXwUb0dHukHRYxqbnl/7a88Q2N
         08KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762172856; x=1762777656;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IoGEKixiOf6+YbSpHpvXgbHu1MiS0fbcnkKp3M0gywo=;
        b=wIH7gwZaQoX0d5CrDscKY/DUfQtE03nkWD0nVwD0F0bMWEKyT0xn1cCB0z+0N8TiUw
         uJjS7sCoLkdo8u1sOQOTE9T/kupUe7fihzY2R0Xi7kT76eiZO1A+m6wSZMo1AM1Tuqy9
         6yzaO3Wl1Nbs+X2oqfTiGXni+URlfrWwV8BBchbbN4jbYCTH/TvbI928pcOuyXf+M2N1
         WCV1snSrf8481jueuXSUqVx4IPwOR1QyL8QYPDH6rDFHpgTfvWGZ+AqSfd8MXlbJq0Wn
         sjV4bVnF2dUWEoACVMkZ/vlwJ3Rbhb86hBSnUWbSPPnnDHTw7c34cCw37OTjiXhHdqMg
         c7pw==
X-Forwarded-Encrypted: i=1; AJvYcCW2YcKqVdN/ixz9LzVGX73ud64U8UwHaILRPWGk0nGnsevAWor5W29QWbFS6qqo2qSp0cKrILFRnHKSWnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7XxkCRHgmhGZAbkVkRpI8rtYTgD5iIP4Mifojr5qQyBMMLU6C
	3qMzAfV7WZ+FDzUBq3APl8p0m91HXSVxeY9jDplB8o7UWDBGMgwMUDknz0FyqrNnvxM=
X-Gm-Gg: ASbGncvXlUzv9idQ2LYMNgrnRFi/SfmUtlDXc8FNmpVs84pwM5SrmbTj0zgUGejawB0
	k5pRyYDSCHYlvlHUk6UOfJD1mwevaoVPidY0oWJjpX0wxdObMHpjG8sjZzLzGVCwXfDcIU9qw27
	Gp1S9F/dIAH4Gl59qKMMz6MsjRnY8eoY1bfTC+RaknAbWH/NOgi6gfuw3ftoMLlDJzKuz8ECRzI
	OC7JSxUqBitxGpOKD3GFcoTRIksHeW39Wi7yKuQ5g9A32rDfL3c0vVB7N6TPY1WX+7V53R/DcVm
	aozpvKHTvX/K47O09I0fhqkcHzehSU0FPMyRIU0mlzPLf0B6upCzjNoC4ji9aGRXMucOR/KjyOX
	S1vDEEGsbhgwopvMJ8Y4VUvLrqL8HEDg8iMyTb7NeuRsiepR//TuUxK+Fm8niEiritnKuM0S+mc
	qHNe2OQ4oWg8/8tT801dY9NYo98kgVQnKLuZcfQ+LmesTX2A==
X-Google-Smtp-Source: AGHT+IEDliw+6lMJHirYDXmx61WJGlCahIYt8y75zXE63Jfyn2/OoGc7w3DNRT31bKf1ipSgsYdjnQ==
X-Received: by 2002:a17:906:c10b:b0:b6d:8e29:8f67 with SMTP id a640c23a62f3a-b70701ae016mr1324652566b.26.1762172855980;
        Mon, 03 Nov 2025 04:27:35 -0800 (PST)
Received: from localhost (144-178-202-139.static.ef-service.nl. [144.178.202.139])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b70a9fb80e2sm548025366b.69.2025.11.03.04.27.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Nov 2025 04:27:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 03 Nov 2025 13:27:35 +0100
Message-Id: <DDZ2560R89E4.2A538CLIBA9B2@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>
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
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20250905-sm7635-fp6-initial-v3-0-0117c2eff1b7@fairphone.com>
 <c93afd94-9d94-42fb-a312-df6e26bb2bc8@oss.qualcomm.com>
 <DDZ1X799V2KV.269J9YL1AGCIF@fairphone.com>
 <0fd020e4-636a-4bb3-9c22-7a5b16e4d3c3@oss.qualcomm.com>
 <89d1eaba-557c-4df6-b65c-b2105ec20788@oss.qualcomm.com>
In-Reply-To: <89d1eaba-557c-4df6-b65c-b2105ec20788@oss.qualcomm.com>

On Mon Nov 3, 2025 at 1:24 PM CET, Konrad Dybcio wrote:
> On 11/3/25 1:23 PM, Konrad Dybcio wrote:
>> On 11/3/25 1:17 PM, Luca Weiss wrote:
>>> On Mon Nov 3, 2025 at 1:14 PM CET, Konrad Dybcio wrote:
>>>> On 9/5/25 12:40 PM, Luca Weiss wrote:
>>>>> Document various bits of the Milos SoC in the dt-bindings, which don'=
t
>>>>> really need any other changes.
>>>>>
>>>>> Then we can add the dtsi for the Milos SoC and finally add a dts for
>>>>> the newly announced The Fairphone (Gen. 6) smartphone.
>>>>>
>>>>> Dependencies:
>>>>> * The dt-bindings should not have any dependencies on any other patch=
es.
>>>>> * The qcom dts bits depend on most other Milos patchsets I have sent =
in
>>>>>   conjuction with this one. The exact ones are specified in the b4 de=
ps.
>>>>>
>>>>> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
>>>>> ---
>>>>
>>>> FWIW this looks good.. where are we with regards to the dependencies?
>>>>
>>>> Are we waiting for anything else than the PMIV0104 (as part of glymur/
>>>> kaanapali)?
>>>
>>> Hi,
>>>
>>> From my side, I'm not aware of any patches that have any unresolved
>>> comments, so I'm essentially just waiting for the correct maintainers t=
o
>>> pick up the variety of dt-bindings patches in this series, and the
>>> PMIV0104 and PM7550 series.
>>>
>>> Any advice to make this actually proceed would be appreciated since mos=
t
>>> have been waiting for quite a while.
>>=20
>> Apparently I misremembered, kaanapali actually uses PMH0101 and PMH0110
>> and PMH0104, whereas glymur uses pmh0101, pmcx0102, pmh0110 and pmh0104
>>=20
>> (it is not easy indeed)
>>=20
>> so it looks like PMIV0104 only showed up with your series.. and I'm not
>> opposed to it, let me leave some review tags there, and I suppose I'll
>> just ask you to rebase this series on next & make sure the bindings
>> checker is happy
>
> Well I apparently already left the review tags there.. please resend
> all of them (2 pmics + this one) as a single v4

Will this help with anything though? Most/all dt-bindings patches have
been unmodified since v2 and haven't been picked up since 13 July...

I can try if you really think it could help...

Regards
Luca
