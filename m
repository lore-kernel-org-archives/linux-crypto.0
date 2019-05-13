Return-Path: <SRS0=12xR=TN=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 830C5C04A6B
	for <linux-crypto@archiver.kernel.org>; Mon, 13 May 2019 00:59:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 56BA3208C0
	for <linux-crypto@archiver.kernel.org>; Mon, 13 May 2019 00:59:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfEMA7Z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 12 May 2019 20:59:25 -0400
Received: from orcrist.hmeau.com ([5.180.42.13]:46794 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727203AbfEMA7Y (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 12 May 2019 20:59:24 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hPzJ7-0002Xv-Cj; Mon, 13 May 2019 08:59:09 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hPzIz-0000Cn-Av; Mon, 13 May 2019 08:59:01 +0800
Date:   Mon, 13 May 2019 08:59:01 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Nayna <nayna@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>,
        leo.barbosa@canonical.com, Stephan Mueller <smueller@chronox.de>,
        nayna@linux.ibm.com, omosnacek@gmail.com, leitao@debian.org,
        pfsmorigo@gmail.com, linux-crypto@vger.kernel.org,
        marcelo.cerri@canonical.com,
        George Wilson <gcwilson@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190513005901.tsop4lz26vusr6o4@gondor.apana.org.au>
References: <20190315020901.16509-1-dja@axtens.net>
 <20190315022414.GA1671@sol.localdomain>
 <875zsku5mk.fsf@dja-thinkpad.axtens.net>
 <20190315043433.GC1671@sol.localdomain>
 <8736nou2x5.fsf@dja-thinkpad.axtens.net>
 <20190410070234.GA12406@sol.localdomain>
 <87imvkwqdh.fsf@dja-thinkpad.axtens.net>
 <2c8b042f-c7df-cb8b-3fcd-15d6bb274d08@linux.vnet.ibm.com>
 <8736mmvafj.fsf@concordia.ellerman.id.au>
 <20190506155315.GA661@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190506155315.GA661@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, May 06, 2019 at 08:53:17AM -0700, Eric Biggers wrote:
>
> Any progress on this?  Someone just reported this again here:
> https://bugzilla.kernel.org/show_bug.cgi?id=203515

Guys if I don't get a fix for this soon I'll have to disable CTR
in vmx.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
