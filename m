Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7A93242C0
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149265; cv=none; b=eGSiXX1h/IFKKzsnMWcmFWqpuhuxr6/TJmwPCKrFagdLZI9WBusF6K/i/aMdqZOmULn7P/HbO2WqdLx6gVFouJblOHjXJVILR+EQANEUNTQp7xeItzLnuucyR7dxf17OjC9TPyxM6aa+DWtsuraUZY68+aPyRRHf+4EDLf2LjYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149265; c=relaxed/simple;
	bh=OMj7xeqwJMwjOl9SBTbfE9Y8LYVng9ddlrSM4o/HdWk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Iuz0RsOLA5Ds/aMoZ4HUfQenoUFWgZXHxI8229q20nJuOVq2C9DU+8hhhWFly+dRh/M5ph7QgMzzWf+Io5suARnVaby9oysMAkUtOOtrClGvtXfN17s0AETpVu4Pd9pRqriPKtSgcMjSgaGrXW1K3sUzkBuaQZPELkqTPUb7Nyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=Nxw1pCJe; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="Nxw1pCJe"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-64c893f3a94so206359a12.0
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 05:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1766149258; x=1766754058; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QH9a092t0vWzb6LlKTi2ntIznrIkgJiQ0lVDXHwlCgM=;
        b=Nxw1pCJeW6oYa0o7jXMT8/6bl0Qhufe/V6WkUqMzXlQARU542McV65Oi/jPSqlsZn/
         1GLdq0p/m3WxvDD27Z0cwi61SyEJ8ka7YygzMCSArhE+byrxS8Hr8HnQc+mFNmbWRhh/
         ZewHkSu1CVwenStJijMPshEsPoHM5V38SiDf9YLrQ4DMYZGTURGhWO5HZibBeZLdl2Tf
         H7WM76XqfwudX4lwdNHmTLSmc98SAmLrhTuJZUtEPCx04ER10yFEww5SUJ1pz8sbXLMC
         nMhYEuF9q32CvQYex+TBIFv+YYIcSczWUJet0EPT/rwbpBo1SnPYWfpEOISQpAJPq9RM
         iLIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766149258; x=1766754058;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QH9a092t0vWzb6LlKTi2ntIznrIkgJiQ0lVDXHwlCgM=;
        b=n7OuFWGPm4LlQ1saPLtZfDOpa8zJ+x5JFU7xjkjOpE9FDWpCHs94+DsFcrQpkw0PEX
         s3jajHabX9/JrO6U2wxpyG3ujtVGYSLLL1PqeNUKx1NgltY+ctT9xw0Sn5v9waVHi+Yj
         OdX2/+jLShZHuSYfXl0KT7URHMnVNX27+pbvgEN8lWpI7hN+bGyOvJF9VQGzHq4DgXIz
         AHhQF6WBKO32YEPCHLG/V41l5grDEJQfZvCnbKR6N2GPVMzq3tP8aQCOM1bDRj8huBwp
         v4j8zXnB0x+onAKTX1Ntn73oUFKs9JkydxuuzpJl1Fp6YhJL7Lhbifi0evDTkxD9OCHt
         54/w==
X-Forwarded-Encrypted: i=1; AJvYcCWuqeQxMaox+1D2H7a9ehg5iAQrtb/ijwXeWo293rS0k0KJudTpjPlDeYapdGBjw6svtffugvJN4V46s90=@vger.kernel.org
X-Gm-Message-State: AOJu0YzmGJVu99Uj0xgOVFfB7qVbxzFHaMQr5OzWbdbswBGkvcLB8Ffk
	HKjvJARENFNetNI60i1oKMc9/nczjlTJ9+BShzRKK9MO1GnYXApZCLAmIl+sSmEL1LM=
X-Gm-Gg: AY/fxX6S8M3pRLTS+9dBSqU8sNhtSzEDioPIwOWSG8EDhUg0rAD5m++9tyaPvvfnxmE
	ogZcGssjMlJZpQ0Yh8nTorWVUBg5LrgL2iwQzDiIwTFwEqk7sk6s+hl41N2RPTSDctvvUO9dc55
	gOpM4UVIU2yHd1663oH4mHwRY5D5sKy/NsraiVqDnZiu43rIPhWE/FCtixObqv14+8RP/3Gc+9R
	LpCFvGFLBP0/C5B2bkHyQCrF30G48pKwtOy9GIN3qJ9Yh+aoXwdQ3areg3NeCdeS5BBewiNk1qp
	H8tRIIoNiUpTAeItxjV6/B6TTbxzyxV5Q4/Pvmhacj/fbM6wGJh3lsrk3Ajx0lE4ztQzbqkpAo7
	8QfdbQvFnfVd9AVHbgYt7bKmDaSb/Xl4fqwxB1fNZnM9fdj7ApBJg5o8lwJZMxF8MYfyorUB2Si
	81TgQwL2etE7yrK9Zg4qve3elwD+/kDnB/vrBu6cYX8PMYUM2+R/kTjNCPXoKP/MwuC9sc3UCu9
	Xn+N8SvcYMGtJEhMnrXGOOL
X-Google-Smtp-Source: AGHT+IHLGt3dLozOmdXSlTcHVXCnuuxt1U6E7k8MjKzoQF2b3nEBMoU2ft3Yv3cwbA/6YNKG+iAu0A==
X-Received: by 2002:a17:907:fdc1:b0:b7d:266a:772c with SMTP id a640c23a62f3a-b803574c34fmr311215066b.21.1766149258484;
        Fri, 19 Dec 2025 05:00:58 -0800 (PST)
Received: from localhost (2001-1c00-3b89-c600-71a4-084f-6409-1447.cable.dynamic.v6.ziggo.nl. [2001:1c00:3b89:c600:71a4:84f:6409:1447])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037de11e5sm223530866b.39.2025.12.19.05.00.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 05:00:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Dec 2025 14:00:57 +0100
Message-Id: <DF27NRY60F8J.19D014VO387TN@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v4 3/9] dt-bindings: qcom,pdc: document the Milos Power
 Domain Controller
From: "Luca Weiss" <luca.weiss@fairphone.com>
To: "Luca Weiss" <luca.weiss@fairphone.com>, "Rafael J. Wysocki"
 <rafael@kernel.org>, "Viresh Kumar" <viresh.kumar@linaro.org>, "Rob
 Herring" <robh@kernel.org>, "Krzysztof Kozlowski" <krzk+dt@kernel.org>,
 "Conor Dooley" <conor+dt@kernel.org>, "Manivannan Sadhasivam"
 <mani@kernel.org>, "Herbert Xu" <herbert@gondor.apana.org.au>, "David S.
 Miller" <davem@davemloft.net>, "Vinod Koul" <vkoul@kernel.org>, "Thomas
 Gleixner" <tglx@linutronix.de>, "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20251210-sm7635-fp6-initial-v4-0-b05fddd8b45c@fairphone.com>
 <20251210-sm7635-fp6-initial-v4-3-b05fddd8b45c@fairphone.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-3-b05fddd8b45c@fairphone.com>

Hi Rob,

On Wed Dec 10, 2025 at 2:43 AM CET, Luca Weiss wrote:
> Document the Power Domain Controller on the Milos SoC.
>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>

Looking at other commits in qcom,pdc.yaml, you're the person who usually
picks up these patches.

Could you please pick this patch up, it has been on the lists since
months, blocking the arm64 dts from going in.

Regards
Luca

> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yaml | 1=
 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/qcom,=
pdc.yaml b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.=
yaml
> index 38d0c2d57dd6..0c80bf79c162 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yam=
l
> +++ b/Documentation/devicetree/bindings/interrupt-controller/qcom,pdc.yam=
l
> @@ -27,6 +27,7 @@ properties:
>      items:
>        - enum:
>            - qcom,glymur-pdc
> +          - qcom,milos-pdc
>            - qcom,qcs615-pdc
>            - qcom,qcs8300-pdc
>            - qcom,qdu1000-pdc

