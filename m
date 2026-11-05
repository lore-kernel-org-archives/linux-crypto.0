Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869012;
	b=QzB19HjxPSxoT76IeoidWQ9EaobnzpnEC4v521AYFSuhR6SMdrtZMFHr+lPDrEuq2Vuw
	 vXJfTP6KAuKswXXO4bu+gTaR79LKyQPzL/4Ai41dUav700XAQlrZVhgIbTxXx438Z5Eh7
	 VLr/9hadWmyxAvap3H4bh+8NM9ZIjrm+hFhxBemX2T04m8NwafoHej2PDf/tgVouCrAgX
	 qqcR6q1EHhp7NkX5vG1ezgpIAipSRXxXtPBMcAWPShlTnAcQD9bMK1+XZOAB4klkDtJCt
	 E6xgOF4U/+dUQzGNpIxXI3GwqStjg4OOrIJED6HZH3tEqykzUf+QSw5BW0WqeYszaFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869012;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Proofpoint-Spam-Info:
	 X-Proofpoint-ORIG-GUID:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
	b=RkK/tP4iVWe27ntV+K+TbdLGzAu/DUL6gOueCRszNK5DeDrHZ9iKPfxksMRG0g9Xt/XF
	 bKs7mzCD/E0pHkdkJ0GfDs5qLSKTcpoFbPRgO1SAeeySxoXaxmjyKpA+pV0zYvBnhlhDe
	 AbX4y8lbNrBJe3pKne0BhzCZIkOqAd1rUoBXt1GUBehucBbqhXHJVin4ENnfm1l5Epssl
	 ujjcLwr6BSD5O9sB2gbmeYV7LYdMhIpI3yjFInWo7ZgakOiaGqiql9pGxo3/kw0zr0Gpx
	 C3ZWCq/bH/BTs5hKOwjfjLdup+pCK/G9jxkKoYK8sZnTd6j0b1dL4VMIcSvsUEI2L8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jj4jpRyU;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TjIkJ5Ag;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E940B606A32C
	for <linux-crypto@vger.kernel.org>; Thu,  5 Nov 2026 08:56:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E940B606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=jj4jpRyU;
	dkim=pass (2048-bit key, unprotected) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=TjIkJ5Ag
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6A56UBpm3819650
	for <linux-crypto@vger.kernel.org>; Thu, 5 Nov 2026 08:56:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=qcppdkim1; bh=FB1C5WDv2k0g4VMhoAfgN9Y8
	5xhLplp0at8UMrU44m4=; b=jj4jpRyUuJ2OeSTNxPibUFA/SC0e81ThCh4vngr7
	KVcr0qIwm++o/H86jrwL67Vl/VdAojkju1WbO+ucBsy2uDDMz6tITOZ2Nh+ylE77
	qY/eSZRSv3Rp/gGe5TkAJcfiZmTyINYEYKEHTkNQHQBdIBKj0XfZLbjjp9gJOf6r
	XstmM5Fu10D5b2vKO3wZUcsbwumOdyHlKHjuS/UFe1aHdCfJ8O3swxIqkUIWmzE8
	Bpow4jsCBqMNLIjwQxKK6DGffIe0JF9MMaFzOPMbfAAceQjp+qCyEukvCE9h1KST
	aWILXma1Ln1zMFZtBajr45rH3GE6FelUJnBWVXJK4lhfVg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hra5tk2e0-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 08:56:50 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93cbf2fd504so324875885a.2
        for <linux-crypto@vger.kernel.org>; Thu, 05 Nov 2026 00:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1793869010; x=1794473810; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
        b=TjIkJ5AgEe3MW3K9GASPJKsvRdkY2SwhOswYkdpAFjgrzxXbRMsmjeiw2zPJvxJWai
         Lr5s9ggZ1USbr918AjaoRSWCTz/FWVjBOXHLwwfaeTyarZdQdt14x3FjcFEvxpYEw1Ea
         +k0HmM4LeeC5AhK2BBc9jM0PWx0vTOSl2KN/Qf0RImJyoggyzp8PvH4+8IvZF/ivOOnj
         cweAv2HMpSgdp6NepmFzXDzwa3UUqz8bkHaDjH2WLCRMtJrBlv5C6wu6+5SrE+IXeHBx
         fEoMP0WS5S5TfgoocXn6egCsc9goUpcI2i2JJRVSaWNN3NFmqP1r1RSAXoMwYUM4H3lk
         QeBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869010; x=1794473810;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FB1C5WDv2k0g4VMhoAfgN9Y85xhLplp0at8UMrU44m4=;
        b=jWH7cy03NCmUb6wWxMOBfnxwFzPoPoxVxhBsg1FiKmUAEDk82rlNb0QDOzDO+bzpoX
         zhrU7+gXfLmfW75aUJYqC8uS0vb40xk3DSNyA6u3oolnKZLqqHNQehE6vf0clE835Bx5
         WAiMWF8OGOfYhH32CSI5HCIPt5ddb11u0Eu8UQQlsZDoi87fIn9M9iSvec9DsyEs25oQ
         MxEzXL0yMXeOYs3GgQvviPMrpIce+ozi92tK7Rt7WAeMFtrmtdTq88lwvSEFom6wNh7C
         k0mg6wIHA1UehhJbc2qx1vpMepuAPl1IHMeICuMW/n7xoC86bSUs7bJWGmi5v8f6N+Zt
         eZ0A==
X-Forwarded-Encrypted: i=1; AKwUvBwL4Gq8SXlDuIUjgk5ICGy7IlpYzn+aK6FT76siCY2/8BYForaQpaeuy9fRPeHL/TxkPOtCFNNolsyIV8M=@vger.kernel.org
X-Gm-Message-State: APuU4Z/F5Z6W80zv8Sw1lFDIOdexBKzOqthgXhDlSswd3bOio4l9Vqce
	eUqo/bCH44tfl7dUzc+InuI1hgNwNXSv6Y/z+Uz0bJgC+FtXTUyyMg7dYA42fXea9rE/vUIzQbJ
	hARd6hlhvQFByxF6/eHho0j8khQfwXuDuMcxLHicYMgODFdLanoe85LCXApZ90fZvtQKCDzN3wf
	o=
X-Gm-Gg: AYBFou3t4khewg4crmfLoL9WunsAffj5V89MHMHl8/yI0mFjDYf8a92NMlFoItOD/Jz
	yM4EVujyr0IV7MnLN66RAqKLKFc/hMNIMElutHfoUA+D63aq6wYVCItjMJ4PerGH78wxVdGaK9U
	SywzjtePeZJQtI/nvbfzPtw+FLltsuVGQOTGwAsPn13fbgCDElcZXnqy4AZtz+Sy8/HahjmaMTq
	IWDR8DtvjaAwZOLOkv2hVxgve5Rk/DaDq8Z3Ot0qywPUuNi8K4Ad5bTYiS2ylBsSsD5YXMrPMDV
	xP9yvzo0hQmY4qTWpt2qCXl1PkeFam1VfSw8wMPkK55RL+YPYm1NUZbnMfkULvREx+6aJA1Rux0
	M67OWgtR9z7DNsophp9hLLJUyjcaL976vM0IrcZ40poGPTiNKtje8YOFZDAdpvOo=
X-Received: by 2002:a05:620a:6483:b0:93e:c12c:4408 with SMTP id af79cd13be357-944217cd92fmr2720754385a.68.1793869009964;
        Thu, 05 Nov 2026 00:56:49 -0800 (PST)
X-Received: by 2002:a05:620a:6483:b0:93e:c12c:4408 with SMTP id af79cd13be357-944217cd92fmr2720751385a.68.1793869009420;
        Thu, 05 Nov 2026 00:56:49 -0800 (PST)
Received: from oss.qualcomm.com ([188.27.161.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56ef2e968sm58629445e9.8.2026.11.05.00.56.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 00:56:48 -0800 (PST)
Date: Thu, 5 Nov 2026 10:56:47 +0200
From: Abel Vesa <abel.vesa@oss.qualcomm.com>
To: Andrew Gigena <mail@andrewgigena.dev>
Cc: Abel Vesa <abelvesa@kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Bjorn Andersson <andersson@kernel.org>, Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: sm8150: Use standalone ICE node
 for UFS
Message-ID: <dxb7s2d25ixowmfifhvetctpckj7h4y5puiai7orhkimgj7uxu@ekhwvpm536mk>
References: <20261104-sm8150-ice-rfc-v2-0-d697bbce0278@andrewgigena.dev>
 <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104-sm8150-ice-rfc-v2-2-d697bbce0278@andrewgigena.dev>
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTA1MDAzNSBTYWx0ZWRfX0LLp7h4zhPTn
 HP4YmgurdzxVyADcy8ThDvWgU6XycZE47YV3rPgAAPJ6RmYEKwgaVu6hBV+DCBIql67lOND87hk
 b57vuTaA28H8FkZtuVJMD8h03PFnz+o=
X-Proofpoint-ORIG-GUID: vcOqh7uMuD9DAbyUCWfUMQ-JyuVTu87i
X-Authority-Analysis: v=2.4 cv=P/6vFSAu c=1 sm=1 tr=0 ts=6aec44d2 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=asF+/XNaGoxFafzDDLC1GQ==:17
 a=kj9zAlcOel0A:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=Bg7KoihMCtH8JNtkfXEA:9 a=CjuIK1q_8ugA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-GUID: vcOqh7uMuD9DAbyUCWfUMQ-JyuVTu87i
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTA1MDAzNSBTYWx0ZWRfX8jAdI3FcQZm0
 QJbhtSnbxLT3s16OwHDWcrM88cl4tpRQHOr3LBwHN7fmK4jE+yUdPe6mUMi7PkyX8jdZ2bEkaN9
 322jpg2StmKb28dGGX3rD/GZrNTZ2iHDdnuHQbwvEsRRrd07hLRJV/W3ZreAm2Y1GkWvZMc78WR
 +uPEcv4x8y4ce6PDEEu2Xl01VZBx4cTInD3vyplLEMatj3b1tD5vZWE02dcLfvE88G1Kp+B8h2D
 FGDrJ7Kzxnft+YVWjcF6uKs3d1KawbpnNCjize964IqVhISPrrDW5u24digjO+5+CKH5zhvnH/L
 uZoUlQYLeydTVhHVtsgaRfEZukiY0I0SvJYNu4TTdNk2yS2wJLTxheUnD7cm1fU48+VKI9mDN6l
 07OxvBzeW6fd1jWYpXTUsqngf1lAKktOSO2+bYbU760OIJ2wwC/uMj6+iljChhBr0oLJy68XSk6
 v7FhkQ76+bV2UfC29Dw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-05_02,2026-11-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 clxscore=1011 priorityscore=1501 impostorscore=0
 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2610300000
 definitions=main-2611050035

On 26-11-04 18:38:13, Andrew Gigena wrote:
> Convert SM8150 UFS to use a standalone ICE node.
> 
> Move the ICE register region and clock from the UFS controller node
> into a dedicated ICE node. Reference the new node from the UFS
> controller using the qcom,ice property.
> 
> This brings the SM8150 device tree in line with the standalone ICE
> representation used on newer Qualcomm platforms.
> 
> Signed-off-by: Andrew Gigena <mail@andrewgigena.dev>
> Tested-by: Andrew Gigena <mail@andrewgigena.dev>

Tested-by tag should come from someone else, other than the author.

Authors are expected to test their patches by default.
