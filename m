Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795703664;
	b=Rdz1q6n6cz0756tYmW/Ge39dkZOGCWFbk//NqjPnHKU513zNENjd6TV34De3awYn/7h3
	 pDgGY8f6+KBBOoUy0SZXMMrmothL9lkuJYQ/VUe/rkrFhafbVJIqFlfi/Jxw41o+1GVCu
	 sW9lqnP0IxFVxYRCnGkT90ELFuZ9FA+7/5fTuLR45f8sZxGsw2QnsX6jGqJuUz8mD4PZW
	 WvKSpXWHqJjFtU6Zu44CPL2dW+PsXQj2VyMct3leLV7KTSu/0VDar2gbLjvSSvP0RK3QO
	 Bg6SR75YbSG2VKB2iNgb27GKKAuQOOk/x726LBtMYh0ihNh2uIuC02vCtYkTgvki1UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795703664;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=quu9PMR9UDySxr/IqPO0z01rsJ1Q0S+Kq7Ac8gw6hUY=;
	b=k31He3sKRizXSwzKbM7BtgMb3DhBFxaP/Hq7JgtRtgfz5rtqMxj/cVwOSAYe0C+cCxMu
	 nz5Ik7E8brwYmam21Zz+b3GcFIF9dnEhxvxXyZYO4x/OdyVCJK7Bv+3Gy26OgrfNlgj3f
	 XrSk0QljC+23kmUjd4IKamL7eruD9jYOSklpKiBNwHQotN9mLtwrbV+QAJe4J3iA7FLRR
	 cKyhGc9Lp32H1OAiK1oI5KunlxBtCHnu/93zOJaiK1QJxWA5obtynvW/uX0XnErhFOfqq
	 CBra4rwDuuUGR1Aoz0RFxGNmPfP9oKWSEpV9i5p1i0ctLJRVkeI+brYzwfSl6DMUYaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Yb5T9A2L;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CGKohUQT;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81D03606A323
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:34:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81D03606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=Yb5T9A2L;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=CGKohUQT
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQEVEDh3143476
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:34:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	quu9PMR9UDySxr/IqPO0z01rsJ1Q0S+Kq7Ac8gw6hUY=; b=Yb5T9A2LDhvYcSMF
	YYJSgn2/hTEgM+/24HXeLjJ8Gdr2skk9kv5BJYrd4f2Cs6reOTAAl/+mQOrx3zp/
	XBfeVDE5k2ZiUEkjSQp/n4ukxZAK4lPPspKCVKHwz2bR7+sR3QTQ8RVZwMvk90bO
	dS1T2rd5oU/EgmAv5eM33zcUswixcBLHfFvC+vnuqVFvc+KlFjCNbuCVFVxEC1H8
	XKKX2nsasBWmWvF6kaeo0ATj2QlIJSQ1flp2PhLsRUD9vp8xNhX+K5/2senat2Wd
	UTtjLaUzamdkfRJglLqXDJ9+3ogo9N2T/eVVbZr30QC9T/AtEhPXze2sVlWI75jb
	YoNC7Q==
Received: from mail-ua1-f72.google.com (mail-ua1-f72.google.com [209.85.222.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j61ahvsxa-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:34:23 +0000 (GMT)
Received: by mail-ua1-f72.google.com with SMTP id a1e0cc1a2514c-99e18abec80so119718241.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 06:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795703662; x=1796308462; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=quu9PMR9UDySxr/IqPO0z01rsJ1Q0S+Kq7Ac8gw6hUY=;
        b=CGKohUQTHrApPtjLxhI9GkbEf0AnJuVURw/f4fgkxMiY0cppkKUa0mUWAVxuC1CNF4
         Z6LD0E7CutpBLKsFMXW1l1bPAIRBZfTl9umm7YV3wCerRThwbjfoNwxUs9Ak2B0/F8K3
         rMIwXT3UJbH1mw3kTlV67MUooQjoBL31K9UPDQL7iRGUz63iDRh4DFoq7MbrorceCKfn
         ShRAl8nxJdo9vwRD8XmqNrO0oyVAGdWx7693jP1Q9zEgNtfSzzL/PWqVYS8hGhaRdNb/
         PQm9QiPpzdr5+/ajtCz1SguszJa6Xq/ccHGrftc+PHeis4PhTvm2KE20BU18Cbk/rYFX
         6WmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795703662; x=1796308462;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=quu9PMR9UDySxr/IqPO0z01rsJ1Q0S+Kq7Ac8gw6hUY=;
        b=cHlr7kOuO/kNjzmnC+gbvV3CxFkNpFastau5+xqBbXbhIjOfnK6XLgSWuVwbkBbbHs
         lm4EzU2mc0bpkEIdjyA6HtakiYpvrpAGorSfZ/Zz6MZPU/YY24ars4p/TFxJEaS8KiVM
         lyL5I6ZY6LhXc4Pk1bic/0Sm7xq2WC6BVQekIn+9gc1guw2LA2ZHdM/NMYpV7cbAjBpe
         hfirD3z7I6pMtQWhyP0yMjbzCozuqGJMa7Teb+rmPgzSG/5x+klsA81e+ruCmtIEZt+R
         tMdojREBzuNnPcDZNItoUIU/zJF3Q5v/iJz1rZZ6T4JAK+tVUIJmS71yKGEf4fdn0Adb
         QgKQ==
X-Forwarded-Encrypted: i=1; AL+hErFKvekkiRZpJOxYVPwkk3yAa9yyLr+kTq+d+Yz8G5Hx2Ibi71fdDW4DtNp7AKKbAlfIQkwQWAcpUnMspso=@vger.kernel.org
X-Gm-Message-State: APuU4Z+AarXrvnan5G2nqsWkejmEzAYqa2CYPhFquxN6xkRnrupGlkns
	SrfjdaAgSQ0aGliEWP3prswGS4tOdXxU5ZadT8euRlZpU9F/yarsxfR2HmEf0rbKIW1PiqCspIs
	cZz4rZZlJLwAA4PKa/HLdtm+tlpA+XLKEswmDdns/Ilm9OO5MCBBHz811kelWaXa5wqQ=
X-Gm-Gg: AZFdTZfCXBUmG6Ek+qy2wRwhVmzxyqxBt3JPp/01T+DPiv182pwvdqJiTZYGqEaCrXQ
	5MarLF9yu6o1OdX0/HWztcC1j84J+tLcQuOLamnsesdPlV1umwSToeSvy7n/rRUwJIWHWjKpNRa
	97gGYW/TyCguMnzZMFAgw5eMuGgM3/OEHVLWUzdbs7jU2lBe4ku+RZHgojRSRAa7Yh5C0uE5jEK
	1OxhXjqyMLVZQTn/QmKokoslDPrLPVi1DI2ff4m0l7WzaVKtGwb8uEnSna3HS6lLoagJpIeJT5D
	aiov2V2dFk7Q4kNgBFgZBoFRG3JLS1Nq3JIqPtNajZUwjyWNTHhjfEg+JFi3VmKEVJIynYD5+Yt
	Yik5pkdDySjMU/VjZIWuTvDd9z923vnDJPUNMsf/AttO4QZMoKE6txzNEvm3/REwrR8CxFHY=
X-Received: by 2002:a05:6122:6107:b0:5ec:e6be:d626 with SMTP id 71dfb90a1353d-5ee8ae0f76bmr14516162e0c.2.1795703662478;
        Thu, 26 Nov 2026 06:34:22 -0800 (PST)
X-Received: by 2002:a05:6122:6107:b0:5ec:e6be:d626 with SMTP id 71dfb90a1353d-5ee8ae0f76bmr14516124e0c.2.1795703662041;
        Thu, 26 Nov 2026 06:34:22 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afc5396sm754027366b.58.2026.11.26.06.34.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:34:21 -0800 (PST)
Message-ID: <06744cd3-e8e9-41aa-be89-c70f352faaea@oss.qualcomm.com>
Date: Thu, 26 Nov 2026 15:34:19 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] arm64: dts: qcom: shikra: Correct QCE node
 configuration
To: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
References: <20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com>
 <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261120-shikra_qce_fix-v4-2-5249e31394ce@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: r3F06TtAro4voOBfiEMh_aBtqfH5SDJ8
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA1NiBTYWx0ZWRfX20/BVhmckcyC
 /E5YQs+wq3RVmVpXz4HWZ1QtUievHumODjY36PtOdaZYWs+dGc4BM/bFMkUFIf3n5O9dC3VJuHR
 fh9Sx7MY2DRUle5rzJWnTD6EHrJaQms=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA1NiBTYWx0ZWRfX41R5aFR7DaQU
 bkhkFwbZO+MfOfsNYopAi19/EmrT+melveBX+1msM77k1b2tEo2WxW1W0BwsmCmTrvctpyIYRGX
 +z4pwVU3yeEQaIBm0L8Xa/zZXAxqedEPxkT0RyMTHFRB/CbqvcCJAEsTnFlPyNoGB7KPcn5273H
 eWH3IYdLBpHfWHBSfE0CUkzlIoQaObmrkkXoIGIhwNhnkguH3fCeTciOPNfwALp3AaUMS6LO/Dv
 5zduuMEgbSlBt+6rVlkkRLv1JC/47rISvFvdYfkfpwPNib048b0FcxNWqL3w2kLgNy7vvWuKn2P
 VUuiJzG2KY6/B4hFtCPjSEvteeIePl0PvNeZngOraDzTuF2+Mf5GbDV93CKWScYVG0KE/zd3en7
 sfpV9aStF4gxBGwibE52MsqIsaXG7cp01UcoLYrsl5INvG7FhLtBIOkxFO1pJzES0edeRVu7pIb
 Au3Sx5Hz0ipz981WeCQ==
X-Proofpoint-ORIG-GUID: r3F06TtAro4voOBfiEMh_aBtqfH5SDJ8
X-Authority-Analysis: v=2.4 cv=BbxNQbt2 c=1 sm=1 tr=0 ts=6b08436f cx=c_pps
 a=ULNsgckmlI/WJG3HAyAuOQ==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=EUspDBNiAAAA:8 a=4q88LKyOuv55sd6UrHYA:9 a=QEXdDO2ut3YA:10
 a=1WsBpfsz9X-RYQiigVTh:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_03,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 adultscore=0 suspectscore=0 impostorscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260056

On 11/20/26 12:29 PM, Kuldeep Singh wrote:
> Shikra QCE requires an explicit core clock, which is missing from the
> current configuration. Adjust fallback compatible to "qcom,ipq4019-qce"
> and specify core clock to match updated binding description.
> 
> Cryptobam is controlled remotely and its clocks are therefore managed by
> remote crypto subsystem.
> 
> Fixes: 099cd05d200b ("arm64: dts: qcom: shikra: Add ICE, TRNG and QCE nodes")
> Tested-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com> #on shikra device
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
