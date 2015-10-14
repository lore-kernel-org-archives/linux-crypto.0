From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] crypto: Allow drivers to build if COMPILE_TEST is enabled
Date: Wed, 14 Oct 2015 16:17:41 +0200
Message-ID: <561E6405.7050905@osg.samsung.com>
References: <1444743760-15155-1-git-send-email-javier@osg.samsung.com>
 <201510140540.8v7D383Q%fengguang.wu@intel.com>
 <20151014140803.GA17261@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
	Luis de Bethencourt <luisbg@osg.samsung.com>,
	linux-crypto@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	kbuild test robot <lkp@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:53127 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164AbbJNORw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 14 Oct 2015 10:17:52 -0400
In-Reply-To: <20151014140803.GA17261@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

On 10/14/2015 04:08 PM, Herbert Xu wrote:
> On Wed, Oct 14, 2015 at 05:03:30AM +0800, kbuild test robot wrote:
>> Hi Javier,
>>
>> [auto build test WARNING on cryptodev/master -- if it's inappropriate base, please suggest rules for selecting the more suitable base]
> 
> Javier, please make sure these warnings are fixed before you enable
> COMPILE_TEST.
>

Yes, I will. I built tested on arm32 and x86 before posting the patch
but forgot about sparse.

Getting more build coverage for the drivers will likely lead to new
build warnings like the one reported by Fengguang so I wonder if should
just desist in enabling COMPILE_TEST for drivers since I would not be
able to test in every possible setup.

On the other hand, I guess the fact that there are issues found, shows
the usefulness of COMPILE_TEST.

> Thanks,
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
