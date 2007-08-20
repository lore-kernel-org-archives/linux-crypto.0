From: Andi Kleen <ak@suse.de>
Subject: {twofish,aes}-{x86_64,i586} versus C implementations
Date: Mon, 20 Aug 2007 02:34:25 +0200
Message-ID: <200708200234.25620.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:57055 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570AbXHTAed (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 19 Aug 2007 20:34:33 -0400
Received: from Relay1.suse.de (mail2.suse.de [195.135.221.8])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id 8356A12D25
	for <linux-crypto@vger.kernel.org>; Mon, 20 Aug 2007 02:34:32 +0200 (CEST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hallo,

Currently there are two twofish and two aes implementions on x86.
Worse when both are enabled as modules a modprobe aes
will get the C version which seems to be slower on K8 
and about the same speed on Core2 on my tests.
 
Is there a specific reason why anybody would prefer the C functions
over the assembler functions? 

Possible reasons I could think of:
- If the assembler functions are optimized for a specific CPU the compiler
might be able to do a better job on other CPUs.
Is there evidence for this? I suspect it's not true.

- They are not trusted and might be buggy. I assume they have
been validated against the C versions with a wide range of input
data, correct? 

If none of these reasons are valid it might make sense to disable
the C versions for x86 and only offer the assembler versions.
Then modprobe aes|twofish would DTRT automatically.

Comments?

-Andi
