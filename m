Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696D24D990C
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788787902; cv=none; b=IQecOYGanv/oVwPBOs9ld49q/wYbVYekKfTGzYgr+Ro85TLgXTuDPFWVx3brYF5k7mSP86v1haEveGs/ANR2JbSICH7LeoRjLGpENnVK6ZVoetuB55UTg/33wgPBvOvYFtGTC0rabO0KopUfNTHssSvc0o6SFgKlzJSdRruQfqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788787902; c=relaxed/simple;
	bh=8ZGAGHOr7NVN0KR3XdeIRqRmKRqrF5dgUOgIMwdgrbk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQsrq3Aii+M+mfPblGrQSRFFp5C4AdAkWg9MxvrEC/WtLtLBC5Vd6lnQkshJQHOoVSvIbaA8cqfSnWmKXaEyDMfING8hiMKPyL1CXwBGqgNDEnkL5okmUQHnK/rqtuWtijpORt5uhC7z9EnI8GMFOzGCL7zstYb6c9wHitTO+G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=cE0ww8yr; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=CABnume0; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="cE0ww8yr";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="CABnume0"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 687AmtMH3872823
	for <linux-crypto@vger.kernel.org>; Mon, 7 Sep 2026 13:31:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=3kkNuPRvUTyM+QmSb6oELf+9
	QvK3eykU5arY9ibysLY=; b=cE0ww8yrah27Sy5bFMJJ85wijy/lNSSTsb2q731+
	wvxtVR1xfQzd2TFBxLD8XRxIujzFD329MsQS2N14EbaFalOozGYaaGqr3Xe0G0Xf
	QOlqqBMOxdoHo0RKmF/U81n3jZD8PA+raWYfj9pPQySYsWYNA6J+BouhHEH2PrHx
	HYx4ZMXpL1j3c8Bv9DXNSveTaD8Hmuo+3MNtb4YValJ0AlWF9MFZMOGh+N8fI44L
	lcmLKfIOF3jGivuHgOYlvMxCQlW38PRFex1FprNSJ4dVGwq3lExaLflnfzOwSQdF
	m3xNbsa+ToXqq1v8Khtkn8rY3ANdnYpYSi3AOeRL/OYR2g==
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com [209.85.222.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ghnmj26x8-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 13:31:40 +0000 (GMT)
Received: by mail-ua1-f71.google.com with SMTP id a1e0cc1a2514c-97e9e1dd7fbso2775255241.0
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 06:31:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788787900; x=1789392700; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3kkNuPRvUTyM+QmSb6oELf+9QvK3eykU5arY9ibysLY=;
        b=CABnume03SUKGiECxMAbbubewS/SkHHZdMj3pqv+YhEIu9eh9o43UC3XEcPiQfdlR6
         rqtb1Osw+O4Vmo6XA7ehgLsD6owr4i3wDBVcJMko3jqtyPjCLjZrJNIZqOBzaL6VHHUb
         irXtpbBJkOpIWHzbHAw67PId6RLQqkOsncK56MC9artnTZC1mOM1NdU3v7Yhj09GZJ2w
         hLtNttehtmpVZyZK3AheClZ4pI/6I9MjwYXj5pDPsAnbC9hJWGYj5M0DdW3aOEnWCCb8
         tuplGEsIth9lRinusMNSRhLyVfM91T9O9iPurws5nuo6t30kZQOFhGKpVTY7Bt42CoMu
         phtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788787900; x=1789392700;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3kkNuPRvUTyM+QmSb6oELf+9QvK3eykU5arY9ibysLY=;
        b=CjnVUB9QiD9FP6aTmzB3WwGdD6Z1vmUEtMIsLrlKsCdfcJp4FSOs9pI6MQ25w9YYma
         xDd9z/BBvCchFOx2vWjUCYgT63Pe4J+B2K58zxOW0jThYTGt/sL+bEfK+n5U/Gw9hFYG
         sZPTh7fcQDtz+lE7scNqiammZ0yGyPw0GOVPJjMP823mOmR8APs45JuMaZgyUu6bTNoC
         GLhYMMhMtBHt8pw9Ca0zQRB7eJjgQFcoXLbM+T28ADjXfYUG1b2wIxNCxBPR4XF2AprH
         2RGLCvhfQXcWJoYMO2u725x8sLVKdmYFdBXTePRr0+eUWUktxxVOe4gBaw+4QsNTln3d
         Besg==
X-Forwarded-Encrypted: i=1; AKwUvByF2IL2rtt1s1i/GM+L1CeoCPzXBvFLs1qjfvmWEM++VpDZjUaKOXxvdFBaMWWnFf+8nIaz23+a54CSZS0=@vger.kernel.org
X-Gm-Message-State: AFuF++nvZxWqHROW9LbHozO5Yhm9L27daQFNavFQniS2jVhQKQuhrveT
	QX5L1eYXXClovzeRu8VOHfibOJjhm0/9TGOlTIEe4R/GHxjjE78xcIotRyUdsIk1mx3LCVx755l
	W3W5cj5aimUuLJZ6JdWbokVHIgFGmp5SxyOPCzxNtnBj2MBi8jsASre62im3MRix8CXo=
X-Gm-Gg: AYBFou2HJXipQbJNj+7AslIIDvDtQV5Hmy6VVmqvrxXkPEy6RCIHUsXVc+4/zUJCk/F
	iWk1tpjfFF+pbIGmbQVRVHNQPQmHbtuSn9VWLtI9Xk6N8Rqd/scyUbWmQLdgklLUsVeIZIoNex2
	lJEu6g7rnMV979473IgTYIaPSPbbAIeJO11JjFbMJ2d7FIwD5P6Kw6R8xLWQGJ3Pks55zkpBV5s
	dra2KZB3QTJTGIRzYSy9AH0LGjBuw1+MSfrS+mhE47OdcGOPTPvc2pOiciKqM4lox4PENmtSxnM
	rEgg7fuJotT5MVvn4SaCEfMKfDjwUzVoqaJp6kuZEO4Akk1pf1mlVPZqwCp59lkGf3U0W5QtvTU
	Z1uMSpVw6HEfw
X-Received: by 2002:a05:6102:3a06:b0:77c:6bdc:824f with SMTP id ada2fe7eead31-78a4a90fc19mr9086710137.1.1788787899561;
        Mon, 07 Sep 2026 06:31:39 -0700 (PDT)
X-Received: by 2002:a05:6102:3a06:b0:77c:6bdc:824f with SMTP id ada2fe7eead31-78a4a90fc19mr9086644137.1.1788787899009;
        Mon, 07 Sep 2026 06:31:39 -0700 (PDT)
Received: from oss.qualcomm.com ([86.121.170.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d084d62b0sm124378275e9.2.2026.09.07.06.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 06:31:37 -0700 (PDT)
Date: Mon, 7 Sep 2026 16:31:36 +0300
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
Cc: Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
Message-ID: <iow4xf2uflvjduax55tkbhaw2r4436uqvys22u6pbm3ry2gryw@g777gu46cgin>
References: <20260907-b4-shikra_crypto_changse-v6-0-0676f61894b3@oss.qualcomm.com>
 <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-b4-shikra_crypto_changse-v6-2-0676f61894b3@oss.qualcomm.com>
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA3MDE0OSBTYWx0ZWRfX4r6hNoRu+y28
 m4IySdsTz5hJT1NFopw7YOClyuAorvHrXzGvWrCDl6ePGAGtNhJlmypqDC1IPHH/knpXUnLQbf/
 HJAdphro/v/2oUJR8iu6zmViRYutHX8Mbf4CiHR0OtTT+GOBIT+SOVRDdCXJZVAZ0NTrQORYxjl
 3TjnYdLIhw5JmQ2sXkRIyrV7vzuSslLEcAl4wleJz7VrFrpKX/HSfoldx6QDaOlJWLktiapeb12
 JwEQKz//OdcBxGVoXcZjdmblM+RoJKwkhRqJMWkCXh/f3MVkaSXyITj3GsIFcITRPxN1Rmaasa0
 70kLsTxK1S1Eo2vj1BMwk9abTQDYs1inhX6xZS0UPGVKQONo9NRUVzQMxvGM8P/S3XrDjfXgHJ2
 ZAVda91e93Yu3XviYCpcH3JxpA/QuKCuzla5HSndgI86NYVpi6XSZqKN9AkE5Rd5Ennbzw/MIBV
 n8B4qb1/jmYFZvLJ9/Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA3MDE0OSBTYWx0ZWRfXx8MPY7Sa859L
 iFEdyAxQ9y31hQq5eFwdK7zWG9dtIZrTqKrsA+dBI6Mrl987wng93tPqiwhhbW4Vv5WXpSuyB/f
 y0PS3E9HiNG6dcrURbcHWq3R3Sk/0Ow=
X-Proofpoint-ORIG-GUID: l0sWsS9gmlCBOfT0orjEDPsj1Kucc82j
X-Proofpoint-GUID: l0sWsS9gmlCBOfT0orjEDPsj1Kucc82j
X-Authority-Analysis: v=2.4 cv=LZYMLDfi c=1 sm=1 tr=0 ts=6a9ebcbc cx=c_pps
 a=KB4UBwrhAZV1kjiGHFQexw==:117 a=q7XEBjOi5DRkXzmV0jSBjQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=mSLAci9PSNYu4dxlomoA:9 a=CjuIK1q_8ugA:10
 a=o1xkdb1NAhiiM49bd1HK:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-07_03,2026-09-07_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 clxscore=1015 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609070149

On 26-09-07 17:33:37, Kuldeep Singh wrote:
> Shikra is derived from Agatti and uses the same QCE integration.
> Update the QCE node to match the underlying hardware implementation by
> adjusting the fallback compatible and related properties, including
> clocks and clock-names.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

No fixes tag ?
