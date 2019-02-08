Return-Path: <SRS0=4jM/=QP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E441BC282CB
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:01:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B563D2147C
	for <linux-crypto@archiver.kernel.org>; Fri,  8 Feb 2019 08:01:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="htqmW5sk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfBHIBd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 Feb 2019 03:01:33 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([81.169.146.168]:22677 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbfBHIBd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Feb 2019 03:01:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1549612888;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=2aEhNY60C8wSVyERlV/KFSAdO5upx69CAFmE37gPPQc=;
        b=htqmW5skbjGRl1SlZy+j176vRMIm94kAgACYQr+qYoBmrWq6LZVoKsbb3cd/wwHr1r
        wbzfrlNfX/k/RfPvo7fFm6A9zp5KtEvs0vteXNrKhFXAvP56epVO3Qxqrg3pV3bOsTvJ
        Z97bnUA0eBEYgFeGyXM3Y83vqLQtlqQcQyLHWgI4upVTLvIDX75p1hEC5OO4q9LBGsCW
        zr7bUY4+uFoM+qEpduRAB76ERqNLssWo/LWJDMe5F1TSNZxp8b5u94CyrcFZ1Zz1gLWl
        K9sdRTzF6LxOzDxeWNCdXNYXvl3Vf6UzNyQmK+j9EdzE28M83smEBc3XQqtTNGycPkTO
        w64Q==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzHHXDaIPSfWeq9"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 44.9 DYNA|AUTH)
        with ESMTPSA id 309bcfv1880x70Q
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Fri, 8 Feb 2019 09:00:59 +0100 (CET)
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
Date:   Fri, 08 Feb 2019 09:00:59 +0100
Message-ID: <1798550.XZem68xxzE@tauon.chronox.de>
In-Reply-To: <20190208074558.j3k6gw66q4e2y2lv@gondor.apana.org.au>
References: <20190103143227.9138-1-jlee@suse.com> <12103603.N4N57GesWC@tauon.chronox.de> <20190208074558.j3k6gw66q4e2y2lv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, 8. Februar 2019, 08:45:58 CET schrieb Herbert Xu:

Hi Herbert,

> We could easily add self-tests for the helper.

Thanks for the clarification. And do you have a suggestion how we can should 
ensure that the self-tests are run only once?

Also, shall we add the signature verification enforcemnt to the helper as 
well?


Ciao
Stephan


