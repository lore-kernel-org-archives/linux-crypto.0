From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 119/123] (.text+0x7a3): multiple definition
 of `adf_isr_resource_free'
Date: Mon, 10 Aug 2015 13:00:02 -0700
Message-ID: <55C902C2.5040809@intel.com>
References: <201508110327.99r9RzJb%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:29165 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752498AbbHJUBG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 16:01:06 -0400
In-Reply-To: <201508110327.99r9RzJb%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/10/2015 12:36 PM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   9cfaf082b8775e9f99fa5f2e8b2ae0ca8baff785
> commit: dd0f368398ea100e34259bf812bc482e15c81991 [119/123] crypto: qat - Add qat dh895xcc VF driver
> config: i386-allyesconfig (attached as .config)
> reproduce:
>   git checkout dd0f368398ea100e34259bf812bc482e15c81991
>   # save the attached .config to linux build tree
>   make ARCH=i386 
> 
> All error/warnings (new ones prefixed by >>):
> 
>    drivers/crypto/qat/qat_dh895xccvf/built-in.o: In function `adf_isr_resource_free':
>>> >> (.text+0x7a3): multiple definition of `adf_isr_resource_free'
>    drivers/crypto/qat/qat_dh895xcc/built-in.o:(.text+0x5f9): first defined here
>    drivers/crypto/qat/qat_dh895xccvf/built-in.o: In function `adf_isr_resource_alloc':
>>> >> (.text+0x818): multiple definition of `adf_isr_resource_alloc'
>    drivers/crypto/qat/qat_dh895xcc/built-in.o:(.text+0x6d7): first defined here

---8<---

When both PF and VF drivers are build in linker complains about multiple
definition of adf_isr_resource_[alloc/free] functions.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
index 7bbf846..a9a27ef 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_dh895xccvf_hw_data.c
@@ -143,8 +143,8 @@ void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data)
 	hw_data->num_engines = ADF_DH895XCCIOV_MAX_ACCELENGINES;
 	hw_data->tx_rx_gap = ADF_DH895XCCIOV_RX_RINGS_OFFSET;
 	hw_data->tx_rings_mask = ADF_DH895XCCIOV_TX_RINGS_MASK;
-	hw_data->alloc_irq = adf_isr_resource_alloc;
-	hw_data->free_irq = adf_isr_resource_free;
+	hw_data->alloc_irq = adf_vf_isr_resource_alloc;
+	hw_data->free_irq = adf_vf_isr_resource_free;
 	hw_data->enable_error_correction = adf_vf_void_noop;
 	hw_data->init_admin_comms = adf_vf_int_noop;
 	hw_data->exit_admin_comms = adf_vf_void_noop;
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
index 041d2a0..e270e4a 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_drv.h
@@ -51,7 +51,7 @@
 
 void adf_init_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
 void adf_clean_hw_data_dh895xcciov(struct adf_hw_device_data *hw_data);
-int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
-void adf_isr_resource_free(struct adf_accel_dev *accel_dev);
+int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev);
+void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev);
 void adf_update_ring_arb_enable(struct adf_etr_ring_data *ring);
 #endif
diff --git a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
index 7fdc84a..87c5d8a 100644
--- a/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
+++ b/drivers/crypto/qat/qat_dh895xccvf/adf_isr.c
@@ -226,7 +226,7 @@ static void adf_cleanup_bh(struct adf_accel_dev *accel_dev)
 	tasklet_kill(&priv_data->banks[0].resp_handler);
 }
 
-void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
+void adf_vf_isr_resource_free(struct adf_accel_dev *accel_dev)
 {
 	struct pci_dev *pdev = accel_to_pci_dev(accel_dev);
 
@@ -237,7 +237,7 @@ void adf_isr_resource_free(struct adf_accel_dev *accel_dev)
 	adf_disable_msi(accel_dev);
 }
 
-int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
+int adf_vf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 {
 	if (adf_enable_msi(accel_dev))
 		goto err_out;
@@ -253,6 +253,6 @@ int adf_isr_resource_alloc(struct adf_accel_dev *accel_dev)
 
 	return 0;
 err_out:
-	adf_isr_resource_free(accel_dev);
+	adf_vf_isr_resource_free(accel_dev);
 	return -EFAULT;
 }
