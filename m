Return-Path: <SRS0=g7fO=NJ=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbeJ2WTv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Oct 2018 18:19:51 -0400
From: AnilKumar Chimata <anilc@codeaurora.org>
Subject: Re: [PATCH 3/3] crypto: qce: ice: Add support for Inline Crypto
 Engine
To: Rob Herring <robh@kernel.org>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org,
        andy.gross@linaro.org, david.brown@linaro.org,
        mark.rutland@arm.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-soc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1539789476-6098-4-git-send-email-anilc@codeaurora.org>
 <201810181902.44DQrfDL%fengguang.wu@intel.com>
 <d6f1930a618f6539a4c3e53d239fdd90@codeaurora.org>
 <20181025145841.GB30244@bogus>
Message-ID: <15fe7675-cef7-3e39-cedc-b09fbcf1a4af@codeaurora.org>
Date: Mon, 29 Oct 2018 19:01:03 +0530
MIME-Version: 1.0
In-Reply-To: <20181025145841.GB30244@bogus>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Rob,

Thanks for the review,

On 2018-10-25 20:28, Rob Herring wrote:
> On Wed, Oct 24, 2018 at 04:44:37PM +0530, anilc@codeaurora.org wrote:
>> Hi,
>> 
>> Thanks for the comments, response inline.
> 
> FYI, this was from a bot.

I have realized after I sent the mail.

> 
>> 
>> Thanks,
>> AnilKumar
>> 
>> 
>> On 2018-10-18 17:13, kbuild test robot wrote:
>> > Hi AnilKumar,
>> >
>> > Thank you for the patch! Yet something to improve:
>> >
>> > [auto build test ERROR on cryptodev/master]
>> > [also build test ERROR on v4.19-rc8 next-20181018]
>> > [if your patch is applied to the wrong git tree, please drop us a note
>> > to help improve the system]
>> >
>> > url:
>> > https://github.com/0day-ci/linux/commits/AnilKumar-Chimata/firmware-qcom-scm-Update-qcom_scm_call-signature/20181018-182318
>> > base:
>> > https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git
>> > master
>> > config: sh-allmodconfig (attached as .config)
>> > compiler: sh4-linux-gnu-gcc (Debian 7.2.0-11) 7.2.0
>> > reproduce:
>> >         wget
>> > https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross
>> > -O ~/bin/make.cross
>> >         chmod +x ~/bin/make.cross
>> >         # save the attached .config to linux build tree
>> >         GCC_VERSION=7.2.0 make.cross ARCH=sh
>> >
>> > All errors (new ones prefixed by >>):
>> >
>> > > > drivers/crypto/qce/ice.c:1372:5: error: redefinition of
>> > > > 'qcom_ice_setup_ice_hw'
>> >     int qcom_ice_setup_ice_hw(const char *storage_type, int enable)
>> >         ^~~~~~~~~~~~~~~~~~~~~
>> >    In file included from drivers/crypto/qce/ice.c:25:0:
>> >    include/crypto/ice.h:60:19: note: previous definition of
>> > 'qcom_ice_setup_ice_hw' was here
>> >     static inline int qcom_ice_setup_ice_hw(const char *storage_type,
>> > int enable)
>> >                       ^~~~~~~~~~~~~~~~~~~~~
>> >
>> > vim +/qcom_ice_setup_ice_hw +1372 drivers/crypto/qce/ice.c
>> >
>> >   1371
>> > > 1372	int qcom_ice_setup_ice_hw(const char *storage_type, int enable)
>> >   1373	{
>> >   1374		struct ice_device *ice_dev = NULL;
>> >   1375		int ret = -1;
>> >   1376
>> >   1377		ice_dev = get_ice_device_from_storage_type(storage_type);
>> >   1378		if (ice_dev == ERR_PTR(-EPROBE_DEFER))
>> >   1379			return -EPROBE_DEFER;
>> >   1380
>> >   1381		if (!ice_dev)
>> >   1382			return ret;
>> >   1383
>> >   1384		if (enable)
>> >   1385			return enable_ice_setup(ice_dev);
>> >   1386
>> >   1387		return disable_ice_setup(ice_dev);
>> >   1388	}
>> >   1389
>> 
>> We will check and get back on the compilation. What is the idea behind 
>> for
>> this
>> effort, is this for testing the ICE driver?
> 
> The purpose is to make sure changes don't break builds that you likely
> haven't tested. Either different architectures or configurations.

Got the point, will try to avoid this in future.

> 
> Rob
