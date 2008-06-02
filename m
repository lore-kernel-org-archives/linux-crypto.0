From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: BUG in scatterlist.h when loading tcrypt
Date: Mon, 2 Jun 2008 14:46:27 +0400
Message-ID: <20080602104627.GA9967@2ka.mipt.ru>
References: <20080602090529.GA28838@alice>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Eric Sesterhenn <snakebyte@gmx.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:49186 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752610AbYFBKqe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 Jun 2008 06:46:34 -0400
Content-Disposition: inline
In-Reply-To: <20080602090529.GA28838@alice>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Mon, Jun 02, 2008 at 11:08:59AM +0200, Eric Sesterhenn (snakebyte@gmx.de) wrote:
> i guess this shouldnt happen, got this
> when loading the tcrypt module
> 
> [   60.113277] testing ecb(seed) decryption across pages (chunking)
> [   60.113309] 
> [   60.113311] testing cts(cbc(aes)) encryption
> [   60.120984] test 1 (128 bit key):
> [   60.121153] ------------[ cut here ]------------
> [   60.121312] kernel BUG at include/linux/scatterlist.h:65!

Fix will be in Linus' tree soon, Herbert just pushed it upstream.
http://git.kernel.org/?p=linux/kernel/git/herbert/crypto-2.6.git;a=commit;h=c4913c7b71abc79b008a3c118628cfb59bdb0efc

-- 
	Evgeniy Polyakov
