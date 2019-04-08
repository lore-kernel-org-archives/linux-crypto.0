Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49A5FC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 09:06:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1471720833
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 09:06:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfDHJGW (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 05:06:22 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:55612 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbfDHJGW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 05:06:22 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDQEF-0002Jo-Kx; Mon, 08 Apr 2019 17:06:11 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDQE8-00069v-OO; Mon, 08 Apr 2019 17:06:04 +0800
Date:   Mon, 8 Apr 2019 17:06:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Zhang Zhijie <zhangzj@rock-chips.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Zain Wang <wzz@rock-chips.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-rockchip@lists.infradead.org" 
        <linux-rockchip@lists.infradead.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Olof Johansson <olof@lixom.net>,
        "ezequiel@collabora.com" <ezequiel@collabora.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tao Huang <huangtao@rock-chips.com>
Subject: Re: [Bug] Rockchip crypto driver sometimes produces wrong ciphertext
Message-ID: <20190408090604.7v7s5xhfvwthknio@gondor.apana.org.au>
References: <CAKv+Gu-RKu9jt+2FnV2529zqyLGR8RSu8r4B8eOs-7Om-pL0aQ@mail.gmail.com>
 <1894799.pWIprST79S@phil>
 <f7a0d04c-339e-d9f8-7188-a27d55ad8b4d@rock-chips.com>
 <20190315033140.GB1671@sol.localdomain>
 <AM5PR0901MB115570ABE89DC1285AE07E60D2500@AM5PR0901MB1155.eurprd09.prod.outlook.com>
 <20190404171204.GA121392@gmail.com>
 <20190407124211.fv7pjsozxhnhw56i@gondor.apana.org.au>
 <AM6PR09MB352377D3A58CE6C12464414ED2530@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190408055841.xa5dof4e5xqgaitv@gondor.apana.org.au>
 <AM6PR09MB35238739075B080390C11341D22C0@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB35238739075B080390C11341D22C0@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 08:59:02AM +0000, Pascal Van Leeuwen wrote:
> 
> It would be nice to have some option in testmgr to just test the core algorithm
> itself and not all the nitty gritty corners of the API that may not be relevant
> i.e. split off the core algorithm cases (e.g. proper straightforward encryption
> of a single block of data with a certain key) from the API cases.
> Perhaps a driver could advertise this through some flag: "I'm not fully API
> compliant, so just test the algorithm and not any API corner cases". Or even
> "please don't test me, I will test myself".
> 
> An alternative approach would be capability flags to advertise specific API
> features, but I can see how you can quickly go overboard with that.

What we could do is have the user specify an explicit flag saying
that they do not care about the output IV.  You could then skip the
output IV step in your driver.

But you'll have to code this up, including the bit on the user-side
to actually set the flag.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
