From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: strange crypto speeds, sort of
Date: Mon, 24 Mar 2008 23:19:28 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0803242307280.9368@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754335AbYCXWTp@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,


How come reading a file from a filesystem on an encrypted block device
is faster than reading the encrypted block device itself?

Linux home 2.6.23.17-rt #1 SMP PREEMPT RT 2007/10/26 14:17:15 
UTC i686 athlon i386 GNU/Linux
cryptsetup 1.0.5

/home # echo 3 >/proc/sys/vm/drop_caches
/home # dd_rescue foo /dev/null
...
Summary for foo -> /dev/null:
dd_rescue: (warning): /dev/null (120704.0k): Invalid argument!
dd_rescue: (info): ipos:    120704.0k, opos:    120704.0k, xferd:    120704.0k
                    errs:      0, errxfer:         0.0k, succxfer:    120704.0k
              +curr.rate:     8728kB/s, avg.rate:    13482kB/s, avg.load:  7.1%

/home # echo 3 >/proc/sys/vm/drop_caches
/home # dd_rescue /dev/mapper/home /dev/null
...
Summary for /dev/mapper/home -> /dev/null:
dd_rescue: (info): ipos:     21504.0k, opos:     21504.0k, xferd:     21504.0k
                    errs:      0, errxfer:         0.0k, succxfer:     21504.0k
              +curr.rate:     4291kB/s, avg.rate:     4291kB/s, avg.load:  5.8%
