From: Gary R Hook <ghook@amd.com>
Subject: Re: [cryptodev:master 56/59] warning: (RAPIDIO_DMA_ENGINE && ..)
 selects DMA_ENGINE which has unmet direct dependencies (DMADEVICES)
Date: Wed, 20 Apr 2016 09:57:16 -0500
Message-ID: <571798CB.1000200@amd.com>
References: <201604201852.NtqZ4byz%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au >> Herbert Xu"
	<herbert@gondor.apana.org.au>
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bn1on0099.outbound.protection.outlook.com ([157.56.110.99]:26448
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753227AbcDTO5c (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 20 Apr 2016 10:57:32 -0400
In-Reply-To: <201604201852.NtqZ4byz%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/20/2016 05:35 AM, kbuild test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> head:   21ec757d2dd8650f978d27ad53cb1fcca8bb5e2b
> commit: 58ea8abf490415c390e0cc671e875510c9b66318 [56/59] crypto: ccp - Register the CCP as a DMA resource
> config: i386-randconfig-x018-201616 (attached as .config)
> reproduce:
>          git checkout 58ea8abf490415c390e0cc671e875510c9b66318
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All warnings (new ones prefixed by >>):
>
> warning: (RAPIDIO_DMA_ENGINE && SND_SOC_SH4_SIU && CRYPTO_DEV_CCP_DD) selects DMA_ENGINE which has unmet direct dependencies (DMADEVICES)

I have sent a separate patch that appears to fix the 3 krobot problems. 
Apologies if I do not have the protocol correct.

Gary
