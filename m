Return-Path: <SRS0=sZ2L=CS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D162C43461
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 21:09:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D6C20BED
	for <linux-crypto@archiver.kernel.org>; Wed,  9 Sep 2020 21:09:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgIIVJg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 9 Sep 2020 17:09:36 -0400
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:34596 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726408AbgIIVJg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 9 Sep 2020 17:09:36 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id CC7DB180A7FFF;
        Wed,  9 Sep 2020 21:09:34 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: copy43_3c134c7270e0
X-Filterd-Recvd-Size: 2033
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf01.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 21:09:33 +0000 (UTC)
Message-ID: <b0c31cbb82aa64027569dff69803ca3ec2f65501.camel@perches.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to
 break;
From:   Joe Perches <joe@perches.com>
To:     Keith Busch <kbusch@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>
Date:   Wed, 09 Sep 2020 14:09:32 -0700
In-Reply-To: <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
         <20200909205558.GA3384631@dhcp-10-100-145-180.wdl.wdc.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 2020-09-09 at 13:55 -0700, Keith Busch wrote:
> On Wed, Sep 09, 2020 at 01:06:39PM -0700, Joe Perches wrote:
> > diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
> > index eea0f453cfb6..8aac5bc60f4c 100644
> > --- a/crypto/tcrypt.c
> > +++ b/crypto/tcrypt.c
> > @@ -2464,7 +2464,7 @@ static int do_test(const char *alg, u32 type, u32 mask, int m, u32 num_mb)
> >  		test_hash_speed("streebog512", sec,
> >  				generic_hash_speed_template);
> >  		if (mode > 300 && mode < 400) break;
> > -		fallthrough;
> > +		break;
> >  	case 399:
> >  		break;
> 
> Just imho, this change makes the preceding 'if' look even more
> pointless. Maybe the fallthrough was a deliberate choice? Not that my
> opinion matters here as I don't know this module, but it looked a bit
> odd to me.

It does look odd to me too.

It's also just a test module though so the
code isn't particularly crucial.

Herbert/David? thoughts?


