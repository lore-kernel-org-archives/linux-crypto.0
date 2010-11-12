From: Dan Rosenberg <drosenberg@vsecurity.com>
Subject: [CRYPTO] obfuscating kernel pointers
Date: Fri, 12 Nov 2010 08:32:01 -0500
Message-ID: <1289568721.3090.267.camel@Dan>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.vsecurity.com ([209.67.252.12]:64293 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab0KLNis (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Nov 2010 08:38:48 -0500
Received: from c-98-229-66-118.hsd1.ma.comcast.net (HELO [192.168.1.128]) (drosenbe@[98.229.66.118])
          (envelope-sender <drosenberg@vsecurity.com>)
          by mx1.vsecurity.com (qmail-ldap-1.03) with SMTP
          for <linux-crypto@vger.kernel.org>; 12 Nov 2010 13:32:01 -0000
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Crypto people,

I'm planning on submitting a patch that introduces a new %p format
specifier that obfuscates kernel pointers depending on privileges.  This
change is for security reasons - many networking protocols expose
pointers to socket structures in their /proc interfaces, which are
attractive targets when exploiting other issues.

It's been suggested that I initialize a secret value at boot, and use
that as the key to a crypto hash function.  I should use a function that
is relatively fast (ideally), produces a unique output based on its
input of a pointer, and produces consistent output when given the same
input.  It should be difficult to infer the input given only the output.

I have two questions:

1. What is a proper, safe way of initializing a random value at boot?
Are there any existing examples that do this?

2. Can you recommend a crypto algorithm that would be well suited for
this pointer obfuscation?

Thanks,
Dan
