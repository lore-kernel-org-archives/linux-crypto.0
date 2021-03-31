Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C8AC433C1
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 07:52:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3C1C619CD
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Mar 2021 07:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234202AbhCaHvn (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:51:43 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.171]:31419 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234146AbhCaHvP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 03:51:15 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1617177068; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=TR0d/ZKvDNwN5gzG/lb80S/qpN9/7RWomMeP5atcaDSmHL51CsxmRWzS+iv49K1nSA
    GI58AN/5Z0iCTFPRQvkLd8rwiWsb8x1Yz3Dbm/6SxBi9L6uGoO9n3pE7BtTEqdbnaU9m
    ADbstgiVMHornq8EDlX1MVVAGjtP8oQMw2ractsMF7QI8BI1cAmxoe0MOG+1fryblDWb
    hZb6XfXZaY2pMMgpTQLdpikzhddG7jZqmtiXMbDWKTI1Q6F+twuergcXgwU4p4fSMlw4
    MF8KUQxo62PNc2b1A5RdapSaz+ow9/QbqECK9QSSxsP1rg1nBBh2Q4rqmDxVCg/0rbgc
    6JSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1617177068;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eOZ4VZTdJ8pUyk2sIkEdXMWyRYgM3XjOzKwRBLoG7YA=;
    b=EikoZYCvG+XSGOG4ekv/KgMgVYDCEyse8WuWslRsCoYupcOfnoEIfWnrryhxrMKArK
    JxR0OnRONtF96SLNti9N24sNQEcsJKEngxvOziWYlO+16tf2zII4hAdDuDSyjl11R/1D
    i3mfbnYXlfI5rWzkFyj18IBG8pgJbHWF8Wki0PZhjnYtsV8hGjY7gooSaxeRCB/3HYcv
    SvAw2yXNdiSMxi3egkrmx18f3GZsbZMLU+ltL2+z7H4w3ehpbqf7RfFQBg4a7dEZOb81
    PNPmq3EG5Ijfj5/vDvd2UPT04bj5FGm9uGOdjkK2D7CwcmQHMfFhCD1oEXWVr+oUHv8X
    3KAQ==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1617177068;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=eOZ4VZTdJ8pUyk2sIkEdXMWyRYgM3XjOzKwRBLoG7YA=;
    b=O7mYg3tMvt/rPg+eKobQo5DBe3L15n/eF7PzT15g1E5Yn6sIFzjyFm2o4EUUljxqhN
    ePuvn5y7Qw5HoyX2WVO8Bk7t12ebc07qmyIgLpHijfQfcMzrqgmRpJYX3hDgjdqJ90sb
    sgl8px1NHJwG3s7swcelTXNTssjZCG0MMCYnfChrnwWNxSzTcvwzyluaLdP82vm5OFkg
    GAmLYlIrvN4szd6ZWE9IkjugJHAxMYBexEfxYGIdDi4OHt5a2cIVkaWRnYaXPA5JGZOA
    KyYDxWXBTejcSkp/bjSW01Ly9wu3Rssp/xEJrOnF9g+PPS9812ja1dBbsGZRVcGbcqvs
    Wyxw==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNzyCzy1Sfr67uExK884EC0GFGHavJShEkMReN0E="
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
    by smtp.strato.de (RZmta 47.23.1 DYNA|AUTH)
    with ESMTPSA id e03072x2V7p7LPw
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 31 Mar 2021 09:51:07 +0200 (CEST)
Message-ID: <7b29ae50e40a031fa145f12b5f5b31fb6578626e.camel@chronox.de>
Subject: Re: crypto: FIPS 200 mode
From:   Stephan Mueller <smueller@chronox.de>
To:     Randy Dunlap <rdunlap@infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>
Cc:     LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 31 Mar 2021 09:51:07 +0200
In-Reply-To: <4e940d39-77c0-74d4-d282-216cc6030c11@infradead.org>
References: <4e940d39-77c0-74d4-d282-216cc6030c11@infradead.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, dem 30.03.2021 um 15:26 -0700 schrieb Randy Dunlap:
> 
> The Kconfig help text for CRYPTO_FIPS says
> 
> config CRYPTO_FIPS
>         bool "FIPS 200 compliance"
> ...
>         help
>           This option enables the fips boot option which is
>           required if you want the system to operate in a FIPS 200
>           certification.  You should say no unless you know what
>           this is.
> 
> This seems confusing to me since it says "compliance" in one place and
> "certification" in another place. And AFAICT, those two words don't
> mean the same thing as far as NIST & FIPS are concerned.
> 
> 
> Should it say "compliance" in both places?  E.g.
> 
>         help
>           This option enables the fips boot option which is
>           required if you want the system to operate in FIPS 200
>           compliance mode.  You should say no unless you know what
>           this is.

Sounds good to me.

Ciao
Stephan
> 
> 
> thanks.


