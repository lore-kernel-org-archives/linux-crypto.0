Return-Path: <SRS0=4Aj0=75=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85A2C433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 05:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A4220644
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Jun 2020 05:03:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="hp06psvi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725306AbgFPFDg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Jun 2020 01:03:36 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:17746 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgFPFDg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Jun 2020 01:03:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1592283811;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=L45aK3OAmuz+/hL1uOOBddEcc9XwtwJLTmWpWlfBX88=;
        b=hp06psviAKjEnAMgSABbTfMjqYNvI8CiS53Vn3mDOtz19z4tEyuP+u1k/OVWqXEVYY
        AJ5Yps2abaynmneb374Uj+9XdlJRXbT/XINyqHvXBTjfPh1ua5EpdVh08mkPB4t4JgZJ
        RSLEat7aIvXbR+AqBrGZA22WOTXkeyFtHSJ8zpNlwZXpPfuo0yBh+AN3krPYHXMCTZdl
        NvaYFl5MQDCCmyzM3aqZDKYMQcPhcb5Str9l7sJDhi8f6y7ZBfosiRksodZ/hghPdNGO
        tBJACLmxrW2Sc3gwhLGqxL1D1qbbBMzpUxnDbaHBcFCJJ3mKidl/Mu+Rm4AQUjLuvFmO
        KC6A==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSc9CNS"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.4 DYNA|AUTH)
        with ESMTPSA id U03fedw5G53SD2B
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Tue, 16 Jun 2020 07:03:28 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     Anshuman Gupta <anshuman.gupta@intel.com>
Cc:     linux-crypto@vger.kernel.org
Subject: Re: [Query] RSA SHA-384 signature verification
Date:   Tue, 16 Jun 2020 07:03:28 +0200
Message-ID: <13970611.Hd4P73xESc@tauon.chronox.de>
In-Reply-To: <20200616035603.GG14085@intel.com>
References: <20200615170413.GF14085@intel.com> <1730161.mygNopSbl3@tauon.chronox.de> <20200616035603.GG14085@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 16. Juni 2020, 05:56:04 CEST schrieb Anshuman Gupta:

Hi Anshuman,

> On 2020-06-15 at 21:25:58 +0200, Stephan Mueller wrote:
> > Am Montag, 15. Juni 2020, 19:04:14 CEST schrieb Anshuman Gupta:
> > 
> > Hi Anshuman,
> > 
> > > Hi ,
> > > I wanted to verify a RSA SHA-384 signature.
> > > I am using crypto_alloc_shash(), crypto_shash_digest() API to extract
> > > the SHA-384 digest.
> > > I am having public key along with the sha-384 digest extracted from raw
> > > data and signature. AFAIU understand from crypto documentation that i
> > > need to verify the signature by importing public key to
> > > akcipher/skcipher API. Here i am not sure which cipher API to prefer
> > > symmetric key cipher or asymmetric key cipher API.
> > > 
> > > There are two types of API to import the key.
> > > crypto_skcipher_setkey()
> > > crypto_akcipher_set_pub_key()
> > > 
> > > Also i am not sure exactly which algo to use for RSA-SHA384 signature
> > > verification.
> > > 
> > > Any help or inputs from crypto community will highly appreciated.
> > 
> > akcipher: asymmetric key crypto
> > 
> > skcipher: symmetric key crypto
> 
> Many thanks for your input, based upon your inputs i should use
> akcipher.
> Actually tried to grep crypto_akcipher_set_pub_key() but there are not any
> usages of this API in Linux drivers.
> What is the preferred method to verify a RSA signature inside any Linux
> GPL driver, is there any standard interface API to verify RSA signature
> by importing input of raw data and public key or else
> it is recommended method to use below set low level of API
> crypto_alloc_akcipher(), akcipher_request_alloc(),
> akcipher_request_set_crypt(), crypto_akcipher_verify().

You can use that API directly or you can go through the intermediary of the 
crypto/asymmetric_keys API. One use case is the kernel signature verification 
as implemented in kernel/module_signing.c

> Thanks,
> Anshuman.
> 
> > > Thanks ,
> > > Anshuman Gupta.
> > 
> > Ciao
> > Stephan


Ciao
Stephan


