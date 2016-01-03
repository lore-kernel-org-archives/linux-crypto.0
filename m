From: Milan Broz <gmazyland@gmail.com>
Subject: Re: next-20151231 - aes crypto algorithm went missing?
Date: Sun, 3 Jan 2016 11:20:03 +0100
Message-ID: <5688F5D3.7080605@gmail.com>
References: <4632.1451799253@turing-police.cc.vt.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38819 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbcACKUG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 3 Jan 2016 05:20:06 -0500
In-Reply-To: <4632.1451799253@turing-police.cc.vt.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/03/2016 06:34 AM, Valdis Kletnieks wrote:
> So booting into a next-20151222 kernel, I can mount an external drive
> that uses cryptLuks.  I try -1231, and I get this failure:
> 
> Failed to setup dm-crypt key mapping for device /dev/sdb2.
> Check that kernel supports aes-cbc-essiv:sha256 cipher (check syslog for more info).
> 
> Tracked it down to this difference in /proc/crypto between the 12/22 and 12/31:

...
> This ringing any bells, before I start the New Year with a bisect? :)

Perhaps see the discussion in thread
[PATCH v2] crypto: algif_skcipher - Require setkey before accept(2)

Could you try to revert this patch?
http://git.kernel.org/cgit/linux/kernel/git/next/linux-next-history.git/commit/crypto?id=9f47e11b9e3169ff4cb35b3cdac0e0f7c2fcfe27

Milan
