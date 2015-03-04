From: Nicolae Rosia <nicolae.rosia@gmail.com>
Subject: IPSec hmac(sha256) truncation bits length
Date: Wed, 4 Mar 2015 19:13:01 +0200
Message-ID: <CAH=tA9Fnd6+gHsvjCv8oXqRVGLtdV9jr-KP1hxUGFg5orC5Qcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Herbert Xu <herbert@gondor.apana.org.au>
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:41599 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932528AbbCDRND (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 Mar 2015 12:13:03 -0500
Received: by labgm9 with SMTP id gm9so6313773lab.8
        for <linux-crypto@vger.kernel.org>; Wed, 04 Mar 2015 09:13:01 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I'm trying to understand why icv_truncbits is set to 96 for
hmac(sha256) in xfrm_algo.c because
RFC4868 [1] says that the truncation length for HMAC-SHA256 should be 128.
Am I looking in the wrong place?

[1] https://tools.ietf.org/html/rfc4868#section-2.6

Best regards,
Nicolae Rosia
