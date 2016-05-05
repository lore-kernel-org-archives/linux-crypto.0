From: Andi Kleen <andi@firstfloor.org>
Subject: Re: UB in general ... and linux/bitops.h in particular
Date: Thu, 5 May 2016 10:32:14 -0700
Message-ID: <20160505173214.GP13997@two.firstfloor.org>
References: <572A6F1C.2080708@av8n.com>
 <CAH8yC8kZDfw+6Ctog-C7Jb57rLnagAFMNwNfGH_dwa9fs=5h1Q@mail.gmail.com>
 <28624BFC-7C63-4F38-9F67-7CBFB0C6499B@zytor.com>
 <CAH8yC8ndyLipAdu5=vmyJ3eHYBS-mxQsRF2q2G2EuOfQxTpM7g@mail.gmail.com>
 <0015E1DE-DFF9-4CCE-805E-7AC286021BED@zytor.com>
 <CAH8yC8mbW5yTwbKN7_RMNVnTiKmtP0u3_2+tKV=-L4BZ6miGVw@mail.gmail.com>
 <20160505035028.GD10776@thunk.org>
 <CAH8yC8n974Z=mvXPsLiZqYPkVjBqtR=nqYQ-jJo194ECmWkofA@mail.gmail.com>
 <572AE9A2.20609@zytor.com>
 <572B71A7.1020100@av8n.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "H. Peter Anvin" <hpa@zytor.com>, noloader@gmail.com,
	Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andi Kleen <andi@firstfloor.org>,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, linux-crypto@vger.kernel.org
To: John Denker <jsd@av8n.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from one.firstfloor.org ([193.170.194.197]:59152 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcEERcS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 May 2016 13:32:18 -0400
Content-Disposition: inline
In-Reply-To: <572B71A7.1020100@av8n.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

> Suggestions:
> 
>  a) Going forward, I suggest that UB should not be invoked
>   unless there is a good solid reason.

Good luck rewriting most of the kernel source.

This discussion is insane!

-Andi
