Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E4647CC80
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 10:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788259740; cv=none; b=Xwb6JfH2HRy1Bry65GMGDudApxC+VGG3+yTIpwFG3FBMhCFxii83H6K4oBTlUpwVVKpb//4yWHzGj/qigGWui4NA4XXLMWEiUyYhh5fnmG8BC+mVeSorbOFwtu8lxfKCGwdy6wgSU29HlVWNfAW1bFIv3OBpZSDmQv3cI2hQHKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788259740; c=relaxed/simple;
	bh=SLGSseQaf0vJp+4kOQXKmxaBEuZ8Z93Jn47quXknsh4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1e0NmPs5HNfeY7JhfdmuS5gY69tx5+GVD424Y4TW9WOhMgU8p70OPW9p7op3NARvmUqmhEbSEjyg9IzK7g1kZjCy2Qk1z4acKRPZH4NftKgJCzodoijN8oEn7eR1dlYqzFqEZF9sGrj/A5ek/gu2qGYC9SEBNMT4ijtKXpHDGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=T0tDVZcd; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=iJKoYCjU; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="T0tDVZcd";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="iJKoYCjU"
Received: from pps.filterd (m0279872.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 681AJlVI1713281
	for <linux-crypto@vger.kernel.org>; Tue, 1 Sep 2026 10:48:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=; b=T0tDVZcdsuc35KoL
	Gl6yMhEOiZ77racbSuMPOeyFCek1TfOwHIawgO58AD9OmvRvrARY9NNGUnCcHrMn
	Hk58PTGkYRaetFb9JtWN9d5dCPDB+51x3xDF20d07maqT2CRv5oPFo1qP/6huy4V
	SBL/fT9yi09owKqSlStcb1zk8wojBlOpQAT4bz7n7S88JLlFeZJqvbsF4C5fdWow
	PL7iWTXsp26kkr4zeqPTC/6WPQZnP5b3rF4g8SeCBgIHcqgBYdgfgubpbUI9J2PH
	7GJKwOwuD6uMGiZXuqdhzTbzR+TBcyy5usm+NBIinlvT1wx4GpXrpn6eksXn6r4N
	8YE1qg==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdndxa43p-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 10:48:56 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso1026959a91.0
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 03:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788259735; x=1788864535; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=;
        b=iJKoYCjUn/u9Q9kDaVe3C2RON2/kPSOj0WYovHF5dSUfRpsnc0qFiCSMpe2eClAXTI
         AY9LIV3QdTOD44jePfLXwxyp3YZZ2zTtpCh/g0WDzd5ZmyoQbgVNRJw8UcnxfJwoNOk0
         RQwN3WGdIgA6Ql6ZKfqseB2bL8l9KZocl3CFKCTqfG7tTutuLVKiziJtqrwumG+tBqRl
         6Bb/gnU7IEz97jlvs8wgq8HddjVXoCRuwcUuQiR8jkN7U976WyatYo24XuznNxWbQ9G+
         iMGiMmjWqNVtFXs7cKzjKTpQQ2WmcgJTpJao8ayxYCJFreXiPRVTjB2vLGmRH0fNEp3X
         swNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788259735; x=1788864535;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kWfgeNOyFGDYlfIW9v/3p67LM/pgSzbvLJN7re/Y3h0=;
        b=M06TaM0YcKbcdSEtu7UoW84i1gGTN0MriWsPexC4ABnlCF+OnZuUatpG8djm2wI6ac
         1sNLaTcX98rk0RtdQBBi9zkRe+FfaUxe0LJtDU+AHDsz38xStpZkmB6LZzl+R18uv41t
         AVr8Ua3HXzz1z1DjjbuiFBTVwO20LEW4Gg157hfPx7yty5WT2cbqWwuq/Fy83VaSAfFJ
         OZSuP0QWbc4zMM/LnNdu2YJpgliZRSB+9aWbJRBvc0rQqQq+vwo/W2EmE8r+fOyaNOzm
         JW9ubMsG/eMmQF1wkwGsU1FNMoLlpJI17CNEx6f3Vj0iPLzTvkNheRp+V+fprSHW36G7
         G4CA==
X-Forwarded-Encrypted: i=1; AKwUvBy6IGG6WnhEeY2PcsVX7pJP/TmceLPoQqEQLBHVBfF5zTjMutrfLP58JifwbKrNXuD/QCeTup8usQzf1x4=@vger.kernel.org
X-Gm-Message-State: AFuF++m5+VCj+W8a7O2A8SArlfPzIxhB5L51U1A1PIlI/o85InL76r3e
	Vq8b0Bh7zKIyRYn06JEG8XR6jYDtFafyTM7zBqZZa4qaE3eZgJwyEkjnY71yqOYwWYpSwF6I8tr
	i0taFtRxhkXkwM2rYHdt2hIskwF/waeL89kVJCvrjGj9lPGQIHejGZUyB6OKaWdUFwnI=
X-Gm-Gg: AYBFou037tXq1NnbJZU3PeDS8AV6RttaaVsFyjbaXSQLZHr8qLs3XLOjPngC6Qz845P
	6f71vWcXz2ykZKszINwxU384fxRoVsCuyGwt9MTnSTYY/276mM21aJge7lVug2u4+g4h2IytuIC
	9fzRel8PrPZoNoVUg9X/a/WfyW37q1Tr9QK30auPIPT2jF0gqom179RVcurkH179hHBNWt+X9RJ
	wo1UJwyyzrRgA+i8sTaTp4WxMow0He9PR5GFNgJZgZNJYU9dPw3xSgpxM5NfXEHLXwTinYMMtZc
	pV2rJymNiUBuliv6E4WS0GPPNoHUMbnUrO9MPmvKXxRlpXRfkMxelyTNS/m3nt3+Lzn9h6FI/Yi
	GTHfCAEUPpMwVXgI5tOPbfEErrDePs9ee4t2cpSagtpOWU2zQKIosAjB4
X-Received: by 2002:a17:90b:5586:b0:398:c8f3:d076 with SMTP id 98e67ed59e1d1-3990f93210fmr4803912a91.31.1788259734999;
        Tue, 01 Sep 2026 03:48:54 -0700 (PDT)
X-Received: by 2002:a17:90b:5586:b0:398:c8f3:d076 with SMTP id 98e67ed59e1d1-3990f93210fmr4803842a91.31.1788259734429;
        Tue, 01 Sep 2026 03:48:54 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32b5bef7683sm23429688eec.12.2026.09.01.03.48.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 03:48:54 -0700 (PDT)
Message-ID: <4d2d0d17-391c-4c81-8748-bf1025ea6f75@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 18:48:46 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 09/11] soc: qcom: add ICE keyslot partitioning driver
 for guest VMs
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
 <20260827160806.1295313-10-linlin.zhang@oss.qualcomm.com>
 <e23142e8-41b3-40f5-9d63-53c9c38fba38@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <e23142e8-41b3-40f5-9d63-53c9c38fba38@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: 0nX_rGhHd2ij8-J-pZz0sHoMZItSRuEP
X-Proofpoint-ORIG-GUID: 0nX_rGhHd2ij8-J-pZz0sHoMZItSRuEP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX6coZdIVpBETs
 2BdsMIYy8ZVxRJS88GD04zZt4eOFDv6PirjDUUT+kRC/U+CLvoeTucxcAt5n5kzhQWtza1y8jTP
 P6sz2m+56PIwg2lHXcua4k2XqUjo28o=
X-Authority-Analysis: v=2.4 cv=U8eiy+ru c=1 sm=1 tr=0 ts=6a96ad98 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yx91gb_oNiZeI1HMLzn7:22
 a=P-IC7800AAAA:8 a=EUspDBNiAAAA:8 a=puuXhSqztIu-OQ_ZuWYA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=mQ_c8vxmzFEMiUWkPHU9:22 a=d3PnA9EDa4IxuAV0gXij:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA5NSBTYWx0ZWRfX32EJNfE4Ep9s
 iSQP95egLSfvistkVOnEMY/O6V9cwkQt5x21myuZXgYbIgNmJz4wBFskkxXkrHEOFWUmnCV6DbM
 HJwgLpsVOH1J+4YKGef+DcUifrEQiBFfqHAdEG6RRoq9Za0MO3G8JasWXahEdtwXut7PXLOglhF
 PvRdEUcDNmmUD2Obk+fM8JVcvvwJBn87bxJBfx3dv1zfvJynQadWytzR4TSwNhXPCsALQVPdeSR
 aiPGew68pGRwlvxURJ97mYqZC+gRPp5vqDuj0LddAr5kYXHPjYy5Ya0UickB9dguCDnyZDe2OqH
 o0HPT6GDpELZwoXYki6A66/VUxjHssPJvXn7ClH7EtaEX6GBhX4JWgLSCQTW3TW4BsVhqIIC2gW
 3VhC7G+RNNqhu5KK+t6Yqc6eK90zU1iWZfa+Ve4ZiRmtpzK612U/rIwakIhqZjcJZC7ihyo8k1Z
 bnsxmP5JW/uEPKhh/4w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_03,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 impostorscore=0 adultscore=0
 spamscore=0 priorityscore=1501 suspectscore=0 bulkscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010095



On 8/31/2026 3:02 PM, Krzysztof Kozlowski wrote:
> On 27/08/2026 18:07, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> On Qualcomm platforms the ICE hardware has a fixed number of physical
>> keyslots shared across the host and all guest VMs.  A userspace
>> virtio-blk backend handling VIRTIO_BLK_T_CRYPTO_IN/OUT requests needs
>> to translate a guest's virtual keyslot index to the corresponding
>> physical ICE keyslot without letting one VM access another VM's slots.
>>
>> Add QCOM_ICE_SLOTS, a platform driver that implements bcp_slot_virt_ops
>> for the /dev/blk-crypto-proxy device.  It parses a
>> qcom,ice-keyslot-map device-tree node describing the per-VM keyslot
>> allocation table, where each child entry maps a guest_id to a
>> contiguous physical slot range [slot_offset .. slot_offset +
>> max_ice_slots).  Entry 0 is reserved for the host; guest entries start
>> at index 1 and are excluded from the guest-facing translation so that
>> blk-crypto-proxy cannot accidentally route a guest request into the
>> host's physical keyslots.
>>
>> The driver exposes two callbacks:
>>
>>   get_guest_slots()  — return the number of ICE keyslots allocated to
>>                        a given guest_id; used by BCP_GET_CRYPTO_CAPS to
>>                        populate the max_slots field in the virtio config
>>                        space.
>>   vslot_to_pslot()   — translate a (guest_id, virtual-slot) pair to the
>>                        corresponding physical ICE keyslot index; used by
>>                        BCP_SUBMIT_IO_BY_VSLOT before calling
>>                        bio_crypt_set_ctx_by_slot().
>>
>> The singleton pointer to the parsed table is RCU-protected; the hot
>> path reads it lock-free.  Probe validates that no two VM entries share
>> a guest_id or overlapping physical slot ranges.
>>
>> Note: This patch is submitted for visibility. The keyslot partitioning
>> is based on the current DT-based keyslot allocation with vm_id known.
>> We are aware this may be revised to use a TZ SCM query interface in a
>> future version of this series, submit it RFC for design discussion.
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/Kconfig          |  18 +++
>>  drivers/soc/qcom/Makefile         |   1 +
>>  drivers/soc/qcom/qcom_ice_slots.c | 232 ++++++++++++++++++++++++++++++
>>  3 files changed, 251 insertions(+)
>>  create mode 100644 drivers/soc/qcom/qcom_ice_slots.c
>>
>> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
>> index 6c632d114d45..e1f383b4dc63 100644
>> --- a/drivers/soc/qcom/Kconfig
>> +++ b/drivers/soc/qcom/Kconfig
>> @@ -294,6 +294,24 @@ endif
>>  # Options selected by other drivers from different subsystems must be outside
>>  # of the menuconfig if-block:
>>  
>> +config QCOM_ICE_SLOTS
>> +	tristate "Qualcomm ICE keyslot partitioning for VM guests"
>> +	depends on ARCH_QCOM || COMPILE_TEST
>> +	depends on BLK_CRYPTO_PROXY
>> +	depends on BLK_INLINE_ENCRYPTION
>> +	help
>> +	  Parses the qcom,ice-keyslot-map device-tree node and provides
>> +	  per-VM ICE keyslot accounting and virtual-to-physical slot
>> +	  translation for guest VMs sharing ICE hardware on Qualcomm
>> +	  platforms.
>> +
>> +	  When enabled, guest virtual keyslot indices are mapped to the
>> +	  physical ICE keyslot range allocated to each VM, preventing one
>> +	  VM from accessing another VM's keyslots.
>> +
>> +	  Say M here when multiple VMs share ICE keyslots on a Qualcomm
>> +	  platform.  If unsure, say N.
>> +
>>  config QCOM_INLINE_CRYPTO_ENGINE
>>  	tristate
>>  	select QCOM_SCM
>> diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
>> index 6d4b7546d1fb..952a57554f9d 100644
>> --- a/drivers/soc/qcom/Makefile
>> +++ b/drivers/soc/qcom/Makefile
>> @@ -38,6 +38,7 @@ obj-$(CONFIG_QCOM_LLCC) += llcc-qcom.o
>>  obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
>>  obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
>>  qcom_ice-objs			+= ice.o
>> +obj-$(CONFIG_QCOM_ICE_SLOTS)	+= qcom_ice_slots.o
>>  obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
>>  obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
>>  obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
>> diff --git a/drivers/soc/qcom/qcom_ice_slots.c b/drivers/soc/qcom/qcom_ice_slots.c
>> new file mode 100644
>> index 000000000000..364ac93077c1
>> --- /dev/null
>> +++ b/drivers/soc/qcom/qcom_ice_slots.c
>> @@ -0,0 +1,232 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * qcom_ice_slots.c - Qualcomm ICE keyslot partitioning for guest VMs
>> + *
>> + * Implements bcp_slot_virt_ops: translates a (guest_id, virtual-slot) pair to
>> + * a physical ICE keyslot index using a per-VM allocation table parsed from
>> + * the device-tree node with compatible = "qcom,ice-keyslot-map".
>> + *
>> + * Device-tree layout:
>> + *
>> + *   ice_keyslot_map: ice-keyslot-map {
>> + *       compatible = "qcom,ice-keyslot-map";
> 
> NAK, there is no such stuff.
> 
> Drivers for undocumented downstream DTS are not allowed.
> 

ACK

This is used to set slot mapping table in DT node. It will be moved
to Trust Zone if current out-of-band key operation is approved. Otherwise,
if virtio block devices implement blk_crypto_ops, this driver is unnecessary.

> ...
> 
>> +
>> +	dev_info(dev, "registered: %u VMs, %u total ICE slots\n",
>> +		 idx, total_slots);
> 
> This does not look like useful printk message. Drivers should be silent
> on success:
> https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/coding-style.rst#L913
> https://elixir.bootlin.com/linux/v6.15-rc7/source/Documentation/process/debugging/driver_development_debugging_guide.rst#L79

ACK

> 
> 
> Best regards,
> Krzysztof

