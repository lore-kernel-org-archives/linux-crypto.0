Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18655328615;
	Mon, 22 Dec 2025 06:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766383846; cv=none; b=aP9iuxM2NATVjYCxtYuhPrxh/JBVCxUHBdyNIrwCA1kK9is02vdAUB4eJtzgmopxjCNzealKoSndtpbv1lFVikG+kbfA+ktaB/cbWbz/dVYfoE7Y3HDjoioJ6iMahI6ba8sLg4zLVOUdk2wmamdk1qX3+90CmcJt+5BdG4G58jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766383846; c=relaxed/simple;
	bh=nK0KluNSl7P8lA5HqO/GiRdkMftJ2nffCF7/IC1vKcY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=ABVeSnzB4XQzs71F44xAQqifx+r2rqNjfx8PP4wTsgkqbFJT0kX+rbvUGINmkxvqHxDqmYX8Fbo/Q/qISErlWhOWWWdVOrRxIDGd0s97z2h42eusrwmZIMJ41vPamj9j2EP8RYAuXJXKq6s1x8IceRpO27EClRl1SILZUudRNPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=0RAhPtUK; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="0RAhPtUK"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ojbEQugBEZR6SqyQuUgdgP0ANr6BZ+ZHgYhMAajvCTE=;
	b=0RAhPtUKNhpLoruDNl4/u347re+PnKDB43iydxjx75wMZdNSSt+1nLY+zt0aZoXIu6G9JIKK9
	4hfFboR040bPo9Dip4ktlSsIivJlgzaNz6JPZ1mkZ0GVA8coFqxg1L/YjpPA4fRkL6wL05moeF/
	2rwZf+9NuO/jxywTM2AuVHo=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dZSNJ6QlXz1cyPx;
	Mon, 22 Dec 2025 14:07:28 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 0FFE240363;
	Mon, 22 Dec 2025 14:10:34 +0800 (CST)
Received: from kwepemq200001.china.huawei.com (7.202.195.16) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 14:10:33 +0800
Received: from [10.67.120.171] (10.67.120.171) by
 kwepemq200001.china.huawei.com (7.202.195.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Dec 2025 14:10:33 +0800
Message-ID: <f1ace3a7-a4ba-4a57-b08f-7d07a5984b20@huawei.com>
Date: Mon, 22 Dec 2025 14:10:32 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] crypto: hisilicon/trng - use DEFINE_MUTEX() and
 LIST_HEAD()
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>, <fanghao11@huawei.com>,
	<liulongfang@huawei.com>, <qianweili@huawei.com>, <linwenkai6@hisilicon.com>,
	<wangzhou1@hisilicon.com>
References: <20251120135812.1814923-1-huangchenghai2@huawei.com>
 <20251120135812.1814923-2-huangchenghai2@huawei.com>
 <aUTAznUr2OrikTH9@gondor.apana.org.au>
From: huangchenghai <huangchenghai2@huawei.com>
Content-Language: en-US
In-Reply-To: <aUTAznUr2OrikTH9@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq200001.china.huawei.com (7.202.195.16)


在 2025/12/19 11:04, Herbert Xu 写道:
> On Thu, Nov 20, 2025 at 09:58:11PM +0800, Chenghai Huang wrote:
>> @@ -308,12 +302,10 @@ static void hisi_trng_remove(struct platform_device *pdev)
>>   	struct hisi_trng *trng = platform_get_drvdata(pdev);
>>   
>>   	/* Wait until the task is finished */
>> -	while (hisi_trng_del_from_list(trng))
>> -		;
>> -
>> -	if (trng->ver != HISI_TRNG_VER_V1 &&
>> -	    atomic_dec_return(&trng_active_devs) == 0)
>> -		crypto_unregister_rng(&hisi_trng_alg);
>> +	while (hisi_trng_crypto_unregister(trng)) {
>> +		dev_info(&pdev->dev, "trng is in using!\n");
>> +		msleep(WAIT_PERIOD);
>> +	}
> Please use the new CRYPTO_ALG_DUP_FIRST flag to let the Crypto API
> deal with reference count tracking.  With that, you should be able
> to unregister the RNG even if there are still tfms using it.
>
> The RNG will be freed after all tfms using it are freed.
>
> Of course you should create a way to mark the trng as dead so
> that the hisi_trng_generate returns an error instead of trying
> to read from the non-existant RNG.
>
> Cheers,

I tried to solve this scenario by adding CRYPTO_ALG_DUP_FIRST:

diff --git a/drivers/crypto/hisilicon/trng/trng.c 
b/drivers/crypto/hisilicon/trng/trng.c
index ac74df4a9471..8baf0c959c29 100644
--- a/drivers/crypto/hisilicon/trng/trng.c
+++ b/drivers/crypto/hisilicon/trng/trng.c
@@ -218,6 +218,7 @@ static struct rng_alg hisi_trng_alg = {
.base = {
.cra_name = "stdrng",
.cra_driver_name = "hisi_stdrng",
+ .cra_flags = CRYPTO_ALG_DUP_FIRST,
.cra_priority = 300,
.cra_ctxsize = sizeof(struct hisi_trng_ctx),
.cra_module = THIS_MODULE,

but encountered a NULL pointer issue when unregistering the algorithm.

The log is as follows:

[ 621.533583] Unable to handle kernel NULL pointer dereference at 
virtual address 0000000000000008
[ 621.533585] Mem abort info:
[ 621.533586] ESR = 0x0000000096000044
[ 621.533587] EC = 0x25: DABT (current EL), IL = 32 bits
[ 621.533589] SET = 0, FnV = 0
[ 621.533590] EA = 0, S1PTW = 0
[ 621.533591] FSC = 0x04: level 0 translation fault
[ 621.533592] Data abort info:
[ 621.533593] ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[ 621.533595] CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[ 621.533596] GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 621.533597] user pgtable: 4k pages, 48-bit VAs, pgdp=0000082809aa9000
[ 621.533599] [0000000000000008] pgd=0000000000000000, p4d=0000000000000000
[ 621.533603] Internal error: Oops: 0000000096000044 [#1] SMP
[ 621.535681] Modules linked in: af_alg rfkill ipmi_si ipmi_devintf 
tpm_tis_spi arm_spe_pmu arm_smmuv3_pmu ipmi_ms ghandler tpm_tis_core 
coresight_tmc coresight_funnel coresight cppc_cpufreq fuse drm backlight 
hisi_hpre dh_generic ecdh_generic hisi_sec2 hisi_zip ecc sm3_ce hisi_qm 
spi_dw_mmio sha3_ce authenc uacce spidev hisi_trng_v2(-) spi_dw dm_mod ipv6
[ 621.649900] CPU: 0 UID: 0 PID: 9267 Comm: rmmod Kdump: loaded Not 
tainted 6.18.0-rc1-gd633730bb387-dirty #11 PRE EMPT
[ 621.660494] Hardware name: To be filled by O.E.M. To be filled by 
O.E.M./To be filled by O.E.M., BIOS HixxxxEVB V3.4.1 07/31/2025
[ 621.672127] pstate: a1400009 (NzCv daif +PAN -UAO -TCO +DIT -SSBS 
BTYPE=--)
[ 621.679075] pc : crypto_unregister_alg+0x6c/0x110
[ 621.683772] lr : crypto_unregister_alg+0x44/0x110
[ 621.688462] sp : ffff8000a6a4bc00
[ 621.691763] x29: ffff8000a6a4bc20 x28: ffff08209bb08000 x27: 
0000000000000000
[ 621.698885] x26: 0000000000000000 x25: 0000000000000000 x24: 
0000000000000000
[ 621.706008] x23: ffffb1ce18b79fa0 x22: ffff082085e77490 x21: 
ffffb1ce1885d100
[ 621.713130] x20: ffff8000a6a4bc08 x19: ffffb1cde59ed0e8 x18: 
ffffb1ce18d150f0
[ 621.720251] x17: 6c703d4d45545359 x16: ffffb1ce16334988 x15: 
0000000000000030
[ 621.727374] x14: 0000000000000004 x13: ffff082f97540000 x12: 
0000000000001a9d
[ 621.734496] x11: 00000000000008df x10: ffff082f97800000 x9 : 
ffff082f97540000
[ 621.741619] x8 : 00000000ffff7fff x7 : ffff082f97800000 x6 : 
80000000ffff8000
[ 621.748741] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 
000000000000022c
[ 621.755863] x2 : 0000000000000000 x1 : ffff8000a6a4bc08 x0 : 
ffffb1cde59ed0e8
[ 621.762986] Call trace:
[ 621.765419] crypto_unregister_alg+0x6c/0x110 (P)
[ 621.770110] crypto_unregister_rng+0x14/0x20
[ 621.774369] hisi_trng_remove+0x98/0xd8 [hisi_trng_v2]
[ 621.779495] platform_remove+0x20/0x30
[ 621.783233] device_remove+0x4c/0x80
[ 621.786797] device_release_driver_internal+0x1c8/0x224
[ 621.792009] driver_detach+0x4c/0x98
[ 621.795570] bus_remove_driver+0x6c/0xbc
[ 621.799480] driver_unregister+0x30/0x60
[ 621.803389] platform_driver_unregister+0x14/0x20
[ 621.808080] hisi_trng_driver_exit+0x18/0x794 [hisi_trng_v2]
[ 621.813725] __arm64_sys_delete_module+0x1c0/0x29c
[ 621.818505] invoke_syscall+0x48/0x10c
[ 621.822244] el0_svc_common.constprop.0+0xc0/0xe0
[ 621.826936] do_el0_svc+0x1c/0x28
[ 621.830239] el0_svc+0x34/0xec
[ 621.833283] el0t_64_sync_handler+0xa0/0xe4
[ 621.837453] el0t_64_sync+0x198/0x19c
[ 621.841104] Code: d2800002 aa1303e0 321b0063 b9002263 (f90004a4)
[ 621.847182] ---[ end trace 0000000000000000 ]---
[ 622.007363] pstore: backend (efi_pstore) writing error (-28)
faddr2line analysis indicates the error points to:
crypto_unregister_alg+0x6c/0x110:
__list_del at cryptodev-2.6/./include/linux/list.h:203
(inlined by) __list_del_entry at cryptodev-2.6/./include/linux/list.h:226
(inlined by) list_del_init at cryptodev-2.6/./include/linux/list.h:295
(inlined by) crypto_remove_alg at cryptodev-2.6/crypto/algapi.c:483
(inlined by) crypto_unregister_alg at cryptodev-2.6/crypto/algapi.c:495

The algorithm is duplicated by kmemdup before registration.

Should the duplicated algorithm be used during unregistration instead of 
the one passed by the driver?


Regards,
Chenghai

