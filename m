Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794691849;
	b=w8stBf+DfePuqX0uxbghOljiAElZozFr9Uk7zEjc/t0iCbuVoHuwQLhfbOx8yQ12weOM
	 dPNd0UKhdaHxg5XhI+/0UqJKNPcZKWI1qNWXfawml0IUVxbzgzYbj0Tyd1NJO11SCBaqW
	 UAFaPcNu40IwnG/l+IU5UFRP2Fk28O/CZLYv2Ou0xqGGPY+CTFlca2cUJwiMs7UE1MB0C
	 a1ZzKk6Oe5p7OZxvlubq7VeyOQreePft8jo11une73TiHPwCgfn9W8Of/XYLv0Qth9ZYz
	 Nqf91MtlJAsXck/Wa/I3fhfDk7rnwbVd/WRhtoKgP3gIVRRyePD1oNA+oUWZ1AoD5zg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794691849;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
	b=ZbMnMxD8hJeRRDEYmYownI3AmO3ji9tzJhBtWlZ4czJffaPWHqCMUetVQVl1XmWtZY+P
	 99arfCx27nPkX05IK0YL664uR3QTQW+VvhZu6QKq6KOPDvpkzrztvAqLzCX10dCrhojHV
	 0vIQ5KyyBBDGukkn3Ymt5ijh7jVH49AtDLf7hy5xsaAWPbejgPCSXiFxAcogicDrXwHVc
	 nCss9WXtL9IXQ4TZJKey1QV/7WyoYhstgfU+ZP2K3DWX6BJWnqZ5UsQ+B0tXTgRaRbW3B
	 1xZpn1bYls7quCa1DYfDt95FCtJIEgRXoTaLlAcRY4SQo+30He/xdbJOu2fiM60F7ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWlSLmZa;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87C6606A333
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 21:30:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C87C6606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lWlSLmZa
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so22067655e9.1
        for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 13:30:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794691847; x=1795296647; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
        b=lWlSLmZaPq3CwNa2GvJ5HLBZxwrHAyR4KYWcNLYDoejqq+bHE47WezKQusTce17cqB
         UTWjdD/IlmKTsXW86lcI5Re+obIoVIb9t86LrcMAeziz9eDWUmhlf0tEDJWLXl6iumFV
         A0KOTfltxQB7iH/1NZqAz8vQsctKFp7PZfZL10agBOyW0+/+Nlq4fquLxNOefQolK0q1
         7b1VyBrgPTzn3K2O93/7d5x0teNBV9W1gjmQsMpDfJX8yxuUQvPJ+6K/Js0FjGNLg/bj
         pddRJxGyyKNTa55ItmUV+vqh3pU2XKCHu2EjpM7+mnWtIVQHlY7yLwHWBA9Qc69Hd/il
         +DeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794691847; x=1795296647;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=vju4Tmf9HxWLCGDozxlRYY/dKPR1MEju5ORsVHds9AY=;
        b=aPpu+plKu4n1wShgE25IyMC5H6WKUqKLrhGxS/PQjSUdcIXMq5kcIpTpwYmcjdM0lE
         VZpJHcpStwTjGlQ1HITkR113CmAwSqmQiHdmytKVQjzDskLswynDHEJnleJE6eCembW6
         gHXxfhpC//qpCq5aEIihq8ENwpzXy7u03AfrwkcUzZaGrgxXmDRMCgCqeZwuG03Y1pwa
         JAlHT0kFFefnSfYQFddKRhSEOfXJIreXKiLX1jkxoqWb7+s6f9nszBL+Lp4HX2fARZN3
         +No8j5fvNlp9i3pd2jIPXrXVAGu37yHBDwhsS9rHRkulLxr83ETN6IpBrCOpOXp5rZaE
         2ZAQ==
X-Forwarded-Encrypted: i=1; AL+hErGkUg7Esps8gBw310KYjlvWEdHpCiU/yBC6ti0fJJFWzTxs31Wp0kIOagYEkO6nW1/805Kl5FNDN2b5s7g=@vger.kernel.org
X-Gm-Message-State: APuU4Z9SN+ogWSeBcurgQ5gPC52dKHhwBUeH+twzJuIQ6Nx1UPEbBKXw
	HLNBD9JXKriK1JMix6e/X6L+Q83BbiBaOe+sNDiDMemnrTWQ3J5pbzdw
X-Gm-Gg: AYBFou13y2igX1ACvDVtpZQ+wKyZQIJvSirDlrISY6Ir4NKIb/MfFqRGF7XxneAOeod
	gaaef28h37tD41w/XJEAEfdX1ncWuxNdQbZNN4yy8RFVJazhCLy18oK0ev0RZRE6L1XZ2aPLKD6
	Vo1yqYCcfqnyydaxMq2DZB54NKxzDOy2w+lnmQRCXu+sqaV3zkgD82rMtg5E2TyRQ5ZSM3d/RGr
	GVtXNHTISV9ENeNabrFuEPrklXgTD8nfefWvegaNm1zPmtg9cWifqBrURZdYmUyMiQ17tu2pm1c
	ccASnfc/1VRvh5nbsLXHqmDBtUaDxEZSDY/2WdtLdfbq+OAzMpHGijmGziHsbbWieD8OfPryjAJ
	O8mcDJcZLSALU3iv8SSl5bR1Qc7p0EBuqXD2k+z4iNdNemMJx9WsPnugDb1tSTAoU8mFLSnmTkB
	2P+2lxQUnkZzJUTC6qxk40JGmW9Yk8xeA5EGnfyvfpGiDRKW7AuRNwn5DZLlf9tG7YivWUmkZLP
	uVOjCRG04kr8uCSpSzaVGduFLpqp+lRiHsbKZOwJel/ZYONGp8R9Dz9ZjNd2cLGFnUaspUgC3oc
	uoAKKjSPJG95+axrq76wA0JIsBI=
X-Received: by 2002:a05:600c:2784:b0:4a1:d49e:9ce with SMTP id 5b1f17b1804b1-4bb4e2918b1mr187322445e9.2.1794691847097;
        Sat, 14 Nov 2026 13:30:47 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49c603f4e2esm12803478f8f.36.2026.11.14.13.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 13:30:46 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Abel Vesa <abelvesa@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Robert Marko <robimarko@gmail.com>,
	Guru Das Srinagesh <linux@gurudas.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Radu Rendec <radu@rendec.net>,
	Lee Jones <lee@kernel.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Bean Huo <beanhuo@micron.com>,
	Stanley Jhu <stanleyjhu@google.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Amit Kucheria <amitk@kernel.org>,
	Thara Gopinath <thara.gopinath@gmail.com>,
	Daniel Lezcano <daniel.lezcano@kernel.org>,
	Zhang Rui <rui.zhang@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
	linux-arm-msm@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mfd@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-usb@vger.kernel.org,
	linux-phy@lists.infradead.org,
	linux-scsi@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org
Subject: Re: [PATCH 16/17] arm64: dts: qcom: Add initial Halliday dtsi
Date: Sat, 14 Nov 2026 21:30:28 +0000
Message-ID: <20261114213028.1933448-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <0cac5090-a135-4a6c-8221-846b34ed5513@oss.qualcomm.com>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-16-289114ab8197@gmail.com> <0cac5090-a135-4a6c-8221-846b34ed5513@oss.qualcomm.com>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 13/11/2026 13:10, Konrad Dybcio wrote:
> Please add the other idle states (D4 and E3) from the downstream
> devicetree and match the order of properties (psci-suspend param)
> to glymur.dtsi

Thanks for the review. D4 and E3 are already there, as cluster_sleep_0
(0x41000044) and cluster_sleep_1 (0x4100c344) in domain-idle-states,
just above idle-states. In v2 I'll move that node below idle-states and
order the properties like glymur.dtsi.

> Please use '0x0' for zeroes in reg values

> Let's break up such long lists into one-a-line

I'll fix both in v2.

Best regards,
Stanislav
