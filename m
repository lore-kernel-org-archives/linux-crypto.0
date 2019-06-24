Return-Path: <SRS0=EE7o=UX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C461C43613
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30D642083D
	for <linux-crypto@archiver.kernel.org>; Mon, 24 Jun 2019 07:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="fr1nAfXR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFXHV5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 24 Jun 2019 03:21:57 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:9623 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfFXHV5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 24 Jun 2019 03:21:57 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45XLML6hfCz9vBmm;
        Mon, 24 Jun 2019 09:21:50 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=fr1nAfXR; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id bVhUwPat72lk; Mon, 24 Jun 2019 09:21:50 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45XLML5gX7z9vBml;
        Mon, 24 Jun 2019 09:21:50 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1561360910; bh=uqSyYAuIgffBR0A50tqUgIECoBVIQIvOhmxv2zbmqbg=;
        h=From:Subject:To:Cc:Date:From;
        b=fr1nAfXR5k6RCYhXpFmkXlofj/WpB8XH4YC/0LFO0OhP69azmMA6IGpHAfjGd+4m+
         tYsax/ac4Gu2NlzvTyIQTSEA8uy/GECXazhRwLKdFxxy0NBEeyyIUCDlHT67I+nh6O
         sZR6Ppy3Ror5TQufdkvkxgYv6F5SYIouDAGgjCFI=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 5EC0A8B787;
        Mon, 24 Jun 2019 09:21:55 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id a_sM-AAY_GJE; Mon, 24 Jun 2019 09:21:55 +0200 (CEST)
Received: from po16838vm.idsi0.si.c-s.fr (po15451.idsi0.si.c-s.fr [172.25.230.101])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 3F2078B74C;
        Mon, 24 Jun 2019 09:21:55 +0200 (CEST)
Received: by po16838vm.idsi0.si.c-s.fr (Postfix, from userid 0)
        id 44DB467424; Mon, 24 Jun 2019 07:21:55 +0000 (UTC)
Message-Id: <cover.1561360551.git.christophe.leroy@c-s.fr>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v5 0/4] Additional fixes on Talitos driver
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, horia.geanta@nxp.com
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Date:   Mon, 24 Jun 2019 07:21:55 +0000 (UTC)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Message-ID: <20190624072155.M-xBZJW6-VTZNVwuvqf3EC3T2P1T5keiWytX5zRGBzY@z>

This series is the last set of fixes for the Talitos driver.

We now get a fully clean boot on both SEC1 (SEC1.2 on mpc885) and
SEC2 (SEC2.2 on mpc8321E) with CONFIG_CRYPTO_MANAGER_EXTRA_TESTS:

[    3.385197] bus: 'platform': really_probe: probing driver talitos with device ff020000.crypto
[    3.450982] random: fast init done
[   12.252548] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos-hsna)
[   12.262226] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos-hsna)
[   43.310737] Bug in SEC1, padding ourself
[   45.603318] random: crng init done
[   54.612333] talitos ff020000.crypto: fsl,sec1.2 algorithms registered in /proc/crypto
[   54.620232] driver: 'talitos': driver_bound: bound to device 'ff020000.crypto'

[    1.193721] bus: 'platform': really_probe: probing driver talitos with device b0030000.crypto
[    1.229197] random: fast init done
[    2.714920] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos)
[    2.724312] alg: No test for authenc(hmac(sha224),cbc(aes)) (authenc-hmac-sha224-cbc-aes-talitos-hsna)
[    4.482045] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos)
[    4.490940] alg: No test for authenc(hmac(md5),cbc(aes)) (authenc-hmac-md5-cbc-aes-talitos-hsna)
[    4.500280] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos)
[    4.509727] alg: No test for authenc(hmac(md5),cbc(des3_ede)) (authenc-hmac-md5-cbc-3des-talitos-hsna)
[    6.631781] random: crng init done
[   11.521795] talitos b0030000.crypto: fsl,sec2.2 algorithms registered in /proc/crypto
[   11.529803] driver: 'talitos': driver_bound: bound to device 'b0030000.crypto'

v2: dropped patch 1 which was irrelevant due to a rebase weirdness. Added Cc to stable on the 2 first patches.

v3:
 - removed stable reference in patch 1
 - reworded patch 1 to include name of patch 2 for the dependency.
 - mentionned this dependency in patch 2 as well.
 - corrected the Fixes: sha1 in patch 4
 
v4:
 - using scatterwalk_ffwd() instead of opencodying SG list forwarding.
 - Added a patch to fix sg_copy_to_buffer() when sg->offset() is greater than PAGE_SIZE,
 otherwise sg_copy_to_buffer() fails when the list has been forwarded with scatterwalk_ffwd().
 - taken the patch "crypto: talitos - eliminate unneeded 'done' functions at build time"
 out of the series because it is independent.
 - added a helper to find the header field associated to a request in flush_channe()
 
v5:
 - Replacing the while loop by a direct shift/mask operation, as suggested by Herbert in patch 1.

Christophe Leroy (4):
  lib/scatterlist: Fix mapping iterator when sg->offset is greater than
    PAGE_SIZE
  crypto: talitos - move struct talitos_edesc into talitos.h
  crypto: talitos - fix hash on SEC1.
  crypto: talitos - drop icv_ool

 drivers/crypto/talitos.c | 102 +++++++++++++++++++----------------------------
 drivers/crypto/talitos.h |  28 +++++++++++++
 lib/scatterlist.c        |   9 +++--
 3 files changed, 74 insertions(+), 65 deletions(-)

-- 
2.13.3

