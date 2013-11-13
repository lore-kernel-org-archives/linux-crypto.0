From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: Error inserting sha256_ssse3: No such device
Date: Wed, 13 Nov 2013 04:33:37 +0100
Message-ID: <4AB85135-933E-497E-AFBB-64A9954F894B@bayour.com>
References: <0125C288-B77D-42DA-B018-FAD56CA0FAAC@bayour.com>
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from vsp-authed02.binero.net ([195.74.38.226]:28429 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867Ab3KMDdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Nov 2013 22:33:46 -0500
Received: from smtp01.binero.se (unknown [195.74.38.28])
	by vsp-authed-02-02.binero.net (Halon Mail Gateway) with ESMTPS
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2013 04:33:38 +0100 (CET)
Received: from [192.168.69.226] (c83-252-98-74.bredband.comhem.se [83.252.98.74])
	(Authenticated sender: turbo@bayour.com)
	by smtp-09-01.atm.binero.net (Postfix) with ESMTPSA id 0C0D93A11F
	for <linux-crypto@vger.kernel.org>; Wed, 13 Nov 2013 04:33:38 +0100 (CET)
In-Reply-To: <0125C288-B77D-42DA-B018-FAD56CA0FAAC@bayour.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Nov 13, 2013, at 4:08 AM, Turbo Fredriksson wrote:

> 	FATAL: Error inserting sha256_ssse3 (/lib/modules/3.12.0+scst+tf.1/kernel/arch/x86/crypto/sha256-ssse3.ko): No such 

Ok, so digging through the kernel source, I noticed that SSE? is apparently
a CPU feature. This is an AMD Phenom II X6 1100T which seems to only support
SSE and SSE2 (according to /proc/cpuinfo) which might explain the No such
device.

Now my question instead is, why did it try to load sha256_ssse3 in the first
place?
-- 
I love deadlines. I love the whooshing noise they
make as they go by.
- Douglas Adams
