From: Nikos Mavrogiannopoulos <n.mavrogiannopoulos@gmail.com>
Subject: Re: [PATCH 01/19] User-space API definition
Date: Fri, 03 Sep 2010 17:20:12 +0200
Message-ID: <4C81122C.3050800@gmail.com>
References: <1282293963-27807-1-git-send-email-mitr@redhat.com> <1282293963-27807-2-git-send-email-mitr@redhat.com> <20100903091842.GC28952@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: =?UTF-8?B?TWlsb3NsYXYgVHJtYcSN?= <mitr@redhat.com>,
	linux-crypto@vger.kernel.org, Neil Horman <nhorman@redhat.com>,
	linux-kernel@vger.kernel.org, Ted Ts'o <tytso@mit.edu>,
	Miloslav Trmac <mitr@redhat.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50003 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244Ab0ICPUQ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 3 Sep 2010 11:20:16 -0400
In-Reply-To: <20100903091842.GC28952@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/03/2010 11:18 AM, Herbert Xu wrote:
> I will be looking at this myself so please stay tuned and be ready
> to yell if you see that your requirements are not met.

On 08/20/2010 03:56 PM, Ted Ts'o wrote:
> So I'm bit at a list what's the whole point of this patch series.
> Could you explain that in the documentation, please?  Especially for
> crypto, explaining when something should be used, what the threat
> model is, etc., is often very important.

Hello,
 The document discussing the model, threats and design goals of this
framework can be found at:
https://www.cosic.esat.kuleuven.be/publications/article-1490.pdf

Comments and suggestions are welcome.

regards,
Nikos

PS. The existing (proposed) implementation covers about 90% of the
design goals, the rest are work in progress.
