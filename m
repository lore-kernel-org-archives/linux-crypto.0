From: Andi Kleen <andi@firstfloor.org>
Subject: Re: random(4) changes
Date: Mon, 25 Apr 2016 09:06:03 -0700
Message-ID: <87twipn05w.fsf@tassilo.jf.intel.com>
References: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>,
	Jason Cooper <jason@lakedaemon.net>,
	John Denker <jsd@av8n.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:9880 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751197AbcDYQGZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Apr 2016 12:06:25 -0400
In-Reply-To: <CACXcFm=PmD1_MqH5j-oY=X=mXD20jLMTuaPe9_GVY7JxN99MpA@mail.gmail.com>
	(Sandy Harris's message of "Fri, 22 Apr 2016 18:27:48 -0400")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Sandy Harris <sandyinchina@gmail.com> writes:

There is also the third problem of horrible scalability of /dev/random
output on larger systems, for which patches are getting ignored.

https://lkml.org/lkml/2016/2/10/716

Ignoring problems does not make them go away.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
