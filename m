Return-Path: <SRS0=+uK6=S2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD6EC10F11
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 18:33:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1841821773
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Apr 2019 18:33:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="Q+knvpR1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387825AbfDXSdx (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Apr 2019 14:33:53 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:16945 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733024AbfDXSdw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Apr 2019 14:33:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1556130830;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=ztRZ8SZCmF9XNLy1UHtfoSMUUhjMciaT/ucfRjdlQGc=;
        b=Q+knvpR1iU/3TlblS8BnmWfrjmWlq5lzJuB328ajaeWrKxIuqLocY8t7ACboyeUFdH
        G47KAhxWMTV5FwqWPikShOXlRAj1zii/G8rIwwnVKVNA2KydoW3yIMpZ0mWWlqSgcWmh
        AnSi9IbKfCAKuWHL/RHLpDT2YGgU5tMsTINojRvV5fKkOWd7HecVCeFBEHIDgtRT9JPo
        J6X5MFrbZE7q6KMvyHswwh8Zl8HeYWBG0280hKxvlNgkXkrZh7Havf8Xp3uTYPQ2dRjF
        ySIszZ71BgI7SIolFGeDrIU6Ba89fNH+vnzbgILdtcYtmqJeFss8Xot3l4yrQpv+MaE2
        vP+g==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9x2cdNU9qrVA3/I2bquZ6"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.18 DYNA|AUTH)
        with ESMTPSA id R0373fv3OIUZ6mS
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 24 Apr 2019 20:30:35 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Kalyani Akula <kalyania@xilinx.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 4/5] crypto: Adds user space interface for ALG_SET_KEY_TYPE
Date:   Wed, 24 Apr 2019 20:30:35 +0200
Message-ID: <18759853.IUaQuE38eh@tauon.chronox.de>
In-Reply-To: <BN7PR02MB5124AC0C75B15E5FB66DF2B6AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
References: <1547708541-23730-1-git-send-email-kalyani.akula@xilinx.com> <4735882.YQOrfzxm5S@tauon.chronox.de> <BN7PR02MB5124AC0C75B15E5FB66DF2B6AF220@BN7PR02MB5124.namprd02.prod.outlook.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 22. April 2019, 11:17:55 CEST schrieb Kalyani Akula:

Hi Kalyani,

> > Besides, seem to be more a key handling issue. Wouldn't it make sense to
> > rather have such issue solved with key rings than in the kernel crypto
> > API?
> 
> [kalyani] Can you please elaborate on this further ?

The kernel has a keyring support in security/keys which has a user space 
interface with keyutils. That interface is commonly used for any sort of key 
manipulation.

Ciao
Stephan


