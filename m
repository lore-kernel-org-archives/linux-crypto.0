Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1341C433E2
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 22:35:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD95420C09
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 22:35:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgIIWfw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 18:35:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55702 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgIIWfw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 18:35:52 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kG8gm-0007LS-BT; Thu, 10 Sep 2020 08:35:41 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 10 Sep 2020 08:35:40 +1000
Date:   Thu, 10 Sep 2020 08:35:40 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Joe Perches <joe@perches.com>
Cc:     Keith Busch <kbusch@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
Message-ID: <20200909223540.GA27590@gondor.apana.org.au>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
 <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
 <b0c31cbb82aa64027569dff69803ca3ec2f65501.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0c31cbb82aa64027569dff69803ca3ec2f65501.camel@perches.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 09, 2020 at 02:09:32PM -0700, Joe Perches wrote:
> On Wed, 2020-09-09 at 13:55 -0700, Keith Busch wrote:
> > On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> > > diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> > > index eea0f453cfb6..8aac5bc60f4c 100644
> > > --- a/crypto/tcrypt.c
> > > +++ b/crypto/tcrypt.c
> > > @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
> > >  		test_hash_speed("streebog512", sec,
> > >  				generic_hash_speed_template);
> > >  		if (mode > 300 && mode < 400) break;
> > > -		fallthrough;
> > > +		break;
> > >  	case 399:
> > >  		break;
> > 
> > Just imho, this change makes the preceding 'if' look even more
> > pointless. Maybe the fallthrough was a deliberate choice? Not that my
> > opinion matters here as I don't know this module, but it looked a bit
> > odd to me.
> 
> It does look odd to me too.
> 
> It's also just a test module though so the
> code isn't particularly crucial.
> 
> Herbert/David? thoughts?

Please read the function as a whole, that fallthrough (and every other
one in do_test) needs to stay.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
