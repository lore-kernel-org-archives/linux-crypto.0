Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED293A59BA
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 09:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781689559; cv=none; b=BDmZ+We2KYHw02+Z50EzV5nZStM4fkYxzXAcM87W4JNE+P+X6ZA9KAQCkE3dtEG+AzDAGAL25naxrIloUChvj56MoNJHpijuOfqM6zNWhsFST/WCj3GOwhJaFGtDZYEE5ojiElH4+Ao/UTAqUAjt/f2rbvGdvhdoq9dd/iFV3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781689559; c=relaxed/simple;
	bh=0eRo7lDvmCW7gx4j5qTCHNZE3+C651RdhR1Op86dcnw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K8xWvsJA/l4ErAtmehlhnjnfF6lSBPO3agpBFddyLdT/D+SOxqLkbqLeyxaI2VhEFujKQkAMPbx9k7m7isDXGp/1ysHjuxqwuIbegdwWdkzg1dfrW2TGTZeanMN7dKUeqa0fbXn2h2wp7tLNB13SQB6niDgFHSS8Bi3OAs1CKu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=kbBA9OGt; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=Kwz5ZSbN; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="kbBA9OGt";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="Kwz5ZSbN"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 65H8WAl02058005
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 09:45:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	COQEA4gxr5ZMXmqKWJk+TCvG3sDkrEPKf7iIbRo/t0g=; b=kbBA9OGtgznYgcQh
	nnxgm3uze/+3P83wSJKSmi9/uRQXujx0ffoTZn2Wn3i/BS1pfPDBuRx/fzhHCxg2
	Ghlqw8nKVfvOac0fYkO9FN2XaIz00WL1jvIosVTKHcJ2hjPCqxo+DX/b+wGJ6IvD
	qrujl7BQ9zG+pqrf+/C/+9Ky73A43lxia8BP5NfJ1zor3vLnXJ5vqN4qSsONHbEh
	v3aJgOGLA6O8B5CCZ5TpGCsS2LTp0W8n1oGquIz/rLJ/VY1qTVCG8QrICDZLyyFQ
	SHyhLLUPaxiZZcZxNkWS4Q7QzvoRMzIgWgdsSR11+mqQfuMKlzMzzyD62rJJ7yZK
	mkAd9g==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4eueesagfh-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 09:45:57 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-36e09ec696aso8955067a91.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Jun 2026 02:45:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1781689557; x=1782294357; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=COQEA4gxr5ZMXmqKWJk+TCvG3sDkrEPKf7iIbRo/t0g=;
        b=Kwz5ZSbNtrYb1YoEetdP7wBTB1nAS+iRn2XdTOWGmxh4NqEex9OpoA3y2Fbm6G4VQB
         /y2M2DxE8Y7VGof5O/yPODX4sEB6+7dOl+8BOMCYdpCWUCOxDWoOjKTh6Su3ctDME9U+
         ynyyxOmN6tc6FBne++ud/sUc87SZMqh1Ktswajxmb0jR8GKpHEijHnGWx31OuhUtdZRQ
         hl6zqD1Mwsb2EQTcQ9BgWGALx0pLvGqY666JaoemFB7NzHsguCygMS6WePSXjcnh8B0f
         7i9VhdllrZB/K8MvL8CDJ42afFEMD1aSpr7oXAUFDHKoenZMwFlgRmkUU5375wkVbdWF
         Bopw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781689557; x=1782294357;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=COQEA4gxr5ZMXmqKWJk+TCvG3sDkrEPKf7iIbRo/t0g=;
        b=TUgFmKeABSXlVYCyU4AdyfnH9/jpqsNH7Pjhhm6rXfke923Zq+7/XVlMOKYFyvoxLu
         MPY6gxQ7gmKp086zJCi5MR4UaaxjHll+/r+SGoxah9OAsjgV904Q8Lq/w/qh72NYZvte
         8YU/WVS1Rqkq69yEbPIEJehCXB3tfURnwmIkKad3RrkXLi2gE5wkc0zb7rgjA3Gea9Ot
         RzD5vN/5ncMESW0KuuNA04Aemyh6c7ZIa5G0mx7OjXqxvgQ8wjrd4VAnOlLRpSaTyqWH
         hJ9pw3gUbJ/7Szldb6TatH8AgHkKhbYhDBCiM+lsVBm/ehUU/LY1dd62V2D90ezkL8ib
         tTHw==
X-Forwarded-Encrypted: i=1; AFNElJ9IbQ7hGdaLTsE3t4l8m7NqKNmibrgXoL74AbKRAVbhbe7l5jN26d+0V0YEgmq4CbZheJ89Xj9fFAPdNtw=@vger.kernel.org
X-Gm-Message-State: AOJu0YzZx6bm+FeXOfQHDQcm9sCngU+5jcxbxzEDimvqcUP6YbunHsM9
	E6U60OwQOjMhxjYUyCkBcmlcuEjNHgbk+4Ad1/3v5GopHLWUnXF0cF5WrEPmeB3L2G01KPVe938
	dsHS8pE6heSv2A5rB4W/E2KKvMVKBN5vJQdlyRKVswscSLXFzqDR5sGGAPTs4jc5OKa4=
X-Gm-Gg: AfdE7clPA0Xi5IkyRvuhH0Rr0Q56lmlcV42ZSbU/3cRgo+GRQ1bWtMhKaKm485dkaJl
	edhtxfdjTioMi+GQ14ifDd+758k7W/0i0V9T+McZbe5gfozBHbtfLk9i6nfQOG3fQWyFpyZq8KL
	ZF2ngXXXgmfKcP+EznjbyyIb6kG5SUPT1ZdXD1lN/YkJiqCq2q+AKIkWLcaubVghE6Q2NaO5iXi
	kowripj9RKkivbpJPL+rDk7Le3+bscV7ode9CjQsafn+M1fI7Y7hdMWukCYcKdi5cMlI+9MdOlU
	ZEMj21Voh6y6N4GHPcJhfSd+R9ChIMZSSb0fup1bZyPxgf0PN2ErxV2GjNHrOrCHzoMt5FStT2F
	tcx0O/+zVyZusCz5USTFLinP6SqoABGK/Yl7/xxi58cI=
X-Received: by 2002:a17:90b:38ca:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-37c936a2631mr3149681a91.1.1781689556832;
        Wed, 17 Jun 2026 02:45:56 -0700 (PDT)
X-Received: by 2002:a17:90b:38ca:b0:36d:b424:4f17 with SMTP id 98e67ed59e1d1-37c936a2631mr3149648a91.1.1781689556422;
        Wed, 17 Jun 2026 02:45:56 -0700 (PDT)
Received: from [10.217.223.142] ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c522a3d53sm5626666a91.15.2026.06.17.02.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 02:45:55 -0700 (PDT)
Message-ID: <ce7ddb59-d219-4684-a56f-35ce4c3c345b@oss.qualcomm.com>
Date: Wed, 17 Jun 2026 15:15:51 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fix Qualcomm Crypto engine self tests failures
To: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Cc: Eric Biggers <ebiggers@kernel.org>, Bartosz Golaszewski
 <brgl@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thara Gopinath <thara.gopinath@linaro.org>,
        linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20260610-qce_selftest_fix-v1-0-1b0504783a46@oss.qualcomm.com>
 <20260610184205.GB1158828@google.com>
 <1abc518e-e24e-44ff-9b15-1766dcecd8a2@oss.qualcomm.com>
 <4fzeulsheu5tam6pcymjqkqnqi3ibjgwchiefy27wr7b5i2yhk@4m47fpfbsmwf>
Content-Language: en-US
From: Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>
In-Reply-To: <4fzeulsheu5tam6pcymjqkqnqi3ibjgwchiefy27wr7b5i2yhk@4m47fpfbsmwf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwNjE3MDA5MCBTYWx0ZWRfXxk30DrljPY4Q
 ZcfsbBP3XN0dS5PjrCE0DA/iBVxt3Ym2aY34owySbbvmUCUaDSgj6WTU0RKQCLXOoDBHuzQ8VS4
 QHg4zIUuQ4Myl7u1rE3GKQHYLLdXIDs=
X-Proofpoint-ORIG-GUID: ae_YsxBNaOKYWejAni92NP7XUqpm0Noh
X-Authority-Analysis: v=2.4 cv=R6oz39RX c=1 sm=1 tr=0 ts=6a326cd5 cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=eESiKCN2Xvo0jsfTh0cA:9 a=QEXdDO2ut3YA:10
 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-GUID: ae_YsxBNaOKYWejAni92NP7XUqpm0Noh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjE3MDA5MCBTYWx0ZWRfXyIyYVjGsKQba
 15dYeG1pvIyQ7Y8odBrch7JW+h0XTYYbzQ08mJNUPSs3ET3aKupPKW7ZpzcDLo/alwx7ubVYER0
 Qax4TgWi8x+B2UFwbWQsp43ZmkV0kEHghTaOL2GI00CJhM9RpFY7kv73crL/ri9fc+uYQmXRUjT
 yZ5EXeEkJTjyHHURs8U8ZCyWxrMmWOKcaSHv1+/vFg2zE7sNwAmKaONZ+4D0kXxr/hDiYjX3jBK
 0y8H6Qk5hviZEQAe58O46Tp10x0XIdN+6vkn/QXx4l5eiYiDkLkkv3gXtvg3CONwwnz4gPtrdCM
 W+PnhqEnss60ERx3KTXNi4Ltqty19aiveRwP8lhY2VQef7yhNAxDJBm9XA3zRgmMLbilivxv9zd
 pPEspypU1ZoHIJ8eEQN2JE0UzYgNh3CjhBVVeQNASBUk1kGVnuuAg+iH2d2uPgJ/dYa74rkRHRB
 T7q/aOzJrHYRduwdZ6Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-17_01,2026-06-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 clxscore=1015 impostorscore=0 phishscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2606170090

>> Seems Bartosz will be sending patches for algorithm removal changes.
>> The rest relevant selftests issues we'll fix accordingly.
> 
> So, the old kernels will remain broken? Or do we expect to backport the
> cipher removal patches too?

Kindly see Barotsz series on top of this one[1].
Fixes will be backported on older kernels too.

[1]
https://lore.kernel.org/linux-arm-msm/20260615-qce-fix-self-tests-v2-0-dc911f1aad42@oss.qualcomm.com/

-- 
Regards
Kuldeep
