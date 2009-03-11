From: Milan Broz <mbroz@redhat.com>
Subject: Re: [2.6.28.5] dm/crypt oops: "unable to handle kernel NULL pointer
 dereference" (tainted)
Date: Wed, 11 Mar 2009 21:42:26 +0100
Message-ID: <49B82232.2090802@redhat.com>
References: <200903111319.43778@rk-nord.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
To: Melchior FRANZ <melchior.franz@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36944 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbZCKUmg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Mar 2009 16:42:36 -0400
In-Reply-To: <200903111319.43778@rk-nord.at>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Melchior FRANZ wrote:
> 
>   umount ...
>   cryptsetup remove ...
>   losetup -d ...
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000004
> IP: [<c0158a75>] mempool_free+0xd/0x9a
...

Yes, I know about that problem and I am almost sure that
it is fixed by patch I sent there http://lkml.org/lkml/2009/3/5/63

Something changed in timing so probability of hitting that
bug apparently increased in the last kernel (the problem was there always:-)

I had asked Alasdair to queue that to dm queue for upstream...

Milan
--
mbroz@redhat.com
