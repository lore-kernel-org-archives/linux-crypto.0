From: "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v6 0/5] /dev/random - a new approach
Date: Mon, 15 Aug 2016 13:42:54 -0700
Message-ID: <2c3286c8-7150-12db-937d-b6407d50d748@linux.intel.com>
References: <4723196.TTQvcXsLCG@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: sandyinchina@gmail.com, Jason Cooper <cryptography@lakedaemon.net>,
	John Denker <jsd@av8n.com>, Joe Perches <joe@perches.com>,
	Pavel Machek <pavel@ucw.cz>,
	George Spelvin <linux@horizon.com>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>, herbert@gondor.apana.org.au,
	Ted Tso <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:40051 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932115AbcHOUm6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 15 Aug 2016 16:42:58 -0400
In-Reply-To: <4723196.TTQvcXsLCG@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 08/11/16 05:24, Stephan Mueller wrote:
> * prevent fast noise sources from dominating slow noise sources
>   in case of /dev/random

Can someone please explain if and why this is actually desirable, and if
this assessment has been passed to someone who has actual experience
with cryptography at the professional level?

	-hpa
