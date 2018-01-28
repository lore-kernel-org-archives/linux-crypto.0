From: Rui Miguel Silva <rui.silva@linaro.org>
Subject: Re: [RESEND PATCH 3/6] ARM: dts: imx7s: add CAAM device node
Date: Sun, 28 Jan 2018 15:42:32 +0000
Message-ID: <m3607m2dnb.fsf@linaro.org>
References: <1516805435-15034-4-git-send-email-pure.logic@nexus-software.ie> <201801272345.TyvgLQ8s%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: kbuild-all@01.org, horia.geanta@nxp.com, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        fabio.estevam@nxp.com, peng.fan@nxp.com,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        lukas.auer@aisec.fraunhofer.de, rui.silva@linaro.org,
        ryan.harkin@linaro.org,
        Bryan O'Donoghue <pure.logic@nexus-software.ie>
To: kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:39440 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751733AbeA1Pmg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 28 Jan 2018 10:42:36 -0500
Received: by mail-wr0-f194.google.com with SMTP id f6so2917929wra.6
        for <linux-crypto@vger.kernel.org>; Sun, 28 Jan 2018 07:42:35 -0800 (PST)
In-reply-to: <201801272345.TyvgLQ8s%fengguang.wu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
Thanks for the report.
On Sat 27 Jan 2018 at 15:49, kbuild test robot wrote:
> Hi Rui,
>
> I love your patch! Yet something to improve:
>
> [auto build test ERROR on crypto/master]
> [also build test ERROR on v4.15-rc9 next-20180126]
> [cannot apply to cryptodev/master]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Bryan-O-Donoghue/Enable-CAAM-on-i-MX7s-fix-TrustZone-issues/20180127-185422
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git master
> config: arm-u8500_defconfig (attached as .config)
> compiler: arm-linux-gnueabi-gcc (Debian 7.2.0-11) 7.2.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=arm 
>
> Note: the linux-review/Bryan-O-Donoghue/Enable-CAAM-on-i-MX7s-fix-TrustZone-issues/20180127-185422 HEAD f907a172373d2c61dd7bf25a88621abc6e410f15 builds fine.
>       It only hurts bisectibility.

Yeah, the order of the patches in the series were wrong and break
bisectibility.

V2 of this series already sent, besides other fixes, also fix this.
Once again many thanks.

---
Cheers,
	Rui
