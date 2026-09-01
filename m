Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F3B47D929
	for <linux-crypto@vger.kernel.org>; Tue,  1 Sep 2026 09:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255621; cv=none; b=DTC0ySfPhVdAWts5KyPof37NzGXIPFMiO328zuzoAjPkMTlRGwOsVwdK0Mi1ENrLEyZlW0sE2arIqqhn23MqLDFXezhxVWdxPNJzKkJ5ZTRt5lOSGfaQQb5e//oPqLQhO7W1GqgY9VkC60AD/Ej40ThJ5BL6fMTq+uJu1QwglYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255621; c=relaxed/simple;
	bh=8APMAef5M9SrLIP+vBlgVZPxJkH5v1YicMDwKDG2Qik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K4LxgTNVdcuqJsIdljz6o+PQqmGo9yZIsfi33gJLs9FzzHbwX+6ZiZAhtKTmtAtdIWdOIEHHnJ81aq+o3i+bibotRURgAGzoNbGxjsf1pL5Mr5VxNNd1kSyNVzOyqkXaEVs4khenl7azgKtZsGJnhLqOZBjaVLVu63JbZj/zTHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=S+rLnLkv; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jr3IH4NO; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="S+rLnLkv";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jr3IH4NO"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68178oqG2973928
	for <linux-crypto@vger.kernel.org>; Tue, 1 Sep 2026 09:40:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dEt4E8LFvA2RKOEkuMLy44P4JRUm+WvHjuvX24Q2FpU=; b=S+rLnLkvaxp7nMMw
	jGkHfmS7RBwNn8Gixn+morA17iIWou/BPXEiVcMiUq+0if/ULdD0cVCdF4K6EN4c
	V0VeJlWBg96XKvY16NubgmsPJbzLV7qcFlbRL63B8BcehCxYxID57WCDKeHHnZF0
	PYzysJgBIdrwBY1V1KYqRh8XXOq6O7RsCMqRzE/81AYA74lllgF6nCR1Hz09HpL2
	UN0zlYUpzyvPn4agl1oQhGZwUy8SbW1c9O454zAdNsx9nePDmHASGANHmq9CD5xo
	idkBChsWlwYeoyq8x/WmoN/JYskM4evkcyAoCh4tyjZVZxwS8AUcCD5Hp0SsNM0L
	YWxJ+A==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gdsnu0sjw-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 09:40:05 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-3968dfff779so1312894a91.1
        for <linux-crypto@vger.kernel.org>; Tue, 01 Sep 2026 02:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1788255605; x=1788860405; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dEt4E8LFvA2RKOEkuMLy44P4JRUm+WvHjuvX24Q2FpU=;
        b=jr3IH4NOkN+FpL4NJf2vSwFU6iu5tSCJLMY1ymKoFBwPbQYPVdEOYBzGjbgQZwY+oI
         +3ghh0veGdF3od0dyPyJBOsmqYp34dgjocOF2HYBEQXeFeDr8IwOnlZDpKxcpoUdYHlp
         lToyIi2M7Ty9b6PW2Ep2gLVNsdF/Wtt7pZm5xQ+aSowOrIt5uhJJ3MpO2/NrEth/jBVQ
         erREwH1KtOrBpPzUo72pGqo5jTPmjcg2RSR1ZK+evsXbmnGVkfFrxMD1q/nwuXswW6+B
         QtT+p1It9hMW4t/2ydw2W/VnXustPMy1R86zE8L4+n+klTDzQitemCWnNOeY11NL6045
         hSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788255605; x=1788860405;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dEt4E8LFvA2RKOEkuMLy44P4JRUm+WvHjuvX24Q2FpU=;
        b=FVwMW/oDefwf0O1QUMVqpKf/B+bTS8YO3YYy06DahPBzOwWNXf+/QavFMXliaJJbYF
         2RcKG/dfxotoOFq7TroaS1B2941kupwtAbA9PAivdcls/EZXESTsGfvb/Vommz2V0ozL
         N9f4kNeDVySsS/XujH8OaTe9UwfhE2R8gqoeyGEVjGO2I+hD0FVjiBusQTB9+5dRF4bT
         HJNO8DGkzTtUE5v+XxJlASixvmIkSRCv3rv/+LKPDGq7iVsnbvnSwsJCkWyEDMUB2VyD
         V3cDYKzV6Cc3zTgOmZYM9bOy+sJZWbMSMaSxGM4yjP8xSxyKK3UmkyiMfqgsFkttxwlO
         ezBg==
X-Forwarded-Encrypted: i=1; AKwUvByF24dysUvToHOdR8TPOuS5YAPIJwhLpaD7Bb9J+XbANID30lZqfvPtwrIgd5RDDtjB8417wTq1KjAOnF4=@vger.kernel.org
X-Gm-Message-State: AFuF++nDePcjKoqoBCA+57I6QINjXbRPjFJWFTgr2fQhuQ269bZR6V7r
	ZTdJljngusL3m2X8Hi8oTA1VB3hex7DnIKWMmzrHbrfVzDi01mdAbO2pQWcM4rKq1VHguPAE7wV
	E08q4WZxTh4MYGqqgYmkfaItGcV/BUwP/IRDqvJJEUHNOUVUcOLN7MjwBEdGKDK8jiXs=
X-Gm-Gg: AYBFou3uatU1aUnjJAdmM54K3r9Zoybcd4WI0g17tYlotaWSyzqHjaQ+qfA5fjhjO1a
	crio58sgevBJtDQAyZwvuh2u4rtQtaL/ErplSAXtpkyE9TghPYkuqGq9hj30rT3RYfWxRhzPVEJ
	T/ycBTHPN+3wfVBxzDngLbrDExWatJd35yiwaPaOlsR5B8LPVLJHqtm2wWF3J/BLQkejXc4USMS
	//Lc0LqtRc+jU1T4PR8A2jv13l2sJTy58GUUmjDCK+w0LHhXHp9HD7wV1/K7T5HITMHBF5nogQq
	tB0Z5W6OOv6nN0DDQX1SqK8aopr19N9Kp9OkFehBwc9yJQu0J05OLfTSNG2hows0DM+whlbI8ws
	1AHJ+YsA/Rn1P0Ye19O1voyDMgRLxq9GrLUK2RPrKwgSEOKOkmSXqah0m
X-Received: by 2002:a17:90b:51c8:b0:394:ed5c:ff9f with SMTP id 98e67ed59e1d1-3990f890efamr4881827a91.17.1788255605047;
        Tue, 01 Sep 2026 02:40:05 -0700 (PDT)
X-Received: by 2002:a17:90b:51c8:b0:394:ed5c:ff9f with SMTP id 98e67ed59e1d1-3990f890efamr4881748a91.17.1788255604402;
        Tue, 01 Sep 2026 02:40:04 -0700 (PDT)
Received: from [10.110.34.210] (i-global254.qualcomm.com. [199.106.103.254])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-142e41837c6sm32385026c88.11.2026.09.01.02.39.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2026 02:40:04 -0700 (PDT)
Message-ID: <03097984-fded-477e-82b6-f9b31fd2f1d3@oss.qualcomm.com>
Date: Tue, 1 Sep 2026 17:39:55 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 02/11] soc: qcom: add crypto_virt backend for
 virtio-blk inline crypto
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
 <20260827160806.1295313-3-linlin.zhang@oss.qualcomm.com>
 <f5915133-ffac-4777-b7d9-cf38ba163d43@kernel.org>
Content-Language: en-US
From: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
In-Reply-To: <f5915133-ffac-4777-b7d9-cf38ba163d43@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTAxMDA4NSBTYWx0ZWRfX64PO8JEu/EeP
 o4gQwjjI7vOPSL5EI8zdj9j6nZBKh/yoCfUQPzibI4QVNeN310TGMOlANJl03sLMHJyovetb4XW
 uLlYnAVF6005J8j51tok7AmsgPmC9QnHat4ExjhNP0xRQXJMEm9vJ1BW6GhDIMLi/GeouggBSug
 s3SS42xcIWFwFDS/Ih9p+cik/p1W7QL99+SDds2OppdXI5NRSCz3djctX35vaUNNZ00IBKfnXG1
 pAKR2LNfPMPsTigpnM8TUawn0TA1G0N+z7XWn9ZsUnHFDIA55ITsiFpPd3b8yIjD8EwBZ672bcA
 EWo2xhgB9sDV5HpY/dTdwySgk0HBt1EQKwZ4NZVpskQ2u3E0KK0Bvqu4vJ9q1Al1yWOdhmxfg1p
 OQU4HoQxoLKfPh15qgIR6cGqOo+6Eq2zyHfoCSHzEPeWVQKOZFuRto51Sb0yhsT/XYgcp3DzZhs
 N59JbAuVkNe7PLc1ZnA==
X-Authority-Analysis: v=2.4 cv=L6ItheT8 c=1 sm=1 tr=0 ts=6a969d75 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=JYp8KDb2vCoCEuGobkYCKw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=EUspDBNiAAAA:8 a=zfqY7Qy--laD8oWU0cEA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTAxMDA4NSBTYWx0ZWRfX+8MDVjqzLJF3
 X0bg4M1/LH8uXrMICbYNsA1GH6iGBJsZI2UeFQ4cbSlBlHtVCfK1Ntxumm8OKj1dpH/J6jtb7ZV
 n/ZcGMoCxDh5qN5+spOUSPHvSwlyiS8=
X-Proofpoint-ORIG-GUID: JoDAU_JyYQsDDm-GHvimlIY26ofQeZGK
X-Proofpoint-GUID: JoDAU_JyYQsDDm-GHvimlIY26ofQeZGK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-01_02,2026-08-31_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 lowpriorityscore=0 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609010085



On 8/31/2026 2:56 PM, Krzysztof Kozlowski wrote:
> On 27/08/2026 18:07, Linlin Zhang wrote:
>> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>>
>> In a Qualcomm GVM environment the ICE hardware is controlled by the
> 
> What is GVM?
> 

GVM means Guest Virtual Machine. This is designed for the virtualization
platform.

>> host, GVM has no direct access to it. So, key operation in GVM is
>> done through SCM calls rather than direct register access. In this
>> way the access to ICE registers are offloaded to Trust Zone.
>>
>> Add QCOM_CRYPTO_VIRT, which implements struct virtblk_crypto_variant_ops
>> for the virtio_blk_crypto_ext dispatch layer. It maps keyslot
>> program/evict to qcom_scm_ice_set_key() and
>> qcom_scm_ice_invalidate_key(), and software-secret derivation to
>> qcom_scm_derive_sw_secret().
>>
>> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
>> ---
>>  drivers/soc/qcom/Kconfig       | 12 +++++
>>  drivers/soc/qcom/Makefile      |  1 +
>>  drivers/soc/qcom/crypto_virt.c | 89 ++++++++++++++++++++++++++++++++++
>>  3 files changed, 102 insertions(+)
>>  create mode 100644 drivers/soc/qcom/crypto_virt.c
>>
>> diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
>> index 2b524154d9fb..6c632d114d45 100644
>> --- a/drivers/soc/qcom/Kconfig
>> +++ b/drivers/soc/qcom/Kconfig
>> @@ -298,6 +298,18 @@ config QCOM_INLINE_CRYPTO_ENGINE
>>  	tristate
>>  	select QCOM_SCM
>>  
>> +config QCOM_CRYPTO_VIRT
>> +	tristate "Qualcomm Technologies, Inc. Crypto Virt driver"
>> +	depends on VIRTBLK_CRYPTO_VIRTUALIZATION
>> +	depends on QCOM_SCM
>> +	default VIRTBLK_CRYPTO_VIRTUALIZATION if ARCH_QCOM
>> +	help
>> +	  GVM-side hardware-wrapped-key SCM operations exposed to
>> +	  virtio_blk's inline crypto layer: per-slot key programming and
>> +	  eviction, and key derive/generate/prepare/import.
>> +	  Say Y here to compile the driver as a part of kernel or M to compile
>> +	  as a module.
>> +
>>  config QCOM_KRYO_L2_ACCESSORS
>>  	bool
>>  	depends on ARM64
>> diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
>> index 798643be3590..6d4b7546d1fb 100644
>> --- a/drivers/soc/qcom/Makefile
>> +++ b/drivers/soc/qcom/Makefile
>> @@ -39,5 +39,6 @@ obj-$(CONFIG_QCOM_KRYO_L2_ACCESSORS) +=	kryo-l2-accessors.o
>>  obj-$(CONFIG_QCOM_ICC_BWMON)	+= icc-bwmon.o
>>  qcom_ice-objs			+= ice.o
>>  obj-$(CONFIG_QCOM_INLINE_CRYPTO_ENGINE)	+= qcom_ice.o
>> +obj-$(CONFIG_QCOM_CRYPTO_VIRT)	+= crypto_virt.o
>>  obj-$(CONFIG_QCOM_PBS) +=	qcom-pbs.o
>>  obj-$(CONFIG_QCOM_UBWC_CONFIG) += ubwc_config.o
>> diff --git a/drivers/soc/qcom/crypto_virt.c b/drivers/soc/qcom/crypto_virt.c
>> new file mode 100644
>> index 000000000000..4ee2a36af6c1
>> --- /dev/null
>> +++ b/drivers/soc/qcom/crypto_virt.c
>> @@ -0,0 +1,89 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +
>> +#include <linux/module.h>
>> +#include <linux/types.h>
>> +#include <linux/blk-crypto.h>
>> +#include <linux/virtio_blk_crypto_ext.h>
>> +#include <linux/firmware/qcom/qcom_scm.h>
>> +
>> +static int crypto_virt_program_key(const struct blk_crypto_key *key,
>> +				   unsigned int slot)
>> +{
>> +	u32 dus_512_units;
>> +	int ret;
>> +
>> +	if (!key || !key->size) {
>> +		pr_err("%s: invalid key\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* Only AES-256-XTS has been tested so far. */
>> +	if (key->crypto_cfg.crypto_mode !=
>> +	    BLK_ENCRYPTION_MODE_AES_256_XTS) {
>> +		pr_err_ratelimited("Unsupported crypto mode: %d\n",
>> +				    key->crypto_cfg.crypto_mode);
>> +		return -EINVAL;
>> +	}
>> +
>> +	/* qcom_scm_ice_set_key()'s data_unit_size is expressed in 512-byte units */
>> +	dus_512_units = key->crypto_cfg.data_unit_size / 512;
>> +
>> +	ret = qcom_scm_ice_set_key(slot, key->bytes, key->size,
>> +		QCOM_SCM_ICE_CIPHER_AES_256_XTS, dus_512_units);
>> +	if (ret)
>> +		pr_err("%s: slot=%u ret=%d\n", __func__, slot, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int crypto_virt_invalidate_key(unsigned int slot)
>> +{
>> +	int ret;
>> +
>> +	ret = qcom_scm_ice_invalidate_key(slot);
>> +	if (ret)
>> +		pr_err("%s: slot=%u ret=%d\n", __func__, slot, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static int crypto_virt_derive_sw_secret_key(const u8 *eph_key, size_t eph_key_size,
>> +					    u8 sw_secret[BLK_CRYPTO_SW_SECRET_SIZE])
>> +{
>> +	int ret;
>> +
>> +	ret = qcom_scm_derive_sw_secret(eph_key, eph_key_size,
>> +					sw_secret, BLK_CRYPTO_SW_SECRET_SIZE);
>> +	if (ret == -EIO || ret == -EINVAL)
>> +		ret = -EBADMSG; /* probably invalid key */
>> +
>> +	if (ret)
>> +		pr_err("%s: ret=%d\n", __func__, ret);
>> +
>> +	return ret;
>> +}
>> +
>> +static struct virtblk_crypto_variant_ops virtblk_crypto_qcom_vops = {
> 
> Why is a crypto-handling code in drivers/soc/?
> 

This driver is a Qualcomm vendor-specific driver, plays the similar role in the
guest, like the ice driver in the host. so I place it in drivers/soc/.

>> +	.owner = THIS_MODULE,
>> +	.program_key = crypto_virt_program_key,
>> +	.evict_key = crypto_virt_invalidate_key,
>> +	.derive_sw_secret_key = crypto_virt_derive_sw_secret_key,
>> +};
>> +
>> +static int __init crypto_virt_init(void)
>> +{
>> +	virtblk_set_crypto_ops(&virtblk_crypto_qcom_vops);
>> +	return 0;
>> +}
>> +module_init(crypto_virt_init);
>> +
>> +#if IS_MODULE(CONFIG_QCOM_CRYPTO_VIRT)
>> +static void __exit crypto_virt_exit(void)
>> +{
>> +	virtblk_set_crypto_ops(NULL);
>> +}
>> +module_exit(crypto_virt_exit);
>> +#endif
> 
> How do you instantiate this driver exactly?
> 

This driver is not instantiated per device. It acts as a provider of
Qualcomm vendor-specific inline crypto operations, which is based on
qcom_scm driver, and registers a global virtblk_crypto_ops instance
during module initialization. So that, each blk_crypto_ll_ops from
virtio block driver in common kernel can be sent via qcom_smc driver.

> Best regards,
> Krzysztof

