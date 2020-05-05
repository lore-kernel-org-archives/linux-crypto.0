Return-Path: <SRS0=vF1r=6T=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449FCC47254
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:04:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FD5C206B8
	for <linux-crypto@archiver.kernel.org>; Tue,  5 May 2020 22:04:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="eEWfXrnk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgEEWEX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 May 2020 18:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729060AbgEEWEX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 May 2020 18:04:23 -0400
Received: from mo6-p01-ob.smtp.rzone.de (mo6-p01-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5301::5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CFC2C061A0F
        for <linux-crypto@vger.kernel.org>; Tue,  5 May 2020 15:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588716259;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=oPj2gshSUeMSn5oqoVdmsw0O1yeAbh57ZqIP8z8Il28=;
        b=eEWfXrnkhvzWhcEM0aXSeGWs8HWY5/5gdK95xpPsaMEez6LK8JLOB9n/kAvs8anye/
        ozbolFHPSk9vK5FQYu50pIzICVnhON0Wf9hGE3OcdMy0Jvef3Zmk55thLiDId8LsJ7U8
        zG4TeEhyzwNPtc+ePrdId22J1r/rhjWac+MXxvLcZde/IixDk6EE5ga0AAEdVAMha58w
        l3Ecf9R8kClRtKWONJ7f5WEc2c8h4XMTbFB5KAthgszie4nWvFIpnrAL0UmI5U3R6l0Y
        YZQa9yTBYhRga96kRVRvW07hL7RhuSKtd2rBrKBBqxnIaZeulqREwFnVGeX5psk1HHWv
        nb0Q==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPZJ/Sc+igB"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id u08bf3w45M45BvL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Wed, 6 May 2020 00:04:05 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Sahana Prasad <saprasad@redhat.com>,
        Tomas Mraz <tmraz@redhat.com>, Ard Biesheuvel <ardb@kernel.org>
Subject: Re: libkcapi tests are failing on kernels 5.5+
Date:   Wed, 06 May 2020 00:04:05 +0200
Message-ID: <4933229.31r3eYUQgx@positron.chronox.de>
In-Reply-To: <20200505075834.GA1190@gondor.apana.org.au>
References: <CAAUqJDvZt7_j+eor1sXRg+QmrdXTjMiymFnji86PoatsYPUugA@mail.gmail.com> <20200505075834.GA1190@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Dienstag, 5. Mai 2020, 09:58:35 CEST schrieb Herbert Xu:

Hi Herbert,


Issue is fixed in libkcapi with https://github.com/smuellerDD/libkcapi/commit/
2fdd3738c77b0db825b4bb94eef9a932aa5077de

Thanks.

Ciao
Stephan


