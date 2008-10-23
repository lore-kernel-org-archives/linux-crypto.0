From: "Barry G" <mr.scada@gmail.com>
Subject: Enabling Talitos kills all IPsec traffic
Date: Thu, 23 Oct 2008 16:12:22 -0700
Message-ID: <61362e760810231612s6fe4dfbfk1c63986881d7152e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org,
	"Kim Phillips" <kim.phillips@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:41243 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759270AbYJWXMZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 23 Oct 2008 19:12:25 -0400
Received: by ey-out-2122.google.com with SMTP id 6so197021eyi.37
        for <linux-crypto@vger.kernel.org>; Thu, 23 Oct 2008 16:12:23 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

I am working on setting up an IPsec network with two PowerQuicc 8349E devices.
I am using Strongswan for key negotiation.  I have a test connection between two
devices running the 2.6.27.3 kernel.  Everything works fine with
CONFIG_CRYPTO_DEV_TALITOS
unset.  Strongswan configures the XFRM tunnels and I get ESP traffic flow
between my remote networks.

I wanted to enable the Talitos driver for hw entropy.  If I rebuild
the kernel with
CONFIG_CRYPTO_DEV_TALITOS set to y, strongswan still successfully negotiates
an IPsec SA, but no traffic flows.

I have a very repeatable configuration (everything configured from
rc.local, etc).

Any ideas what is wrong?  Any recommendations on places to start looking?

Also, is it correct that Talitos only accelerates AEAD connections, not ESP/AH
protocols so there will be no performance increase for me until Strongswan
adds rfc5282 support?

Attached is the output for my device.  The output is the same with or
without the TALITOS driver (Except for the keys and the SPI values of course):
# ip xfrm state
src 192.168.1.1 dst 192.168.1.2
	proto esp spi 0xcc0b06a6 reqid 1 mode tunnel
	replay-window 32
	auth hmac(sha256)
0xffab7c320d8375cad9633af7c67d923df47183296b9eb8a25fca5c8e5670e8ac
	enc cbc(aes) 0x1e918673fd34a1dbb52480e8587f656790194727114cddfdc5f41d19972c1649
	sel src 0.0.0.0/0 dst 0.0.0.0/0
src 192.168.1.2 dst 192.168.1.1
	proto esp spi 0xc929ef13 reqid 1 mode tunnel
	replay-window 32
	auth hmac(sha256)
0x2330715271fb3cb23e35bce99ef21c60e4c6a81d684533c2be114e6d1e85197e
	enc cbc(aes) 0x1cc443b036fcf1aeb4d6e25da46e07681b513ea489816c507b32f0f79e1cbbc2
	sel src 0.0.0.0/0 dst 0.0.0.0/0
# ip xfrm policy
src 0.0.0.0/0 dst 0.0.0.0/0
	dir 3 priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
	dir 4 priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
	dir 3 priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
	dir 4 priority 0
src 0.0.0.0/0 dst 0.0.0.0/0
	dir 3 priority 0
src 10.201.0.0/16 dst 192.168.2.0/24
	dir out priority 2840
	tmpl src 192.168.1.1 dst 192.168.1.2
		proto esp reqid 1 mode tunnel
src 192.168.2.0/24 dst 10.201.0.0/16
	dir in priority 2760
	tmpl src 192.168.1.2 dst 192.168.1.1
		proto esp reqid 1 mode tunnel
src 192.168.2.0/24 dst 10.201.0.0/16
	dir fwd priority 2760
	tmpl src 192.168.1.2 dst 192.168.1.1
		proto esp reqid 1 mode tunnel

Thanks in advance for any help,

Barry
