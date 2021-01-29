Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A85EC433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:08:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1094764E02
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Jan 2021 05:08:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbhA2FHy (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Jan 2021 00:07:54 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:55860 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229463AbhA2FHy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Jan 2021 00:07:54 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l5Lyi-00027x-FU; Fri, 29 Jan 2021 16:05:53 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 29 Jan 2021 16:05:52 +1100
Date:   Fri, 29 Jan 2021 16:05:52 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, nicolas.ferre@microchip.com,
        alexandre.belloni@bootlin.com, ludovic.desroches@microchip.com,
        jesper.nilsson@axis.com, lars.persson@axis.com,
        horia.geanta@nxp.com, aymen.sghaier@nxp.com, gcherian@marvell.com,
        thomas.lendacky@amd.com, john.allen@amd.com, gilad@benyossef.com,
        bbrezillon@kernel.org, arno@natisbad.org, schalla@marvell.com,
        matthias.bgg@gmail.com, jamie@jamieiles.com,
        giovanni.cabiddu@intel.com, heiko@sntech.de, krzk@kernel.org,
        vz@mleia.com, k.konieczny@samsung.com,
        linux-crypto@vger.kernel.org, linux-mediatek@lists.infradead.org,
        qat-linux@intel.com, linux-rockchip@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        Allen Pais <apais@linux.microsoft.com>,
        Romain Perier <romain.perier@gmail.com>
Subject: Re: [PATCH v4 01/19] crypto: amcc: convert tasklets to use new
 tasklet_setup() API
Message-ID: <20210129050551.GA5586@gondor.apana.org.au>
References: <20210121044126.152274-1-allen.lkml@gmail.com>
 <20210121044126.152274-2-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210121044126.152274-2-allen.lkml@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 21, 2021 at 10:11:08AM +0530, Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> In preparation for unconditionally passing the
> struct tasklet_struct pointer to all tasklet
> callbacks, switch to using the new tasklet_setup()
> and from_tasklet() to pass the tasklet pointer explicitly.
> 
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> Signed-off-by: Allen Pais <apais@linux.microsoft.com>
> ---
>  drivers/crypto/amcc/crypto4xx_core.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

This doesn't even compile:

  CC [M]  drivers/crypto/amcc/crypto4xx_core.o
  CC [M]  drivers/crypto/amcc/crypto4xx_alg.o
  CC [M]  drivers/crypto/amcc/crypto4xx_trng.o
  CHECK   ../drivers/crypto/amcc/crypto4xx_trng.c
../drivers/crypto/amcc/crypto4xx_core.c: In function ‘crypto4xx_cipher_done’:
../drivers/crypto/amcc/crypto4xx_core.c:526:13: warning: variable ‘addr’ set but not used [-Wunused-but-set-variable]
  dma_addr_t addr;
             ^~~~
../drivers/crypto/amcc/crypto4xx_core.c: In function ‘crypto4xx_ahash_done’:
../drivers/crypto/amcc/crypto4xx_core.c:557:24: warning: variable ‘ctx’ set but not used [-Wunused-but-set-variable]
  struct crypto4xx_ctx *ctx;
                        ^~~
In file included from <command-line>:
../drivers/crypto/amcc/crypto4xx_core.c: In function ‘crypto4xx_bh_tasklet_cb’:
../include/linux/kernel.h:694:51: error: ‘struct device’ has no member named ‘tasklet’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                                                   ^~
./../include/linux/compiler_types.h:306:9: note: in definition of macro ‘__compiletime_assert’
   if (!(condition))     \
         ^~~~~~~~~
./../include/linux/compiler_types.h:326:2: note: in expansion of macro ‘_compiletime_assert’
  _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
  ^~~~~~~~~~~~~~~~~~~
../include/linux/build_bug.h:39:37: note: in expansion of macro ‘compiletime_assert’
 #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
                                     ^~~~~~~~~~~~~~~~~~
../include/linux/kernel.h:694:2: note: in expansion of macro ‘BUILD_BUG_ON_MSG’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
  ^~~~~~~~~~~~~~~~
../include/linux/kernel.h:694:20: note: in expansion of macro ‘__same_type’
  BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) && \
                    ^~~~~~~~~~~
../include/linux/interrupt.h:646:2: note: in expansion of macro ‘container_of’
  container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
  ^~~~~~~~~~~~
../drivers/crypto/amcc/crypto4xx_core.c:1078:23: note: in expansion of macro ‘from_tasklet’
  struct device *dev = from_tasklet(dev, t, tasklet);
                       ^~~~~~~~~~~~
./../include/linux/compiler_types.h:146:35: error: ‘struct device’ has no member named ‘tasklet’
 #define __compiler_offsetof(a, b) __builtin_offsetof(a, b)
                                   ^~~~~~~~~~~~~~~~~~
../include/linux/stddef.h:17:32: note: in expansion of macro ‘__compiler_offsetof’
 #define offsetof(TYPE, MEMBER) __compiler_offsetof(TYPE, MEMBER)
                                ^~~~~~~~~~~~~~~~~~~
../include/linux/kernel.h:697:21: note: in expansion of macro ‘offsetof’
  ((type *)(__mptr - offsetof(type, member))); })
                     ^~~~~~~~
../include/linux/interrupt.h:646:2: note: in expansion of macro ‘container_of’
  container_of(callback_tasklet, typeof(*var), tasklet_fieldname)
  ^~~~~~~~~~~~
../drivers/crypto/amcc/crypto4xx_core.c:1078:23: note: in expansion of macro ‘from_tasklet’
  struct device *dev = from_tasklet(dev, t, tasklet);
                       ^~~~~~~~~~~~

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
