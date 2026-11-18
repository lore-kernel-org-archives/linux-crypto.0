Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.180.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794995297;
	b=ftDNls5wouoVfv0azTsUzTQT7HlUnoGP8zhSqCakzbTVe5+nfwe3WCc/SQwvFG24zg19
	 p3x4cF59OBNurjK/v9MKHfvhahKcQK49zuqI6pMP58nTvXeGtEmRF9+X7BQEMHcsHSDuH
	 m5o8UO6klhoxOUtomOt/N0L/D8/Cnb6VegTY5LxsKK+fyUUyhzUYgoF/mpc20CoLVmrZe
	 vqEm2qb/B/vMwQtbeu3N2c6Pr1nx5IRTDA2HTu1so4lgTemA9kpD80um4LDM0KjYHCNFB
	 ONqB9HWYvSPeheBfxYS8DaHeRxUohJYOmu5iVZ9ABSMiKVF9YnGIMKSZ0PK5+Xwf+4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794995297;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-ORIG-GUID:
	 X-Proofpoint-Spam-Info:X-Proofpoint-GUID:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=kLnvSYRMn2ne36NTXb1nZYBaoMvTs9kFclp6tyj7WCY=;
	b=NCAkvL6N97WvapLa3OcbtKtqqszJSNxyD0KaboZw6RHraw59mFq8WM0ORfD2CKWciHhN
	 q8BfdFmNHpgSOBhsIHfRvxvw9lAqn3DfbQemLLMAgQzKYZpZ+Z3Lh7631gbuiKa+w7vIX
	 7zwMekkrcRke9fbL7KEKZ+Y3yKG4PTJJHvqhPNa0VrbzsjfEGFy6Psc6VRj7QU3sVYCCv
	 Vvmd12mAR18/7uvlab8u4KQu9V25NQPu6xxs3ti3Oq3UuvJc6sRutRjCZKm00s4CfRI5r
	 D5NgW+iBdnNngDmOrE4gBp+wqvHgoN+wb9vPWug4Ja5HXfjFmiTRwzrmDO6xkq+eDFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hFVEUO5W;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=drA6BBiF;
	arc=none smtp.remote-ip=205.220.180.131
Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8BBE606A335
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:48:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8BBE606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=hFVEUO5W;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=drA6BBiF
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AI9kJsh3071632
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:48:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kLnvSYRMn2ne36NTXb1nZYBaoMvTs9kFclp6tyj7WCY=; b=hFVEUO5WeSIobojN
	UVIw2O6MToBWX4CaZBcpZxtQT820QajyDdXRy9Td4vVQvTRIrizSrsWqOn6o3XdK
	mCy5dhWkjoqFP/1KPXqA7Kj6uwsXz2HHuMtmc2GlfWwUKfKVY2M9RxAzEdJ9dNMb
	qvXAs5AZ+WWCHY+sI5Z0etjtbE3iyLI+hvwnDhE/Q6dkEqPX/jHDMY7jONEedr/p
	XrS/9PjpuiOlCxdS7NgTLWz+nyZjaTGK8XrVjLrJELW7yreeIvdb7rYfdbuWncg3
	ZaZLtZimYJWULfgwezkXIpGgMfkik7d5s9PuQpSOuOmtDKYdG7daBxUCL+X4siD6
	zXm5lQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j0yv8tbj9-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 09:48:15 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8a06750c74fso767173b3a.0
        for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 01:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794995294; x=1795600094; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kLnvSYRMn2ne36NTXb1nZYBaoMvTs9kFclp6tyj7WCY=;
        b=drA6BBiFKQRvXjawVSxnk0rsv3v2tUC5+6fTjFIzJZlxgNiYjn3beKYb6ZDiTCCMXl
         Rd6Ew513IL+0exjvSG824u3na/grMh5w9dQ5uirOzfe0QAIvERiSezA55AkUzoqrx32A
         hxkxsoxjwHUUva1MXGOm5LvOBc1LsGRp1DY8FST9EQ0iKm9eMbOYNENPTET+KlhXEx1x
         67QONNl3vStJLPkN1hG4LEG61S52VT8+79gIC/dlQblcNkmPSbmZjtbs9k9KHOju+/mP
         WT85mALYaA82UlmWOa8+rvYP+84C8AX3dYbN7337SvLVBjj/Rmh9noEQj06h7E8lYIKr
         tugg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794995294; x=1795600094;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kLnvSYRMn2ne36NTXb1nZYBaoMvTs9kFclp6tyj7WCY=;
        b=Of5s3E6rTTsqc/ubIJ4LwLp+x2yJfE4FrTo4KJIcE6j5Te96OcACc7m4h4ZhD5rkaE
         PSNP7k7l0uH6ukXoYQuP2fXy8lAQUMZs5UkYbfFPvBZ0N//3zKmQpKKsLhSElaC9aCM+
         Dkbms/IIIKx+sDwQOMFpiQtRhvHX3lrrAPv2LimVV1WJ3K/LJw/PysEcZR62xieLZ9Zu
         rm4cCte40kO/yMoGRuuwJJzVEvIoc8l+MiM5+luCwwP2XPecn7njOYkQ1prtV5R8X5nx
         J0ADtmt6x7TNhhiIS1ostoKadPgIXiLKZMBezN1D1UFS+67B4VFpKEqJwU4LORFgTNqQ
         CmHw==
X-Forwarded-Encrypted: i=1; AL+hErF6YCZ2zJV2CPocuGaUj52qVeIAvS2afB2KkHf3+DOunWf2sK3tbwrGU+CMkdpcrcCTgWqnOypCIo8/+Ak=@vger.kernel.org
X-Gm-Message-State: APuU4Z9dydCmiHgkIrqs8xQQimbxEoc9bVo0iVsxPkxm++VX5gAyAXid
	Rhsu+NUHnym9tiLQMfFnt43PYQlKksZyQB1fvciEc9yv+lekgn0zn4xvODw3MhOqJNjaThe8OXX
	sZBCe9iAM2vFuXoQpcUsrJmoVqtevY7rq9sy7WuW9poQnecSrTGo9oDibXCxjiqTAi74=
X-Gm-Gg: AYBFou2tBpJYCFKWAKTbwlfWn8CckRNSiyM0/Jtj7ZI9Htg2R1+AU9jyqzBudR82Jdq
	TjweBxUBakt3r3ZRRUOW452mzgDESxbPpfDH628XxKEUpW7cYFL8wizQhnHpNuU0mpkcKmEGhwS
	ZPWyDmcuOkgx3CQFDS1HmAv/wiiclxPYIyuXBEx0ND7Gtpc2BZ6nOeszCVdZfkM0E7Yw2o1T3nL
	jlBi7cNOoww99C1IhKSqXoliaWu70i4D9vGaZKFhQtkcTvQIZPY34Haz4/KHqxY0iV+NWyWp7ne
	Ici6y9Zb3o5Z7YJ8S2z34baefhOGEHLqWs1+n2U0mWHS5FJpC5dY/bE7fNrBQUIxJO5144bbTZd
	/OrWfW5zRxdCC8CRQKTsqRadxaOxh5TRtaYame+ewmBPSgC55yXCeWYI+AdriZbEFjQuVwxUFeF
	WiPMM=
X-Received: by 2002:a05:6a20:6a08:b0:3e2:7a40:a566 with SMTP id adf61e73a8af0-3fe8acfad99mr2273418637.45.1794995294249;
        Wed, 18 Nov 2026 01:48:14 -0800 (PST)
X-Received: by 2002:a05:6a20:6a08:b0:3e2:7a40:a566 with SMTP id adf61e73a8af0-3fe8acfad99mr2273388637.45.1794995293773;
        Wed, 18 Nov 2026 01:48:13 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c5cb54e413sm938597b3a.43.2026.11.18.01.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 01:48:13 -0800 (PST)
Message-ID: <61542423-9ad8-4791-abac-3745e032cbf0@oss.qualcomm.com>
Date: Wed, 18 Nov 2026 15:18:07 +0530
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
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261118-glymur_ufs_ice-v2-2-7ef4556eea15@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: Yq-tbJGQDo-onYdwRGfISxgHHqAMwwaC
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTE4MDAzOCBTYWx0ZWRfX+/kp2A1eoE2D
 6NPcmBy/76s4KH2O7r3U+lmcTHdKvX4qj4Zw0gIY1yS+AWYtBMUVf7AiOEdktHBTVDSDu+5H1qk
 jKRyNQf6+oOyAkzqybqS15qEvH3j6Xc=
X-Proofpoint-GUID: Yq-tbJGQDo-onYdwRGfISxgHHqAMwwaC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTE4MDAzOCBTYWx0ZWRfX47qeYUVHxbga
 IlqZarCgRhQ7bMp9o2ARKlCa85MltHqUwj4pB/VFqf2id2v6eRWHdyHtGhuut8+R4+02RyveBai
 AMGllmGXKoL+TLy2Ju0hB1j+Gj2gOL9orZvmbC0sx31pYgjEWvF/9UzdcbWkg37qt+E3eBdT6MC
 DB5Gr2M/KIsq/jr83SS0bxIxoX8aN5fe/3FgA6Fe4fjrkZJSRg1UzfP5VZJiak7AxCgDjN118kE
 ZoSTBvxfjVFlk2QoIUuw4tmxiGpJd9fjweVGB9dCU0MAJ4N0tQBAu/OyYQo2y35TJ6WH43lObP7
 N67fVrA3eWyz1fK65w1Ykkx4O7+zxhK72OQYLMgTPEqZO9VDqZQhvdUULU+JfyNxL8x5n0iVDVs
 lBTJEnT5gJCSPEgfmDOLjcf7+eEEGUfDRs7S6HarzGDtLbdr8ws+6bI1zYNiJnN6e63S85eEkfS
 QnJCkSz+tAHa89xOPHw==
X-Authority-Analysis: v=2.4 cv=NNVAaE6g c=1 sm=1 tr=0 ts=6afd745f cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=EUspDBNiAAAA:8 a=SooqmcQUKh5i17ny3PUA:9 a=QEXdDO2ut3YA:10
 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-18_02,2026-11-16_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 suspectscore=0 clxscore=1015 impostorscore=0 lowpriorityscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611180038

On 18-11-2026 14:38, Wenjia Zhang wrote:
> Add the Inline Crypto Engine (ICE) device node to describe the
> hardware-accelerated inline encryption for UFS storage on the
> Glymur QCB board.
> 
> Signed-off-by: Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>

ICE addr/reg and other values are correct as per hardware spec.

Reviewed-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

-- 
Regards
Kuldeep

