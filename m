From: David McCullough <David_Mccullough@securecomputing.com>
Subject: Re: help on how to use OCF for SSL v3.0 protocol's cryptographic operations
Date: Fri, 6 Mar 2009 10:49:33 +1000
Message-ID: <20090306004933.GB23972@securecomputing.com>
References: <200903051359.n25DxvlH020441@az33smr01.freescale.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ocf-linux-users@lists.sourceforge.net
To: lakshmi prasanna <lakshmi.prasanna@freescale.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:35285 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751077AbZCFAtg (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Mar 2009 19:49:36 -0500
Content-Disposition: inline
In-Reply-To: <200903051359.n25DxvlH020441@az33smr01.freescale.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Jivin lakshmi prasanna lays it down ...
> Hi,
> 
> I am using OCF's ixp driver for Cryptographic operations.
> TLS protocol is working fine, since it uses only a single 
> Authentication operation to be performed.


You probably want to move this to the ocf-linux mailing list:

    http://lists.sourceforge.net/mailman/listinfo/ocf-linux-users

> Since SSL v3.0 protocol needs two rounds of operations to be 
> performed to calculate the MAC, I am calling OCF crypto_dispatch() 
> twice with the relevant data.
> Since I am using SHA, 40 bytes of 0x36 and 0x5c pads are used
> 
> Round 1 : HMAC(Initial seed+data)
> Initial seed = Client_write_mac_secret+40 bytes of 0x36+sequence 
> number+application type(0x17)+data length
> 
> Round 2: HMAC(Final Seed+result of Round 1)
> Final Seed = Client_write_mac_secret+40 bytes of 0x5C
> 
> The calculated MAC is different from the client generated MAC.
> 
> Can anyone help me with what data to be passed to the OCF, the seeds 
> to be used for SSLv3.0, and other required data.
> 
> I have gone through the SSLv3.0 draft, and surely I'm passing the 
> right seeds and offsets to the OCF, still the thing does not work...
> May be I'm missing out something....
> Please help......

Which OCF crypto driver are you using ?  Talitos or cryptosoft or
something else ?

Cheers,
Davidm

-- 
David McCullough,  david_mccullough@securecomputing.com,  Ph:+61 734352815
McAfee - SnapGear  http://www.snapgear.com                http://www.uCdot.org
