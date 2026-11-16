Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794864484;
	b=hwM4uLTLVZB+HhAAnWi2CM5o2t3xvDClKl/abE4eXDtrQy3IpDYr/Y5TaEFL2eWHjmzx
	 FMBzO9iO6BLFSrHt2W0SCpz3iVQYrTVzQNuYICvL0GUHLFmEhxhqUOG8X94FyY++giVPV
	 PGfxhwmGDYjiiGODiGcnhQD/R8YQgc9W2HMcE6lgilranTayj7cVZKZD8keM/wOEvQHw0
	 vqA9BRsjVRtRjK9T1jJgRrJU1r/AKF+N6Y+PNvP7Q0SF6TMBBCTgnp8dTR5KWe/dK7pqq
	 xidvmGW2zMpPHcknfZMiALXP5ygx21bEi8rvDPuMJ4FIDBq9PaN6vyStrq8QnQP551Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794864484;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:Date:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key;
	bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
	b=13XD5Y0n+IanxVysGm7OpoAhDVLcr+4WzLMqRmFKYDX3VMPqpEWSqX184v4Sl1A7N/+5
	 s5YwAleLNtJo1RLaOWZgXEzX5rPd2BxTZ7aWEduuJhifIZJxZQ4uDaeIlleEfnngT7Sg1
	 lnFpmkBYcbjrqzbosddH67of5JJkhNvusRbM6SzsIJDoNH6gKbLXf31A3qO3cFPgbjkGu
	 wVQce5cD+2kbLrjMp2mIsC7RhKreF4l+zC9g8FNTHukURybFhNf1tjf1oq3RlR/l3FFB2
	 10YjSC7eu+aHbcOrFLV+I4SYEasskVGw5VlGqHIW2f0y9Po9shdS/Fh0J0HZMcn920Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UGH3kEag;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5259606A881
	for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 21:28:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A5259606A881
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UGH3kEag
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e46e449e8so2963388f8f.3
        for <linux-crypto@vger.kernel.org>; Mon, 16 Nov 2026 13:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794864482; x=1795469282; darn=vger.kernel.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
        b=UGH3kEag7+QnSPw8NgN0my144BL9MI6P+lzS4lSmWpGQLU/I1Wj2jG9zLis6cKkcyN
         ttu90mcZBjnspWeaKA1sIRwB9cdXaff25bi0pIzo2nlZOYJTE5UudY0yiqgN+oIc1Gk4
         27gWEvQJDPseqUIJdZV/bKhN6eyFQZ7udD/C2KLm+okaF7uw60hj4NRq7HAVpwg467V9
         MmOa42/K0JqbfZnd737Yd7PfrKLwppbtes0cyHasCRpOwm/EKfvIwi9YyvfmdII+iysG
         TW0GSAVvcD/jtsTLZMB/5KuH/HSlooTeqSEMLMXw4y/dOpM0oYUhyTRXoRWTIM99mqwk
         kqPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794864482; x=1795469282;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8TdMvk4MSLOM7B2AUfqYT5uxdywhrc23UXtZE8vgWzQ=;
        b=ItEeBuS8SKWQhUF5MHj02s2lr1feVlZLHQUh18g7aKdBHPJaj/ZCOE8n/J2XrcZBXD
         KsSwxdmMlKkfWBj5SxQsK7bL7l5VrKPtKPH9R4UggQ42qsinOE95PjXrzJFO9f9C6tsS
         CSUfyPYMaC/yjgyMXI5GKcgulmpduny2GHwwH4ThJmBykjqS8bqctGb4E6AlMR4PYi+9
         oQnrcwAGYUquNJXuphxLN9QmbHyokySjvFcco+onZFlxFvzQ0FDrR3FKnFvXK+5djIZI
         rI4tL94bt1He/Vyp+701x9B9IyqbuxkPNkOTKkv0NG6FBT8sY31Wjr68P+c4ug0/h7j4
         c2ig==
X-Forwarded-Encrypted: i=1; AL+hErFOF8vb2+G2BUYg6+KWPmhq3xJsSbHEevHorvRN3boeHOq6ifO6N8crkuGWQJedCeeur8d+zb39qbK0N2E=@vger.kernel.org
X-Gm-Message-State: APuU4Z9k07cBG356YBuwbU/0wdvLJ8P7z2atO4CFcartHGtsttG7KOM/
	qRdxYO9ajWskj0UZiOLKHUhpg/nDjoeonrBfoAE2+pv2RVCv3AveYUbY
X-Gm-Gg: AZFdTZdsFOkKJneTfnEfcIDIopxjXgIuZAIscj9Fjz3MIW2APA2oJIhIiUVDAosNetC
	Q3lezqfygeAa22yRg4SIYl/3v9doO2nw4hTOkhpRN9mSW/09mYUbFuJKSWq6XOxNeP3yyyhrgDU
	LP4DqtKdEztJSfHjpBlmD7AZlYZP9BjKOXoZ5cLWfoF3Izyw9oBzl6Bh87LsCEoBbb1O7GeatfG
	l9N/xWPE8RlRhKoIGiE1IqabkPV4vhTYPTng6nC95Qb+OUiG1wOE5oUyYutqzWpCG6MPC5wTjSJ
	rdogOrDE5gHProUeVYMSNEaOzh+d4Gd9doyvdFo0Je1kie3ycDMjhctRV4+OswSfuqZhS4GUjci
	/4CzAPr4SA/Q6FuFb+2CzEBZhW5zC9yoVcmZFUBLBFZwoKiL6PmCtLghkP/MiiPZ/y0kjcP4scC
	ris7SUC5JGS3L9oZeZ6Zk8IeaZt9snheOcAL93WTa2fd32pvmVd6h2ml2tc67+PtoduKkEF2wKt
	GEwT8Xs8JCARujq3GXqcQ09YTDRCDTnLGCesgch0M/vzoyA7d7pKchXaZ8DTm+7uEgN9ot8b3mo
	+MSQoWcmnhOjWYwdbTDSWAyZ8aW0E+FBXSSqzokH
X-Received: by 2002:a05:6000:5c7:b0:48d:f996:1814 with SMTP id ffacd0b85a97d-49c7325b40amr23107019f8f.57.1794864482125;
        Mon, 16 Nov 2026 13:28:02 -0800 (PST)
Received: from [192.168.10.105] ([212.58.121.92])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4a378138cfdsm1260150f8f.58.2026.11.16.13.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 13:28:00 -0800 (PST)
From: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Date: Mon, 16 Nov 2026 21:26:30 +0000
Subject: [PATCH v2 14/16] soc: qcom: socinfo: Add SXR2250P SoC ID
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-halliday-dts-v2-14-2c92438c6c46@gmail.com>
References: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
In-Reply-To: <20261116-halliday-dts-v2-0-2c92438c6c46@gmail.com>
To: Bjorn Andersson <andersson@kernel.org>, 
 Konrad Dybcio <konradybcio@kernel.org>, Abel Vesa <abelvesa@kernel.org>, 
 Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
 Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>, 
 Guru Das Srinagesh <linux@gurudas.dev>, Thomas Gleixner <tglx@kernel.org>, 
 Radu Rendec <radu@rendec.net>, Lee Jones <lee@kernel.org>, 
 Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
 "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Wesley Cheng <wesley.cheng@oss.qualcomm.com>, Vinod Koul <vkoul@kernel.org>, 
 Neil Armstrong <neil.armstrong@linaro.org>, 
 Manivannan Sadhasivam <mani@kernel.org>, 
 Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
 Bean Huo <beanhuo@micron.com>, Stanley Jhu <stanleyjhu@google.com>, 
 Herbert Xu <herbert@gondor.apana.org.au>, 
 "David S. Miller" <davem@davemloft.net>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Viresh Kumar <viresh.kumar@linaro.org>, Amit Kucheria <amitk@kernel.org>, 
 Thara Gopinath <thara.gopinath@gmail.com>, 
 Daniel Lezcano <daniel.lezcano@kernel.org>, Zhang Rui <rui.zhang@intel.com>, 
 Lukasz Luba <lukasz.luba@arm.com>, Georgi Djakov <djakov@kernel.org>, 
 Sibi Sankar <sibi.sankar@oss.qualcomm.com>, Ulf Hansson <ulfh@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org, 
 linux-kernel@vger.kernel.org, mfd@lists.linux.dev, 
 linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev, 
 linux-usb@vger.kernel.org, linux-phy@lists.infradead.org, 
 linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org, 
 linux-pm@vger.kernel.org, Stanislav Aleksandrov <lightofmysoul@gmail.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794864382; l=679;
 i=lightofmysoul@gmail.com; s=20261108; h=from:subject:message-id;
 bh=6bC47xmeKrVS8XaUkfpVIXGQqamVpsrDydmAXACmpko=;
 b=L3bECMGWqB70KSAXliPLAtrm9JvwyHz3xUlIS/JSaVuyDRybXKh4TJZIKniI807WZa1pL3+Ja
 bm5mXrDXMYUCX9Qe7poGqRt5BD+3P/4++4UczCRJAuB1UHs6hFIK/pI
X-Developer-Key: i=lightofmysoul@gmail.com; a=ed25519;
 pk=jeRUlfmkhE53CJPoeIIXgu7rTE0ybDRH0HQrEwbydzg=

Add the SoC ID for the Qualcomm SXR2250P (Snapdragon XR2+ Gen 2).

Signed-off-by: Stanislav Aleksandrov <lightofmysoul@gmail.com>
---
 drivers/soc/qcom/socinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/soc/qcom/socinfo.c b/drivers/soc/qcom/socinfo.c
index 38efc5db7fa8..c5b61d28fc9d 100644
--- a/drivers/soc/qcom/socinfo.c
+++ b/drivers/soc/qcom/socinfo.c
@@ -529,6 +529,7 @@ static const struct soc_id soc_id[] = {
 	{ qcom_board_id(SM7635) },
 	{ qcom_board_id(SM6650) },
 	{ qcom_board_id(SM6650P) },
+	{ qcom_board_id(SXR2250P) },
 	{ qcom_board_id(IPQ5321) },
 	{ qcom_board_id(IPQ5424) },
 	{ qcom_board_id(QCM6690) },

-- 
2.55.0

