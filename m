Return-Path: <SRS0=gCBe=74=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FAB3C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:16:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC7952074D
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Jun 2020 13:16:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="PYRP3IWJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgFONQe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Jun 2020 09:16:34 -0400
Received: from mo4-p01-ob.smtp.rzone.de ([81.169.146.164]:30956 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729977AbgFONQd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Jun 2020 09:16:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1592226989;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=zqxmVgdmjcOl7HZi58VyJB7Dsh33gu503wdQu+OOuvI=;
        b=PYRP3IWJeVC0k8GcSwZWnnL2k/7V1/H/CkXXuoY2ldq1bLIepW6O9o2CHvdtbw8suo
        9dgBnSp6aIZzH+JAjGFk9vg1iImYNMPA71taWZ0sT/wrYcJjf8AI505YnOQj33PlLX+R
        jMxFe8ml9Csm9zGguDFc6ZYqP+L8Iee7VI3pg6avK0lc1IfSUvTc5pXKnNC8ac2ClK8t
        cTUxHNcMSnPKYYnJWeeix2hM3DfBaQ1yZzdlgKyntfIX05kBKC9q1d7jyrZrClAvh1Rf
        EwTE4avkGwilvJjPIDDWwgfIadZg941fcqD/YmBkniY8M6sL/sxcBI59Twnv9PtpdI1X
        hdOQ==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPaJfSc9CNS"
X-RZG-CLASS-ID: mo00
Received: from tauon.chronox.de
        by smtp.strato.de (RZmta 46.10.4 DYNA|AUTH)
        with ESMTPSA id U03fedw5FDGPB5E
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Mon, 15 Jun 2020 15:16:25 +0200 (CEST)
From:   Stephan Mueller <smueller@chronox.de>
To:     LABBE Corentin <clabbe@baylibre.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 13/14] crypto: sun8i-ce: Add support for the PRNG
Date:   Mon, 15 Jun 2020 15:16:25 +0200
Message-ID: <2861786.iSnlG1rnU6@tauon.chronox.de>
In-Reply-To: <20200615130253.GA8958@Red>
References: <1587736934-22801-1-git-send-email-clabbe@baylibre.com> <5634597.9v007L4FOH@tauon.chronox.de> <20200615130253.GA8958@Red>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Montag, 15. Juni 2020, 15:02:53 CEST schrieb LABBE Corentin:

Hi,


> I still dont see any memset_secure in kzfree (mm/slab_common.c).
> Does I miss something ?

Nope, you do not miss anything, it seems that the patch that I had seen did 
not go in.
> 
> Regards


Ciao
Stephan


