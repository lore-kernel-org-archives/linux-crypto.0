From: Kent Borg <kentborg@borg.org>
Subject: aes-generic.c: what mode is it?
Date: Mon, 28 Feb 2011 14:48:50 -0500
Message-ID: <4D6BFC22.2010505@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:58340 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124Ab1B1UI4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Feb 2011 15:08:56 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kentborg)
	by borg.org (Postfix) with ESMTP id 8D62C186782
	for <linux-crypto@vger.kernel.org>; Mon, 28 Feb 2011 14:48:51 -0500 (EST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hardware crypto drivers all seem to have encryption modes, but 
aes-generic.c does not.  But it must.  What is the mode of 
aes-generic.c?  ECB seems the most bare-bones...but if it is ECB, why 
not say so?


Thanks,

-kb the Kent who is trying to get some new crypto hardware working and 
is looking to do some cribbing.
