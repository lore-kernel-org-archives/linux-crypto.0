From: Kent Borg <kentborg@borg.org>
Subject: Re: HW Accelerated IPSEC?
Date: Thu, 09 Jun 2011 14:53:31 -0400
Message-ID: <4DF116AB.8020105@borg.org>
References: <4DEE558A.6050602@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:55908 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab1FISxd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 9 Jun 2011 14:53:33 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kentborg)
	by borg.org (Postfix) with ESMTP id 89321186781
	for <linux-crypto@vger.kernel.org>; Thu,  9 Jun 2011 14:53:32 -0400 (EDT)
In-Reply-To: <4DEE558A.6050602@borg.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kent Borg wrote:
> Does HW acceleration of IPSEC work?

[...sounds of crickets...]

Let me re-phrase the question.

Should loading a crypto module (in this case mv_cesa in a Sheevaplug) 
cause IPSec to break?  (Is the crypto system wired up with IPSec?  Does 
that wiring work?)


Thanks,

-kb, the Kent who is trying verify his own new (iffy) crypto hardware 
driver, get it to work with IPSec, and was looking for some working example.
