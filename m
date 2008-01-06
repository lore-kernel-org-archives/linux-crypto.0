From: Dennison Williams <evoltech@2inches.com>
Subject: Re: ext3 filesystem is not recognized after losetup -e aes
Date: Sat, 05 Jan 2008 16:32:45 -0800
Message-ID: <478021AD.3040608@2inches.com>
References: <477F2813.3010003@2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns1.2inches.com ([64.147.164.71]:47758 "EHLO vostok.2inches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058AbYAFAct (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 5 Jan 2008 19:32:49 -0500
Received: from [192.168.2.101] (adsl-75-36-186-243.dsl.pltn13.sbcglobal.net [75.36.186.243])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: evoltech)
	by vostok.2inches.com (Postfix) with ESMTP id B37E71828853
	for <linux-crypto@vger.kernel.org>; Sat,  5 Jan 2008 16:12:59 -0800 (PST)
In-Reply-To: <477F2813.3010003@2inches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dennison Williams wrote:
> Here is the setup: MD software RAID 5 on 4 disks (md0), a LVM logical
> volume (/dev/volume_group/logical_volume) comprised of one physical
> device (/dev/md0), a encryption layer provided by the cryptoloop driver
> (losetup -e aes /dev/loop0 /dev/volume_group/logical_volume), then a
> EXT3 file system (mkfs.ext3 /dev/loop0).
> 
> Recently the RAID device kicked out one of the disks during a large file
> transfer. After re-adding the disk to the array whith "mdadm /dev/mdo
> -add /dev/sde (smartctl didn't report
> anything wrong with it, I am not sure why this happened), authenticating
> against the cryptographic layer, then trying to mount the drive, I get
> the following error:
> 
> [root@storage redhat]# mount -t ext3 /dev/loop1 /terrorbyte/1/
> mount: wrong fs type, bad option, bad superblock on /dev/loop1,
> 
> The message in /var/log/message is:
> VFS: Can't find ext3 filesystem on dev loop1.


I saw in the encryption howto, section 6.1, talks about the effects of
blocks occupying different space when the kernel is compiled with the
CONFIG_BLK_LOOP_DEV_USE_REL_BLOCK option.  Would this effect also be
possible by a RAID5 system re-syncing a drive?  I don't see this
configuration option anywhere in the 2.6.18 kernel (I am using a redhat
build of this kernel).
