From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/12] staging: ccree: correct coding style violations
Date: Mon, 29 May 2017 10:36:28 -0700
Message-ID: <1496079388.18529.3.camel@perches.com>
References: <1495982440-10047-1-git-send-email-gilad@benyossef.com>
         <1495982440-10047-2-git-send-email-gilad@benyossef.com>
         <20170529143728.GA12428@kroah.com> <1496077030.18529.1.camel@perches.com>
         <CAOtvUMeU=c=_H3tb0iu7967-z_yL5EM3Y+8ZmgXjMwg3S7jhzA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-crypto@vger.kernel.org, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Ofir Drang <ofir.drang@arm.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtprelay0105.hostedemail.com ([216.40.44.105]:40382 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750844AbdE2Rgb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 May 2017 13:36:31 -0400
In-Reply-To: <CAOtvUMeU=c=_H3tb0iu7967-z_yL5EM3Y+8ZmgXjMwg3S7jhzA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2017-05-29 at 20:11 +0300, Gilad Ben-Yossef wrote:
> On Mon, May 29, 2017 at 7:57 PM, Joe Perches <joe@perches.com> wrote:
> > On Mon, 2017-05-29 at 16:37 +0200, Greg Kroah-Hartman wrote:
> > > On Sun, May 28, 2017 at 05:40:26PM +0300, Gilad Ben-Yossef wrote:
> > > > cc_crypto_ctx.h had multiple coding style violations reported by
> > > > checkpatch. Fix them all.
> > > 
> > > Sorry, no.  You need to do only one-thing-per-patch, and "fix all coding
> > > style issues is not "one thing".  I wouldn't take this kind of patch
> > > from anyone else, so why should I take it from you?  :)
> > 
> > Because he's the named MAINTAINER of the subsystem
> > and you are acting as an upstream conduit.
> > 
> 
> LOL. Thank you Joe, but I have opted to upstream via staging to get the guidance
> and review of Greg and other developers kind enough to offer it, and I'd be a
> fool not to listen to them.

For reviews of technical merit, true.

For reviews of commit log wording of whitespace
changes, where git diff -w shows no difference,
less true.

This patch seems almost entirely whitespace except
one bit reformatting a comment block.

Breaking those down into changes like:
	added space after commas
	added spaces around bit shifts
	added spaces around arithmetic
is simply excessive.

The only comment I would have given would be to
change the patch context that added line comment
initiators to use the /** kernel-doc style.

And maybe a style change of

#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE (CC_MULTI2_SYSTEM_KEY_SIZE + \
					  CC_MULTI2_DATA_KEY_SIZE)

to 

#define CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE \
	(CC_MULTI2_SYSTEM_KEY_SIZE + CC_MULTI2_DATA_KEY_SIZE)

as it's sometimes easier to scan arithmetic on a single line.

btw: this #define seems misleading as it's used in both .min_keysize
and .max_keysize with "+ 1" and key[CC_MULTI2_SYSTEM_N_DATA_KEY_SIZE]
is also used.
