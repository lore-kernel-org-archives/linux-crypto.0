From: Matthias Urlichs <matthias@urlichs.de>
Subject: Re: [RFC] WireGuard: next generation secure network tunnel
Date: Fri, 1 Jul 2016 13:50:28 +0000 (UTC)
Message-ID: <loom.20160701T154859-125@post.gmane.org>
References: <CAHmME9q-6ioctzcB8gLdYOsMFqHVGY8GUsVGFisKv=wGdVqi2A@mail.gmail.com> <CAFLxGvzk5NywJou_g9_z6JQUrvcTNsAUPXt4R6AdS9nmRqYwcw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43310 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750715AbcGAQpU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 1 Jul 2016 12:45:20 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkc-linux-crypto@m.gmane.org>)
	id 1bJ1Yu-0003zi-Rp
	for linux-crypto@vger.kernel.org; Fri, 01 Jul 2016 18:45:04 +0200
Received: from vdsl.extern.smurf.noris.de ([213.95.133.148])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Fri, 01 Jul 2016 18:45:04 +0200
Received: from matthias by vdsl.extern.smurf.noris.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-crypto@vger.kernel.org>; Fri, 01 Jul 2016 18:45:04 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Richard Weinberger <richard.weinberger <at> gmail.com> writes:

> So every logical tunnel will allocate a new net device?
> Doesn't this scale badly? I have ipsec alike setups
> with many, many road warriors in mind.
> 
No.

>> When a locally generated packet hits the device, it looks at the dst IP,
>> looks up this dst IP in the aforementioned association table, and then 
>> encrypts it using the proper public key's session.

Thus: one device, many peers.

-- Matthias Urlichs
