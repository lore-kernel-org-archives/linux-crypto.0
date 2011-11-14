From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] crypto: mv_cesa - fix hashing of chunks > 1920 bytes
Date: Mon, 14 Nov 2011 07:57:13 -0800
Message-ID: <20111114155713.GA25105@kroah.com>
References: <1321285303-28925-1-git-send-email-phil.sutter@viprinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, stable@vger.kernel.org,
	linux-crypto@vger.kernel.org
To: Phil Sutter <phil.sutter@viprinet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37315 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755027Ab1KNP5U (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Nov 2011 10:57:20 -0500
Received: from compute6.internal (compute6.nyi.mail.srv.osa [10.202.2.46])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id B95AA20B9D
	for <linux-crypto@vger.kernel.org>; Mon, 14 Nov 2011 10:57:19 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1321285303-28925-1-git-send-email-phil.sutter@viprinet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 14, 2011 at 04:41:43PM +0100, Phil Sutter wrote:
> This was broken by commit 7759995c75ae0cbd4c861582908449f6b6208e7a (yes,
> myself). The basic problem here is since the digest state is only saved
> after the last chunk, the state array is only valid when handling the
> first chunk of the next buffer. Broken since linux-3.0.
> 
> Signed-off-by: Phil Sutter <phil.sutter@viprinet.com>
> ---

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
