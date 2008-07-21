From: "Barry G" <mr.scada@gmail.com>
Subject: Debugging Talitos
Date: Mon, 21 Jul 2008 15:27:33 -0700
Message-ID: <61362e760807211527w550f070dk37fd59454f839c3d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org, kim.phillips@freescale.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.243]:56433 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYGUW1f (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 21 Jul 2008 18:27:35 -0400
Received: by an-out-0708.google.com with SMTP id d40so401860and.103
        for <linux-crypto@vger.kernel.org>; Mon, 21 Jul 2008 15:27:33 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am working on getting HW acceleration working via the talitos
driver for the 8347E.

We are running 2.6.25.4 with the realtime patchset and ubifs.
I have a testbed setup of machines like:
A<->B<->C<->D

I am running a talitos aware kernel on B and C.  (I cloned linux-2.6 and
copied talitos.[c|h] and changed Kconfig and Makefile in drivers/crypto.

Unfortunately, I am still seeing only about 20 Mbit/sec from iperf (same
as before I installed the talitos module).  I also don't see any talitos
stuff in the drivers:
# cat /proc/crypto | grep -i talitos
#

I do have a /sys/bus/of_platform/drivers/talitos folder with uevent,unbind,bind
though.

dmesg | grep -i talitos also returns nothing.

What is the best way to go about debugging the crypto stuff?  Should I jump
in and start printk'ing everything or ?  Do I need other changes from
the tree than the taliltos driver?

BTW, here is the relevent entry in the DTS:
crypto@30000 {
   device_type = "crypto";
   model = "SEC2";
   compatible = "talitos";
   reg = <30000 10000>;
   interrupts = <b 8>;
   interrupt-parent = < &ipic >;
   num-channels = <4>;
   channel-fifo-len = <18>;
   exec-units-mask = <0000007e>;
   descriptor-types-mask = <01010ebf>;
};

Thanks,

Barry
