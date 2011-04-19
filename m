From: Kent Borg <kentborg@borg.org>
Subject: shash_alg size fields and stomping memory
Date: Tue, 19 Apr 2011 14:29:16 -0400
Message-ID: <4DADD47C.1080701@borg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:56244 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab1DSSs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Apr 2011 14:48:57 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: kentborg)
	by borg.org (Postfix) with ESMTP id DF564186781
	for <linux-crypto@vger.kernel.org>; Tue, 19 Apr 2011 14:29:16 -0400 (EDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In struct shash_alg what are the various sizes for?  (WOuld be cool to 
know what everything is for in those alg structures...)

My most recent discovery is that if I want to do an shash_desc_ctx() and 
use the result, cra_ctxsize doesn't seem to mean a thing.  Rather, 
unless I set descsize, memory will be stomped.

And, while I am at it, what is "cra"? 


-kb, the Kent who would love to RTFM but there doesn't seem to be an FM.
