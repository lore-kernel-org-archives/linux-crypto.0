Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795508758;
	b=a1WRVrky+cqiMvQ2O1zfBl3kbtfNFaryDjA3bSYki9bDAIfRZ/r9wbRgJX/5HPxsM8FL
	 CL+siKQnLfzf6AB0mmVtL9jEqqjcrkjpcvWkL7Nw+D2HV91Zl5bi9McqlTOROcqGfj07a
	 fjWzX198Fg4rWSaTn5slL/ClcMSauTZnTF5egUjDS6+bjx4UVSbz5RfctcEKQC4df7d/w
	 CG8UahFQEFmwzrtWZQHm5SWQC6hDyk/tpVSZAn+fun7pZoKidkF+RloT7e4beXzl9rUHB
	 PA8/+nFMharW5HgHPVIqjDt4dwWfwzKEEVG/dJ2u2xXg22U6AxhVLszVkVKkFnnY+6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795508758;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=GCTNA9xgCHXdB81WrISHqlua/lWBZnpYRxHVBs5lH/s=;
	b=0rhPEm89GObuG0AqRc9sIYbvV2Z03Suo9JiVV9Qz51HQWX++zXMmzF+0WMexld1OLYzD
	 ofkvmLJncAZGbsk+/Xbuihocn+lJRcu1Tyzkss0Cr+FmuRf81Kzv65UkCvVxCw4oCG/0F
	 TaBLi5yduvwU0OQtDvHiDZOnJWP8O4/nMSsr2obT/xJaPhgKK/XUQLASVyR5Z9d6E3QrO
	 rV4I7nC+Y7JXTOkoHtCR2oDEaDdpbposaTFE9aSlhOi9F9U8cmwxDotIuEzToU0sEXSGX
	 2O/RJ9tHAgTsmcfRkF2pjOT1iE6pd1Z6ZXYViGeSpVVxvkI9it487PROuJi/N5/kskA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gc0jjAbA;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HkCMqgTP;
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5433606A327
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 08:25:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5433606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=gc0jjAbA;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=HkCMqgTP
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AO8OJa9901979
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 08:25:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	GCTNA9xgCHXdB81WrISHqlua/lWBZnpYRxHVBs5lH/s=; b=gc0jjAbAvL/zSslc
	utmB9/45kGAqVWnWEKLkVkANHSp+F/eDR8HDF47GBRhaa6P/Zlo1knyDckAZtx22
	gLFb6QV08z31iLEtSn8/muvnyj5dAvb3vX+oFkBNNdxLCK+QD4izuZ3tz7lD2A55
	qK1bzWfhLRyQuv1q1/wSIFzU003NDgzv0bsruifBYaXx00dM27jWQSBO+9sSG/eB
	Tit7+yPMmOQJvFikdlizr0bj5OXy7LKXjGifGlumL5cCj9sNVkw2iziPMWddiQHG
	JurgFCfgXaVyV4RVkURw51ofjxSgMHaqXayXPect3KxNuZyGwhJO+K4Q1zDa3lbR
	6sAo2A==
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4j4w6st6u7-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 08:25:55 +0000 (GMT)
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a0522cdaf3so3105334b3a.0
        for <linux-crypto@vger.kernel.org>; Tue, 24 Nov 2026 00:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1795508755; x=1796113555; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GCTNA9xgCHXdB81WrISHqlua/lWBZnpYRxHVBs5lH/s=;
        b=HkCMqgTPTpd8uWgqkNr6g/4dDJc6GOtZaHQhGKJwC1xfwaSJ+M6l5+yBJ++SbuGtCj
         jQRA0TlFWSflIc+CsQ+UZTxYaqJNeqtqxD8yD+tfW9BBn/dL1zoBGnYqdPpnTUBto4Ol
         gmJADUgZk8zfOELRCDWCYD1sbxLkw743YPUYCMunThFYnNfQ+cXY5juC+63JGQWotO3u
         PmK38Pku8tVqTvH/ja4eHPzV370XdCV29USAY6kTcLwcu591CuSj/se0BKFbmGTDnBzw
         p6S9uf78mIOKgbU+kdGxUJD/Qa82NlwjpPsbmnuvBYZ7jVTjsnsqx1ufvXyB1xABjjaI
         cFng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795508755; x=1796113555;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GCTNA9xgCHXdB81WrISHqlua/lWBZnpYRxHVBs5lH/s=;
        b=ssBv5kCuwNwDOKVWA5mYmW3Xz2GskJmzS6Tk31Xai4Z6Kgu6auNYowVotDHOaxw2i4
         sI39NAN3oGSQx2Hd485Pet5se4t40bMwpo2wfhgCUGjd5xl6k7pD/FcMjrVARZ1yzn7x
         0R0u+3wZskt6o259FTJaC4X7H4kzowM78h55eqEYI4Uy+ikMcHPOBtFv1xQdeHOmMcnL
         uNfbxHhE9EIrfq/AkP8xbDeOnZFcauQnc9oeCfcUaOeHae2/1RX/dH/O/4j7yvVN2jQN
         tymGlNh/SzIb7DivNFtyvEC9f1Jc3sofXtINVYh7Fec1ZV7jF8EE8Ui2ddX9wWMvXH/z
         UKgA==
X-Forwarded-Encrypted: i=1; AL+hErETw5boQuQH5sG+cXF7xsFj+Ulck1VX+lWuXJnR7UGTI5TDpsKduA/InZ7x6DgVJbPhr28QoTrg8gskh5U=@vger.kernel.org
X-Gm-Message-State: APuU4Z+FEmZkhsR7aHF86jNpPB7HlC1tK7CKDks97jKpHTClN0xjgo2Z
	1kRG/xMm5j9BtihKbeSs1Dz5QkZh2JOLI9BRAoTa9X2oGzz9XBQQedT63KpWTxsl3UXa02GFVQ2
	O5Rv75vpNwqtE1Hy94qf7nqUQu6IBAw1ZjazE3F8CpXSHS/9m1LxH1kPibMBBjfRRd+I=
X-Gm-Gg: AZFdTZd8SQIz1hjwLz8fVN5URMg35vXVvmRwPAuoE7MpD8/sobAwKH8imxslHNnO/38
	qeNAlWoH/Qu0Bvg1c5JbGybd/U6XCk33jP0IIFHaBU2MLYQKcgUrGlapxtfxJ99EfefM1KK25Qr
	2nxGH6A7U4l9DF4R3McmD6VvB2ljMCkZ4EZKWzIhYGkhAA0KTmTRf8fRHYSUma+QK1GwDtYCRZ4
	9F4TN9bHRRB4MOi5rBv/zEQNMb0i5hQQ7RSRbUOKyCvbasrNZl3JZiBTmO0vrXaeErpB10PVPAH
	Hq2kuq7s79/2HM1GauZQy9AeEds0FepxhGmda8El/oeCVjdE7QSxDLk4k7/WfZAb8QkMHPsOUmk
	jFTrdJLvmnlG7Ewf8z/gPDMw+yr2yWBH4OuAFZc+tVLUuO9M3HANsPR6hi75jJ0/Ygw3V0Zledy
	I3/yQ=
X-Received: by 2002:a05:6a00:f8a:b0:89f:7a1b:2bf4 with SMTP id d2e1a72fcca58-8c87baccd9dmr12143588b3a.16.1795508755363;
        Tue, 24 Nov 2026 00:25:55 -0800 (PST)
X-Received: by 2002:a05:6a00:f8a:b0:89f:7a1b:2bf4 with SMTP id d2e1a72fcca58-8c87baccd9dmr12143555b3a.16.1795508754869;
        Tue, 24 Nov 2026 00:25:54 -0800 (PST)
Received: from [10.218.31.125] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8c87343f726sm7129262b3a.36.2026.11.24.00.25.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 00:25:54 -0800 (PST)
Message-ID: <f3ee6297-fb83-4b1c-b083-f3b15fa082b5@oss.qualcomm.com>
Date: Tue, 24 Nov 2026 13:55:47 +0530
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
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20261116-shikra_qce_fix-v3-0-9ae31470ef48@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: i97XlBCXqe3o2eELh1JCm9EZhgCsPyqz
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDAzMiBTYWx0ZWRfX4Y3kcZ25p+ZC
 tWK9jAV2VdPwWI9ib5erH1Q8NYVlyE5RZlL5uBa/mU+FIKBkToAwjB+WMIB/TGkLqZVSRw5Haci
 kD3TzK0tjdUPaPIDhP5CS7SSim+0EjE=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDAzMiBTYWx0ZWRfX1N5LLsylDAaa
 Zj+iR0lB/OREZKaLQuVa/2iUhwLcym9DXGgIgrqTUWok+ZYaUFDdsBbY/KW9sqapw+IFrTVUuCe
 6Ceznd2fkzf++NGO7Y4HOKVW6G3tNg9uJHObx9CHdUjszgKSKxn2qJJ3HYC1TvD82fSDIqCbh9A
 9JLKAD8vRxc1u3BJYdHwwt6lGV5LyqVk8+hI75yyLUUI3in3f6Rx5zeZL1+iqYVYxeBkOrUBYQy
 JQHFmX675P1OroaLMt4C/szHoIvXw25+p/SP88Z/03d8THiQRROssmW3+Cz2MzyyNE2Fqnd1w8p
 klMkYgOAnCP8asjv/OTWTT72KbYWaPc6rJWtd2iynLo5xDMaOSElJJkYvaOcjc+cqlobPry668x
 9fZyuWMyBsVVbHEmuQutwcnSajY5oWWZtKRVgofD3GWjmwj/aV9HXu7qwgFce/4NpqxSjxmrV7e
 VCSYXlCBqpjyU6vBSOw==
X-Proofpoint-ORIG-GUID: i97XlBCXqe3o2eELh1JCm9EZhgCsPyqz
X-Authority-Analysis: v=2.4 cv=V8DoQuni c=1 sm=1 tr=0 ts=6b054a14 cx=c_pps
 a=mDZGXZTwRPZaeRUbqKGCBw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=4cre8Lmcb22TJlfxBc4A:9 a=QEXdDO2ut3YA:10
 a=zc0IvFSfCIW2DFIPzwfm:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_01,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 suspectscore=0 bulkscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240032

On 16-11-2026 14:29, Kuldeep Singh wrote:
> Herbert/Bjorn,
> This patch series fixes QCE on Shikra and targetted for v7.4.
> Shikra crypto qce binding was consumed in v7.3 but DTS node got merged
> in v7.4-rc1. It's important to merge this fix in v7.4 to avoid breaking
> backward compatibility.
> This series updates shikra fallback compatible and hence, both patches
> should go from same tree to pass make dtbs_check otherwise patches from
> individual tree will break dtbs_check checker. If dtbs_checker is not
> blocker, then patches can go from individual tree.
> 
> Bjorn, will you be able to pick both?
> 
> The patch series fix description as follows:
> Shikra require explicit clock which is omitted with current binding
> description.
> Also, one more reason to update shikra-QCE is, clk-smd-rpm was doing proxy
> voting and crypto was consuming it. With proxy vote removal, qce need to
> vote for it's own clocks explicitly which is already being done for
> agatti target. Adapt same mechanism to Shikra QCE too.
> 
> Validations:
> - Qce probe and kcapi_convenience.sh tests.
> - Correct clk_summary output as prepare_count and enable_count are 0.
> 
> Signed-off-by: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>

Hi Bjorn/Konrad, Can you please review and comment for this series?
It's important for QCE to vote for it's own clocks as dropping proxy
clock voting(patch in review) will result in QCE issues further.
This series fixes that.

-- 
Regards
Kuldeep

