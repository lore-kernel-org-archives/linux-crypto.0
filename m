Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952F9376A05
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 10:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788260095; cv=none; b=EdGJ95TyNC97F88GWR+BCs+fWMlrRhR6FTnmFoZzwjbT+TnXBjWQiZOer3hvBlNQ7oP9D4mnv/HHndMym8V6PIc+pLanx+Dsps1IU3RXMvx1QMjMj5N8VUAPhGxaex3GjMDCp/zEdfdA9Pa9vwM480uP3haAM+Y1It4wIQfiGSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788260095; c=relaxed/simple;
	bh=eo41WihyA3ojxp0NLE3JaISxqefjtiIrGimbXZifWtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dNV3irXolXjDmcaFHdDcQviGowPpN8oJbbVLK4+CUbk62L/ijbp6FTGwvFprEaYLv8FGpYSGjarey17kY8jAozU+0qPdX14DGmyigHvR/mHdp+WpXhmAE1u4dNkpKe7sqlIYz0PoElJXjcP7EvI7bTX9ewyawxOcsSS9nFZx8WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=UqJ0Goxn; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RB4SYQ+p; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="UqJ0Goxn";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RB4SYQ+p"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJTc31137300
	for <linux-crypto@vger.kernel.org>; Tue, 1 Sep 2026 10:54:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	OPtv8ii2wGrHphSvsH0bCWdT13ol9RcJ1O+uWSnFADo=; b=UqJ0GoxnCQ4Csd1v
	wKkffNP5ImAKrzb4gvgZDMzVLBhu8gm+M6RLcMlx/t65dwplHNQAakzHjAyY6Mo6
	YgVAbK8ywJvsJectDmn3yv2MR1y/xk/b2wXbFI5tnbtCm8fGRO/gdETgRlTeR+th
	KiBijkBVFxkEKSkVBZbCB2Ybwi5rqXWrEByQTrjjPuLO0byhSPSUU0g9C6MoeYG8
	4enK9+sCKsNbE4VyggZza0RBduwyopJtPIdAQFRCzEq9nIqI2jUJD5+TyXGbXoU3
	gAlTXV9uVErdTR+hSToJ6TsFvKEgzmh0uDDJ6ZU9XHOnCXalBzgTq4AOm49WOLgr
	QVSMxA==
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdrcshfrb-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 10:54:51 +0000 (GMT)
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2d7151120d6so23837275ad.3
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 03:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788260091; x=1788864891; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OPtv8ii2wGrHphSvsH0bCWdT13ol9RcJ1O+uWSnFADo=;
        b=RB4SYQ+p2mg5q1Gh9bLE1rUC3diLzIXoo3D6/AxVJ/2Kg/uE8VQuvOMYIFsLl7Ojtt
         yUdnWz6KKoV1knAqCs9mdH8kU/IbaK6/wwKF7STTHIhb8LOrSV2hd0QaMo/T0OAT+frv
         ty3pH6forX/HgcWRuMCuaTns4h16gQDhA2TK4+iBJgB+7Ct6ne0qJSsCTa2wJGjUfCpe
         FHkEC1Pcx5LOqILfLlkV4Eb+AlpWwlsP42EO3svgi+8yIhr16soL8SxgRiaXv1GZ69rf
         0jfVWX4vwI7P288dLzp+SuikexulYrH132zdrl/sUEXIB0uJLBiVkyn3XB2Fa5y4J5W9
         Y5aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788260091; x=1788864891;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OPtv8ii2wGrHphSvsH0bCWdT13ol9RcJ1O+uWSnFADo=;
        b=JbTNdX1WArNRrcrAPibst3wVQbY4JDxU6ejydZwpcrpxCdOIolMhtvxK00Zp+T9Tca
         cxDoO3ZRr9yBF0nUJhKoGovzYPEJQZi4oCpEYjbin76LKAT9sfY/bcjTHRi00MLF3/Wv
         6QK5E/+FAUjid8l+V3Q79lu5Rr68Z68glG1Uy+fQuR0ZxnNCJY+G+HTaf49Ks05Pu7iF
         COjdW2X90e9GCvtvjkSy5JbpakDU6j5U7Jfi7znKrh1l2n3ThkX7/twwjesaRm5duBTr
         kxw2PdkGvuLaTB5B+1/ZsAs94P02tzTy1ggXqtEcAWYvNL284+7UTS+KKGhUY0mAryQt
         RoLw==
X-Forwarded-Encrypted: i=1; AKwUvByyrVWxzvOPl1xA9omLV886RK92Wfw7pBb7IBKMd/p/lW77edftQtesQZO64LI3723GZkmf43lnnnQWuJQ=@vger.kernel.org
X-Gm-Message-State: AFuF++mJx56LmKtpzfYnf+8TbmAEB3T5SHan3A+jPVsV1iWGRNsMuzTe
	cWKnBS8apPpL7uFPrCpitUjrWddLnZaHRs0JSRqJE0UbnpF2tjE6MZISXlWU1h4sWzz9HRmJQZo
	zhsOyQo1JRG1fOQXPrtgk4Dra+MZTKEpD/jWPge846W3JAya0ASRQpK95lf685ljaEeE=
X-Gm-Gg: AYBFou32XrYvMmk4OQw2GHA0dP2wNC+V3FzHHF8GIFcZFhGfGeV5kz0QzbAl+UdmVTq
	RQH85TmQzyUMeLbWbiQ9H3gL902JwBf2dVuGb4La8uq6Eo6kZZ/D/SO0LYNzHYQo22899y2iqKa
	BgqzV9evPxY4IxFYNVBr+W72f6yFef3yM/AOOjd+oGsjK27wXrPX3sIQ+Kt7Zv0EuvkiMkoVYce
	Mtvtw9f8urhVC/IAZn8spHn1wRryBVPDSZ424v4XjhnKlr3hoRhLiUkTSwYgBcpTCPHZyqtIFdV
	uPiDyYAblYIr8UGXF3woiDAfblcFtns/qZVfNXZ9g0xYRDWaEPDZVlfrUwlTxKP9u59s84ZFpB4
	uAzIBemYD3rS4evQpT7c6VNM4ggc5P8wvqp6aLV2qrRSDE5GlOCMcU9VO
X-Received: by 2002:a17:902:ce8e:b0:2d7:107c:917b with SMTP id d9443c01a7336-2d94a32e0c0mr87827115ad.0.1788260090778;
        Tue, 01 Sep 2026 03:54:50 -0700 (PDT)
X-Received: by 2002:a17:902:ce8e:b0:2d7:107c:917b with SMTP id d9443c01a7336-2d94a32e0c0mr87826565ad.0.1788260090392;
        Tue, 01 Sep 2026 03:54:50 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32bdfd03e71sm20231849eec.1.2026.09.01.03.54.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 03:54:49 -0700 (PDT)
Message-ID: <b571ea8a-4434-45e0-958f-20b2f83ced24@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 18:54:41 +0800
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
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <046e4b62-6d25-40fc-baa3-2978eb96eb70@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX85rXgoxLPmHI
 algyvkNeff0FdyQ18cpzawkW8OntJQkdIIFPba8TuQFGMklVhUz+0TT0jznhFH1nrh5MZOwt4Lu
 QGya489FO1C/ZB4sb3hTYn+CfEdvjrw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX3qxVkrIA8Hhu
 E9XwuJc2Ki8wQgiW1+h4DBPow6TEt6nKkc7o/lLfIpmqIVOTyNQTVmbiD5k2GNHIho6+Gtqb0bl
 kIiconYDkMT9g4l2Ad/qZqhkrdVZTThfmfNFnVwQmw7huL/225U4nbqn0Jmwgcg1IW4k16IbwlQ
 9+UWs2IlMMb3kmj5OZ5tBSq+nzWlcEbnaGIt1wPluaPzrYLh/F+xVUlMo00ZGdtGAm0jCINMS4G
 W3tv6SDYAl8TUpaRZR6uXqG+5ryPRfSO6rXEQwLHzFaGfjd5lRMS9Y6qq80s+e801+CEPmLgLB4
 G6MiUCwjuIqqzvXD7cHDLs2aISO8kFVzirDIJxiCFp9YBio4Wrnp/p7mE374PvW5chzYiGw17Ke
 nN+JeVb0aacajd8KPnbaZvwWPht24KBnkpIOAzJEsFvhXa7sMRqkhsfvuvtz2dMAANdXp5btnwy
 fAlZpaL4Gtbc7j3hheQ==
X-Proofpoint-GUID: JtqSiyvoAugLcIUX_jmQ_7HTAqWB4SWs
X-Proofpoint-ORIG-GUID: JtqSiyvoAugLcIUX_jmQ_7HTAqWB4SWs
X-Authority-Analysis: v=2.4 cv=QsNuG1yd c=1 sm=1 tr=0 ts=6a96aefb cx=c_pps
 a=cmESyDAEBpBGqyK7t0alAg==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22
 a=EUspDBNiAAAA:8 a=0jl50ytlWdhOsGfDH1oA:9 a=QEXdDO2ut3YA:10
 a=1OuFwYUASf3TG4hYMiVC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 spamscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2609010095



On 8/31/2026 3:03 PM, Krzysztof Kozlowski wrote:
> On 27/08/2026 18:07, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> On Qualcomm platforms where UFS inline encryption is shared between
>> the host and guest VMs, the ICE hardware keyslots must be partitioned
>> so that each VM operates only within its own physical slot range.
>> Without this, the host's blk_crypto_profile would manage all hardware
>> slots, conflicting with slots already allocated to guests.
>>
>> Add ufs_qcom_ice_parse_slot_table() to read the qcom,ice-keyslot-map
>> device-tree node.  The function parses all child entries and validates
>> that no entry's slot range or the combined total exceeds the hardware
>> slot count from REG_UFS_CCAP.  The first child entry is taken as the
>> host's own reservation; its slot count and offset are returned to the
>> caller.
>>
>> In ufs_qcom_ice_init(), use the parsed host reservation to initialize
>> the blk_crypto_profile with only the host's slot count rather than the
>> full hardware range.  Set profile->slot_offset so that
>> blk_crypto_keyslot_index() returns the correct physical ICE slot
>> number when programming hardware.  If no qcom,ice-keyslot-map node is
>> present, the existing behaviour (profile manages all slots) is
>> preserved.
>>
>> Note: This patch is submitted for visibility. The ufs-qcom driver
>> gets its max_slots and slot_offset based on the the current
>> DT-based keyslot mechanis. we are aware this may need to be replaced
>> by a TZ SCM interface, submit it RFC for design discussion.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/ufs/host/ufs-qcom.c | 91 ++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 90 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
>> index 62396212a0a7..0611ab50f4cc 100644
>> --- a/drivers/ufs/host/ufs-qcom.c
>> +++ b/drivers/ufs/host/ufs-qcom.c
>> @@ -163,6 +163,74 @@ static inline void ufs_qcom_ice_enable(struct ufs_qcom_host *host)
>>  		qcom_ice_enable(host->ice);
>>  }
>>  
>> +/**
>> + * ufs_qcom_ice_parse_slot_table() - parse qcom,ice-keyslot-map DT node
>> + * @dev:          UFS controller device
>> + * @hw_max_slots: total physical ICE keyslots reported by REG_UFS_CCAP
>> + * @num_slots:    receives host max_ice_slots (0 = no partitioning)
>> + * @slot_offset:  receives host ice-slot-offset
>> + *
>> + * Parses the qcom,ice-keyslot-map device-tree node.  The first child entry
>> + * is the host's own reservation; subsequent children are guest reservations.
>> + * Validates that no entry's range exceeds @hw_max_slots and that the sum of
>> + * all entries does not exceed @hw_max_slots.
>> + *
>> + * If no qcom,ice-keyslot-map phandle is present, sets @num_slots to 0 and
>> + * returns 0.  Returns -EINVAL if any entry or the total exceeds @hw_max_slots.
>> + */
>> +static int ufs_qcom_ice_parse_slot_table(struct device *dev,
>> +					 unsigned int hw_max_slots,
>> +					 unsigned int *num_slots,
>> +					 unsigned int *slot_offset)
>> +{
>> +	struct device_node *slots_np, *child;
>> +	unsigned int total_slots = 0;
>> +	bool first = true;
>> +	int ret = 0;
>> +
>> +	*num_slots   = 0;
>> +	*slot_offset = 0;
>> +
>> +	slots_np = of_parse_phandle(dev->of_node, "qcom,ice-keyslot-map", 0);
> 
> No
> 
>> +	if (!slots_np)
>> +		return 0;
>> +
>> +	for_each_child_of_node(slots_np, child) {
>> +		u32 off, max;
>> +
>> +		if (of_property_read_u32(child, "qcom,ice-slot-offset", &off) ||
>> +		    of_property_read_u32(child, "qcom,max-ice-slots", &max))
> 
> No, there is no such ABI.
> 

ACK

This is submitted for visibility. It may be revised in a future version to use
a TZ SCM query interface if current out-of-band key operation in the guest is
approved.

> 
> Best regards,
> Krzysztof

