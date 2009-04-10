From: Karl Hiramoto <karl@hiramoto.org>
Subject: Re: help for ixp4xx crypto panic
Date: Fri, 10 Apr 2009 10:24:47 +0200
Message-ID: <49DF024F.2090003@hiramoto.org>
References: <200904091256010463689@163.com>, <49DD9E23.9070101@hiramoto.org>, <200904091612593907204@163.com>, <49DDED9A.9020402@hiramoto.org> <200904100926168752615@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	christian <christian@hohnstaedt.de>
To: timenhhf <timenhhf@163.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:35511 "EHLO
	spunkymail-a12.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753248AbZDJIYy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Apr 2009 04:24:54 -0400
In-Reply-To: <200904100926168752615@163.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

timenhhf wrote:
> hi,
> thanks for your reply.
> the attached file is the microcode file included in CSR2.4 crypto
> package that i got from INTEL's FAE.
> And the crypto function supported or not isn't really what i'm concern
> now, because after I startup the NPE module, the network can't work well.
> the detail steps as followed:
> (1)gcc -Wall IxNpeMicrocode.c -o IxNpeMicrocode
Which image are you specificing in the .h?
I currently use
IX_NPEDL_NPEIMAGE_NPEC_CRYPTO_AES_ETH_LEARN_FILTER_FIREWALL and
IX_NPEDL_NPEIMAGE_NPEB_ETH_SPAN_FIREWALL_VLAN_QOS_HDR_CONV

> (2)./IxNpeMicrocode (get NPE-B & NPE-C)
> (3)cp NPEs to /lib/firmware : cp -a NPE-* /lib/firmware/
> (4)Make ixp425's ramdisk.gz package
> (5)after system startup, do:
> echo "/sbin/mdev" > /proc/sys/kernel/hotplug
> /sbin/mdev -s

You should see the busybox doc. I do:

mount -t proc proc /proc
mount -t tmpfs -o size=64K mdev /dev
mkdir /dev/pts
mount -t devpts devpts /dev/pts
mount -t sysfs sysfs /sys
echo /sbin/mdev > /proc/sys/kernel/hotplug
mdev -s



> (6)insmod the NPE modules:
> modprobe ixp4xx_eth
> IXP4xx Queue Manager initialized.
> eth0: MII PHY 0 on NPE-B
> eth1: MII PHY 1 on NPE-C

if you modprobe ixp4xx_crypto does it come up?

> (7)lsmod to check:
> Module Size Used by Not tainted
> ixp4xx_eth 12824 0
> ixp4xx_npe 7200 3 ixp4xx_eth
> ixp4xx_qmgr 4824 1 ixp4xx_eth
> (8)set the NPE MAC address:
> ifconfig eth0 hw ether 00:03:05:06:07:08
> (9)ifconfig eth0 192.168.1.1 netmask 255.255.255.0

perhaps "ip link set eth0 up"

> (10) ping the NPE own interface:
> # ping -c 1 192.168.1.11
> PING 192.168.1.11 (192.168.1.11): 56 data bytes
> 64 bytes from 192.168.1.11: seq=0 ttl=64 time=0.539 ms
> (11)ping -c 1 192.168.1.98 (192.168.1.98 is the PC's ip address)
> PING 192.168.1.98 (192.168.1.98): 56 data bytes
> --- 192.168.1.98 ping statistics ---
> 1 packets transmitted, 0 packets received, 100% packet loss
> (12)check the interface status
> # ifconfig
> eth0 Link encap:Ethernet HWaddr 00:01:03:08:01:02
> inet addr:192.168.1.11 Bcast:192.168.1.255 Mask:255.255.255.0
> UP BROADCAST RUNNING MULTICAST MTU:1500 Metric:1
> RX packets:0 errors:0 dropped:0 overruns:0 frame:0
> TX packets:3 errors:0 dropped:0 overruns:0 carrier:0
> collisions:0 txqueuelen:100
> RX bytes:0 (0.0 B) TX bytes:126 (126.0 B)
> Comments? thank you very much.

What does "ip link" and "ip addr" show?

perhaps send the entire "dmesg" it should contain info if the NPE is
starting up correctly.

-- 

--
Karl Hiramoto  http://karl.hiramoto.org/


