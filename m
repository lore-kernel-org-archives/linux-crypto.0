From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: Tue, 21 Jun 2016 19:23:19 +0200
Message-ID: <6038462.HIH9pGNYO7@positron.chronox.de>
References: <1466007463.20087.11.camel@redhat.com> <1466515196.17017.8.camel@redhat.com> <e70c9e01-5e48-a26a-d485-ca512c111cbc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Tomas Mraz <tmraz@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
	David =?utf-8?B?SmHFoWE=?= <djasa@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, sandyinchina@gmail.com,
	Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	Joe Perches <joe@perches.com>, Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:37732 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbcFURXY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 13:23:24 -0400
In-Reply-To: <e70c9e01-5e48-a26a-d485-ca512c111cbc@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. Juni 2016, 13:18:33 schrieb Austin S. Hemmelgarn:

Hi Austin,

> > You have to trust the host for anything, not just for the entropy in
> > timings. This is completely invalid argument unless you can present a
> > method that one guest can manipulate timings in other guest in such a
> > way that _removes_ the inherent entropy from the host.
> 
> When dealing with almost any type 2 hypervisor, it is fully possible for
> a user other than the one running the hypervisor to manipulate
> scheduling such that entropy is reduced.  This does not imply that the

Please re-read the document: Jitter RNG does not rest on scheduling.


Ciao
Stephan
