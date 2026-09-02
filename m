Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2765388860
	for <linux-crypto@vger.kernel.org>; Wed,  2 Sep 2026 05:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328708; cv=none; b=DbONd6AiShk7ao7QNnjJRZUzZaB1B87Z/xmyFTqee68LZXM9Cy/AYiv4MwP5u1ug4/KdMDh7DpYSLQdILEMZn5wJ5AIhdbQVxRToOTjaJXFd+2OYIVCI1v/Nl3W/xLOo9f1SNQZlfCiJ/n+hnCvvN61Z65Ie47OLHARBK5DiPWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328708; c=relaxed/simple;
	bh=YU8UPMKZ/ySiuNk1+MpS6FNLDJVxn5Pnh3Srux/+E3g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DRhp0QZN3Hn6xh5V4FuOWC5gDKuoOIjXZOVDx2I9f78+oLXKGDjnPFJHE3dCF/lsZaH0/ckaeiDJKeEhHBBm1JBgry25nx0ys4bJMR3gli8vloyLAX/ug/qZEo82psawLfxH90fv3C8ojPXQUzFhkzRqzn5feh3K2KwyeMh5V/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Z3Cupj4x; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=VvGu/Hbs; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Z3Cupj4x";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="VvGu/Hbs"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6825YPYM630955
	for <linux-crypto@vger.kernel.org>; Wed, 2 Sep 2026 05:58:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=; b=Z3Cupj4xK0M8m9+n
	HjPNoKTjeyNo+c+jG+BW7b81ZBszWFE9bGKqqv8VtmKwpjwQmAyzR9DQy6XOEOTn
	JIik4SxlBmNoATDKXWCRQOhT1fTMHvT+qwulbIt7juSNHHiX/sfhKDwfUPiA/vMp
	Rb1Lz+1LQuMZlkDq/BmEUf/fRmTSsKks3w9dcB9pHDaM5AZYj6bxXdUhl5/JO6r1
	qTgIw7Qh7P9izcq01KhGO8WPbBSMNT4QlAB8p2HTuw8skaSvhoN7q0g9q+j71Yfi
	8nMskBlrvZH0VVkD4Fejfvz5RHKCV/nQCnOGHuDmB3DZXWw5NCwZAfxoUbguo3IS
	cLMX2g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ge37j2bnx-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Wed, 02 Sep 2026 05:58:26 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1340432a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 22:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788328706; x=1788933506; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=;
        b=VvGu/HbsQTDRB/ELpMwv5hYLbnia3iQxcd+R0H6MWLsbUYg+8sZW9KzB+VNB+8ay+5
         c2H6lU/rEFspuzoxYak5vrp5XqtI7dEiT/BNAgX9IDO2YsFSfcqOgR6pFq3fQcsQ7j3V
         Zp1clPfH3sQ5kAUaZwKCNiCtUbWt9ASnNsAPsAqzDx54ols1X9AzsNnQONorAmrB3oXH
         VjJGsDm+Q/sorQw3cMA94OjHS2exuguMQTJCT3wl5nJMq93sI8BgM68nJ1HuFEOxkABK
         /RCNorTM2Hknmm5/1RK0VtQys/jIl6unKerOLfqtATwpsxqOKjrW9JzA9DbzO5TBPuOF
         +9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788328706; x=1788933506;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1OvAK2FF1tp6tcmLzdukvxlL1CZuIQ6FiGRnYYPcWf4=;
        b=JeVDZ12sfc2BpGs4xyK+jJMbKL56c07wQ8UKT6+7Cy90PSnPxmEcduS0U0g/8lLktw
         CbmE2V6uInIOrrfEdsU9ZYlcTT/ncJoomAuBIwc/7ekzoDlxkvXybBVIF/fr8zp1H2B+
         RK4CbH95vkKm6luZkzsrFmgDLuBIS+e+oX2nGlS5BiCbY0QJC68aT6797c6bLa1Q1NLF
         H6RO6q5QZ5ZwfWuAg1Tj+SoY6CGIvGGJE9cf4o2+uoC9ywf5eNCip/Z2Wbf7pci9LiuU
         w9LJ39pqGxpMoqYsDFa963ZIKQP0BEbAmQzgqo7F62Q9jY9acOpo5H22iS8M/UjPiI71
         h2pQ==
X-Forwarded-Encrypted: i=1; AKwUvBwHI+MAAlhDun6+EWMfiLWyJaI4z2QaFEojrOVw1AvfxrZ6gAmrn/sfbUoWs8bosbeYKPUUaag0gueWiQg=@vger.kernel.org
X-Gm-Message-State: AFuF++kJxhwbQnOFGc+3XO8piSNpU6nWZWH7LX6+NLFIs6gld9oqI9uk
	NgukEMCyB1v2pM0jzG2luXyAvn1Xun2TQNnbEN4Y+DrRRKh4nmTsnXbTJdc6vqc/jxv7tT3fzQ+
	5+lpCxCKaEgJ/bTwdow4BMRAs8p7hfPgh8ouhNngfquFJBPW3W9zZT/xGg7+A8L6oO0s=
X-Gm-Gg: AYBFou0hUFDj5u1i9v6gdKvqdRcGD4fLGsbVym5Lu1+kpFwsNLyAmvntMkXZc6NKp4E
	f8gcz3yxfxJmR6+16gBDpTVWqve6b5eaulBqM2rxl/yHekOa78JlTdVa4x262p5n5X+gWJY3tF7
	lAf5TLwqep/XPdxt3mrt/rF70CvOZq/QfPb0KvrcMkzdxzMqMmnWUeshog5ZCElQW5H1z+1X0si
	Gb3zjqUDVH/0ANnEmP8ulNP/mpvih9xKKF9bg3mQ0F6Thkc91X9G1egA00QvY8Cn1A1TGcBEieJ
	rrlSHSCTNY7xlUp1Q8DNcdl4BoKcfVu3xzlsU9vfgt9hZ4XxEYziVAIWaV8yJYJ1t6JmIRKiXfQ
	bkjbXHXe2aRg5r6uPNFHVXOeh32QhsQvFx9OOqAPWc48dVr+P9Ar+cqTS
X-Received: by 2002:a17:90b:4ac9:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39aee0b498dmr2783800a91.19.1788328705724;
        Tue, 01 Sep 2026 22:58:25 -0700 (PDT)
X-Received: by 2002:a17:90b:4ac9:b0:398:9bd5:490c with SMTP id 98e67ed59e1d1-39aee0b498dmr2783746a91.19.1788328705240;
        Tue, 01 Sep 2026 22:58:25 -0700 (PDT)
Received: from [10.110.50.50] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f07b79898sm3792600eec.15.2026.09.01.22.58.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 22:58:24 -0700 (PDT)
Message-ID: <d7229be4-36f9-4050-8a45-1f89b1283b9a@oss.qualcomm.com>
Date: Wed, 2 Sep 2026 13:58:17 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/11] virtio_blk: add inline encryption support
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com, jasowangio@gmail.com,
        James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-scsi@vger.kernel.org, virtualization@lists.linux.dev,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        neeraj.soni@oss.qualcomm.com, gaurav.kashyap@oss.qualcomm.com,
        mani@kernel.org, andersson@kernel.org, konradybcio@kernel.org,
        bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@sandisk.com,
        pbonzini@redhat.com, eperezma@redhat.com, xuanzhuo@linux.alibaba.com,
        linux-kernel@vger.kernel.org
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-2-linlin.zhang@oss.qualcomm.com>
 <20260901194817.GE729142@fedora>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <20260901194817.GE729142@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: bO2mZ8YRXudxnYbeRb0Iiv9IX23-D7AA
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX3RePz4oWefBZ
 L/DCHp72kVzKX+UwwaJ0maw37aUnlLGZPKTaroFiH0t9v2XAAklqRRPU40xvZA+nKo7te1MCruL
 /ISv10/nTGQECCeS1LRVbcXy2aw6hrY=
X-Proofpoint-ORIG-GUID: bO2mZ8YRXudxnYbeRb0Iiv9IX23-D7AA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAyMDA1MSBTYWx0ZWRfX19EtKtTdijY6
 CJ7hF2JnDkFgMg/qwROJtQ6uUTfrrgwhlLZBFD/RdTP2PV69JrnbV+NloOA8Pay7lux0IaMTaur
 o8YsM7aTSi70rhuSJsMfKxImDqTBtTko7269Ak9ua3qwlk7XYD9kblMPiRUpsdCEHD5AjdEfdWs
 TuIXCUx09DUyGFIsFSuf8Im+nAZwVBpKVukxAoruXNt9dju4xFsja/ocbG92JtGON7QnDl4Movk
 C47NSvIVAX8Aj37pVS6QnRB58AFw1h0ZUtm9qadgkVXmQ6qCnZxj67CdYQK2X1UUAXN96g2KR33
 y3P1eaQsCOrlJAzfy0ojY0KWEuKHmeEPHj70TX0ocfFvS2GBO7rRSMjDEsForUF2SG3ZcPoJ8R0
 Iqtg5Gr8RFAfCoXebtjpCJmCwPpgGDkHMbDyGeLfaLykSwIg5efUD33sNr3UdOI9NEyNu6alIAB
 XQ22OXr1NSXzKeFi+LQ==
X-Authority-Analysis: v=2.4 cv=PKg/P/qC c=1 sm=1 tr=0 ts=6a97bb02 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=EUspDBNiAAAA:8 a=dlkBk7sggpSz48gVZtEA:9 a=QEXdDO2ut3YA:10
 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_06,2026-09-01_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609020051



On 9/2/2026 3:48 AM, Stefan Hajnoczi wrote:
> On Thu, Aug 27, 2026 at 09:07:10AM -0700, Linlin Zhang wrote:
>> From: linlzhan <linlzhan@qti.qualcomm.com>
>>
>> Negotiate VIRTIO_BLK_F_INLINE_ENCRYPTION with the host and wire it into
>> the block layer's inline-crypto framework to enable inline encryption
>> on virtio block device.
>>
>> When the feature is present, the driver reads crypto characteristics from
>> virtio config space (key-slot count, DUN size, supported key types) and
>> issues VIRTIO_BLK_T_GET_CRYPTO_MODES to discover supported cipher and
>> data-unit-size combinations.  Encrypted requests use new request types
>> VIRTIO_BLK_T_CRYPTO_IN/OUT, which append a virtio_blk_crypto_msg
>> (keyslot index, DUN, data-unit-size-bits) to the standard outhdr.
>>
>> A new virtio block crypto extension driver (virtio_blk_crypto_ext),
>> owns the blk_crypto_profile singleton and the blk_crypto_ll_ops dispatch
>> table. Actual key operations are forwarded to a platform-specific
>> backend registered via virtblk_set_crypto_ops(); without one,
>> VIRTIO_BLK_F_INLINE_ENCRYPTION is still negotiated and the
>> profile is registered, but every keyslot operation returns -EOPNOTSUPP.
>>
>> The shared profile is a singleton as per blk_crypto_profile is
>> corresponding to one ICE hardware: the first device to negotiate the
>> feature initializes it; subsequent devices reuse it only when their
>> negotiated capabilities (slot count, DUN size, key types) match exactly.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/block/Kconfig                 |  13 ++
>>  drivers/block/Makefile                |   2 +
>>  drivers/block/virtio_blk.c            | 199 ++++++++++++++++--
>>  drivers/block/virtio_blk_crypto_ext.c | 283 ++++++++++++++++++++++++++
>>  include/linux/virtio_blk_crypto_ext.h |  78 +++++++
>>  include/uapi/linux/virtio_blk.h       |  62 ++++++
>>  6 files changed, 623 insertions(+), 14 deletions(-)
>>  create mode 100644 drivers/block/virtio_blk_crypto_ext.c
>>  create mode 100644 include/linux/virtio_blk_crypto_ext.h
> 
> Thanks for sending this as we discuss the VIRTIO spec changes.
> 
> Although it's nice to have all the Linux patches together, there are two
> separate parts: 1. the virtio_blk.ko guest driver changes and 2. the
> hypervisor blk-crypto uapi. I suggest splitting this into two patch
> series to avoid confusion between these parts. It may also make review
> and merging easier if we stay focussed on just the guest or just the
> host parts.

Thanks for the comments!

I can separate them as 2 patch series in next patch.

> 
> Stefan

