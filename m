From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [linux-next:master 4796/5585] adf_vf_isr.c:undefined reference to
 `adf_enable_pf2vf_interrupts'
Date: Wed, 23 Dec 2015 06:49:58 -0800
Message-ID: <567AB496.2060707@intel.com>
References: <201512200824.Fu1YirHO%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: kbuild test robot <fengguang.wu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:24945 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752263AbbLWOx1 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 23 Dec 2015 09:53:27 -0500
In-Reply-To: <201512200824.Fu1YirHO%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
On 12/19/2015 04:24 PM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> head:   9379b045413ee30c88965e81d376af989ec32cf3
> commit: 1a72d3a6d1d9a08705546eba14f0390c565ccd24 [4796/5585] crypto: qat - move isr files to qat common so that they can be reused
> config: x86_64-randconfig-s4-12200710 (attached as .config)
> reproduce:
>         git checkout 1a72d3a6d1d9a08705546eba14f0390c565ccd24
>         # save the attached .config to linux build tree
>         make ARCH=x86_64 
> 
> All errors (new ones prefixed by >>):
> 
>    drivers/built-in.o: In function `adf_pf2vf_bh_handler':
>>> adf_vf_isr.c:(.text+0xdfb30b): undefined reference to `adf_enable_pf2vf_interrupts'
>    drivers/built-in.o: In function `adf_isr':
>>> adf_vf_isr.c:(.text+0xdfb38b): undefined reference to `adf_disable_pf2vf_interrupts'
> 
Thanks for reporting and sorry for delay. I'm on Holidays.
This should fix it.

---8<---

Fix random config build issue.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

---

diff --git a/drivers/crypto/qat/qat_common/adf_common_drv.h b/drivers/crypto/qat/qat_common/adf_common_drv.h
index c03e286..0e82ce3 100644
--- a/drivers/crypto/qat/qat_common/adf_common_drv.h
+++ b/drivers/crypto/qat/qat_common/adf_common_drv.h
@@ -106,8 +106,6 @@ int adf_dev_start(struct adf_accel_dev *accel_dev);
 int adf_dev_stop(struct adf_accel_dev *accel_dev);
 void adf_dev_shutdown(struct adf_accel_dev *accel_dev);
 
-void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
-void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 int adf_iov_putmsg(struct adf_accel_dev *accel_dev, u32 msg, u8 vf_nr);
 void adf_pf2vf_notify_restarting(struct adf_accel_dev *accel_dev);
 int adf_enable_vf2pf_comms(struct adf_accel_dev *accel_dev);
@@ -236,6 +234,8 @@ void adf_disable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				  uint32_t vf_mask);
 void adf_enable_vf2pf_interrupts(struct adf_accel_dev *accel_dev,
 				 uint32_t vf_mask);
+void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
+void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev);
 #else
 static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 {
@@ -245,5 +245,13 @@ static inline int adf_sriov_configure(struct pci_dev *pdev, int numvfs)
 static inline void adf_disable_sriov(struct adf_accel_dev *accel_dev)
 {
 }
+
+static inline void adf_enable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+}
+
+static inline void adf_disable_pf2vf_interrupts(struct adf_accel_dev *accel_dev)
+{
+}
 #endif
 #endif
