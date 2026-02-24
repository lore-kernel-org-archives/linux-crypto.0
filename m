Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 429763803F1;
	Tue, 24 Feb 2026 11:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771933991; cv=none; b=pyhR7vH8r+Beyx5cVSMaIQ9w9aUQFWmFZ/U3YaU84RN71ovopTYkfNg1Z2qBSliPNj/FFYWPQWCnooktbbF30yCE2otNHff0JeLWf9EJ+HsBxxRojzt3+VlKcAdQmOY21mk+GY/509c48kJY39KNip+Hq0FxVUKYKLK8V5v3drk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771933991; c=relaxed/simple;
	bh=UPrvamPx2bdnYf13mAoDTJRr+sBPiAGv7kZvkbWhsY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nOur2m82JBULLVXN2M8M5yAeSPUm31h/YkuI+AxyStNUCNHebjTioMUdWL8L2Ic406eHGb58hLmMWc2W1XGW7HOwnXfR9MGwrY0wal4ZI23A+1o+dD0f5oT0tYPO6PYd9FdurDYxdsrQcX3gCc9Jd1pcPtAAsnMWUOTdFlYHQXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=hTVw92Xy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="hTVw92Xy"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61O0XVWW1136392;
	Tue, 24 Feb 2026 11:52:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=90RmZX
	MgR/YLYjJTsQQHIO+fS98Ds+i8QeWjIyPS18A=; b=hTVw92XyOnKOQtXPs3grBM
	tlfoGTVURi7l1MLe3KkVGdfs75DVOxrXK23Ciw9TNyEynC1aO9Xl7aKh/zBm99u4
	v3XpJwgkPvYONKsR4to58eo758++QxIHFx14o4VNEVFwFBolmc0Pq3y3vDbIlCwp
	YAmE9i84R+/tkomfTa3oFQBupoK2voozS0Y2A4HjVcBDhCb2pOYLL5Fhd2+djnY/
	t/Iu5Vt1dilZlFqgC18jBTe5RM2LRTk1CZmWPuSo3hX8AEmqpLgnXttWxZoEhJMu
	hlRiw9GUsq6HokMb2eV/McDAGCXrz3MeOpoxzqGjFq/yWvm2ut+szws+7/kM32cA
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4brtqgq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 11:52:30 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61O6t4K8013411;
	Tue, 24 Feb 2026 11:52:30 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfqdy0st0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Feb 2026 11:52:30 +0000
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61OBqSYZ50201006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Feb 2026 11:52:28 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F32A58053;
	Tue, 24 Feb 2026 11:52:28 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BEE6958043;
	Tue, 24 Feb 2026 11:52:25 +0000 (GMT)
Received: from [9.61.28.161] (unknown [9.61.28.161])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 24 Feb 2026 11:52:25 +0000 (GMT)
Message-ID: <9d21b38f-e974-4620-90f1-61f6fd6f56ad@linux.ibm.com>
Date: Tue, 24 Feb 2026 06:52:41 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] treewide: fix duplicated word "the" in comments
To: Yousef El Bouzidi <elbouzidyyousef@gmail.com>,
        linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
        tglx@kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net,
        lee@kernel.org, hansg@kernel.org, ilpo.jarvinen@linux.intel.com,
        ansuelsmth@gmail.com, atenart@kernel.org, wens@kernel.org,
        hauke@hauke-m.de, andrew+netdev@lunn.ch, kuba@kernel.org,
        david.e.box@linux.intel.com, pasic@linux.ibm.com,
        jjherne@linux.ibm.com, hca@linux.ibm.com, driver-core@lists.linux.dev,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        platform-driver-x86@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20260224065300.454633-1-elbouzidyyousef@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: yOHnHnyuErcAPBjNGdkLN8955PElSAU3
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI0MDA5MyBTYWx0ZWRfXw1z9ie31xtTn
 W4L1FiXiUDhIeo/ab7uUqzy25zjCbgGySpOFDoRJQH2vp65Z6hRVfJ61tkRMlr/FBCxyKmBBlIQ
 T2fvunl0TiuMY5FmfwPd6j0bGQgFij5IQL+cFgbBgNq0p59crDanB3wyN9/yvR92omVQeNEJPJv
 0WeegMsKNyZ2lxnlH9borA2Z+i8qDfLo/s2NLxYy4ua6tLcuwTEoAXYngMwqb37XEzYGAZw/35q
 jFJAHSJ9PDpLhoTcUyclQzUbNYgZVAtiC98MDp+kBesEvWzY2oNZmkxbDpJ6r9sEChw0W4Qu0Ae
 aIO60zK/tGGZwLUo8mM7xLMlHN5gQp6VVCBOPI2W/yS6UKhI4UbyomLtY2F7l5zrRv24KZ9u0Mg
 WEXUC6w2jxLNQeHsNKSexlg7Pdp+YdtVzPgvnxLdNgDC+NcoBJ3Ad2Zv3ydR9QQO+PNOpUGt6vE
 k370UtZY9Vwu0JVHX3Q==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=699d90ff cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=-HbPlMZHRNqPhV-FfxwA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: FUoaeiQA5jPvJwkpqWIrdb2ypQ6LU8O7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-24_01,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602240093



On 2/24/26 1:52 AM, Yousef El Bouzidi wrote:
> Remove duplicated word "the" from comments across various subsystems.
> All instances are clear typos where "the" appeared twice in
> succession, often merged with the following word (e.g. "the they",
> "the there", "the these", "the them").
>
> Files fixed:
>    - drivers/base/platform.c
>    - drivers/crypto/inside-secure/eip93/eip93-hash.c
>    - drivers/mfd/axp20x.c
>    - drivers/net/ethernet/lantiq_xrx200.c
>    - drivers/platform/x86/intel/chtwc_int33fe.c
>    - drivers/platform/x86/intel/pmt/class.c
>    - drivers/s390/crypto/vfio_ap_ops.c
>    - kernel/irq/migration.c
>
> Signed-off-by: Yousef El Bouzidi <elbouzidyyousef@gmail.com>
> ---
>   drivers/base/platform.c                         | 2 +-
>   drivers/crypto/inside-secure/eip93/eip93-hash.c | 2 +-
>   drivers/mfd/axp20x.c                            | 2 +-
>   drivers/net/ethernet/lantiq_xrx200.c            | 2 +-
>   drivers/platform/x86/intel/chtwc_int33fe.c      | 2 +-
>   drivers/platform/x86/intel/pmt/class.c          | 2 +-
>   drivers/s390/crypto/vfio_ap_ops.c               | 2 +-
>   kernel/irq/migration.c                          | 2 +-
>   8 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/base/platform.c b/drivers/base/platform.c
> index b45d41b018ca..3e3b6fcfa194 100644
> --- a/drivers/base/platform.c
> +++ b/drivers/base/platform.c
> @@ -565,7 +565,7 @@ struct platform_object {
>   };
>   
>   /*
> - * Set up default DMA mask for platform devices if the they weren't
> + * Set up default DMA mask for platform devices if they weren't
>    * previously set by the architecture / DT.
>    */
>   static void setup_pdev_dma_masks(struct platform_device *pdev)
> diff --git a/drivers/crypto/inside-secure/eip93/eip93-hash.c b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> index 2705855475b2..d91a1ac152f0 100644
> --- a/drivers/crypto/inside-secure/eip93/eip93-hash.c
> +++ b/drivers/crypto/inside-secure/eip93/eip93-hash.c
> @@ -432,7 +432,7 @@ static int eip93_hash_update(struct ahash_request *req)
>   
>   /*
>    * With map_data true, we map the sa_record and sa_state. This is needed
> - * for finup() as the they are mapped before calling update()
> + * for finup() as they are mapped before calling update()
>    */
>   static int __eip93_hash_final(struct ahash_request *req, bool map_dma)
>   {
> diff --git a/drivers/mfd/axp20x.c b/drivers/mfd/axp20x.c
> index 679364189ea5..0c6e93eb3955 100644
> --- a/drivers/mfd/axp20x.c
> +++ b/drivers/mfd/axp20x.c
> @@ -1417,7 +1417,7 @@ int axp20x_device_probe(struct axp20x_dev *axp20x)
>   	 * 1 bit customizable at the factory, and 1 bit depending on the
>   	 * state of an external pin. The latter is writable. The device
>   	 * will only respond to operations to its other registers when
> -	 * the these device addressing bits (in the upper 4 bits of the
> +	 * these device addressing bits (in the upper 4 bits of the
>   	 * registers) match.
>   	 *
>   	 * By default we support an AXP806 chained to an AXP809 in slave
> diff --git a/drivers/net/ethernet/lantiq_xrx200.c b/drivers/net/ethernet/lantiq_xrx200.c
> index b8766fb7a844..dde651d901c8 100644
> --- a/drivers/net/ethernet/lantiq_xrx200.c
> +++ b/drivers/net/ethernet/lantiq_xrx200.c
> @@ -157,7 +157,7 @@ static int xrx200_open(struct net_device *net_dev)
>   	/* The boot loader does not always deactivate the receiving of frames
>   	 * on the ports and then some packets queue up in the PPE buffers.
>   	 * They already passed the PMAC so they do not have the tags
> -	 * configured here. Read the these packets here and drop them.
> +	 * configured here. Read these packets here and drop them.
>   	 * The HW should have written them into memory after 10us
>   	 */
>   	usleep_range(20, 40);
> diff --git a/drivers/platform/x86/intel/chtwc_int33fe.c b/drivers/platform/x86/intel/chtwc_int33fe.c
> index d183aa53c318..1fca9fdd8f5b 100644
> --- a/drivers/platform/x86/intel/chtwc_int33fe.c
> +++ b/drivers/platform/x86/intel/chtwc_int33fe.c
> @@ -14,7 +14,7 @@
>    *
>    * So this driver is a stub / pseudo driver whose only purpose is to
>    * instantiate I²C clients for chips 2 - 4, so that standard I²C drivers
> - * for these chips can bind to the them.
> + * for these chips can bind to them.
>    */
>   
>   #include <linux/dmi.h>
> diff --git a/drivers/platform/x86/intel/pmt/class.c b/drivers/platform/x86/intel/pmt/class.c
> index be3c8d9e4fff..99bf7e0afdf1 100644
> --- a/drivers/platform/x86/intel/pmt/class.c
> +++ b/drivers/platform/x86/intel/pmt/class.c
> @@ -239,7 +239,7 @@ static int intel_pmt_populate_entry(struct intel_pmt_entry *entry,
>   
>   		/*
>   		 * Some hardware use a different calculation for the base address
> -		 * when access_type == ACCESS_LOCAL. On the these systems
> +		 * when access_type == ACCESS_LOCAL. On these systems
>   		 * ACCESS_LOCAL refers to an address in the same BAR as the
>   		 * header but at a fixed offset. But as the header address was
>   		 * supplied to the driver, we don't know which BAR it was in.
> diff --git a/drivers/s390/crypto/vfio_ap_ops.c b/drivers/s390/crypto/vfio_ap_ops.c
> index 44b3a1dcc1b3..334aaa2d97b2 100644
> --- a/drivers/s390/crypto/vfio_ap_ops.c
> +++ b/drivers/s390/crypto/vfio_ap_ops.c
> @@ -610,7 +610,7 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>   	matrix_mdev = container_of(vcpu->kvm->arch.crypto.pqap_hook,
>   				   struct ap_matrix_mdev, pqap_hook);
>   
> -	/* If the there is no guest using the mdev, there is nothing to do */
> +	/* If there is no guest using the mdev, there is nothing to do */

Reviewed-by: Anthony Krowiak <akrowiak@linux.ibm.com>

>   	if (!matrix_mdev->kvm) {
>   		vfio_ap_le_guid_to_be_uuid(&matrix_mdev->mdev->uuid, uuid);
>   		VFIO_AP_DBF_WARN("%s: mdev %08lx-%04lx-%04lx-%04lx-%04lx%08lx not in use: apqn=0x%04x\n",
> diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
> index f2b2929986ff..b29d13baee55 100644
> --- a/kernel/irq/migration.c
> +++ b/kernel/irq/migration.c
> @@ -89,7 +89,7 @@ void irq_move_masked_irq(struct irq_data *idata)
>   
>   		ret = irq_do_set_affinity(data, desc->pending_mask, false);
>   		/*
> -		 * If the there is a cleanup pending in the underlying
> +		 * If there is a cleanup pending in the underlying
>   		 * vector management, reschedule the move for the next
>   		 * interrupt. Leave desc->pending_mask intact.
>   		 */

