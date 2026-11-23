Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795468663;
	b=Z6zjvDK1nvIDYRUHMcA0KpHXkGoRo3YHGXtkbIJrtcPyDxRL9Nc11Q4LJjFEAyBU3kHe
	 YRcLFA3goGy5z5g01Pq0QYOYRi13zDXV7EJLLPpnOGiNgmwvifo+rNpr2AniRNEksHxCh
	 zem3h8tTcTn8kzt2bgB+oVJydKeXHzqgerUI0f+gxWkV2gNK8JrRFWCXuxLXeJQZiElYw
	 Bk/w+dz+PVL47VH0j1oxRzZ7tyF+5/k0h3AFQpWm6J8sk6odzDE7MX7Cu5auzKewSDGIT
	 pTez8Y7WJWBZ2BkQo5/gr5hZcsumK4PByEFHdv/9QuozuaqBgTVnCWvA5F6dqP82AjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795468663;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
	b=VYk/HVuw3VV1ZfwXDyXcsQKtgaKj+MAIRcYgSzp9fOQAw1NzOszTXALz8uifoADrMEQN
	 /xPzOLO/MSa9HZSXdGYwP4d4p2oj+gNNMULtZVAwlF/+c7nUmghOxlvU6jzXWRoGmU+Pe
	 xvYvAnVE4M+4kXrdxk+U0dwWagAhktPajvYYhzcR5OFe1VpETiKtSvPUrav4YLxNmhLmn
	 NTUCYg+osLoiKJWlnkccI33FkycCFtyADSq8gn8qPJmjoGnOWxr3KkMmrUuedVzD5JUJO
	 a+bAALqHfLaCZebc0msVmV+5OSwktWE33LAin1aGxycrVSTLesMrDr/Em3hIM5HSoMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0fedjRZx;
	arc=none smtp.remote-ip=209.85.221.41
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46203606A33B
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 21:17:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46203606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0fedjRZx
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48e3b22e971so1991411f8f.0
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 13:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795468662; x=1796073462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
        b=0fedjRZx2RaPeNewDfT6kMMnjXVPl/B3fA1gPsEqLujR7kcW0NYtdJYVaByQandrUq
         QJzBJ4uC9eS8a+ayksMogNxSExWs0eNFKItvTDKAx6NHc5x9hqv9RQlhAAzaAg7s5gs1
         9sbtbyps4kPCKude8iZa2iiFH+utWXTUN8TCJqFX8mRmvPPMu6I8nAQcyMZ4i4mpzyX5
         Cp154EF42lPno5OVkcDwnkP37Yni0BUszr0xLEoRsNB5R9GRF4fxmXOCy5ua5f8Nqhrg
         4AybiECJ+X7fZBXujwbzZQ4s2TiblfJ29wOS+plEAwzRWxdPuG712xtYts3o3CIOU5fN
         1RVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795468662; x=1796073462;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mEI2MWJHKjiB6vj3bpQygFD6VsBJJyxeJ4zAlBvCIuE=;
        b=ILkHej5VTejm5CDN/1DjkqJECFNP8RHO06S4cFOrkG+XaF0Ry8IPHwnVWlvbQE+06o
         uen4dX1DHrOHBU7DbjPs4MQVRwwqR1butqFkXfYtqab/42dzgapbIQRO4zDsr+z4NihM
         XnGhklYLfxwyWmCy2Z0jSNaPvdVE7cVxZVx7GQ8cUdFv8rbFQQwRIZQBPdu+Uup8XD6H
         +7ttDLKzKMRXHfkRlgufmB0B9HG6UlJfQUxLdAJK1cyUaT6jg5URCNrcNQEKcMu4Ed9P
         JMgV0qjtID0lQu7p8c/bZ/vXLwnT1gCOHMyPjk7b7TmWODxzjjA0jiVBRV5qVLRax7FH
         JSjA==
X-Forwarded-Encrypted: i=1; AL+hErHAv20zfENAtJca2V8ifLMwkBUse4Vk58mU/z7udQJMKEjPIrEGUWxb5fDAYExb8Pipai7GPH0pY395aHw=@vger.kernel.org
X-Gm-Message-State: APuU4Z9PA2ljh3mQEFD+52LPjOeLRdGRfzOt/zSkt9ArHdjFXdGEg16z
	Frjb5mNk5nHRvcAEDC2hoTDapKC7EhPVLe90TGDgE5rd0lP+5eOUAepM
X-Gm-Gg: AZFdTZfrwLAJuSQAAE9wETjvzzlAyo4UH3cpmh2GSV7sA1cOQitr/FXNNZMMmahTmMd
	UPz5nIMpdGJsa41wB+uVgfKFIsRisyUcEVsL2CaWYZX2SHbZlTR1i+3OG2Y8aHbFx62+IqHW8pG
	aZoP1YADzmJ5jaMpYdNqO9NQ7hEYbv/ek3RiRHe8MKijRBrQzfTloLp+cFSNsWW7YFOETzMWWuK
	GVKtqZWnp7gROSHqjeFaTJoiwOzKpBmI5uLYZbl3H7ZuKdd7Y9KlxijZp7y8YR4164OTbPAEXaO
	f6poEmbvPpWefplvaE/FdLTnBq1m7HMHRPgFM4NZh4hhRVmvB2ftHj4uJ4zDOdmIOG+Fv+Fb346
	GPNmPE5j1wZufYKTL/l0l89pAOgOn8CJma7XMa9NOyTGQlrBr9ti6+4JZ8nx9Ce2fPie0C4J15U
	eD9OxzW5IcJ2f4r9VgElPFdPNcIkxMMeP70wRYfqJtz/+De0gskYuQcynyq9ypT6KcPFJj0eqy/
	Jfb6CkWKWszm2EEFGlF9iibVUH9yATHNeay4IOM0D3h9IemULpu1l3Yg+K1dhDnD2+un5fS8R8T
	4vuVd6sUS91JkHl5XgDH1em88VlSLO9dHKG/tosCccdR1G/D
X-Received: by 2002:a5d:4605:0:b0:4a4:14db:2348 with SMTP id ffacd0b85a97d-4abb29105d1mr18698069f8f.35.1795468661504;
        Mon, 23 Nov 2026 13:17:41 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2e6dsm24513121f8f.6.2026.11.23.13.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 13:17:40 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
To: Krzysztof Kozlowski <krzk@kernel.org>
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
	Ulf Hansson <ulfh@kernel.org>,
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
	linux-pm@vger.kernel.org,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Subject: Re: [PATCH v2 13/16] dt-bindings: arm: qcom,ids: Add SoC ID for SXR2250P
Date: Mon, 23 Nov 2026 21:17:23 +0000
Message-ID: <20261123211723.1065310-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261123-pastel-barracuda-of-rain-bce8ac@quoll>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com> <20261116-halliday-dts-v2-13-2c92438c6c46@gmail.com> <20261123-pastel-barracuda-of-rain-bce8ac@quoll>
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

On Mon, Nov 23, 2026 at 01:09:26PM +0100, Krzysztof Kozlowski wrote:
> This should be rebased on my patch removing the IDs.

Thanks for review. I will rebase it, but I am not sure about
the order, could you please clarify?

1. Should I wait for sending v3 until your patch is applied?
or
2. Should I apply your patch locally and then send v3 based on it?
(but if something changes in your patch a v4 might be needed)

Best regards,
Stanislav
