From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] crypto: testmgr - mark ctr(des3_ede) as fips_allowed
Date: Mon, 20 Mar 2017 21:32:27 +0100
Message-ID: <4546878.pbhW5Upcq1@tauon.atsec.com>
References: <1490041685-25947-1-git-send-email-marcelo.cerri@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
To: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58170 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753207AbdCTUew (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 20 Mar 2017 16:34:52 -0400
In-Reply-To: <1490041685-25947-1-git-send-email-marcelo.cerri@canonical.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 20. März 2017, 21:28:05 CET schrieb Marcelo Henrique Cerri:

Hi Marcelo,

> 3DES is missing the fips_allowed flag for CTR mode.
> 
> Signed-off-by: Marcelo Henrique Cerri <marcelo.cerri@canonical.com>

Acked-by: Stephan Mueller <smueller@chronox.de>

Ciao
Stephan
