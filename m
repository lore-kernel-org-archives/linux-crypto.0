Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=205.220.168.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794571868;
	b=OpIA/khytH2bSAL1ZqyXIM+PGS5aT1o9lOepPaxlVbLG309DL1HdNlqXYta+lYDFI/Cv
	 h0LapVdIcg7/k6jQnWzZKAvcgSOsdfcR/SQQWZcNMezAq8Zpek8Ykph04zlQbUppTwhVu
	 0+rpWIDcjkroV5WtFgeMvNmrvALIfi92O9T5lnfgalUpWaw6+SM0ee2GGYoWLIAO+jKe9
	 cQ5K/AJ3WPIR1HUAOhTnuGw4zYdWzpUDRvUhC50oZAkXztFl6yp3V2ODNPI1gGsBy3gmH
	 0kQE0cqGV+5GZsLFaFIdzI/9YPdLOz6HWCHe3NqIgNm0JjvcTRCUZGDv/bVkve2BdGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794571868;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Received:
	 DKIM-Signature:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:X-Proofpoint-GUID:X-Proofpoint-Spam-Info:
	 X-Proofpoint-Spam-Details-Enc:X-Proofpoint-ORIG-GUID:
	 X-Authority-Analysis:X-Proofpoint-Virus-Version:
	 X-Proofpoint-Spam-Details;
	bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
	b=OtPBIpoYN7AQl4OUk/K5UmVWJXW+6Ko4816IPMrDWCmulTfL0/rhZVldXQS1J87daQik
	 qg6CzB1eUzTnnsO7W35uq9QNQgMX2ND4ijL0y9yMqvIG22LMUZD7g3F6rO6GQ2TK1bDco
	 x3IOVeJk6O5dK0g41T3Hpc/tO9lQQdWqVU9A/BtdxaGB7Ai0OxFPU/fQwonL+GSieQPyx
	 tfM4l4RLR7F7rFi7ODyrzaGbWAFjyrbwg6QLp/1jVyL5fNlFUVv2jwJvW+H/UNtxazmVe
	 Ji60HR/4fHYoGH7kEYuRAVao+3wgiapH552RwzQ5jx6lzyPiBMINvHH1LkDHCWqvAfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=oss.qualcomm.com;
	spf=pass smtp.mailfrom=oss.qualcomm.com;
	dkim=pass header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEFiQ7Cg;
	dkim=pass header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b="gmBZxwg/";
	arc=none smtp.remote-ip=205.220.168.131
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081D606A337
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 12:11:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7081D606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.a=rsa-sha256 header.s=qcppdkim1 header.b=TEFiQ7Cg;
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.a=rsa-sha256 header.s=google header.b=gmBZxwg/
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6ADC0ZjK4173885
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 12:11:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=; b=TEFiQ7CgOeSRnQW/
	Se5AoZ7dU6cjjcaKCcUCdHvC6glfYOpUgtIi46FqA8lPXUVJgojFjfTr5Twfu4Mp
	CQbbN6g6pHf3PwdXgHahKEHyyYCJvFy3uK1ZrPlHyfhXCDZPXP7l2zI3/X6YRhr9
	P4cuWfILX/CScAZSIlXC+90djbPnxUYlMfurTNDWM2n9N5nRSr3Zm+vlX3pnFWhZ
	As8+Ov7kfmMtzFJB0joQo73uFu88E+LeiTT/JhxBaznhr2QHYE+waIvCpoMzvaU1
	mUm3VHg+zCXtMTkhyvJzq0nOEheAZ9Jegsrr/fM1r+Ndg83P6CJP2LKdzamirrDX
	+ZsSTg==
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com [209.85.221.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4hwvja9971-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 12:11:07 +0000 (GMT)
Received: by mail-vk1-f199.google.com with SMTP id 71dfb90a1353d-5edc82ecc78so47369e0c.3
        for <linux-crypto@vger.kernel.org>; Fri, 13 Nov 2026 04:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1794571862; x=1795176662; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
        b=gmBZxwg/XbqtrqP2oY5LPz0tR+Xlsf3EK8DvNSJ1rLx9AofPyhzm2VQVvXVe4JZBqx
         OxgSJOVwbJ0o5JaQMKSlltQMxvdvq4J/n21qNljvslQMWk621bEdPn8ttOu+Lbe3UH7d
         +3xKZVHZ/L43kTKUZJ2vU/LUqd+LJrcYZ+SxgNovrNfnrwkRs3rK4WZG2ml2tSK5p+iq
         iecQvJEjCJPeJ+s9iggi4m4wOyMTontB8DhfUyM5I9auPFyujfzSGzZEMHi2FujjyKVi
         VR5uXP6/MOfEY/p8Twe3ZB/IMLUoBomk0ofKmSVtF3tp5YjlI/roFhNUgEOHp0CHwICf
         Sd8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794571862; x=1795176662;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/NqXXavtqWESRvkrCUGDpDtfe0DY5TPqAKh7ZVcfS7g=;
        b=hLJj7uLIew47f3jfGk11N6GAffbrznl05qbdosgAX9tXWLL6AzrnG0pFV1oCstZEeo
         BJdahp3dAoSj+yFudajXLINJvTLQ0t/xb5LYlH2O4AFh1ED/mftLmhZPmmRN9vic16Rm
         /NHYbwP+jLBp0wDNlJxpZJ5BOWrkjUnhyBFudJtjrJtYnDWtRFNDIlU01HcidWYnMRy9
         hCcI3+IJIziu4h+OC2uy763Qm1MhIMCVEIiNWzrsXGG9hnREmqP6V8EEgli15WBh6SIK
         CkqIbpYR0/IqcSXmqo6Ih1ndmQjIivYiihit0gzEmESpaTvM9WhGJkoybB0YCw3RCUUt
         TPyw==
X-Forwarded-Encrypted: i=1; AL+hErFBA6q9Szn9IxBbh8F1fLkb6dxOqL1foDU+KnImSphR+bdkhN2HaIrSY8QBVYK3uk7GeMYdd70NkFW0C3A=@vger.kernel.org
X-Gm-Message-State: APuU4Z/oqAUYcoer76oklgeA/DJGp4Jzd+sBpD9FjwB7onp2myBLsQro
	WhxRtp2mRHu20L/LCUTrxzNlbJXodp4bbzD7uB7zLTdBa1Fn13sYWyDrqDH/6dM26HbbjcJSijM
	VO63t+ytsxwGZxYGnmYsp55vVOZiZv5PgYXGVZrR5XHenqnQtAG9xdu8pPg1xpy5+bCQ=
X-Gm-Gg: AYBFou1szN0z5jQOkay0OFaz2PDTOPL9QoumZX6a0RFw3KXSqVOzq+2fN3PSrpB4ese
	ssL9WzEPXNGCwyFU4PNY10jvEMqFBuBWzcG/YobpYlPY0s+e5egKP1Vc8xVJBdVEf9KaNRHkDRN
	cevM+19BbuH9Wrjq3eBRl81mNCcxdozkKHi6ndDi/X4Z4Sg5b/e4YWOXk9dBiZ4u8sg9bE9cHmY
	RR7Rwm2y6q935tvIS4M7SR042nXYHmbfv0pAcEaHL7Dmb3aeJBw8PdnaJefqSse6Oe9YKm7VQFr
	qfQww5rid78mnX4BDn46oVxTUNq+0aqqwClf2R5CidM1oIblc9Ka5NJwFgC/Qn70px7qnYOvIIV
	RGv08g2DnX/UQqM/CkjDcSoqUZDVKRPLwH5Pt+sLCO6Q90VO+CzJHlzwOdpoZSJjPN3Ec14k=
X-Received: by 2002:a05:6122:6c09:b0:5ec:abdc:bb72 with SMTP id 71dfb90a1353d-5ee346b6663mr738707e0c.2.1794571861680;
        Fri, 13 Nov 2026 04:11:01 -0800 (PST)
X-Received: by 2002:a05:6122:6c09:b0:5ec:abdc:bb72 with SMTP id 71dfb90a1353d-5ee346b6663mr738699e0c.2.1794571861279;
        Fri, 13 Nov 2026 04:11:01 -0800 (PST)
Received: from [192.168.226.72] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b56df7sm86814566b.47.2026.11.13.04.10.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 04:11:00 -0800 (PST)
Message-ID: <03d75b49-dea4-4736-a662-27ef64682157@oss.qualcomm.com>
Date: Fri, 13 Nov 2026 13:10:53 +0100
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
Subject: Re: [PATCH 17/17] arm64: dts: qcom: Add Samsung Galaxy XR
To: Stanislav Aleksandrov <lightofmysoul@gmail.com>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Abel Vesa <abelvesa@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, Robert Marko <robimarko@gmail.com>,
        Guru Das Srinagesh <linux@gurudas.dev>,
        Thomas Gleixner <tglx@kernel.org>, Radu Rendec <radu@rendec.net>,
        Lee Jones <lee@kernel.org>, Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "Joerg Roedel (AMD)" <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wesley Cheng <wesley.cheng@oss.qualcomm.com>,
        Vinod Koul <vkoul@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>, Bean Huo <beanhuo@micron.com>,
        Stanley Jhu <stanleyjhu@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amitk@kernel.org>,
        Thara Gopinath <thara.gopinath@gmail.com>,
        Daniel Lezcano <daniel.lezcano@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Lukasz Luba <lukasz.luba@arm.com>,
        Georgi Djakov <djakov@kernel.org>,
        Sibi Sankar <sibi.sankar@oss.qualcomm.com>,
        linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, mfd@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
        linux-usb@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-scsi@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <20261109-halliday-dts-v1-0-289114ab8197@gmail.com>
 <20261109-halliday-dts-v1-17-289114ab8197@gmail.com>
 <3ddaacfd-59c0-4d87-9b8c-2caa85143393@oss.qualcomm.com>
 <20261109170407.2073295-1-lightofmysoul@gmail.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20261109170407.2073295-1-lightofmysoul@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: KR91BiDRb2xAuOK03aGd3yuBtvqcnnFI
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfX16QH5lpB353B
 4SUf6wJfzStAvEY8KSEE9SNi1tcBox0Ggyo8fkqVGVKwkGDINQneNpHjKdWqFR6zUOamIo7/ajz
 x7u1VSM6eg5UzIMznn24RWn7G+bwMg0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTEzMDA0OCBTYWx0ZWRfXwlo5OR7OiURv
 A07Y0jrWtKJ9UAvnaBhorMKWOixyR0gYatHagmf7dhT0w2A5ZKhz+KJjSCKH5nc2wa64nsrpdr6
 th71dwBfxsp45WMEacpuOquwUygO6oUYUHREYtcZCjhJXDxMrq0ICURbPpDjQmgElifQvuqo4r/
 kpJHQxotBoLRKHWXBPlUcztoK+PJyPK6qD/1TygBnNfGKli+4ZQmxjgb/MLCUz8IZXZIz0phIFm
 cdxRlou/Pmu4nD3Tl97vNM4Yu5rmKGJ2JytAOc65YiVamPHEPmtfmXHogMSkE3ItkipQ5VoTLPp
 1n4FPDTh3n/cqMdFK+WUiliPENICheeRtPd/KFwALn13LbENRnDK28awEvEhVvCbXmta7UA/0ih
 V7SI/4mBguIyPko/UydbmTYwrULkKkj+AagsNgDfsLNwdbjrUUxX4YfDz1UfoLPw2SjAuwNUJEa
 AghhYSXbKgIF43hdJmw==
X-Proofpoint-ORIG-GUID: KR91BiDRb2xAuOK03aGd3yuBtvqcnnFI
X-Authority-Analysis: v=2.4 cv=AoN7T+9P c=1 sm=1 tr=0 ts=6af6fe5b cx=c_pps
 a=+D9SDfe9YZWTjADjLiQY5g==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VS6XN_di3_qKZAQ5k78A:9 a=QEXdDO2ut3YA:10 a=vmgOmaN-Xu0dpDh8OwbV:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-13_04,2026-11-11_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611130048

On 11/9/26 6:04 PM, Stanislav Aleksandrov wrote:
> On 09/11/2026 16:12, Konrad Dybcio wrote:
>> On 11/9/26 1:33 AM, Stanislav Aleksandrov wrote:
>>> +&usb_1 {
>>> +	dr_mode = "peripheral";
>>> +	maximum-speed = "high-speed";
>>> +	qcom,select-utmi-as-pipe-clk;
>>
>> Is there no superspeed / dp altmode in hardware?
> 
> The headset supports USB SuperSpeed and DisplayPort via its USB Type-C
> port, I just haven't brought them up yet. It seems we need a new driver
> for the Type-C controller.

OK, we can do that incrememntally

Konrad
