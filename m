Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048064A33E1
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 15:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788361451; cv=none; b=Tv847dVwIdnsL26Dfkdu3APnOyB1E1IYrX4YUZ5p9G0Rl+HzgBDBNZp56iYh2M/wrJfghB0WW03BnzD0WnQdy2L/Aq030HtpX82uwbnPVbNborR/w+K7Cm5sVHlZNLd57NvSBZTBdIivLim0+Lo9GAUn18Owy7wPXUjMLzCJ1js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788361451; c=relaxed/simple;
	bh=wCCHaHjAyebRsmsmEX2icSW1s+oMksjOOy7EFoGCWjw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g9n7uIqM/4Jf8EmlvTXCVDgo/wczOhdTT3m4jwnfWtvXW7WGSySVtdDwQg10fv0yp85hANBeHwiMJ1AwbWAO1/sNVTNhtk7BDf8+cDP72eOemmbOBoqXUeJ7gboZ8mnfE0w/5WVihmZjFH9vJxnoAbuGdT2TmyexW1QZbViZ/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Gslt+rWg; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=eFTrziXi; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Gslt+rWg";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="eFTrziXi"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 682DH9n01046501
	for <linux-crypto@vger.kernel.org>; Wed, 2 Sep 2026 15:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=; b=Gslt+rWgaEkn8Wtt
	/GY4xVCimRHa2DbrI8POvL6E7qeLQdytf4vC+D7M9SyKb63Zk/egQ/aHObhm5XSu
	34V9wJoSKIIdXswfhBcglWSNWtlppU0yMF0W8bzoiG+2wlczpOXtKelwdMeoD7kG
	d2XmgIofGoxkaz/bwRWU2k0qB2J8ejlZxWBqPkI9Ixy6ZmNh3yRWAZ43JOXZ+/Hn
	ORx3Onu4LCsoqeCGG3G6B246sbXK2ZAX9tO4Ur3C7Qn/lcj48kj66sch0Cd5xSB0
	JlKyaBGQHkbbv7QF0r0IxAZU9Hy5IWzu3aVlynpWBl4F4bzz+a15q0OtyyAOOMPc
	y+04jA==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gemj4rdfg-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 15:04:08 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1662182a91.3
        for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 08:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788361448; x=1788966248; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=;
        b=eFTrziXi3Lluc9XUB+MReoZbYQTEm4pDzXfbXQlpZly6DRQ0p9QjNwKa9fq9J8vapQ
         yH1wrzWjVUheLnprhKlVQFoAtVGnxy4cbw80LsYjGv0ZOS897Qoi6vJ25seQl9yuBJqU
         zb479x3Q9CsGOl+DbYmIWMfQbjqZ6SL/yA+aURBAih1B3y+XUH/gns9W8KlkI2EzrHtb
         LagNjp8QAL5V4j/3fGzHFHFc+7mh7hcYH3p/4fLqebWvHFAKNoAhh1TR81LTtEAJMhPl
         0Ys0zxCOIpj2qenXBS0p5YzE76r0hSL6Q27E04V42c9Cdyl7SnHdRgxfD8LLutUOmY2T
         XxbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788361448; x=1788966248;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8d/HYLVaYKgSu6VLD4TUXAuT+WMimsoAlFLEDX6rbHM=;
        b=Im3+ixZVzgv8Ef/m+v8+QgO9GaRIuTi3X2h1GPzgLw6d1fYN3GVMF4CTmGExEXx4Tm
         NYak2YyQLwEVo+3LVvjr2EA48k4smzl6ptRE5o/D0gqcbQSdweSg1PpPqixpx3Xge8qA
         3yrnWpTN0uYdW6ztqnAOy8VBDW9caN92ePFx5X0FLwhD2pArj5IgvGTkyIxL7XQCUelD
         31sPk4wnUNsHCeXZNu3H6pst5Vm6qiiYlXEKlTuDSrOKJs337H6O9b3WYsZwvB6/Wthd
         v+AHkdS3BoXEYQx8EdiwUQByemKq0bg1bn3yDk0uDNymY9ISgKKBDezHWpXC01cwPxMS
         IXvw==
X-Forwarded-Encrypted: i=1; AKwUvBxG09vxaD63m8FdJZ84hVER4TJvQ0gKIDUoD0blprOvQSzKUJmp8KaaaEkWelPsfr2taLdaleaWorlwcnA=@vger.kernel.org
X-Gm-Message-State: AFuF++mUWvvCszKl0mNrNLx9khL4B9WdFSewzPyU8M44Zr8YpXpxXOmZ
	7Fe/EebVzroVYD25rgle3iOzAoS2OJ3SS/BXUIAJqn62qKXhqH+Sh+r5uOFWSjIHjJX36bjDeDn
	qUG+WJIy2nGFQ9gx7RS6mgNVDlGiAurj+ikFRQntLxo4vd+ZqwWP8TSlq+9SZDriZ1RA=
X-Gm-Gg: AYBFou33RslFj/vNT3+n1IPNjqhw2PvEC0MptBmzh+B/vOpYyyitWHzhDedw+Sar1UL
	UOFHUiWs46I/X1xU36A3DXwJke/yxuQfWh6gv97qK3QiIpGbpd+Wh+ffslSyEdZ4wmu++yKwFUX
	0/spk4ExcKWvF34PgtZVVseM0ky9CtX4Bn0N0qABOVeYXRyeeutiU4LDKd4F6MqXrmt0fQJxGU2
	kHHKnE5KGWGHAXGd/4jieQ/C+68uwjFM+tZIS/LEw0ZIwPOizgCCyUkAs2NPdShMKBo4MjgFbga
	2nydNbFr9sL5gx7zPrjz6hBS+pexdYHkwPk+qiyzBsCSSt5nfwFm0niyTut8FHYbrZbcmCTsHcU
	C5CogbBESJ5BT7FH8n+0s9p15cvgUqi/061BFoa6BJ9YstYb1CZxOp3inZw==
X-Received: by 2002:a17:90b:2ccd:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-39aedf77333mr8400156a91.11.1788361446270;
        Wed, 02 Sep 2026 08:04:06 -0700 (PDT)
X-Received: by 2002:a17:90b:2ccd:b0:38e:5c6:4db9 with SMTP id 98e67ed59e1d1-39aedf77333mr8399969a91.11.1788361445459;
        Wed, 02 Sep 2026 08:04:05 -0700 (PDT)
Received: from [10.110.114.54] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079f1f4fsm7552713eec.11.2026.09.02.08.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2026 08:04:05 -0700 (PDT)
Message-ID: <d530f962-4fd0-4897-8022-c7335167f450@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 23:03:57 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 11/11] scsi: ufs: ufs-qcom: support ICE keyslot
 partitioning for guest VMs
To: Krzysztof Kozlowski <krzk@kernel.org>, ebiggers@kernel.org,
        axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org
Cc: neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        stefanha@redhat.com, pbonzini@redhat.com, eperezma@redhat.com,
        xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-12-linlin.zhang@oss.qualcomm.com>
 <046e4b62-6d25-40fc-baa3-2978eb96eb70@kernel.org>
 <b571ea8a-4434-45e0-958f-20b2f83ced24@oss.qualcomm.com>
 <ff869d8a-85d1-4148-b19d-af3a70fcc904@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <ff869d8a-85d1-4148-b19d-af3a70fcc904@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDEzMyBTYWx0ZWRfX97Mj/6JUMjZ5
 rJqfBvbPndxTtQ3mj72yzMJhdz/aElvd9hRxmSawI6g0y3nnFnmJs5LzZu4QYs6FcikfEzHP0P7
 1j+k4hfzxDsJ0EQ8lg/SJS5wPI5OeBtTd0MvVsm+5CpZwCqBfFTZFWBNVUmNZdVP2A+yJQTI1dX
 UN5EjaVaNY6PqmMkKOJWNtR1aVBri+9LGZEiFuxTVfRsb9antpRZano/t5oHzGEriJ1aZtaN+oi
 jJ4OzjKimsfhRgIV328tbbM38ayYV5Y8ys1YgREGgD5LAKE09CH6vwrMldrKXaTfe/NMnpWYRcr
 6SwgrkVXm/HbgTJHMClPON8U0y7PQ+BCM7iKdAbR6FI2qQHLV+uzcQjm8dbFcVj3eetlHylUeOI
 tGO4owgImtV2hLjHp94EZTr+jG7EQFVG+QzJZkz0Df4kT84M4PG37xM9FXCZPDA2hH9w241aZ4v
 anSZ0j7QTh9HdvLL7OQ==
X-Proofpoint-ORIG-GUID: otNC5rztY4CgyCxrzlAoIfKTzLT8z7V0
X-Authority-Analysis: v=2.4 cv=MdhcfZ/f c=1 sm=1 tr=0 ts=6a983ae8 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=Vihkso_W4dyqxCYGQKUA:9 a=QEXdDO2ut3YA:10 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-GUID: otNC5rztY4CgyCxrzlAoIfKTzLT8z7V0
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDEzMyBTYWx0ZWRfX9bnQtdJLzpRo
 u3Bq6+KpbfahERGiq/JiUNlUr4lrvHt+qVRSOLCmymEmDugbtL036SMrF0KRvmlLpvW4ljTIrSf
 q35oDPeLtG48YYzlMjmngCt4Jg6TGig=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-02_03,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0
 phishscore=0 clxscore=1015 spamscore=0 lowpriorityscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020133



On 9/1/2026 10:02 PM, Krzysztof Kozlowski wrote:
> On 01/09/2026 12:54, Linlin Zhang wrote:
>>>> +		u32 off, max;
>>>> +
>>>> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
>>>> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))
>>>
>>> No, there is no such ABI.
>>>
>>
>> ACK
>>
>> This is submitted for visibility. It may be revised in a future version to use
>> a TZ SCM query interface if current out-of-band key operation in the guest is
>> approved.
> 
> Don't submit downstream code for visibility. It just clutters review and
> wastes our time.
> 

ACK, thanks for pointing that out.

> Such code IS NOT ACCEPTED to upstream, thus posting it is absolutely
> pointless.
> 
> Best regards,
> Krzysztof

