From: "J. Paul Reed" <preed@release-approaches.com>
Subject: 3.14.61 breaks dm disk drive encryption?
Date: Mon, 22 Feb 2016 22:17:55 -0800
Message-ID: <20160223061755.GA4979@release-approaches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53312 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926AbcBWGR6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 23 Feb 2016 01:17:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id B0BAB209F3
	for <linux-crypto@vger.kernel.org>; Tue, 23 Feb 2016 01:17:57 -0500 (EST)
Received: from release-approaches.com (c-50-174-131-147.hsd1.ca.comcast.net [50.174.131.147])
	by mail.messagingengine.com (Postfix) with ESMTPA id 3A3B168009C
	for <linux-crypto@vger.kernel.org>; Tue, 23 Feb 2016 01:17:57 -0500 (EST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hey all,

I just upgraded from 3.14.60 to 3.14.61, and when I try to mount my
luks-encrypted disk drives, I get an error saying the mapping couldn't be
created and to check whether aes-xts-plain64 is compiled into the kernel;
it is:

[preed@underworld linux-3.14.61]$ grep CRYPTO_AES .config
CONFIG_CRYPTO_AES=y
CONFIG_CRYPTO_AES_X86_64=y
CONFIG_CRYPTO_AES_NI_INTEL=y

This all works fine with 3.14.60 (and previous 3.14-versions), and I
compiled .61 by copying the .config over and "make oldconfig"'ing, so I'd
expect this to work.

I looked around for other config options I need to turn on but nothing
popped out at me. Looking through the changelog for 3.14.61, perhaps this
is related to the fix for 7e6978fb73 ?

I can provide more exact error messaging if it'd help, but I'd expect a
"make oldconfig" to carry over all the options correctly, as it's done for
the rest of the 3.14 kernels.

Any ideas?

thanks,
preed
-- 
J. Paul Reed
Release Engineering Approaches
Simply ship. Every time.

http://release-approaches.com/
(415) 226-9655
