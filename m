Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795584673;
	b=B+UGIPcdse9xMj3KjOjNpANVCDKOw4XYLPehyoutOnOb6nT/9dpPgNSOQ1EhRmXfiIUl
	 jX3VHJHwzWOQf14TCPzldvTEqQTjJ6zGQofdaDWup+pjsO7u4uXLES/Huu3LUeHyZCCcx
	 y/YTAW/OrTHcqoDVfEpkTf/7t9mF+k38bQK5rAJM+h5Lt6kjtbSpnlBVjEhyPKoj7xXcH
	 Z7apJlUuiHiDcdHUM0b2pmiNxF6VOwvQK5TDuqY5Ag9fA2V1zRyJsG4eRvBkFdIeVzWI9
	 9+fM2TDZId/+ZqmOtXS8e2YFoAhINDs7/s0C6AeiM2mSc2c8oOPUvWn7d95mzCYABhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795584673;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 X-Proofpoint-Spam-Details-Enc:X-Authority-Analysis:X-Proofpoint-GUID:
	 X-Proofpoint-ORIG-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Virus-Version:X-Proofpoint-Spam-Details;
	bh=eIAhBu5Bmeq0m//pVVYoXwX5xWDaT5pLP0CDoa8Q3NI=;
	b=Q/D7CKrP7mIOHCKTBE71ZoFOOe70JHOXkUlGvF4Ljdl2HQqN8nHx1JspSCM7qRfD8Hqm
	 /PbfZZgJfa9wlIKCpKr3rujWseyPgnbcz1sUPdyyUjb+gCOO4FzPYYB+eT3H6dBl8LD1R
	 6RzmLMNOJZFAlmpujUgchmoURZB4FcgVPQRL/HE6rSPoHx0LkpdtYRNcvOUJpqIyf1lEV
	 QusucLqZ/FYhbkekk8rok5A5XXEWWVzP1CpPQrUdZHtQH4C4N5cTHXduSb39FKQXFlLB1
	 H6qXTOpm3KBVXvOHYEddsd9aWYDpMjk6VhOlL51Qhb6iHxpYa1gKgyucsnejdhqJoGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b="MEIdCMK/";
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Zn+qX8o8;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D958E606A31E
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 05:31:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D958E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=MEIdCMK/;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=Zn+qX8o8
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AP2As3R3974100
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 05:31:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	eIAhBu5Bmeq0m//pVVYoXwX5xWDaT5pLP0CDoa8Q3NI=; b=MEIdCMK/LuwkdpNR
	93/yWb4TDT0kAnXFt/vUOMBUYgatoskzQlslxdeF4IrVukwHLxB/eXSEYnERiSqa
	xuHc/9NsyTf1vjDwS1B3bSsb2HOEdycYrMscWTk0i9XYG6uGcsN076kwgfp6REoS
	D6Qit8k47rVADKbX6R0KMP/Vr1+ZVSBOkBjbyd8kZCRv7kShCGFxhVzp9grCim1F
	V1+kf35DEd8tWwJRp4GUe/IGj/Li1uYrox7P1sK3RL52CbWW1AFnhYy+fRjUEUdh
	L8Hemk6cEWwgL0iueBe/HxvxhGPwMJnWTV3an6kZ+a7qr9EtfMZMsWyrNaN2Qnuu
	y1TUKQ==
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j5n6rrw9j-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 25 Nov 2026 05:31:11 +0000 (GMT)
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3b42ebf632cso3798550a91.2
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 21:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795584671; x=1796189471; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eIAhBu5Bmeq0m//pVVYoXwX5xWDaT5pLP0CDoa8Q3NI=;
        b=Zn+qX8o8ljDRGcebLRYsy585B8hV1Q/agiRR568uBQJnTJnYfCFGr/7E3GvuWZpKyD
         jA4cbStfA8o7EuZw1FeJ+ymRBfwV0Ij6ZPVlUviLId5Yk9g9GlhOveqgyQHR5QJoc/fM
         kIf+f5LZNY1tXZF+eDm+Ql04MFaTRm/F+9LvVyz2Jv4sGypgPAYj4xZFTw8j5Qa9h7Cs
         GT4pTF6pC2nbLef9lpQWcGiWMlta2NlPXHpLkcs/LnV3YlbrgTOHzryY85/fBwveBH2Y
         tmOXmujNNKoDNiJ71LWqDDwbRfDl4Z5L6HzFL4l/GgapADpT1Iz1kCZ5+cYPggKYhZsZ
         5qmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795584671; x=1796189471;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eIAhBu5Bmeq0m//pVVYoXwX5xWDaT5pLP0CDoa8Q3NI=;
        b=FNd1fFv2NJV/i6eC6x8jv7VKMfwoy03PAJkpKPFiziABsdRqtWoMRsOSA/E1qbSL3e
         cgstMAvEJrJ0+Ius7yMnLSwt0H5QEzbMtqBYIjNhcsRy9e/TlgT3j/H+o0HuPu3gsVWF
         MF7h61c56XqfPhDmcAM1UeLVAp7ST00bKR4E5dTDowQeUXhV8F3zHycy4zoCpBQEcOsT
         tQWdRPrmZO0plBaxK3vRwg+RJYkg10d+PBuZccz06hSU7s+SKuC1NF3u+QEE/bPd/Bak
         U4WJu83jZkLOzAlbsxbVNervOsweRZ7i9Qfze3XsHS+mu9NLwT8taq9P2u2YqTnlkZGj
         U7uA==
X-Forwarded-Encrypted: i=1; AL+hErHeVYMniKEO9wzdOJ4bEbpAfRSmhSQ/BGiR84JGwGCPESD13lg7aBiuJWzwW+3hgqAYAZtCbvOzofMVcns=@vger.kernel.org
X-Gm-Message-State: APuU4Z/P2JO5WUfrPzSGMfOOo6vRlgupQZRXxYhgcKIEcjOvMSe3YE2O
	yVUguATbB0AAWFNR42CmFglMyt4etM4e0PForCymCfhjcMbAbUrcKg+xWPBZDw7c0Vwpw/P28LH
	IjOdByYWLOUlSPE2lUzczM8FJXGwRVJRmZj3+EpUU0whrkyn8nRh0tlYdaTKCokbs+HA=
X-Gm-Gg: AZFdTZegbyIfwMbP+JRge6VrMp0Z42LwbCB83c2bVXNCAdd8xqABrdXwS8lHF+SQSsw
	tdsimBFtsS//RhvfJ3OieJ21RhwkXW0GjX66oVOkgdQDAfI1uPTJBgEnaa02BHMtlTuVeCunOL4
	rEPS/Fzz9yJbQ7CymBgbnLG8JwJT8vCoBEpDx0Uy3v+g7ruQ8AT5UyfskmsoUhuLw9srxq6SZ8N
	vwi/euk233ZV+MuzmnJZNe43chB+a2Oi3wldKH2uCBbqN3zWnpRwOZ+b2iSs2cpTOKRe4UnEVlu
	7ahaT5OdSpVLX3oDSNwWisFVLanMqws0bJA3LL8w0eCwXE/b5AWFrZeEzmGIn5XDIhEmPfpTFLw
	1Qln1jKMp4hsxSEBYecpVUpTC6ZfGQdga/Sa9fNnQmYLWLYFHfbAjsG8EGpqDMrWl0M5OUxaUwt
	mVqdbp
X-Received: by 2002:a17:90b:180b:b0:3b4:1336:4f53 with SMTP id 98e67ed59e1d1-3b41c7d5c11mr14553294a91.1.1795584671014;
        Tue, 24 Nov 2026 21:31:11 -0800 (PST)
X-Received: by 2002:a17:90b:180b:b0:3b4:1336:4f53 with SMTP id 98e67ed59e1d1-3b41c7d5c11mr14553265a91.1.1795584670520;
        Tue, 24 Nov 2026 21:31:10 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b405d135e9sm28528572a91.4.2026.11.24.21.31.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 21:31:10 -0800 (PST)
Message-ID: <45453937-5fce-42c7-ac1f-66aa94dec646@oss.qualcomm.com>
Date: Wed, 25 Nov 2026 11:01:03 +0530
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
Subject: Re: [PATCH v3 0/2] Shikra: Fix qce configuration
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>
Cc: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, linux-crypto@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
        Wenjia Zhang <wenjia.zhang@oss.qualcomm.com>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley
 <conor+dt@kernel.org>, Abel Vesa <abelvesa@kernel.org>
References: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
 <f3ee6297-fb83-4b1c-b083-f3b15fa082b5@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <f3ee6297-fb83-4b1c-b083-f3b15fa082b5@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI1MDAyMSBTYWx0ZWRfX70Gv3VPit7Oh
 FjCqPbL8IX6pHag4G15hFsWUzY0dDdSShyDhrP2xBQOeb95JFqjR1fT8NOPUaGFUOFikejPlPxr
 13jdmbAVH0lQertxWG/PHW+qjOXrEWCe8QmLQ3eO1aS0rFG/99gzM3KEthDBvwAkokLclnZqgFG
 on20/U86IHy94PJsbt0DZidgD5ZncUp7IoxzoHCZRltTg6o9bTMINNiws5fcENfnGo2VjhYlMH8
 hkRuMAudaMHeBEc/tc1Tm68fmDBw7Il2mAd67hgwhsN35hhTx8T8ZTysajuPCh5C9zUPsrp1WMY
 dbGz8tHQUf04Vx7hBq6tVVfYM/fKhjY7mYFFdSkzdnW3H3BF0DYjyMfP/DdFUX4EY9vfjhHAIni
 pYEg5zCpZkK0g98MQSicw30GMubQzdC/oSXUDkK/vQW4Jw0z7Wkse1Ok2uemW/5BgOJFKvQLY/o
 1LRWgsvpu7b7su13Xdg==
X-Authority-Analysis: v=2.4 cv=Voa2kO2n c=1 sm=1 tr=0 ts=6b06729f cx=c_pps
 a=vVfyC5vLCtgYJKYeQD43oA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=jYJX1yTOf0vTYKAZykEA:9 a=QEXdDO2ut3YA:10
 a=rl5im9kqc5Lf4LNbBjHf:22
X-Proofpoint-GUID: hLcAEkfVd-vJAxHTchrncDAYnQfJB7a7
X-Proofpoint-ORIG-GUID: hLcAEkfVd-vJAxHTchrncDAYnQfJB7a7
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI1MDAyMSBTYWx0ZWRfX5axTNY8TolP2
 FtWxR7961D8adFcAUzJfOrJ6hVMD8Ry0b3BRnoxuIsPl7cfNDnkGjuJ+GXGKGAxkRW1YFyVxR3K
 qVlulv9e5kTdUTH3jd0CUkdC7dVwnP8=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-25_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0
 adultscore=0 spamscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2611040001 definitions=main-2611250021

On 24-11-2026 13:55, Kuldeep Singh wrote:
> On 16-11-2026 14:29, Kuldeep Singh wrote:
>> Herbert/Bjorn,
>> This patch series fixes QCE on Shikra and targetted for v7.4.
>> Shikra crypto qce binding was consumed in v7.3 but DTS node got merged
>> in v7.4-rc1. It's important to merge this fix in v7.4 to avoid breaking
>> backward compatibility.
>> This series updates shikra fallback compatible and hence, both patches
>> should go from same tree to pass make dtbs_check otherwise patches from
>> individual tree will break dtbs_check checker. If dtbs_checker is not
>> blocker, then patches can go from individual tree.
>>
>> Bjorn, will you be able to pick both?
>>
>> The patch series fix description as follows:
>> Shikra require explicit clock which is omitted with current binding
>> description.
>> Also, one more reason to update shikra-QCE is, clk-smd-rpm was doing proxy
>> voting and crypto was consuming it. With proxy vote removal, qce need to
>> vote for it's own clocks explicitly which is already being done for
>> agatti target. Adapt same mechanism to Shikra QCE too.
>>
>> Validations:
>> - Qce probe and kcapi_convenience.sh tests.
>> - Correct clk_summary output as prepare_count and enable_count are 0.
>>
>> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
> 
> Hi Bjorn/Konrad, Can you please review and comment for this series?
> It's important for QCE to vote for it's own clocks as dropping proxy
> clock voting(patch in review) will result in QCE issues further.
> This series fixes that.

I mistakenly replied to v3 instead of v4[1].
Kindly review v4 for latest.

[1]
https://lore.kernel.org/linux-arm-msm/20261120-shikra_qce_fix-v4-0-5249e31394ce@oss.qualcomm.com/

-- 
Regards
Kuldeep

