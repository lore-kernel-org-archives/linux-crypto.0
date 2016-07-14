From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH] DH support: add KDF handling support
Date: Thu, 14 Jul 2016 04:00:57 -0400
Message-ID: <CAH8yC8=GUqm5w069_42SWpjTwcuQxvmCtrAfzX9BnoyW_PEYwA@mail.gmail.com>
References: <4161793.TTVXSVQtZL@positron.chronox.de> <1652054.TS73CfBaWe@positron.chronox.de>
 <alpine.OSX.2.20.1607131520480.52983@mjmartin-mac01.local> <1954976.nIU2Zma9Rk@tauon.atsec.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: keyrings@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:35808 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897AbcGNIA6 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Jul 2016 04:00:58 -0400
In-Reply-To: <1954976.nIU2Zma9Rk@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Note, as shared secrets potentially post-processed by a KDF usually are again
> used as key or data encryption keys, they need to be truncated/expanded to a
> specific length anyway. A KDF inherently provides the truncation support to
> any arbitrary length. Thus, I would think that the caller needs to provide
> that length but does not need to truncate the output itself.

As far as I know, there's no reduction in proof that a truncated hash
is as secure as the non-truncated one. One of the reasons to provide
the output length as a security parameter is to help avoid truncation
and related hash output attacks.

Also see Kelsey's work on the subject;
http://www.google.com/search?q=nist+kelsey+truncated+hash.

Jeff
