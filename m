From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [3.12-rc1] Dependency on module-init-tools >= 3.11 ?
Date: Thu, 12 Sep 2013 19:20:23 +0900
Message-ID: <201309121920.AHJ58678.OMVJFFSHOtOFQL@I-love.SAKURA.ne.jp>
References: <201307201456.JIC35412.VFOMFJOQLOtHFS@I-love.SAKURA.ne.jp>
	<201309112043.HBD04609.FOtLSOFVQHFOJM@I-love.SAKURA.ne.jp>
	<20130912042622.GA15181@gondor.apana.org.au>
	<201309121403.FIH09821.JtLOVOSFOFHFQM@I-love.SAKURA.ne.jp>
	<20130912052806.GA15737@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: andr345@gmail.com, rusty@rustcorp.com.au,
	linux-kernel@vger.kernel.org, arthur.marsh@internode.on.net,
	tim.c.chen@linux.intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www262.sakura.ne.jp ([202.181.97.72]:53874 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755396Ab3ILKUy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 12 Sep 2013 06:20:54 -0400
In-Reply-To: <20130912052806.GA15737@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
> The trouble is not all distros will include the softdep modules in
> the initramfs.  So for now I think we will have to live with a fallback.

I see.

Herbert Xu wrote:
> OK, can you please try this patch on top of the current tree?
> 
> This way at least you'll have a working system until your initramfs
> tool is fixed to do the right thing.

I tested the patch and confirmed that the boot failure was solved.

But arch/x86/crypto/crct10dif-pclmul.ko is not included into initramfs and
therefore we cannot benefit from PCLMULQDQ version.

---------- before applying patch ----------
kernel/arch/x86/crypto/crct10dif-pclmul.ko: kernel/crypto/crct10dif.ko
kernel/crypto/crct10dif.ko:
kernel/drivers/scsi/lpfc/lpfc.ko: kernel/drivers/scsi/scsi_transport_fc.ko kernel/drivers/scsi/scsi_tgt.ko kernel/lib/crc-t10dif.ko
kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko
kernel/drivers/scsi/scsi_debug.ko: kernel/lib/crc-t10dif.ko
kernel/lib/crc-t10dif.ko:
---------- before applying patch ----------

---------- after applying patch ----------
kernel/arch/x86/crypto/crct10dif-pclmul.ko: kernel/crypto/crct10dif_common.ko
kernel/crypto/crct10dif_common.ko:
kernel/crypto/crct10dif_generic.ko: kernel/crypto/crct10dif_common.ko
kernel/drivers/scsi/lpfc/lpfc.ko: kernel/drivers/scsi/scsi_transport_fc.ko kernel/drivers/scsi/scsi_tgt.ko kernel/lib/crc-t10dif.ko kernel/crypto/crct10dif_common.ko
kernel/drivers/scsi/sd_mod.ko: kernel/lib/crc-t10dif.ko kernel/crypto/crct10dif_common.ko
kernel/drivers/scsi/scsi_debug.ko: kernel/lib/crc-t10dif.ko kernel/crypto/crct10dif_common.ko
kernel/lib/crc-t10dif.ko: kernel/crypto/crct10dif_common.ko
---------- after applying patch ----------
