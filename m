From: lakshmi prasanna <lakshmi.prasanna@freescale.com>
Subject: help on how to use OCF for SSL v3.0 protocol's cryptographic
  operations
Date: Thu, 05 Mar 2009 19:32:29 +0530
Message-ID: <200903051359.n25DxvlH020441@az33smr01.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:63284 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654AbZCEOAE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2009 09:00:04 -0500
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id n25E00Nm024570
	for <linux-crypto@vger.kernel.org>; Thu, 5 Mar 2009 07:00:00 -0700 (MST)
Received: from intoto786.freescale.com ([10.232.113.99])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id n25DxvlH020441
	for <linux-crypto@vger.kernel.org>; Thu, 5 Mar 2009 07:59:59 -0600 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I am using OCF's ixp driver for Cryptographic operations.
TLS protocol is working fine, since it uses only a single 
Authentication operation to be performed.

Since SSL v3.0 protocol needs two rounds of operations to be 
performed to calculate the MAC, I am calling OCF crypto_dispatch() 
twice with the relevant data.
Since I am using SHA, 40 bytes of 0x36 and 0x5c pads are used

Round 1 : HMAC(Initial seed+data)
Initial seed = Client_write_mac_secret+40 bytes of 0x36+sequence 
number+application type(0x17)+data length

Round 2: HMAC(Final Seed+result of Round 1)
Final Seed = Client_write_mac_secret+40 bytes of 0x5C

The calculated MAC is different from the client generated MAC.

Can anyone help me with what data to be passed to the OCF, the seeds 
to be used for SSLv3.0, and other required data.

I have gone through the SSLv3.0 draft, and surely I'm passing the 
right seeds and offsets to the OCF, still the thing does not work...
May be I'm missing out something....
Please help......



thanks,
Lakshmi Prasanna 

