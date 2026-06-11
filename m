Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EB3C415C
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781171353; cv=none; b=fEpTMomnmy5soUU0LbcAMx6vwsaEB60xJCry1bl98KF3QkdPDA7lI+Lh86R1y3vk+mUVk1ASZShAolJB/p2uJS1jB9WSbL3GYchLWMvUjQwYkvYuau5NLJzbHS5myAvy3gureWlhJy/S2Ke3OJQrIJMnMjlEXxHTNa6stCVhgik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781171353; c=relaxed/simple;
	bh=d0T5kP3LL+kfIxqV6/dK/GXb1lMjqJJIjQZkzPC1N6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9hAlQsIHuoA4+Bm6iVQ1sVCv/zeRSjmn+b/6QDw+ruOcXRlUZAbS5yEE32K8/IR29C0ENw6gDutZuKrykQ2Zl8nIk6oQxZeggO2nIRn4ReQ6qE1eczVm9gLMJmbPSZet5MVK7sWJdDofMJXC+4qHW+og8t8TJB/erUXSk0xPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=jyGmsJE7; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=A7Kg01kQ; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="jyGmsJE7";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="A7Kg01kQ"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65B5GKXN2247995
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:49:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3i9DKlQbhqJ2Xx9GXVi37yT+grS7XDDKX94F+vmurL8=; b=jyGmsJE7vj02LXJu
	IytJR/lxSUiq7a/P/VGpxWeJ9r1VtoH2VomkQTCTssOOJyIgLHqzXQzJLoEbuxDP
	WhtO2L92WX/Kg7YYTmoNbB3AAngiWtq0b0LP74UV+lXBhoRbmZd/ZF+Fbd69AXQ8
	hLpfEyJSr859JmCpqdrKS9kJY3PS2SAV7VkJwB5oPr1RhSJ7oePauTymMY554SFN
	RuoejhLNN8y2fBJfucCsnNCClmpS7snl5ApPkHuGOE4GqBA3IpI9BtIi1N665hia
	D56R42navWm9DvWv8bQe/JZcpHxGmT9xE2DCVTO62HlIcyf0qCIkq7Ac9tSOUorF
	fm7EAA==
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eqe79jqxc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 09:49:11 +0000 (GMT)
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-c8514f8ed5dso4687232a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Jun 2026 02:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781171351; x=1781776151; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3i9DKlQbhqJ2Xx9GXVi37yT+grS7XDDKX94F+vmurL8=;
        b=A7Kg01kQsOnoLcMxUyGWO8BOiNfTaR0hiMeNdHIdE+w4pR64rgQb0EjBX39jcive3Q
         /6jHrdM9ah59kauGrosRZtxmFzbF7H9Bj3Kdp5zD9mEsWqpbqtrz8TGoqPFaX3gokpSe
         +IVRpprJn92OYW1uP0wuUP21ACPGSw4op2yEQYlol9BNbt9aL68jehPyzS8HzSt46yG3
         HhFC6pJso8DwLjqLGW8+tx6lYIxkoLH8vcGofaDqVVpzroQWigBgNaJIQiNFEk7+srZV
         Y2g8nFuG3NVjFm5XKufcXWEibHw9F+JO9m8oj0wdShc3ZGw2mEPP/YLBfd9UCdj0AdQh
         erkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781171351; x=1781776151;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3i9DKlQbhqJ2Xx9GXVi37yT+grS7XDDKX94F+vmurL8=;
        b=X5OiZRINuB3/57b/8SAEuSU16cSdFrvonR1bYdVyMK+U8KBohvMdhUWSyqMJ2Zv7yE
         OmzxdIe6YXwKEaIJBP9e8EC/eMAZNMAGQvZGbfKpgbwr0GVFG6AcNfEtMVyX9QN0fPJz
         V3OcGVpeaMaKH2FyaqYK3LV/rX8tFf5t55N6V6ZS6g/4IJsZg35ag0adBcvgNKirlGe+
         EDJL9uWrU4z+VDMXHHUBv18WKUlucqr3PpBsCg83ZqOIxGROr7u0Jj91/IXAsZBY0Bbe
         c3zkCcpRASs5rIv0IznxYtP3C+YQW2WtoMBisSxMWu0dm11ydBZ5T9QHmaJDXYokxM+r
         fQPg==
X-Forwarded-Encrypted: i=1; AFNElJ8tcBZbNoTZvfDuTdeBXMlR/z5QqFj0+vvOd8UIda6zFmhZAQoxWvn/B9xEJ3WlGoaxyfZrHF4yE79lj1c=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxza1cwYhg4O7mmjQt97ynlHv4dMdKZy4CLWqvgVYIz00H4Avdc
	2iQKBRPq50yuxqEbP8MPfu9yCGg4eEzCnb9xaS5IAcG1unqIb34PKY21r9Vr5XV0hOV3y0rgVNE
	018Gf0cGC00u3ie3gQ3nUuCM8jhbONR70HEChZl24tnX8MY+6J9PzQit+Vdc1Hcs3y7De2YXDSN
	s=
X-Gm-Gg: Acq92OGyHlG+2kU5YBVUx0s0byhsjuWI4lRbJ8yg4U43TavkFG0JSwEjpRhlwcbiUy/
	RUIyoZj1M8g05eEejd9UP3wlpmw/FQdSvRdkrh/UgjHtCLlBkjQlpNetVw1m0PldB38Ivsm/RVR
	wqeuDtSAeHdmo4ctetdw/x6GLPSYgBIe2proVu1EcPV37cvNwFTots5RUhHIcP+0a0g7czSNDM3
	yfjyhOZOvuqalEln7sNkguE/zNruOHbYv/AlPSxkaeUsqkymdJpPP/1ZfDFRZ1Zu5ZGnTuxa3/i
	yWTJLVlzErjTWUayOCHg2jHX8Lvw2GtageDun85ibcNP5w8rKnLDSPiP0n28teDQqmCrBlQMTQ6
	LYhjAQKbUhgxJkEwovQhKj/UXdA2dQxYdskn8ZBIi5D02rAppBQF0UfQXJXbwPhU=
X-Received: by 2002:a05:6a21:7d04:b0:3b3:bdfd:762c with SMTP id adf61e73a8af0-3b5e3200915mr2484924637.17.1781171351024;
        Thu, 11 Jun 2026 02:49:11 -0700 (PDT)
X-Received: by 2002:a05:6a21:7d04:b0:3b3:bdfd:762c with SMTP id adf61e73a8af0-3b5e3200915mr2484880637.17.1781171350373;
        Thu, 11 Jun 2026 02:49:10 -0700 (PDT)
Received: from [10.92.167.195] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c86585a1cf5sm1354184a12.4.2026.06.11.02.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2026 02:49:09 -0700 (PDT)
Message-ID: <a62345ab-483d-4201-be41-a14f5f44690d@oss.qualcomm.com>
Date: Thu, 11 Jun 2026 15:19:05 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] crypto: qce: Fix CTR-AES for partial block requests
To: Eric Biggers <ebiggers@kernel.org>
Cc: Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Bartosz Golaszewski <brgl@kernel.org>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610-qce_selftest_fix-v1-2-1b0504783a46@oss.qualcomm.com>
 <20260610184610.GC1158828@google.com>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <20260610184610.GC1158828@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: lIWb561t4tx2oDKCrfsqGFtWT9Hcu51U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjExMDA5OCBTYWx0ZWRfX9lokzrX6OEO/
 0QvwcCh403/A0jIB4t98JS5p0RO1Fgm2MTgLeS+d8yLNabAKGde1W6EL6y6zOM+zrI6RwucyWED
 rKgp7bKq7QY+dORvDNN77yCYhbVlRSayZTW/HKe8Upz/w5NQnNDFL8RVdLbHV9h3PmRlmHctZyR
 NgFZz0eKVbB+LLEa/pZcYAnoET46NH5SJk3EFWH537e7BiUcemiQKmWWmZZKS7KTTDX1583NnmN
 cbRnRDmrw690vacuh9BVf2TlV1fN+tYlqn+AKRUeSdL2CKTYRMtpHAdHbdesQk2NBADaqVbjeGC
 860DW/AZWv9DfMwId5v/jsVeWc+h+MzMdsiZbzi+ZAi7MjNgkcS++OVrHSwO6yait13XoxJ0Pdb
 uUT+UDnfOrS8OwQ6KHkhIBov/b3LZu/uj1IPv5pjdSKxJGgFVTV4NAhHhH/gJnz6j0CZOuFQ66J
 +T8UB4WJKSfjdsGnMmg==
X-Proofpoint-GUID: lIWb561t4tx2oDKCrfsqGFtWT9Hcu51U
X-Authority-Analysis: v=2.4 cv=fbydDUQF c=1 sm=1 tr=0 ts=6a2a8497 cx=c_pps
 a=oF/VQ+ItUULfLr/lQ2/icg==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=Um2Pa8k9VHT-vaBCBUpS:22
 a=HjGwlBrXPuM9SlVP364A:9 a=QEXdDO2ut3YA:10 a=3WC7DwWrALyhR5TkjVHa:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjExMDA5OCBTYWx0ZWRfX+PIgQTgmO896
 I4v+BV7bwooJoDunqqDX9WPw0S4p7HCYsYk/vE1xcAr1didxXMYfapF73oWHjz0CAVNUhNCxjBr
 g3n/naEai5gHBTGwSWLQuPma326L+UA=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-11_01,2026-06-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 bulkscore=0 suspectscore=0 spamscore=0 adultscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 malwarescore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606040000
 definitions=main-2606110098

> This fix isn't Cc'ed to stable, so stable kernels will remain vulnerable
> to this bug.
Sure, I'll Cc stable tag in v2 with any other feedback/comments on these
patches.

-- 
Regards
Kuldeep

