Received: from mail-ej1-f67.google.com (mail-ej1-f67.google.com [209.85.218.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B532D73BE
	for <linux-crypto@vger.kernel.org>; Wed, 25 Feb 2026 07:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772005114; cv=none; b=Y3cTh4ZCFqQQMfZBV6HN1J4uC7Iz98mwY6Yr8p4uOuc3U+S4IpTtOwc6y+zZqdgYEO5HbzwcTWMzxyqC/zW07XoopRjIvC0KX21FAy2UB38/o4UiLtyhUhytJQTox2cTLTq4uRuN39dXY5GgYlSgvwMCf7LPWQsuNrhxxSVc1Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772005114; c=relaxed/simple;
	bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=kxPe6FtUthfLk1s908oMPgjvFDhXUGRUBsOdhQWNEHQ/nP/eRRlfRlZDEWCjf9GqY16PvLsJm5dIpJb5enWGBLPUg0NcgPyi0CJZRwsRRHBy6LXVcDQEhETtgqvxZbEWCoRb/wmHEBroxWqoDGtXfH1G6CAKhmQ89aicpKRy3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=YFt0B7kz; arc=none smtp.client-ip=209.85.218.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="YFt0B7kz"
Received: by mail-ej1-f67.google.com with SMTP id a640c23a62f3a-b90bc00578cso351579766b.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Feb 2026 23:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1772005112; x=1772609912; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
        b=YFt0B7kzDND5OVl2+MnPcsAB9HGkjCkn/jj4r7YU5tBnp4y36qwriwD2e5CJdI0c/6
         1sDt5AbR0J+c+HHL9iWMYCeX6umOneiuoC0ZlYQAXmOO0/iqYeTbkdfSkC17K8fzxtGq
         /zfB36IRQ6XEmyLqYLfAAdNlx+L+e8uYv0oyjuPlGY/5/FYMEHHOWNr1TkEwHRZnV0mo
         ML2hpvsd4YdzGSK6FtoOvy6TxNtdTaUvf7+r47vbkl/ciYb3wl0Cwq3OMvKh1e47NzxR
         zRI2ex3XM0JpGH0xJGYSrUPPiCbNLbZBcn1JLffUfpiP5p0Y+wK+WTCgrntBVYa06+eI
         xiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772005112; x=1772609912;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RBbXuWLXblfk6OwSd9oD/neH6OS15UC/fy5GctQv3UE=;
        b=kUXN3svaWUdGKKLqJer4V6V1+xyYswWywZMC/R/qq4xuPKA+5zJn5s2YRxUl+w90bi
         UcGLyMaKSM5LbwD2kT7QaG5125vjqYt5jwwqgD8Vvh5D3tehJmRi1sGnPYrI9LMR1Jhl
         oGoVHn71mz0ygK7xd1N5wb6p2NxjegSIsIf5DUtg9Zc9VVj+d2PbaaKTLsIgvYtHJwsw
         tZwGLeccB9fda0BZNhNphk2x1jKSe/w3h5l1rJyeI0gJcJ0CcGx7r8Qg7exksrjAMbZk
         zyE2By40ecPH5bHvLwj0trf48hWVnU2Z/uIaagVTqOatd/kMf36oqpRbguBJWeh8X/HI
         QVkQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe+lszBHD+UBPpLI+PFg50fktN5yZ+ik+tSRqWjGlj+zD85CsfyuyKfcQSmzbJPpWS/zhZJ2/VdIjE9Mg=@vger.kernel.org
X-Gm-Message-State: AOJu0YxXDP2SMS37MkHH40W55mVe7NYPkvkI5bKoYlrXHtPoJlKKp5d4
	8+9SbA2zO+SIyOJBUQnLhgerhZ8w4V4TN/zeMBptreRsoNieTyLDum+YTZRmNqkciJc=
X-Gm-Gg: ATEYQzyWBglc9MAbDPAOuXhFTBh/niqX5kPY43kmFK3Kd4p3C7RTr6a0+o+JC5q7Odh
	e2lFEuL4czzoeXUHsHAI8QcYnPhhWyD8d4W3GLZWqG9veUHDsdcCEVckQChm+av4yy67ws4iVf2
	IwbVMgnBcRfLAPbOIhdoY0tabD3/+uC+qMS2rYuWnNMsjgMKoYWlm/a/PwtIZTx3ccsTf+8JJSM
	yv1vLy6zLnt4w912X/Q4wS24/A1JH4BBVDdriwNGGX2OrruUr2i/kEQO+i9gvQItcBtoeBRjDi3
	XKdMdp6I7MrCquOxG+HeCUQ3LQzFAK1EBfQZ1QR38IoChME0rcwk5vSb0Bq+lSl6zFrs2hPhgKg
	hegmMTPf2xr7WI7irRxobdRrDalqkVMlp/6NT8oddWyFbAcgk8b3SGOMUHhAF4wQajvWOQ9fimf
	TNMlA0VQ52/QPfc6sDpfD3mYn32+hVh+XRP+sotGFXOUGIL7pJVRTCVAcVA9jCgFPYeqgL
X-Received: by 2002:a17:906:eec7:b0:b87:c92:25bf with SMTP id a640c23a62f3a-b9081b23d71mr868904066b.33.1772005111791;
        Tue, 24 Feb 2026 23:38:31 -0800 (PST)
Received: from localhost (144-178-202-138.static.ef-service.nl. [144.178.202.138])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b9084cd4adbsm494528566b.29.2026.02.24.23.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Feb 2026 23:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 25 Feb 2026 08:38:30 +0100
Message-Id: <DGNVDXQTH812.3MCVKWNCKR8B6@fairphone.com>
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Rob Herring" <robh@kernel.org>, "Krzysztof
 Kozlowski" <krzk+dt@kernel.org>, "Conor Dooley" <conor+dt@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>, "Alim Akhtar"
 <alim.akhtar@samsung.com>, "Avri Altman" <avri.altman@wdc.com>, "Bart Van
 Assche" <bvanassche@acm.org>, "Vinod Koul" <vkoul@kernel.org>, "Neil
 Armstrong" <neil.armstrong@linaro.org>, "Konrad Dybcio"
 <konradybcio@kernel.org>, <~postmarketos/upstreaming@lists.sr.ht>,
 <phone-devel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
 <linux-phy@lists.infradead.org>, "Krzysztof Kozlowski"
 <krzysztof.kozlowski@oss.qualcomm.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: qcom,sc7180-ufshc: dt-bindings:
 Document the Milos UFS Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, "Luca Weiss"
 <luca.weiss@fairphone.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260112-milos-ufs-v2-0-d3ce4f61f030@fairphone.com>
 <20260112-milos-ufs-v2-2-d3ce4f61f030@fairphone.com>
 <DGDW69W84LJ1.2GHM2WU31VANR@fairphone.com>
 <yq14in67xwd.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq14in67xwd.fsf@ca-mkp.ca.oracle.com>

On Tue Feb 24, 2026 at 8:19 PM CET, Martin K. Petersen wrote:
>
> Luca,
>
>> I've added you to this email now since you seem to pick up most patches
>> for these files. Could you take this one please to unblock Milos UFS
>> dts?
>
> Applied #2, #5, and #6 to 7.1/scsi-staging, thanks!

Hi Martin,

Thanks for picking up the bindings!

I'm surprised you picked up the dts as well (and modified the subject
line), these patches should go via Bjorn's qcom tree.

* scsi: qcom: milos: arm64: dts: Add UFS nodes
* scsi: qcom: milos-fairphone-fp6: arm64: dts: Enable UFS

I also see these in your staging branch as well:

* scsi: qcom: hamoa: arm64: dts: Add UFS nodes for x1e80100 SoC
* scsi: qcom: hamoa-iot-evk: arm64: dts: Enable UFS

Regards
Luca
