From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [cryptodev:master 119/123] warning: (CRYPTO_DEV_QAT_DH895xCCVF)
 selects PCI_IOV which has unmet direct dependencies (PCI)
Date: Mon, 10 Aug 2015 10:44:09 -0700
Message-ID: <55C8E2E9.8000509@intel.com>
References: <201508110049.yV4f3Yls%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:45092 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932271AbbHJRpQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 10 Aug 2015 13:45:16 -0400
In-Reply-To: <201508110049.yV4f3Yls%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/10/2015 09:24 AM, kbuild test robot wrote:
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   9cfaf082b8775e9f99fa5f2e8b2ae0ca8baff785
> commit: dd0f368398ea100e34259bf812bc482e15c81991 [119/123] crypto: qat - Add qat dh895xcc VF driver
> config: mips-allyesconfig (attached as .config)
> reproduce:
>   wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>   chmod +x ~/bin/make.cross
>   git checkout dd0f368398ea100e34259bf812bc482e15c81991
>   # save the attached .config to linux build tree
>   make.cross ARCH=mips 
> 
> All warnings (new ones prefixed by >>):
> 
> warning: (CRYPTO_DEV_QAT_DH895xCCVF) selects PCI_IOV which has unmet direct dependencies (PCI)
---8<---

Fix unmet direct dependencies for QAT_DH895xCCVF

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

diff --git a/drivers/crypto/qat/Kconfig b/drivers/crypto/qat/Kconfig
index 95a9566..6d1d107 100644
--- a/drivers/crypto/qat/Kconfig
+++ b/drivers/crypto/qat/Kconfig
@@ -24,6 +24,7 @@ config CRYPTO_DEV_QAT_DH895xCC
 
 config CRYPTO_DEV_QAT_DH895xCCVF
 	tristate "Support for Intel(R) DH895xCC Virtual Function"
+	select PCI
 	select PCI_IOV
 
 	help
