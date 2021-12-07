Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A862C433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Dec 2021 19:32:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231620AbhLGTg1 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Dec 2021 14:36:27 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:60158 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbhLGTg1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Dec 2021 14:36:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 98707CE1DEF
        for <linux-crypto@vger.kernel.org>; Tue,  7 Dec 2021 19:32:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCCBC341C3;
        Tue,  7 Dec 2021 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638905573;
        bh=MYx2kWdoRIjjodPYgxf9scwYAvj4mEPyOf7GhfBbw14=;
        h=Date:From:To:Cc:Subject:From;
        b=hrYCfbmd2d9dwXk4+z1SwkmZLhsRMgTe/8Xo0XakzcWgcStrU8CQG3+SwejQfTl/7
         omC3CcIPWahi2Hnk/98CgOvMD9I8v6u8SpJETWJsRB63ABHxarfaqEWOoMxxEE4Qxg
         toV1fBVaiNLmVErFY3SUPP9gVIFrrOaFEH3bVc44QlS9NnfaNqLTymd0rGTIg1/P6g
         RnDE2cp9QYN9+YJ/O6swA+pSreU7MKBmSIb7qEezp31D1Tcxdc+lQE6p9BOLz0BTYD
         faJ2HmxRqDy497Smc+BgvZdW+njOpgnIaXDuqrdXc0MLCPbhwT6gTrQUA3ny4aKs57
         xcH4Neo8d3p5Q==
Date:   Tue, 7 Dec 2021 11:32:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: x86 AES crypto alignment
Message-ID: <20211207113252.162701ed@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi!

The x86 AES crypto (gcm(aes)) requires 16B alignment which is hard to
achieve in networking. Is there any reason for this? On any moderately 
recent Intel platform aligned and unaligned vmovdq should have the same
performance (reportedly).

I'll hack it up and do some testing, but I thought it's worth asking
first..
