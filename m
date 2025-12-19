Received: from mail-ed1-f67.google.com (mail-ed1-f67.google.com [209.85.208.67])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878492FF15E
	for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 13:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.67
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766149437; cv=none; b=SnpPjdnFI8koMNmqVrO/jbTGrOGZbkg60UWsU4uSIfK8Yj1/GI8UcAOS9SA+nVRuhXz6LErNha7DhlGsFrJITJUkD0qbS3wY/RvCdDeJ7lp/8TUGibPdSijnYtN9JPB874xwbqnAGiIvGZRPZplgHUAMkDFCLj2Z4lvSmKYHBD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766149437; c=relaxed/simple;
	bh=EE/IMt3bWpzuwoh4Y4VtblwKWctMNVKGBDh9u8GUYg4=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Qmbb7Ixx36W1okf4WLEJ3fSa2lcALeTYSOoFs+cIIEQo0C+ObRJ4000wr5djFu2A9b6qiJ3gHYBRDU96G/imLDdNkapLdX29oPsFL89b21UYFb0Z70P5cclTG3PQhJ1z3XlL0OffdcLtR7NSTadHY6T/WfdyN55xt87Zsc1hhr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com; spf=pass smtp.mailfrom=fairphone.com; dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b=rdkQli19; arc=none smtp.client-ip=209.85.208.67
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fairphone.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fairphone.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fairphone.com header.i=@fairphone.com header.b="rdkQli19"
Received: by mail-ed1-f67.google.com with SMTP id 4fb4d7f45d1cf-64bea6c5819so394275a12.3
        for <linux-crypto@vger.kernel.org>; Fri, 19 Dec 2025 05:03:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fairphone.com; s=fair; t=1766149434; x=1766754234; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9xYZmg2CKda72uPjDDhOOvObRBbG4YdmNuqSLpmH/Go=;
        b=rdkQli19NK7ZEFHBRsA5+cEoaTtjs0dkJIY4AiX/DVUiiCUmYs6ErlxDUXa1ZNQPV/
         Fwj7zF+TZE3+sx6a5lBgBF+lLAkpjj+eKs42IIyJLTP4AjRzaaCGVVAg8G2w2JofOQ61
         OqOi4XmIKyot0DosmjRoIM9NvTnQ/QkiQnYjf3mM0+fMHyK/2Gr0NPpNZ1ILuzpXGclf
         4hvOGVA8nUKkH9tUXicpXtcDK3vOdZC0/epBjlorfgUOzVI6d7pJx1+pfi4GHt3XN5MR
         knAIyiWTFDad2ZGMGOvR02ssNj9LxLxU0f6uW4oBjqumk6ixccZj9TTAoqFC3zCXooV1
         c9Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766149434; x=1766754234;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9xYZmg2CKda72uPjDDhOOvObRBbG4YdmNuqSLpmH/Go=;
        b=oI046ADNZ8Ls4bly/G5NuwtxAmGYrQ8ZiCMZh0D/3YQbkM/b035k/KF+GIh3rJ/HUp
         25dzVBFKV7ls/xPKI4HAfu2l6oXDvSTLR7EN0gSKgg+Aokb0zu+Q4bv4kdF2TgbtxfjZ
         tdqJlblVGjSBCkCihoza2hFj4dh+4E6XxIJiJoLw5cy7bNAHlF0JmxyuM+xHBweFPIDS
         UiHfipGX0nhGcVdAhFSOVuwwlzi3XG0/BsJonb3LLooZ/E9ZryORaa0QaftjtKbWWpMi
         b7jhioFlTRcqliAofB0vS+QWXbIgDyY7q7V0qfL8NuBNFBRITckA92Rf7M7UQClyPZTF
         jeOg==
X-Forwarded-Encrypted: i=1; AJvYcCWmt8uz8z1SS3VtBXgVDk/0EjpadDodg8G6C4beJkshP1987CdSVppWQUbquuRWPjGHaFnoG5RJuNVWaMM=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3n1zXdIOBC6K1fmBQLin8E5ahnArOiBxAU3RudoJRndebX7g/
	7ficeh8Y07P04g8dontwf27VYm8LG0qBYoMLCFTBW8vKA1u59im1JaXzZhPW8QqczZw=
X-Gm-Gg: AY/fxX5aXQzWX+RMQk1baGU8RICIZ0k2Y3BCa9C6bWD5pWTRcW1x6zk3bekFzn4PQ+m
	1VlTm96OxWxBK9G4EI6rOzKjgLg60G1HWTBRXT7a7zuPBhoNgZgtKLAgJr6sAHEazbH3+/+JBQ/
	UtSiy8CiQIQzXRQmRjpAHyQ2UB7HGwDSuep2UaCNlG3HO3iNfwEFwEmiI86HdMUZi3hL53/bLeo
	A0Gr53DS34Dfq3F+FhD7fTQSy6ULcvEohoi8jBTuoKTLjNZJLH2IOatItOZtLjX5xJVtJVH/ML2
	8HoX0wZ6ldqJOcEhK5xBhnCtmOEI11NcLMyJ+W5lkIzO/CaXbKVoIiMgK4b4L0e+Il5xRZKECAY
	x1eISa/WHK+OwvOWxLBo6eMkXx/DU8zepLSPKPNFLLnuh+f62jTnATopg6Ju3jtdiE7ehRQq1uo
	InEG8FGi2Faog1U5jJL93fB0BzIJBZ4mZW63SsqYNygORulf/e7xjCVNb3HfyM4eU8rCsf2itmY
	Vo4t6LUqealRAVRclhKqBIX
X-Google-Smtp-Source: AGHT+IEUfFWnQG7RAyzRaKjx7Ol55uUIMDfqgbftEXKGsTsm+LxGEOqp3Py4SFBBhTsoJjx3bbI4nA==
X-Received: by 2002:a17:907:7ea2:b0:b79:a827:4c4a with SMTP id a640c23a62f3a-b8036f1308cmr281276266b.15.1766149433565;
        Fri, 19 Dec 2025 05:03:53 -0800 (PST)
Received: from localhost (2001-1c00-3b89-c600-71a4-084f-6409-1447.cable.dynamic.v6.ziggo.nl. [2001:1c00:3b89:c600:71a4:84f:6409:1447])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8037f0cb27sm221143266b.51.2025.12.19.05.03.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Dec 2025 05:03:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Dec 2025 14:03:52 +0100
Message-Id: <DF27Q0DG1UZG.1Q5HP9SBKYBT0@fairphone.com>
Cc: <~postmarketos/upstreaming@lists.sr.ht>, <phone-devel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>, <devicetree@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
 <linux-crypto@vger.kernel.org>
Subject: Re: [PATCH v4 2/9] dt-bindings: crypto: qcom,prng: document Milos
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
 <20251210-sm7635-fp6-initial-v4-2-b05fddd8b45c@fairphone.com>
In-Reply-To: <20251210-sm7635-fp6-initial-v4-2-b05fddd8b45c@fairphone.com>

Hi Herbert,

On Wed Dec 10, 2025 at 2:43 AM CET, Luca Weiss wrote:
> Document Milos SoC compatible for the True Random Number Generator.

Could you please pick this patch up? It's been on the lists since months
and blocking this series from landing.

Regards
Luca

>
> Acked-by: Rob Herring (Arm) <robh@kernel.org>
> Reviewed-by: Bjorn Andersson <andersson@kernel.org>
> Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
> ---
>  Documentation/devicetree/bindings/crypto/qcom,prng.yaml | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml b/Do=
cumentation/devicetree/bindings/crypto/qcom,prng.yaml
> index 597441d94cf1..a9674e29144e 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,prng.yaml
> @@ -21,6 +21,7 @@ properties:
>                - qcom,ipq5424-trng
>                - qcom,ipq9574-trng
>                - qcom,kaanapali-trng
> +              - qcom,milos-trng
>                - qcom,qcs615-trng
>                - qcom,qcs8300-trng
>                - qcom,sa8255p-trng

