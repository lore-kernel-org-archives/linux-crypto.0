Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704706;
	b=EqzqCKiPZpuqUnPwzzkhYNGnKykIEtGmQbQvsDEokYAeDuJUHJ9MTmeAoUt9BeLoqmdd
	 B+aXN0jvHl+NYHnous9pngw+M21BdE3ynb3m6ySUo6jFoVj697JB2yxHq9oa/E88GCplH
	 AnREWJ+dzOAjw3ojilbqOjCmNr6iTBsCPatgIyOt9D11J2OwVjKkThdAY3Tw7qAiNWT0I
	 vpNtUi52xfOnIRvYhMBf/3HBl7vkHAWs4SIGmqNA5bq2fbg6nea0zI5jkApHVWne91jDs
	 0YnMNX4jsdTHgNC336xCa8QSjAiUIK5X8orfq/NiTDJ29xpmUCnTOqG8ude4IiJBRqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704706;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Details-Enc:
	 X-Proofpoint-Spam-Info:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=p3SN1D4sjrKdWgPAwPandAiNpKuWV/CzGULwNCRR7as=;
	b=O5f4f1psESUerFXscXZSctmCXDBzbkQ2d/S8QTPwgoFx0kidXHABlbQ2FtaryFsUFdPd
	 oy/85gLNAkx4Fe2L0xV5ad7yabP2fC/fAEPQpkVJOiqoYEIKnkEpVz2UyRFXnZ31TFLBy
	 4lEu+eqzCUobB5d31t3AuCACgAhzpSFZQBCPhfb6bETCBsl7TxIdzXEMTIX9rd4nWWu2u
	 U47KoeD/PMNf84pf1vBMncck5b8uuYbQAbAhCcMVnKcDX9x8x/0gVbNRAXHCSqf7v25mM
	 G6MlUmIYOtGOJShgATxg4lzjXeHNdSVSCLKqy31BynmyXPsskfc2OGQ5pkoLf7lmqwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hC2qlaFq;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="D6m/f5rK";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDEC606A338
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:51:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0BDEC606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hC2qlaFq;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=D6m/f5rK
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AQEV0gO3563246
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:51:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	p3SN1D4sjrKdWgPAwPandAiNpKuWV/CzGULwNCRR7as=; b=hC2qlaFqZwOOa5OA
	3aGWxXcsDHzEraTeaGDfzyVTeTWUwlvouNbM1DCReSmw9Q4eEm8ud/urX0nE6Ezy
	gCGTi6s4+r5f24n5AJUp+f+Xl1xUVmBIzQSkJ5LpixU1/3C11B59JcmhslIf+Gpw
	Dl64cbtu3rRIYd5h8mLuSseKlvZit9wa79dQMfY7LObpWJnY3hKaUp7Q0BcI7G+A
	4qrxQuXbkT7g/LJoJidVkJ+VWxhDsQ2BSmcTx/1tyVPWVyIxyoG00cDvSU08SMU1
	eG16GORB0Xm/uzwBXfYkJ7/JImSVk23YYwkuNrXaLskSRuAJCrVJVVDCrwtKK97y
	ChElFg==
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com [209.85.221.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j662sbk6j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 14:51:45 +0000 (GMT)
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-5ece1a3bf7fso296754e0c.3
        for <linux-crypto@vger.kernel.org>; Thu, 26 Nov 2026 06:51:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795704704; x=1796309504; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p3SN1D4sjrKdWgPAwPandAiNpKuWV/CzGULwNCRR7as=;
        b=D6m/f5rKmw359YmVBhAgoSjuDalHZx91kEPGZ2aOKFRd+40+ACxhpLyutKiLkYEwDW
         6vtE9x/pX8DXVms/c9+ei3U/CzCtk92DxswT1tVZyP1aE8QSV40B3Th8fLSeSUysjo2l
         S4Ga7DKw9R/HPw8w8GRsSb61P9aBU1zK2LVrW1R0SIsi/pv8A19Cu0R/xKl3BJqNkMOn
         ZPU/FqN/wH8Bj7R95HHDsoctbdJmxC7oYkSFTUt6LRoef4+SdRBX+YGvo80tyU21Yw9Z
         BVqsBX8oBAYqekSY07u6GOPKYcH8Dp5JeXjRjadxXgAi4Y9YeDf+v2EUWaTEwfbjSd4F
         y7Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795704704; x=1796309504;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p3SN1D4sjrKdWgPAwPandAiNpKuWV/CzGULwNCRR7as=;
        b=cuoqLjX145Z4vWKROrs8o4itiNc0HUAMOoTTq/p2wzZ6FYY1JBBP3vQw2tNjBNmPkF
         Z6YFiVZinuA9PdNKoR+rAqbchvG/KH7Lqm37IqULHMg+stVpgw+WcwMRZbmBroMkplLC
         iWWm5OXc3vLadbtRR53tznfD0+7v1D/yxMs2GUDTjYm2cOyDNw/EH30il/ddPlis5Phx
         3o0i7goV0TXWLqg47fh7qfJS90OspFeiZcKdKY6NILnB7MoEATm93ik87YGrFGkSbfvB
         d98QTP0CyZx4l3UUXo6XGl22T3KVlOAvkjJD26nQU4S+MSAJAbMSnSrtC02e4gNeY0wV
         Dl6A==
X-Forwarded-Encrypted: i=1; AL+hErH/0fTt4TRrz6+cMOsvJXbc4ZY8b/rr4XCyOCxdIdnLkutxYjKT7c1bo2Y5nsJxqqQ7isi4WeFmAIBK0uU=@vger.kernel.org
X-Gm-Message-State: APuU4Z/BxQ/OgxatJd6/fO2zi79/akEb17iDsbAuZBmct01BWC+8eHnF
	99vnSaahtj23iUGVSLTbZ5LguOp/UYv6+7fKKVCcpCKlRNYShc+o4R36Do57qf+GrWF1yYG5V8f
	0+6XQeHCJllnUhzDnzwepYi8RfigoJVSNFKQe9uD84d45MkBobZWM2v4p5Zi+B16jwI0=
X-Gm-Gg: AZFdTZdsvKk8e8umSpM6iLNhiFIlboNwpb5jTUIeoF4lz2a6IK+hEqCdiQis7pqWxYq
	6QPAiUK/jwUXoB0sfo3k64yRZe0AMKIqPL9OxfOl1LxnjFsa+/uX88n4+wBI1Zt2a1NqgTb/Er/
	vZllICDWr7zd0xn+WrUJrlP56N9kiQAKFrdE18b/5sdQmvLQYR2wX/4lKnZsSjdwlnqPaJhPiq1
	Db6koi3CJThYx9fn3IHBNA16oCTrQvaDgLxewwL7o/K9Ouvm2JlfJkhaOm7OjduaJvfk9cfvM/I
	zAw1dUN94IYbRJ331sNCTUvpsUiJhMZoSGg9/iHGUKVwSrBrr7EoT4cnSY/YLhfLZdoWZCabJuK
	Ajzg9CqZOGXmjrluiEFJjh94NukAO4LxWkX+jcrY1f5rjg/Qpzp5u5NL9wrbbbsS+NO+ukKs=
X-Received: by 2002:a05:6123:424b:20b0:5c9:91ba:5d7a with SMTP id 71dfb90a1353d-5ee8adf2d02mr13329284e0c.1.1795704704149;
        Thu, 26 Nov 2026 06:51:44 -0800 (PST)
X-Received: by 2002:a05:6123:424b:20b0:5c9:91ba:5d7a with SMTP id 71dfb90a1353d-5ee8adf2d02mr13329258e0c.1.1795704703707;
        Thu, 26 Nov 2026 06:51:43 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba370cbb80sm9784877a12.9.2026.11.26.06.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 06:51:42 -0800 (PST)
Message-ID: <8e071cda-92d8-4583-975d-7f07cdd783ac@oss.qualcomm.com>
Date: Thu, 26 Nov 2026 15:51:40 +0100
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
Subject: Re: [PATCH v2 2/2] arm64: dts: qcom: glymur: Add ICE node for UFS
 inline encryption
To: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Abel Vesa <abelvesa@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20261118-glymur_ufs_ice-v2-0-7ef4556eea15@oss.qualcomm.com>
 <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=B54sQ+tM c=1 sm=1 tr=0 ts=6b084781 cx=c_pps
 a=1Os3MKEOqt8YzSjcPV0cFA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=ayT878WuGnbjg-ISTX8A:9 a=QEXdDO2ut3YA:10
 a=hhpmQAJR8DioWGSBphRh:22
X-Proofpoint-GUID: pEWEsqxlQPs-jD77AJ0IVIrAa2xN5XDI
X-Proofpoint-ORIG-GUID: pEWEsqxlQPs-jD77AJ0IVIrAa2xN5XDI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI2MDA1OCBTYWx0ZWRfX1lQuxS5lKKB/
 AsUU21td6kSZu8iFbFT3FS66EjEAzZ7kEtXoVdh26M3EoafDy+vcwxAUzHwisn/hxabt8+Rgpkq
 ITJcxKzTOIxi1/AOh86Fm/WByEykJWDDcxpX/FsLhsvOTKBH3ViVhbhV/aiU07JmXS4Wjd1571/
 tWW+dZvnXHrUlhRqgpXCNT3XX5QDwVyfVGiFIqh2UIx3tyny2b7AQMOoO0FGYpuTKH2UIllImW/
 DZN8h2FmAthIarNgKbu0j2khSBC/l3JwBhVSpWLQWSq52MTBtxi1F1/YcTr0tTRMtfVTiNaSjGA
 Mdx28bjU2UoUYLbW1To3jPZKCRhk0ulJpvL7wLaGHs0HyJyyF3MSiuqnbin6y3iWhANDeAr8ajz
 VTY7LtakK/WmGTzfcC2y/L2zvqtv3S6VY4u4ElNoiTVzFII8rFp8DW13DEqg4Fg7bHrf0x4xb52
 M+tEj+jF5H7VCq9GUYg==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI2MDA1OCBTYWx0ZWRfXySZHpzTrdImX
 uZ22SdNUPkiS3guKQ5YMxCQFUn/h0j3lycFAHkPfNMUVCCP1Qmf3ZGf3I0GioY7XKyzfMTTRlVX
 W3+rK8ypPN6o0b2yLBJVleJ56Indb64=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-26_03,2026-11-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 phishscore=0 clxscore=1015 malwarescore=0 adultscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611260058

On 11/18/26 10:08 AM, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Glymur QCB board.

This is overly specific, the enablement of the block doesn't have
anything to do with the QCB board. Mentioning you tested it on
there is perhaps what you were after.

> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>
> ---

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
