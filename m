From: "Barry G" <mr.scada@gmail.com>
Subject: Re: Debugging Talitos
Date: Tue, 22 Jul 2008 14:37:34 -0700
Message-ID: <61362e760807221437j188866d5ve15cce716e65265d@mail.gmail.com>
References: <61362e760807211527w550f070dk37fd59454f839c3d@mail.gmail.com>
	 <20080721175004.642fc876.kim.phillips@freescale.com>
	 <61362e760807220836m59207c33y1c6b673fdd2d03@mail.gmail.com>
	 <61362e760807220941t4eebd229g45838c1c8209c1c5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Kim Phillips" <kim.phillips@freescale.com>,
	linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.246]:39568 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYGVVhg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Jul 2008 17:37:36 -0400
Received: by an-out-0708.google.com with SMTP id d40so477783and.103
        for <linux-crypto@vger.kernel.org>; Tue, 22 Jul 2008 14:37:35 -0700 (PDT)
In-Reply-To: <61362e760807220941t4eebd229g45838c1c8209c1c5@mail.gmail.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I have tracked down a problem with the talitos driver and the way
it interacts with the device tree on the 8349.

In the platform specific drivers (/arch/powerpc/platforms/83xx/
mpc834x_itx.c in our case), we setup the bus as .compatible with
"fsl,pq2pro-localbus".  This causes the of_platform_bus_probe
to find the localbus entry in the device tree
(/arch/powerpc/boot/dts/mpc8349emitx.dts) and bind the localbus
entry to of_platform_bus_type.

At this point in time of_platform_bus_type has two entities,
localbus and pata.

Along comes talitos at a later point in time who calls
of_register_platform_driver with a match_table of fsl,sec2.0
which exits in the soc hierarchy of the device tree.

of_register_platform_driver calls of_register_driver passing
in the of_platform_bus_type of the localbus found above,
and eventually calls into of_match_device which fails to
find fsl,sec2.0 as only localbus and pata exist,
and as a result of_match_device fails and talitos is never probed.

I found that by moving the compatible = "fsl,pq2pro-localbus"
line in my dts from my localbus to my soc node the system
booted and correctly searched the soc for talitos and it worked.
I don't think this is the recommended solution though.

I am new to kernel debugging, so any input would be appreciated.
What is the proper way to fix this?

Thanks,

Barry

P.S.  Would the linuxppc-embedded mailing list be more appropriate for this?
