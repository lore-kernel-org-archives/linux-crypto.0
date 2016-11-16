From: Arnd Bergmann <arnd@arndb.de>
Subject: crypto: caam warning fix, was: master build: 0 failures 1 warnings (v4.9-rc5-177-g81bcfe5)
Date: Wed, 16 Nov 2016 17:40:41 +0100
Message-ID: <5255539.MpGQJX1bep@wuerfel>
References: <E1c6kSQ-0008UC-DM@optimist>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Build bot for Mark Brown <broonie@kernel.org>,
        kernel-build-reports@lists.linaro.org,
        Horia =?utf-8?B?R2VhbnTEgw==?= <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org
To: linaro-kernel@lists.linaro.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.131]:53753 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932201AbcKPQk6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Nov 2016 11:40:58 -0500
In-Reply-To: <E1c6kSQ-0008UC-DM@optimist>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tuesday, November 15, 2016 8:35:54 PM CET Build bot for Mark Brown wrote:
> Tree/Branch: master
> Git describe: v4.9-rc5-177-g81bcfe5
> Commit: 81bcfe5e48 Merge tag 'trace-v4.9-rc5' of git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace
> 
> Build Time: 87 min 40 sec
> 
> Passed:   10 / 10   (100.00 %)
> Failed:    0 / 10   (  0.00 %)
> 
> Errors: 0
> Warnings: 1
> Section Mismatches: 0
> 
> -------------------------------------------------------------------------------
> defconfigs with issues (other than build errors):
>       1 warnings    0 mismatches  : arm64-allmodconfig
> 
> -------------------------------------------------------------------------------
> 
> Warnings Summary: 1
> 	  1 ../include/linux/kernel.h:739:16: warning: comparison of distinct pointer types lacks a cast
> 

Hi Herbert,

This is currently the only build warning reported for v4.9, and you have merged
the fix for v4.10 in

d69985a07692 ("crypto: caam - fix type mismatch warning")

Any chance you can send this for v4.9 so we have a clean build?

Thanks,

	Arnd
