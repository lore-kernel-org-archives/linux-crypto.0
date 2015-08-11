From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 119/123] warning: (CRYPTO_DEV_QAT_DH895xCCVF)
 selects PCI_IOV which has unmet direct dependencies (PCI)
Date: Tue, 11 Aug 2015 11:05:37 -0700
Message-ID: <55CA3971.5070008@intel.com>
References: <201508110049.yV4f3Yls%fengguang.wu@intel.com> <55C8E2E9.8000509@intel.com> <20150811135738.GA30846@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:9592 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932120AbbHKSG7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Aug 2015 14:06:59 -0400
In-Reply-To: <20150811135738.GA30846@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/11/2015 06:57 AM, Herbert Xu wrote:
> On Mon, Aug 10, 2015 at 10:44:09AM -0700, Tadeusz Struk wrote:
>> >
>> >  config CRYPTO_DEV_QAT_DH895xCCVF
>> >  	tristate "Support for Intel(R) DH895xCC Virtual Function"
>> > +	select PCI
>> >  	select PCI_IOV
> Wouldn't a dependency on PCI make more sense? Or does this not
> work?

Yes, you are right. This is how it is in the PF config.
It also needs to select the qat common code.

---8<---
Fix unmet direct dependencies for QAT_DH895xCCVF

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 95a9566..eefccf7 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -24,7 +24,9 @@ config CRYPTO_DEV_QAT_DH895xCC
 
 config CRYPTO_DEV_QAT_DH895xCCVF
 	tristate "Support for Intel(R) DH895xCC Virtual Function"
+	depends on X86 && PCI
 	select PCI_IOV
+	select CRYPTO_DEV_QAT
 
 	help
 	  Support for Intel(R) DH895xcc with Intel(R) QuickAssist Technology
