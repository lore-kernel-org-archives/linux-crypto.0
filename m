Return-Path: <SRS0=jNyN=2V=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB0DFC2D0C3
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 02:43:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99204206DB
	for <linux-crypto@archiver.kernel.org>; Tue, 31 Dec 2019 02:43:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cs.com header.i=@cs.com header.b="sflk30V2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbfLaCn4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 30 Dec 2019 21:43:56 -0500
Received: from sonic312-22.consmr.mail.bf2.yahoo.com ([74.6.128.84]:35531 "EHLO
        sonic312-22.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbfLaCn4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 30 Dec 2019 21:43:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.com; s=a2048; t=1577760235; bh=nQBtscLoJHJZhW0nTrR2SuBCaRU/woc+YjXqdQWUO1o=; h=Subject:From:To:Date:References:From:Subject; b=sflk30V2kEGO73JwlghTeOrCRhF9aDbs9ffN+PDqVbCKHRH1mTwL09RtS+vkHujWtZ0a0RDrQmSyX7zr6bE+c9TdQVS8b6hEKLdfCa1O6Qkhlj2spG5z12vdpp22bswOCIA+JwadufeCVDTwwLdOlXmMqF4jSxHG1XdvaCRU4BtYu7VptjbglpYPpUMdRr2uFykoExS/7A3/P3QW1qET7FuxXl/278uoYdOkbKaA5ozV1ft9bZP7f5iG+X2fmyc8W1wiWyA6u9sClxPOY+QCT1gBo/62X0RW2OONeGzZpys7AWW0JKdfKUYbw8QV+jY5vu6MWDRn849xb0iiLBQXbQ==
X-YMail-OSG: 9zNbt3cVM1krfDvsnNkJEe_45zHiYnRjCmWhQojyvivZ.TQ3J1_z8SDSI_1Uf3y
 biTU4gTKWn06K1u3Bm4C1IdTxedSk_IH0Euf2uxATHKTPlav2oUo.DAwKG3cP3NrF5s89JN4P9si
 EcRr0nqs63o2AlEKco_FexRA2smA5B52TNirlTQrpCOHUYo2PBJbe6oPkzonViGXig5LOmnh0ztY
 J4UiPiy9E.9cP0xVJ7FdLmOaZdOHfsYP1eRQBWR1aZ.WNmCkQtlSNEAKlK4kUVJ_1pCvnMAPXwv2
 7cJCnT.CKzXpSL_i_osIBboJsd0Q3GjiWSI0dGMRxppBcqTzSnycpYhxrfD69m4OnnP7OsB63VLA
 Usng2p9TznhqkuzGMnj_oks6hUfaZG07EJ1LjfHhLVvl2o7TwU6bVjtXh76OB1IHD1czXcrKGo.F
 RM48FIlWRAdUfG5dmeeT2kTMhJvUWDRlfstl0Mte4hKQEboUSi4ooG9Kg.BIzRZwmxaqPtlBDtvl
 koazhLXE7EL_38eIjFSaqcuCISDLUmlO4KXJ725vsF2fbXn0.tivMpgwMn.e43PsZrC4zXUJid92
 bXdd8.R.uJ.FCRG0nLCg95Kj0LQEG4kLuVj3Nnhmr._MqUONVZtFQRCjLCEKdZtgz64Ab7q.sn_3
 7M8ljSEpLMULZ8ALnbdaNgTeBz2mlPsWUcFgnhWZv2JjRaVMiMauCO_q2yZgghQQXqx0heAWoszh
 fRFGsDuRZW7nR6b1bir_BNFAv_usFvqm6bAArHcQOGO_M55GdM22wKrNBq59YEdoPq.cjlBMD214
 NUTutAnUxNu9UZ7OrhuZM7fr3OjqTCZRqO.1tmGhMGi0WrXWt1jSO2OqfjNknH2t_YomQYdidU4y
 0SrStamwBw.3GzVu53Om_kgM3C4GkKDHxr15FA1pBaPst1n7qUzUwqEb7bNeSp2f.Cu3VanVxLzM
 MD98fMtAifJHk2BasfzLVspEPjyq6r6d5RjbSl1VUqJ81yUr2Y1JxDI64QG94quO2M3f_iFsJkZP
 g2EFwQXjBqHakxsPh2nVVacSmIqRyWNiDbw.Il3jzFTCGAPBiWVPdHNX8KbE3aKcUL_nWQJ1M3oh
 XwG7k.yEz_TxXNo_Wtyen7OHPriUZD25DAasxwnvxUiRcbIw_eVusWlIcDMAGBxXrlwziSD52uwI
 PnQXrlIG8EOLgO05EG7lIGiGR7I82fAebXbrU4wQJSnoLMWkwF8RS1RKkvzX3G7fyv58iCgApq6s
 M6YK_zffLo9L2RHI3Ojm0HsiFB_287a5U4Cvoe_cH2CftvNn5eIdK6bFZbooJ8S3VOJ53PLZN5i5
 pd3CEfQ1yROCxCcQzxmjCsMkSsaTVNcfigEyz9zc-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic312.consmr.mail.bf2.yahoo.com with HTTP; Tue, 31 Dec 2019 02:43:55 +0000
Received: by smtp431.mail.gq1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID de1393e8dd90e2abe4ad7ff02cd5c5f5;
          Tue, 31 Dec 2019 02:43:52 +0000 (UTC)
Message-ID: <2345369f0bf4169a1ec792545df7d409dd7fecd1.camel@cs.com>
Subject: Hardware ANSI X9.31 PRNG, handling multiple context?
From:   Richard van Schagen <vschagen@cs.com>
To:     linux-crypto@vger.kernel.org
Date:   Tue, 31 Dec 2019 10:43:45 +0800
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
References: <2345369f0bf4169a1ec792545df7d409dd7fecd1.camel.ref@cs.com>
X-Mailer: WebService/1.1.14873 hermes Apache-HttpAsyncClient/4.1.4 (Java/1.8.0_181)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

As part of my EIP93 crypto module I would like to implement the PRNG.
This is intented to be used to automaticly insert an IV for IPSEC /
full ESP processing, but can be used "just as PRNG" and its full ANSI
X9.31 compliant.

Looking over the code in "ansi_cprng.c" I can implement the none "FIPS"
part since it doesnt require a reseed everytime. For full FIPS it needs
to be seeded by the user which means if I do this in Hardware I can not
"switch" seeds or reseed with another one from another context becasue
that would not give the expected results.

Is it acceptable to only implement "none-fips" and/or return an error
(-EBUSY ?) when more than 1 call occurs to "cra_init" before the
previous user called "cra_exit" ?

Richard

