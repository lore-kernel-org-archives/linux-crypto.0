Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F247C169C4
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:18:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C17DE21916
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:18:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="c+ub+vtc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727235AbfBHISm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:18:42 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.82]:34095 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727166AbfBHISm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 03:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1549613919;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=HCB63srv2dZIavCQE8QCNeWaSpOPvhtRoJPZWCpNd44=;
        b=c+ub+vtcXDBYUlmA0egusm0q8ZNb1hPqYCiAG2OjE4WChAX6Um6VoLlgSYwfY1XlZY
        FMUsW6SVZLmLr/NOUpgP7WSVrvzM8aHEkW7LEBKBmTeUtrQ95itXf7X0ihTgqdF8Z93p
        tGRfWHMGgoXNlzzmQOtTqtoTph4kySJe/7gMkG4AwVCXEXAWkUQJY9NTqeIAcN4zk+DY
        4sy0rz60FL/yBRktewDBKMg3EDvN+av9jGw/+67aHD51K5XPkR7cRtgAXIWBgwHJEpgN
        DWXjAcjU/7LzcMB1Hb4tSRLGyqGUTXNKlqnHg0Otk+nif+dLB5AR300pzCV7u4QvmMFZ
        y6NA==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDaIPSfWeq9"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.9 DYNA|AUTH)
        with ESMTPSA id 309bcfv188Ho76p
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 8 Feb 2019 09:17:50 +0100 (CET)
From:   Stephan Mueller <smueller@chronox.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 0/6] General Key Derivation Function Support
Date:   Fri, 08 Feb 2019 09:17:50 +0100
Message-ID: <2047284.dgeq8KlW64@tauon.chronox.de>
In-Reply-To: <20190208080547.224fudg2m22d3a6d@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com> <1798550.XZem68xxzE@tauon.chronox.de> <20190208080547.224fudg2m22d3a6d@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 8. Februar 2019, 09:05:47 CET schrieb Herbert Xu:

Hi Herbert,
> 
> > Also, shall we add the signature verification enforcemnt to the helper as
> > well?
> 
> What do you mean by that?

We need to invoke the function crypto_check_module_sig when the module is 
loaded. Do you have any concerns invoking it from the module init function?

Ciao
Stephan


