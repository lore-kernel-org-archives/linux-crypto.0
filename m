From: Kent Borg <kentborg@borg.org>
Subject: HW Accelerated IPSEC?
Date: Tue, 07 Jun 2011 12:44:58 -0400
Message-ID: <4DEE558A.6050602@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:58463 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755613Ab1FGRFx (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Jun 2011 13:05:53 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kentborg)
	by borg.org (Postfix) with ESMTP id E6CE4186782
	for <linux-crypto@vger.kernel.org>; Tue,  7 Jun 2011 12:44:58 -0400 (EDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Does HW acceleration of IPSEC work?  I am trying to get it working on 
some new hardware, and for comparison I tried it on a Sheevaplug, 
various Linus kernels from 2.6.35 to 2.6.39.  All fail.  I reboot and 
rmmod mv_cesa and it IPSEC works on all of them.

Is the kernel broken?  Is mv_cesa broken?  Am I being stupid elsewhere?


Thanks,

-kb
