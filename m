From: Michael Buesch <mb@bu3sch.de>
Subject: Re: [dm-devel] Re: NULL data pointer dereference in kcryptd
Date: Sat, 1 Aug 2009 12:07:12 +0200
Message-ID: <200908011207.13090.mb@bu3sch.de>
References: <200907312254.45630.mb@bu3sch.de> <20090801002708.GA6292@gondor.apana.org.au> <4A74050B.6080608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: device-mapper development <dm-devel@redhat.com>,
	davem@davemloft.net, linux-crypto@vger.kernel.org
To: Milan Broz <mbroz@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:42814 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZHAKHQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 Aug 2009 06:07:16 -0400
In-Reply-To: <4A74050B.6080608@redhat.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Saturday 01 August 2009 11:04:11 Milan Broz wrote:
> Herbert Xu wrote:
> > On Fri, Jul 31, 2009 at 10:54:45PM +0200, Michael Buesch wrote:
> >> [15577.988608] NIP [c0000000000b8034] .mempool_alloc+0x74/0x1a0
> >> [15577.988614] LR [c000000000139bdc] .bio_alloc_bioset+0x4c/0x130
> >> [15577.988616] Call Trace:
> >> [15577.988619] [c0000001f022fb60] [c0000001f022fbf0] 0xc0000001f022fbf0 (unreliable)
> >> [15577.988625] [c0000001f022fc40] [c000000000139bdc] .bio_alloc_bioset+0x4c/0x130
> >> [15577.988632] [c0000001f022fcf0] [c0000000005334a0] .kcryptd_crypt+0x210/0x520
> >> [15577.988637] [c0000001f022fde0] [c000000000068018] .worker_thread+0x248/0x3e0
> >> [15577.988642] [c0000001f022ff00] [c00000000006e1e4] .kthread+0x84/0xe0
> >> [15577.988648] [c0000001f022ff90] [c000000000021830] .kernel_thread+0x54/0x70
> 
> That seems like mempool is NULL in bio_alloc_bioset. That mempool/bioset is destroyed only
> when crypt mapping is destroyed, after workqueue is flushed, so it should not happen...
> 
> Which command did you exactly run to trigger this? only sync & mkfs on existing
> LUKS device or there was also some cryptsetup luksClose (or something removing
> mapping) before?

I started mke2fs on a large luks mapping (1TB). So that takes quite a while.
So I had some time to do some other stuff simultaneously. It happens that I
did a "sync" while the mke2fs command was still running. The sync immediately froze.
Then after mke2fs finished writing the inode tables it also froze.
Then I looked into dmesg and saw the oops.
I don't think I did a cryptsetup action while mke2fs was running. I just mounted a few
USB sticks and copied a few files around and did that sync operation...

> 
> > kcryptd actually belongs to drivers/md/dm-crypt.c.  So please post
> > to the DM list.
> 
> yes, this is dm-crypt or block layer problem. But I read linux-crypto list too:-)
> 
> Milan
> --
> mbroz@redhat.com
> 
> 
> 



-- 
Greetings, Michael.
