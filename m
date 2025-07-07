Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9932B12C544;
	Mon,  7 Jul 2025 03:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751859191; cv=none; b=DO3rIZp9NYlPq7jaz0IR659fmk2R1q5WsKPJzNQuSUIPbNJarznm2jVNaUlRT7Q1cfG2UjJulKBcEcqK2Qgyrty/C1JKlfpYOA4ci5c9c+IMF0h7FRmcof1RHZ0mN25z3IwkYMwqs84brMXz8s8uYB9vfjx+4e9qGbhoeXDVg1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751859191; c=relaxed/simple;
	bh=e0q8nxNnmBzqWW8SBAa9LaqX4SUMxgP06U2FBY5+lwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sjD0yX2LGRfvs0ZEcpG3VBZH3XH4YV7u2iIAsE2RK5HGcqysSsavO17+/Ps4InO9fGOPzP+vtaoaNNsPPI2qWGft9J/GOWXRz3pnEYA7uyuCR1xdZx5XwReCkKgXcFhnE2ym5VjVEcpY28bRT6VRICmHv5d36EtLDTAEI9jb+ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=HCKd/aYl; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="HCKd/aYl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yYO7oFAcgLtcduhvrZUV+OOPnhvNYuC+oqbqOWaNQf0=; b=HCKd/aYlD1ZmSQmDgwQB7vsZQq
	P6zEIHrztWbKfE24/OdizeXxLvAEPSnEH7GpqPfUR6WsMUW+eu517RIMJqfrhK6nDYU676YJ7++d3
	dDXAxTbDiEF/0Kzy7assQb1L1PC1SxFnLNayqRHbWoxRW9tz4X+GFXkK23FLUu1C4INmVKNw8pFwm
	oK3YtRIINfnIM+rEC0WJxvWy4Z9ImTa8hgEB5hW8sm2tpKaXQT/64keG4GKp36lOcZrn62o9Qsufb
	0JdLlGFZ65pfSJI4JSL+m1TFj5J74dSiBSgmhdMfaFHWwYYpaqyUYdjknUl2y42kEdyd1vLe/Vl1o
	duYPj3FQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1uYcLp-004VcC-0v;
	Mon, 07 Jul 2025 11:33:02 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 07 Jul 2025 15:33:01 +1200
Date: Mon, 7 Jul 2025 15:33:01 +1200
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Mengbiao Xiong <xisme1998@gmail.com>
Cc: thomas.lendacky@amd.com, davem@davemloft.net, john.allen@amd.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] crypto: ccp - Fix crash when rebind ccp device for
 ccp.ko
Message-ID: <aGs_7eEgPCRXMtIW@gondor.apana.org.au>
References: <20250624065418.1743-1-xisme1998@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250624065418.1743-1-xisme1998@gmail.com>

On Tue, Jun 24, 2025 at 02:54:18PM +0800, Mengbiao Xiong wrote:
> When CONFIG_CRYPTO_DEV_CCP_DEBUGFS is enabled, rebinding
> the ccp device causes the following crash:
> 
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/unbind
> $ echo '0000:0a:00.2' > /sys/bus/pci/drivers/ccp/bind
> 
> [  204.976930] BUG: kernel NULL pointer dereference, address: 0000000000000098
> [  204.978026] #PF: supervisor write access in kernel mode
> [  204.979126] #PF: error_code(0x0002) - not-present page
> [  204.980226] PGD 0 P4D 0
> [  204.981317] Oops: Oops: 0002 [#1] SMP NOPTI
> ...
> [  204.997852] Call Trace:
> [  204.999074]  <TASK>
> [  205.000297]  start_creating+0x9f/0x1c0
> [  205.001533]  debugfs_create_dir+0x1f/0x170
> [  205.002769]  ? srso_return_thunk+0x5/0x5f
> [  205.004000]  ccp5_debugfs_setup+0x87/0x170 [ccp]
> [  205.005241]  ccp5_init+0x8b2/0x960 [ccp]
> [  205.006469]  ccp_dev_init+0xd4/0x150 [ccp]
> [  205.007709]  sp_init+0x5f/0x80 [ccp]
> [  205.008942]  sp_pci_probe+0x283/0x2e0 [ccp]
> [  205.010165]  ? srso_return_thunk+0x5/0x5f
> [  205.011376]  local_pci_probe+0x4f/0xb0
> [  205.012584]  pci_device_probe+0xdb/0x230
> [  205.013810]  really_probe+0xed/0x380
> [  205.015024]  __driver_probe_device+0x7e/0x160
> [  205.016240]  device_driver_attach+0x2f/0x60
> [  205.017457]  bind_store+0x7c/0xb0
> [  205.018663]  drv_attr_store+0x28/0x40
> [  205.019868]  sysfs_kf_write+0x5f/0x70
> [  205.021065]  kernfs_fop_write_iter+0x145/0x1d0
> [  205.022267]  vfs_write+0x308/0x440
> [  205.023453]  ksys_write+0x6d/0xe0
> [  205.024616]  __x64_sys_write+0x1e/0x30
> [  205.025778]  x64_sys_call+0x16ba/0x2150
> [  205.026942]  do_syscall_64+0x56/0x1e0
> [  205.028108]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [  205.029276] RIP: 0033:0x7fbc36f10104
> [  205.030420] Code: 89 02 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 8d 05 e1 08 2e 00 8b 00 85 c0 75 13 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 54 f3 c3 66 90 41 54 55 49 89 d4 53 48 89 f5
> 
> This patch sets ccp_debugfs_dir to NULL after destroying it in
> ccp5_debugfs_destroy, allowing the directory dentry to be
> recreated when rebinding the ccp device.
> 
> Tested on AMD Ryzen 7 1700X.
> 
> Fixes: 3cdbe346ed3f ("crypto: ccp - Add debugfs entries for CCP information")
> Signed-off-by: Mengbiao Xiong <xisme1998@gmail.com>
> ---
>  drivers/crypto/ccp/ccp-debugfs.c | 3 +++
>  1 file changed, 3 insertions(+)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
