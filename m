From: Dennison Williams <evoltech@2inches.com>
Subject: Re: ext3 filesystem is not recognized after losetup -e aes
Date: Mon, 07 Jan 2008 12:37:28 -0800
Message-ID: <47828D88.2080903@2inches.com>
References: <477F2813.3010003@2inches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ns1.2inches.com ([64.147.164.71]:60631 "EHLO vostok.2inches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755174AbYAGUhd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Jan 2008 15:37:33 -0500
Received: from [192.168.1.105] (adsl-70-132-11-93.dsl.snfc21.sbcglobal.net [70.132.11.93])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: evoltech)
	by vostok.2inches.com (Postfix) with ESMTP id B06E6182889E
	for <linux-crypto@vger.kernel.org>; Mon,  7 Jan 2008 12:17:18 -0800 (PST)
In-Reply-To: <477F2813.3010003@2inches.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I am pretty confident that this problem is somewhere in the block driver
/ crypto driver combo and am considering digging through the code.
Before I do can anyone point me in the direction pertinent documentation
, specific drivers, etc.?

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
> 
> I then tried to e2fsck the /dev/loop1 partition with all of the
> different blocks that were reported from:
> mke2fs -n /dev/loop1
> with no luck still.
> 
> I don't think that LVM has anything to do with it, because on another
> volume group, that didn't loose any drives, there is a encrypted logical
> volume that has the same problem.  Actually all of the drives that I
> have encrypted have this problem now. I am unsure of where the problem
> actually is, and how to go about debugging it. Any suggestions would be
> appreciated.
> 
> Sincerely,
> Dennison Williams
> -
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
*****************************************************************
* To communicate with me securely, please email me and I will   *
* send you my public key.  We can then verify each others       *
* fingerprints in person, or over the phone.                    *
*                                                               *
* I am open and willing to talk about setting up PGP, the       *
* security problems inherent with PGP, and alternatives to PGP  *
* for secure electronic communication.                          *
*****************************************************************
