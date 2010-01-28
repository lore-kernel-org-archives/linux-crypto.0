From: Bai Shuwei <baishuwei@gmail.com>
Subject: device driver for hardware encryption
Date: Thu, 28 Jan 2010 17:12:46 +0800
Message-ID: <f3566d61001280112i7d125852l1cd0a6b241ec33e3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:37096 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab0A1JMr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 28 Jan 2010 04:12:47 -0500
Received: by pwi21 with SMTP id 21so343401pwi.21
        for <linux-crypto@vger.kernel.org>; Thu, 28 Jan 2010 01:12:47 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi, ALl:
   When I add the hardware device driver for crypto, i get the bellow
error information. My kernel is 2.6.26

[  319.938873] BUG: scheduling while atomic: kcryptd/3676/0x00000002
[  319.938920] Pid: 3676, comm: kcryptd Tainted: P          2.6.26-2-amd64 #1
[  319.938922]
[  319.938922] Call Trace:
[  319.938926]  [<ffffffff80427cd4>] schedule+0x95/0x635
[  319.938934]  [<ffffffffa0eb629b>] :libfpga:fpga_dma_open+0xa5/0xab
[  319.938941]  [<ffffffffa0eb67ea>] :libfpga:fpga_dma_block_read+0x12b/0x167
[  319.938945]  [<ffffffff802461c5>] autoremove_wake_function+0x0/0x2e
[  319.938954]  [<ffffffffa039a248>] :dsi_aes:dsi_aes_crypt+0x1db/0x24b
[  319.938960]  [<ffffffffa03a832a>] :cbc:crypto_cbc_encrypt+0xe6/0x138
[  319.938964]  [<ffffffffa039e043>] :aes_generic:aes_encrypt+0x0/0x21
[  319.938980]  [<ffffffffa0384f6f>] :crypto_blkcipher:async_encrypt+0x35/0x3a
[  319.938986]  [<ffffffffa03eea0b>] :dm_crypt:crypt_convert+0x1de/0x261
[  319.938995]  [<ffffffffa03eec6e>] :dm_crypt:kcryptd_crypt+0x1e0/0x2c5
[  319.939007]  [<ffffffffa03eea8e>] :dm_crypt:kcryptd_crypt+0x0/0x2c5
[  319.939012]  [<ffffffff802430c8>] run_workqueue+0x82/0x111
[  319.939016]  [<ffffffff80243995>] worker_thread+0xd5/0xe0
[  319.939019]  [<ffffffff802461c5>] autoremove_wake_function+0x0/0x2e
[  319.939024]  [<ffffffff802438c0>] worker_thread+0x0/0xe0
[  319.939026]  [<ffffffff8024609f>] kthread+0x47/0x74
[  319.939030]  [<ffffffff8020cf28>] child_rip+0xa/0x12
[  319.939041]  [<ffffffff80246058>] kthread+0x0/0x74
[  319.939043]  [<ffffffff8020cf1e>] child_rip+0x0/0x12

I think it is happed when calling the
wait_event_interruptible(fdev->wait) routine, but i don't know how to
fix it. Hope can get you help. Thanks!

The encryption calling tree and irq handler tree showed in bellow

/* ecryption callint tree */
aes_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
|-->dsi_aes_crypt((unsigned int *)in, (unsigned int *) out);
   |-->do_crypt
      |-->down_interruptible(&fpga->sem)
           fpga_dma_block_write()
           |--> fpga_dma_block_transfer(base, pcie_addr, local_addr,
size, flag | FPGA_DMA_READ_FLAG); /*write data to hardware */
                |-->wait_event_interruptible(fdev->wait) /* waiting event*/
          up()

/* interrupt calling tree */
pci_fpga_handler(int irq, void *arg)
|-->schedule_work(&fpga.work);
   |-->fpga_work_task(struct work_struct *work)
        |--> spin_lock()         /*lock*/
               wake_up_interruptible(&fpga.wait); /**/
               spin_unlock_irqrestore(&fpga.lock, flags);

The fpga.work and fpga.wait define is

    init_waitqueue_head(&fpga.wait);
    INIT_WORK(&fpga.work, fpga_work_task);


Best Regards

Bai Shuwei

-- 
Love other people, as same as love yourself!
Don't think all the time, do it by your hands!

E-Mail: baishuwei@gmail.com
