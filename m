Return-Path: <SRS0=EZcf=VA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E0DC06511
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67794218A6
	for <linux-crypto@archiver.kernel.org>; Wed,  3 Jul 2019 14:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfGCO1e (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 3 Jul 2019 10:27:34 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52124 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726675AbfGCO1e (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 3 Jul 2019 10:27:34 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1higEJ-0000cD-5e; Wed, 03 Jul 2019 22:27:27 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1higEF-0000UZ-Ar; Wed, 03 Jul 2019 22:27:23 +0800
Date:   Wed, 3 Jul 2019 22:27:23 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Christophe Leroy <christophe.leroy@c-s.fr>
Cc:     "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 0/4] *** SUBJECT HERE ***
Message-ID: <20190703142723.zueylnlwzajpdtvs@gondor.apana.org.au>
References: <cover.1561360551.git.christophe.leroy@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1561360551.git.christophe.leroy@c-s.fr>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 24, 2019 at 07:20:13AM +0000, Christophe Leroy wrote:
> This series is the last set of fixes for the Talitos driver.
> 
> We now get a fully clean boot on both SEC1 (SEC1.2 on mpc885) and
> SEC2 (SEC2.2 on mpc8321E) with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS:
> 
> [    3.385197] bus: 'platform': really_probe: probing driver talitos with device ff020000.crypto
> [    3.450982] random: fast init done
> [   12.252548] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos-hsna)
> [   12.262226] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos-hsna)
> [   43.310737] Bug in SEC1, padding ourself
> [   45.603318] random: crng init done
> [   54.612333] talitos ff020000.crypto: fsl,sec1.2 algorithms registered in /proc/crypto
> [   54.620232] driver: 'talitos': driver_bound: bound to device 'ff020000.crypto'
> 
> [    1.193721] bus: 'platform': really_probe: probing driver talitos with device b0030000.crypto
> [    1.229197] random: fast init done
> [    2.714920] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos)
> [    2.724312] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos-hsna)
> [    4.482045] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos)
> [    4.490940] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos-hsna)
> [    4.500280] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos)
> [    4.509727] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos-hsna)
> [    6.631781] random: crng init done
> [   11.521795] talitos b0030000.crypto: fsl,sec2.2 algorithms registered in /proc/crypto
> [   11.529803] driver: 'talitos': driver_bound: bound to device 'b0030000.crypto'
> 
> v2: dropped patch 1 which was irrelevant due to a rebase weirdness. Added Cc to stable on the 2 first patches.
> 
> v3:
>  - removed stable reference in patch 1
>  - reworded patch 1 to include name of patch 2 for the dependency.
>  - mentionned this dependency in patch 2 as well.
>  - corrected the Fixes: sha1 in patch 4
>  
> v4:
>  - using scatterwalk_ffwd() instead of opencodying SG list forwarding.
>  - Added a patch to fix sg_copy_to_buffer() when sg->offset() is greater than PAGE_SIZE,
>  otherwise sg_copy_to_buffer() fails when the list has been forwarded with scatterwalk_ffwd().
>  - taken the patch "crypto: talitos - eliminate unneeded 'done' functions at build time"
>  out of the series because it is independent.
>  - added a helper to find the header field associated to a request in flush_channe()
>  
> v5:
>  - Replacing the while loop by a direct shift/mask operation, as suggested by Herbert in patch 1.
> 
> Christophe Leroy (4):
>   lib/scatterlist: Fix mapping iterator when sg->offset is greater than
>     PAGE_SIZE
>   crypto: talitos - move struct talitos_edesc into talitos.h
>   crypto: talitos - fix hash on SEC1.
>   crypto: talitos - drop icv_ool
> 
>  drivers/crypto/talitos.c | 102 +++++++++++++++++++----------------------------
>  drivers/crypto/talitos.h |  28 +++++++++++++
>  lib/scatterlist.c        |   9 +++--
>  3 files changed, 74 insertions(+), 65 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
