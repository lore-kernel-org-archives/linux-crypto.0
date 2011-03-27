From: Thomas Siedlich <thomas.siedlich@yahoo.com>
Subject: loop-aes: It is not longer possible to create a filesystem on an encrypted DVD-RAM
Date: Sun, 27 Mar 2011 10:16:41 -0700 (PDT)
Message-ID: <134368.68091.qm@web114114.mail.gq1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:41015 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754043Ab1C0RQn (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 27 Mar 2011 13:16:43 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!
 
I try to format a loop-aes encrypted DVD-RAM in /dev/sr0 with mke2fs.
 
,----[command line]
| eagle:~# losetup -v -e AES256 -K ./key.gpg /dev/loop2 /dev/sr0
| Password:
| eagle:~# losetup /dev/loop2
| /dev/loop2: [000b]:985 (/dev/sr0) encryption=AES256 multi-key-v3
| eagle:~# mke2fs -K -N 2048 -m 0 -b 4096 -v /dev/loop2
| mke2fs 1.41.12 (17-May-2010)
| fs_types for mke2fs.conf resolution: 'ext2', 'default'
| Filesystem label=
| OS type: Linux
| Block size=4096 (log=2)
| Fragment size=4096 (log=2)
| Stride=0 blocks, Stripe width=0 blocks
| 2240 inodes, 1118352 blocks
| 0 blocks (0.00%) reserved for the super user
| First data block=0
| Maximum filesystem blocks=1149239296
| 35 block groups
| 32768 blocks per group, 32768 fragments per group
| 64 inodes per group
| Superblock backups stored on blocks:
|   32768, 98304, 163840, 229376, 294912, 819200, 884736
|
| Writing inode tables: done
| Writing superblocks and filesystem accounting information: done
|
| This filesystem will be automatically checked every 29 mounts or
| 180 days, whichever comes first.  Use tune2fs -c or -i to override.
| eagle:~# echo $?
| 0
| eagle:~#
`----
 
 
After the successfull mke2fs run ($? = 0) I have got this error message
in syslog:
 
,----[/var/log/syslog]
| Mar 27 15:29:27 eagle kernel: loop2: loop_end_io_transfer err=-95 bi_rw=0x461
| Mar 27 15:29:27 eagle kernel: Buffer I/O error on device loop2, logical block 0
| Mar 27 15:29:27 eagle kernel: lost page write due to I/O error on loop2
| Mar 27 15:29:27 eagle kernel: loop2: loop_end_io_transfer err=-95 bi_rw=0x20
| Mar 27 15:29:27 eagle kernel: Buffer I/O error on device loop2, logical block 0
`----
 
 
And I'm not able to mount the freshly created file system:
 
,----[command line]
| eagle:~# mount -text2 /dev/loop2 /media/backup/
| mount: wrong fs type, bad option, bad superblock on /dev/loop2,
|        missing codepage or helper program, or other error
|        In some cases useful info is found in syslog - try
|        dmesg | tail  or so
|
| eagle:~#
`----
 
,----[/var/log/syslog]
| Mar 27 15:30:40 eagle kernel: EXT2-fs (loop2): error: can't find an ext2 filesystem on dev loop2.
`----
 
 
Do I the same without encryption this means:
 
,----[command line]
| eagle:~# mke2fs -K -N 2048 -m 0 -b 4096 -v /dev/sr0
| mke2fs 1.41.12 (17-May-2010)
| /dev/sr0 is entire device, not just one partition!
| Proceed anyway? (y,n) y
| fs_types for mke2fs.conf resolution: 'ext2', 'default'
| Filesystem label=
| OS type: Linux
| Block size=4096 (log=2)
| Fragment size=4096 (log=2)
| Stride=0 blocks, Stripe width=0 blocks
| 2240 inodes, 1118352 blocks
| 0 blocks (0.00%) reserved for the super user
| First data block=0
| Maximum filesystem blocks=1149239296
| 35 block groups
| 32768 blocks per group, 32768 fragments per group
| 64 inodes per group
| Superblock backups stored on blocks:
|   32768, 98304, 163840, 229376, 294912, 819200, 884736
|
| Writing inode tables: done
| Writing superblocks and filesystem accounting information: done
|
| This filesystem will be automatically checked every 30 mounts or
| 180 days, whichever comes first.  Use tune2fs -c or -i to override.
| eagle:~# mount -text2 /dev/sr0 /media/backup/
| eagle:~#
`----

It just works fine but unencrypted :-(.

I guess it is a problem with loop-aes. Have someone an idea how I
can track this down or has someone seen this already?

My recipe above did work two years ago. I have a couple of working
formatted DVD-RAM from this time. Only e2fsck doesn't work any longer
in fact with the same behavior as mke2fs above this means $? = 0 and
the same errors in /var/log/syslog.

Thanks for help
Thomas



      
