From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: testmgr - don't DMA map IV from stack in
 test_skcipher()
Date: Thu, 9 Mar 2017 12:18:51 +0800
Message-ID: <20170309041851.GA6012@gondor.apana.org.au>
References: <1484290756-20868-1-git-send-email-horia.geanta@nxp.com>
 <20170113084620.GF22022@gondor.apana.org.au>
 <DB4PR04MB08477C25A41104FA6D879D07982E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34663 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750763AbdCIET0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 8 Mar 2017 23:19:26 -0500
Content-Disposition: inline
In-Reply-To: <DB4PR04MB08477C25A41104FA6D879D07982E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Mar 08, 2017 at 01:04:14PM +0000, Horia Geantă wrote:
>
> Since changing the API and converting the users looks pretty lengthy,
> would it be acceptable to fix tcrypt for now?
> Indeed, I've missed updating test_skcipher_speed, I can add this in v2.

Might as well leave it there because at least it reminds us to
fix the problem.  With the API as it is any new kernel user could
potentially provide us with an IV off the stack.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
