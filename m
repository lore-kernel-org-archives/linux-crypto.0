From: "George Spelvin" <linux@sciencehorizons.net>
Subject: Re: [PATCH v4 0/5] /dev/random - a new approach
Date: 31 May 2016 18:34:46 -0400
Message-ID: <20160531223446.718.qmail@ns.sciencehorizons.net>
References: <1668650.acZVSyjHlL@positron.chronox.de>
Cc: andi@firstfloor.org, cryptography@lakedaemon.net,
	hpa@linux.intel.com, joe@perches.com, jsd@av8n.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@horizon.com, pavel@ucw.cz, sandyinchina@gmail.com
To: herbert@gondor.apana.org.au, smueller@chronox.de, tytso@mit.edu
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from science.sciencehorizons.net ([71.41.210.147]:49690 "HELO
	ns.sciencehorizons.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with SMTP id S1753673AbcEaWes (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 31 May 2016 18:34:48 -0400
In-Reply-To: <1668650.acZVSyjHlL@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I'll be a while going through this.

I was thinking about our earlier discussion where I was hammering on
the point that compressing entropy too early is a mistake, and just
now realized that I should have given you credit for my recent 4.7-rc1
patch 2a18da7a.  The hash function ("good, fast AND cheap!") introduced
there exploits that point: using a larger hash state (and postponing
compression to the final size) dramatically reduces the requirements on
the hash mixing function.

I wasn't conscious of it at the time, but I just now realized that
explaining it clarified the point in my mind, which led to applying
the principle in other situations.

So thank you!
