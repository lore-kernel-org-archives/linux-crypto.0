From: Jamie Iles <jamie.iles@picochip.com>
Subject: IPSec AH hardware offload
Date: Tue, 20 Jan 2009 14:14:48 +0000
Message-ID: <20090120141448.GG3849@brook.picochip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail2.picochip.com ([82.111.145.34]:40947 "EHLO
	arun.picochip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750825AbZATOgE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jan 2009 09:36:04 -0500
Received: from localhost (jamiei.ovpn.rb.picochip.com [172.17.21.82])
	by arun.picochip.com (8.13.1/8.13.1) with ESMTP id n0KECuf8017868
	for <linux-crypto@vger.kernel.org>; Tue, 20 Jan 2009 14:12:56 GMT
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I'm currently developing a driver for a hardware crypto offload engine that is
capable of offloading both ESP and AH in IPSec. I've noticed that none of the
crypto drivers in 2.6.28 do offload for ahash and that the netkey AH
implementation both use synchronous hashes. Are the synchronous software
versions likely to be more efficient than hardware offloading or is there an
architectural reason for not using async hashes?

Cheers,

    Jamie
This email and any files transmitted with it are confidential and intended solely for the use of the individuals to whom they are addressed. If you have received this email in error please notify the sender and delete the message from your system immediately.

