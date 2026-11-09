Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794245938;
	b=NCQFvqcyGyicC+ozip7ktaTK5oke+g7KsKAGpZBBim3vjrwuYttN/zcQQJex0TTc+9yt
	 tuzYy6ok0Yc7ONK0+wgODOmjpigF0n1kOYzM8/Zrnq6FCplEgTnGjy3H47nGjdFJz1TxN
	 htydcMf0WMiKcEve6vxbTpcauzFwZnd40HATY6/rrJVFpONVKr+4u4mynVsn5BSfxwl0N
	 r9d+BNqgAAv1HQDKdgsY+iB9Puq9JuqroNQZs/RXPIU4ep9UceKKfG/QCgHFbc48zENr+
	 1+KG3Wnw3/WeMFotfERbtN7CwtSqhIx3jKudkpoTLsQjdm+CCRhJ2Mly6sG/AW78iPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794245938;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
	b=IQrXFjznwT94LS0FkBdSZXpH2+ciwfqxebNT2RN7LNWaJ5sYXBVVKemr3kLIrN72yg8i
	 jJIVNxjM/d8ZyphNaXJV1hiFTnA9VN1H3h10uOXIsc34oxByT54KM1yUQG02LnJ8DB/MO
	 vKynhMlh6i6SCBV+SLCN4g6AfNCdpCyOoN5u3H1Xn4dkT51pbyIFKXxEYQKHuF/fTaJ64
	 n+YkcgMYetAmyK8BOMaugz2YxKceV85Kh43qiL4ffYWr5sOpfmCMdbvP/1D078sUfKlql
	 RmxX+/UO9VW148Mrf2Ohx4jjUul7/WoMzThc8rhxuPGe6Mn3XVY9YxYycr697y+kNSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ET4UmX4l;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2921F606A332
	for <linux-crypto@vger.kernel.org>; Mon,  9 Nov 2026 17:38:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2921F606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ET4UmX4l
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso12250525e9.1
        for <linux-crypto@vger.kernel.org>; Mon, 09 Nov 2026 09:38:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794245936; x=1794850736; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
        b=ET4UmX4lnrqCC21B5oGoVYsMQvX/uO5ZDK9wo7RPCXLUSHAzor2KKP7C7D4g9dOSKl
         T9tIynx1iZ7nScEbu/rROoW0ihwiLqJhnnQ61YL9jqzvok+DK3S1a+gguxLlBKC8w5O1
         moTFTURhfavgIUyQOJfzNwN7KB0x4LD4UGwaMonewXo+m5sWjx57U6MMJmglEzxfuxMO
         LmUAzY4EtqQeiNxES10G3nMFPkiJj/jPtOOkesOWKBy7x6Ryd1/Cph6kqfXQpWmPijOY
         8IbZFuODa/za16J/GDh0DmEFHyP77cWRenI/CjjMSrzXFx4Mn5aU+7EARh+lKdHOYquD
         rC7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794245936; x=1794850736;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VSgAu1YCz0/TBDQtz025D2yh3sRQq8BFfiF0sq3qrAw=;
        b=UI9HKCFrVXz0VvKAiHAaWlCHAir0J1scq/rCGJupcWr6u0a3Y3dmzjtf3jp8ntcFVE
         vTYmCgTU7gqYkxP/oCMauqJcbuc5ob37T1aZWf7Qu5W/5DM8XKlCjgJggTR21gXoHQTG
         jxTGcgOYTkXQVrFIakEjsfoCTbxvfuLFOdR6VemEqUCv92C9LbB9aIExoU1/s8vpdiuq
         +AD8FV/LtIT0ACYEMzug8nJ/lm3sPbHpHOocM8tKppSWbcgRbTJANSbyw/R6CqcEP9zH
         Yem7whloMxQfTkOaYJeSfWzbX2MHIWT0MYpo7ngC0OmFbkjXk6mw2EIEXH84XD9GCBvu
         /UOA==
X-Forwarded-Encrypted: i=1; AL+hErFTsNRt2HVv3uQS9oU0bVwYoNlnKbQIjwhzZN4mk3r+7fYh0PA47fotuuQrelloN6KpwJ2q79K1k3chBQI=@vger.kernel.org
X-Gm-Message-State: APuU4Z/k8cWRjOt3GJjKCHM9lc8uHK+MYBs6TJ+FW6v+sM20h10JXmnH
	5ZBBPYukRvLlnR8GRFC9uDzzKyY596pQr8RgcUzcBZcv5y974GV7WKXB
X-Gm-Gg: AYBFou1ik4zfcSflIi2B0S7Tk3uC/yGEFuJEAP1RItCPIQtd4zAnAugc6JDXAbraY2r
	dbXtXfQronCO0DSCJr/xsExENqO0RKC/ixyiTUJDndJVnaPQhv2rXsQ0sJVy56gsvgdSoF2ABFz
	ZwvQvpDj6JCA8MmsnsQNhQ4S8eCpXcQc9/M182/vTNgfxocot0bdI6MgBjBbkM4dQjWEfQmSAP9
	dal8WrBN82kJHRngFPKFs0ar0vfbGJsmGHAlCDXI1M7lvgBINa6L/sW6hfjbLyct9algz4pbNW1
	UMfUuA5sbftoeM0BHG03LbgaSMXe6bOBzDgURW4DMWmHSANFRDChX64Vr+k1xPKijzSjR88VrQn
	dy2Vh5kVgYbqjvor+uNJYdTOkyMUkNkOnJp5RSuW4IoSPe/PEThcYg4grKfb8+/2lCmLcLLyOSv
	K+Y4fIGu1KnYh2K7p05qkuRo3UeRJk4w0zYTCMfoEBBaTqTVtJcirD9yLDeGi54CeGkcNIKD3uB
	1Oakk0+LD9nNJJac0l84rGk3XCyLb5vddLe/lJTQBwzuM82DgduRoHw1l23bVeqqZZHrHnA35Mk
	nIkoImyNu7V2NvvdSP8tRQ+IE1c=
X-Received: by 2002:a05:600c:608a:b0:4a0:1b14:e283 with SMTP id 5b1f17b1804b1-4b94d76329cmr92154365e9.1.1794245936334;
        Mon, 09 Nov 2026 09:38:56 -0800 (PST)
Received: from flare5 ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0157b707sm2522005e9.0.2026.11.09.09.38.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2026 09:38:54 -0800 (PST)
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
Subject: Re: [PATCH 01/17] dt-bindings: arm: qcom-soc: Add Halliday
Date: Mon,  9 Nov 2026 17:38:37 +0000
Message-ID: <20261109173837.2084788-1-lightofmysoul@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <78a88d4d-11af-40c1-b063-b6a4d4298ecd@kernel.org>
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com> <20261109-halliday-dts-v1-1-289114ab8197@gmail.com> <78a88d4d-11af-40c1-b063-b6a4d4298ecd@kernel.org>
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

On 09/11/2026 09:25, Krzysztof Kozlowski wrote:
> This should be squashed with patch #15. Also, there is no benefit in
> organizing patches within patchset where patches to the SAME subsystem
> are split all over. #1 and #2 targets SoC, then there is a break and
> again we are at SoC at #15.

Thanks, I'll squash it into #15 and keep the SoC patches together in v2.

Stanislav
