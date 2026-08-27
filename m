Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFB833F5BE
	for <linux-crypto@vger.kernel.org>; Thu, 27 Aug 2026 07:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814454; cv=none; b=M3ghChBjgjvLvSZpbwN4mVMeEUwYBd7ibWWJhP0kSfWqLWi2AnzIiRCVt5UrXB0sq2CPjlEU6yoglNvq542vuTM4fz1VsQmJsS3A5s0xLcIuyCdCCSLYDayj8/KEoSpcwOVjCiDcUyK0M5mgdYoHBYA8zNEX94AUqos3ZjF7GaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814454; c=relaxed/simple;
	bh=NYdl39J8PFJLQqPVxWoZ48WTDu1KlH7JMxY8On2/8LM=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OI1uiMS+qCfTFitJCsA2XE2n3T1GwXmaKz5tQhIgxA+OxYgnpOhIXKtEnHA8n2tKfHm9JL7BBImrUlHYrgh3sBKBQlhCZ1hqYJCuTYIH1CGlAAiB2XpFhauQZNNIQrUAdNds06YE07uip0y4XbVeI9Yv+7XL6XoBY6VP8fLabu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=Z0XFCTge; arc=none smtp.client-ip=113.46.200.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="Z0XFCTge"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=VhFh5ljgGCSfIu1nswzIhxNL6fMTFTwzByLdPH57qL4=;
	b=Z0XFCTgeBP7J3/J7XTl05sD2BhWRVQhijidzT8p6JRzg9BcpJX+KdoyYV1bEgI/GCIKSyArYv
	2/JpmacMWQdCOX7ZDkUEDd8BRClzEG7bW2e9hthHJUe8PB6mtZGhSc9+hT0cJLQUrxjeCgyiZg6
	eZyD4hhoI0P00ZqWy+7QAc0=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4hVskb6KflzRhVJ;
	Thu, 27 Aug 2026 14:56:39 +0800 (CST)
Received: from dggpemf500015.china.huawei.com (unknown [7.185.36.143])
	by mail.maildlp.com (Postfix) with ESMTPS id 2407640538;
	Thu, 27 Aug 2026 15:07:24 +0800 (CST)
Received: from [10.67.121.110] (10.67.121.110) by
 dggpemf500015.china.huawei.com (7.185.36.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Aug 2026 15:07:23 +0800
Subject: Re: [BUG] crypto: hisilicon/hpre: RSA request never completes during
 signed module verification on Kunpeng arm64
To: Evanshenf <archwse@gmail.com>, <linux-crypto@vger.kernel.org>
CC: Weili Qian <qianweili@huawei.com>, Zhou Wang <wangzhou1@hisilicon.com>,
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
	<davem@davemloft.net>
References: <178779980745.730913.5616603289665364629.hisi-hpre-7980@gmail.com>
From: liulongfang <liulongfang@huawei.com>
Message-ID: <5ec5464b-a84d-48c4-6ef7-d60944ae94a9@huawei.com>
Date: Thu, 27 Aug 2026 15:07:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <178779980745.730913.5616603289665364629.hisi-hpre-7980@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf500015.china.huawei.com (7.185.36.143)

On 2026/8/27 11:03, Evanshenf wrote:
> Hello,
> 
> I observed a permanently stuck RSA request in the HiSilicon HPRE driver
> while a signed kernel module was being verified on a Kunpeng ARM64 server.
> The lost completion subsequently blocked module loading and all PVE API
> workers which invoked ss(8).
> 
> This was observed with a Proxmox kernel rather than a vanilla upstream
> kernel.  I have not yet reproduced it on a mainline build, but the relevant
> HPRE and rsassa-pkcs1 paths appear unchanged in current upstream source.
> 
> Environment:
> 
>   architecture: arm64
>   CPU: TaiShan-v120 (Kunpeng)
>   system product: J353 G3
>   HPRE PCI ID: 19e5:a258 (four PFs)
>   kernel: 7.0.14-6-pve
>   kernel package: proxmox-kernel-7.0.14-6-pve-signed 7.0.14-6
>   CONFIG_MODULE_SIG=y
>   Secure Boot: disabled
> 
> Trigger and impact:
> 
> PVE executed:
> 
>   /bin/ss -Htln sport = 5900
> 
> This requested net-pf-16-proto-4-type-2, which resolves to inet_diag.
> Verification of the signed inet_diag module selected HPRE because the
> registered algorithms were:
> 
>   pkcs1(hpre-rsa,sha512) priority 1000
>   hpre-rsa                priority 1000
>   rsa-generic             priority 100
> 
> The first modprobe has remained in uninterruptible sleep for more than ten
> hours.  Its stack is:
> 
>   rsassa_pkcs1_verify+0x284/0x3a0
>   public_key_verify_signature+0x1e4/0x2b0
>   public_key_verify_signature_2+0x20/0x48
>   verify_signature+0x48/0xc0
>   pkcs7_validate_trust+0x23c/0x300
>   verify_pkcs7_message_sig+0x10c/0x190
>   verify_pkcs7_signature+0x78/0xe0
>   mod_verify_sig+0xac/0x150
>   module_sig_check+0x104/0x190
>   load_module+0x48/0x2a68
>   init_module_from_file+0x110/0x168
>   __arm64_sys_finit_module+0x220/0x398
> 
> All later ss processes became blocked in call_usermodehelper_exec() while
> waiting for the same module request.  This exhausted all three pvedaemon
> workers and caused PVE API login requests to time out with HTTP 596.
> 
> HPRE debugfs counters isolate the lost completion to one PF:
> 
>   0000:3a:00.0 send=3  recv=3
>   0000:3e:00.0 send=25 recv=25
>   0000:7a:00.0 send=1  recv=0
>   0000:7e:00.0 send=1  recv=1
>

Hello!

We have received your report and have initiated internal analysis. Since we
do not have access to your Proxmox kernel, we are using the open-source
kernel 7.0.14 for analysis and testing. If you suspect this is an alignment
issue, you could try modifying and verifying it.

Thanks.

> For 0000:7a:00.0, send_busy_cnt, send_fail_cnt, invalid_req_cnt,
> abnormal_irq, aeq_irq, err_irq and dev_timeout are all zero.  The QM status
> still reports "work".  Its completion IRQ vector has received zero
> interrupts; the assigned CPU is online.
> 
> The signed kernel package passes dpkg verification.  hisi_hpre is not in
> the initramfs and is loaded automatically through the PCI modalias.  It is
> not exposed through UACCE and is not passed through to a VM.
> 
> Possible cause:
> 
> hpre_hw_data_init() directly maps a single full-size RSA scatterlist with
> dma_map_single() through hpre_get_data_dma_addr(), without checking the
> DMA/cacheline alignment.  rsassa_pkcs1_verify() uses the same scatterlist
> as both source and destination for the child akcipher request.
> 
> HPRE already has hpre_prepare_dma_buf(), which allocates a coherent bounce
> buffer, but the full-size RSA path bypasses it.  This resembles the recent
> rsassa-pkcs1 alignment discussion, where it was noted that the underlying
> accelerator driver must handle unaligned buffers:
> 
>   https://lore.kernel.org/linux-crypto/20260731024446.786329-1-changwei.zou@canonical.com/
> 
> I cannot prove from the current stuck system that alignment is the only
> cause, so this is a hypothesis rather than a conclusion.  Independently,
> hpre_is_bd_timeout() only records elapsed time after a response callback;
> it cannot recover a request whose completion never arrives.  The synchronous
> crypto waiter therefore remains blocked indefinitely.
> 
> The production workaround is to blacklist hisi_hpre and reboot, which
> causes signed-module verification to use rsa-generic.  The current request
> cannot be killed or recovered without rebooting.
> 
> Would forcing unaligned or in-place RSA requests through the existing
> coherent bounce-buffer path be an appropriate first fix?  Is there an
> existing HPRE/QM recovery mechanism that can safely time out the request,
> reset the affected queue, and complete or fall back to software without a
> late-callback use-after-free risk?
> 
> The corresponding Proxmox report, including a sanitized diagnostic
> attachment, is available here:
> 
>   https://bugzilla.proxmox.com/show_bug.cgi?id=7980
> 
> Please let me know if a mainline reproduction, additional HPRE registers,
> or testing of a candidate patch would be useful.  The affected production
> host is currently being kept unchanged so that more read-only evidence can
> still be collected before the maintenance reboot.
> 
> Regards,
> Evanshenf
> GitHub: https://github.com/Evanshenf
> 
> .
> 
