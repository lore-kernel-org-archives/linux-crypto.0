From: David =?UTF-8?Q?Ja=C5=A1a?= <djasa@redhat.com>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Wed, 15 Jun 2016 18:17:43 +0200
Message-ID: <1466007463.20087.11.camel@redhat.com>
References: <1668650.acZVSyjHlL@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbcFOQRt (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 15 Jun 2016 12:17:49 -0400
In-Reply-To: <1668650.acZVSyjHlL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Stephan,

Did you consider blocking urandom output or returning error until
initialized? Given the speed of initialization you report, it shouldn't
break any userspace apps while making sure that nobody uses predictable
pseudoranom numbers.

I was considering asking for patch (or even trying to write it myself)
to make current urandom block/fail when not initialized but that would
surely have to be off by default over "never break userspace" rule (eve=
n
if it means way too easy security problem with both random and urandom)=
=2E
Properties of your urandom implementation makes this point moot and it
could make the random/urandom wars over.

Best Regards,

David Ja=C5=A1a
