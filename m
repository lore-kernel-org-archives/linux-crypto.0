Return-Path: <SRS0=vipQ=TG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E41C04AB3
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 05:49:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37B622087F
	for <linux-crypto@archiver.kernel.org>; Mon,  6 May 2019 05:49:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=c-s.fr header.i=@c-s.fr header.b="Aecj5irM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbfEFFt1 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 6 May 2019 01:49:27 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:10797 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbfEFFt0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 6 May 2019 01:49:26 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 44yBdD3xdQz9v0RS;
        Mon,  6 May 2019 07:49:20 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=Aecj5irM; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id fNW60CVscOpe; Mon,  6 May 2019 07:49:20 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 44yBdD2dT0z9v0RR;
        Mon,  6 May 2019 07:49:20 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1557121760; bh=ZR4QW6ntpbbWc12tNnxtspEddAjXzTd2FYoSfOxzYwY=;
        h=Subject:References:To:From:Date:In-Reply-To:From;
        b=Aecj5irM/U3/kSndsba3jfnXjuta+s2EID9KS68jQZTfBMPXgXu6J1W6ICdxI/GHn
         k6oSSucGntxRhWV+7xoOFKyjeMrXa8mSalTvcr7pGKVrr1Pi+7rfcUbQ9RKUnaw1yD
         Np0ovHW5xntEmhWj0xZL9YOTCdg27ZEzTBowkg2c=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id CBC618B7F7;
        Mon,  6 May 2019 07:49:24 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id BUF_jVace8VX; Mon,  6 May 2019 07:49:24 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.6])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id B041B8B74F;
        Mon,  6 May 2019 07:49:24 +0200 (CEST)
Subject: Fwd: [Bug 203515] New: [crypto] alg: skcipher: p8_aes_ctr encryption
 test failed (wrong result) on test vector 3, cfg="uneven misaligned splits,
 may sleep"
References: <bug-203515-206035@https.bugzilla.kernel.org/>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
X-Forwarded-Message-Id: <bug-203515-206035@https.bugzilla.kernel.org/>
Message-ID: <0efc212e-ae3a-d968-69f8-3e79cd113a0e@c-s.fr>
Date:   Mon, 6 May 2019 07:49:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <bug-203515-206035@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org




-------- Message transféré --------
Sujet : [Bug 203515] New: [crypto] alg: skcipher: p8_aes_ctr encryption 
test failed (wrong result) on test vector 3, cfg="uneven misaligned 
splits, may sleep"
Date : Sun, 05 May 2019 00:05:40 +0000
De : bugzilla-daemon@bugzilla.kernel.org
Pour : linuxppc-dev@lists.ozlabs.org

https://bugzilla.kernel.org/show_bug.cgi?id=203515

             Bug ID: 203515
            Summary: [crypto] alg: skcipher: p8_aes_ctr encryption test
                     failed (wrong result) on test vector 3, cfg="uneven
                     misaligned splits, may sleep"
            Product: Platform Specific/Hardware
            Version: 2.5
     Kernel Version: 5.1.0-rc7
           Hardware: All
                 OS: Linux
               Tree: Mainline
             Status: NEW
           Severity: normal
           Priority: P1
          Component: PPC-64
           Assignee: platform_ppc-64@kernel-bugs.osdl.org
           Reporter: erhard_f@mailbox.org
         Regression: Yes

Created attachment 282609
   --> https://bugzilla.kernel.org/attachment.cgi?id=282609&action=edit
dmesg (5.1.0-rc7, Talos II)

Seems like some POWER8/9 specific encrytion test fails in 5.1.0-rc7. 
This did
not happen in 5.0.x and before.

[...]
[    5.246612] crypto_register_alg 'cbc(aes)' = 0
[    5.254268] alg: skcipher: p8_aes_ctr encryption test failed (wrong 
result)
on test vector 3, cfg="uneven misaligned splits, may sleep"
[    5.255266] xhci_hcd 0003:01:00.0: xHCI Host Controller
[    5.255346] xhci_hcd 0003:01:00.0: new USB bus registered, assigned bus
number 1
[    5.255522] xhci_hcd 0003:01:00.0: hcc params 0x0270f06d hci version 0x96
quirks 0x0000000004000000
[    5.256008] crypto_register_alg 'ctr(aes)' = 0
[...]

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
