From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC PATCH v2 30/32] kvm: svm: Add support for SEV DEBUG_ENCRYPT
 command
Date: Thu, 2 Mar 2017 10:18:27 -0500
Message-ID: <148846790758.2349.16768762953657853550.stgit__5651.82356299392$1488469080$gmane$org@brijesh-build-machine>
References: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: <simon.guinot@sequanux.org>, <linux-efi@vger.kernel.org>,
        <brijesh.singh@amd.com>, <kvm@vger.kernel.org>,
        <rkrcmar@redhat.com>, <matt@codeblueprint.co.uk>,
        <linux-pci@vger.kernel.org>, <linus.walleij@linaro.org>,
        <gary.hook@amd.com>, <linux-mm@kvack.org>,
        <paul.gortmaker@windriver.com>, <hpa@zytor.com>, <cl@linux.com>,
        <dan.j.williams@intel.com>, <aarcange@redhat.com>,
        <sfr@canb.auug.org.au>, <andriy.shevchenko@linux.intel.com>,
        <herbert@gondor.apana.org.au>, <bhe@redhat.com>,
        <xemul@parallels.com>, <joro@8bytes.org>, <x86@kernel.org>,
        <peterz@infradead.org>, <piotr.luc@intel.com>, <mingo@redhat.com>,
        <msalter@redhat.com>, <ross.zwisler@linux.intel.com>, <bp@suse.de>,
        <dyoung@redhat.com>, <thomas.lendacky@amd.com>, <jroedel@suse.de>,
        <keescook@chromium.org>, <arnd@arndb.de>, <toshi
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-co1nam03on0041.outbound.protection.outlook.com ([104.47.40.41]:15007
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753178AbdCBPfA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Mar 2017 10:35:00 -0500
In-Reply-To: <148846752022.2349.13667498174822419498.stgit@brijesh-build-machine>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The command copies a plain text into guest memory and encrypts it using
the VM encryption key. The command will be used for debug purposes
(e.g setting breakpoint through gdbserver)

Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/kvm/svm.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 87 insertions(+)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ce8819a..64899ed 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -6058,6 +6058,89 @@ static int sev_dbg_decrypt(struct kvm *kvm, struct kvm_sev_cmd *argp)
 	return ret;
 }
 
+static int sev_dbg_encrypt(struct kvm *kvm, struct kvm_sev_cmd *argp)
+{
+	void *data;
+	int len, ret, d_off;
+	struct page **inpages;
+	struct kvm_sev_dbg debug;
+	struct sev_data_dbg *encrypt;
+	unsigned long src_addr, dst_addr, npages;
+
+	if (!sev_guest(kvm))
+		return -ENOTTY;
+
+	if (copy_from_user(&debug, argp, sizeof(*argp)))
+		return -EFAULT;
+
+	if (debug.length > PAGE_SIZE)
+		return -EINVAL;
+
+	len = debug.length;
+	src_addr = debug.src_addr;
+	dst_addr = debug.dst_addr;
+
+	inpages = sev_pin_memory(dst_addr, PAGE_SIZE, &npages);
+	if (!inpages)
+		return -EFAULT;
+
+	encrypt = kzalloc(sizeof(*encrypt), GFP_KERNEL);
+	if (!encrypt) {
+		ret = -ENOMEM;
+		goto err_1;
+	}
+
+	data = (void *) get_zeroed_page(GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto err_2;
+	}
+
+	if ((len & 15) || (dst_addr & 15)) {
+		/* if destination address and length are not 16-byte
+		 * aligned then:
+		 * a) decrypt destination page into temporary buffer
+		 * b) copy source data into temporary buffer at correct offset
+		 * c) encrypt temporary buffer
+		 */
+		ret = __sev_dbg_decrypt_page(kvm, dst_addr, data, &argp->error);
+		if (ret)
+			goto err_3;
+		d_off = dst_addr & (PAGE_SIZE - 1);
+
+		if (copy_from_user(data + d_off,
+					(uint8_t *)debug.src_addr, len)) {
+			ret = -EFAULT;
+			goto err_3;
+		}
+
+		encrypt->length = PAGE_SIZE;
+		encrypt->src_addr = __psp_pa(data);
+		encrypt->dst_addr =  __sev_page_pa(inpages[0]);
+	} else {
+		if (copy_from_user(data, (uint8_t *)debug.src_addr, len)) {
+			ret = -EFAULT;
+			goto err_3;
+		}
+
+		d_off = dst_addr & (PAGE_SIZE - 1);
+		encrypt->length = len;
+		encrypt->src_addr = __psp_pa(data);
+		encrypt->dst_addr = __sev_page_pa(inpages[0]);
+		encrypt->dst_addr += d_off;
+	}
+
+	encrypt->handle = sev_get_handle(kvm);
+	ret = sev_issue_cmd(kvm, SEV_CMD_DBG_ENCRYPT, encrypt, &argp->error);
+err_3:
+	free_page((unsigned long)data);
+err_2:
+	kfree(encrypt);
+err_1:
+	sev_unpin_memory(inpages, npages);
+	return ret;
+}
+
 static int amd_memory_encryption_cmd(struct kvm *kvm, void __user *argp)
 {
 	int r = -ENOTTY;
@@ -6089,6 +6172,10 @@ static int amd_memory_encryption_cmd(struct kvm *kvm, void __user *argp)
 		r = sev_dbg_decrypt(kvm, &sev_cmd);
 		break;
 	}
+	case KVM_SEV_DBG_ENCRYPT: {
+		r = sev_dbg_encrypt(kvm, &sev_cmd);
+		break;
+	}
 	default:
 		break;
 	}
