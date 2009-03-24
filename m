From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: talitos - scaffolding for new algorithm
 types
Date: Tue, 24 Mar 2009 18:34:38 -0500
Message-ID: <20090324183438.2a72998a.kim.phillips@freescale.com>
References: <1237166510-7312-1-git-send-email-lee.nipper@gmail.com>
	<1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Lee Nipper <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:50896 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948AbZCXXQM (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 24 Mar 2009 19:16:12 -0400
In-Reply-To: <1237166510-7312-2-git-send-email-lee.nipper@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sun, 15 Mar 2009 20:21:48 -0500
Lee Nipper <lee.nipper@gmail.com> wrote:

> This patch is preparation for adding new algorithm types.
> 
> Some elements which are AEAD specific were renamed.
> The algorithm template structure was changed to
> use crypto_alg, and talitos_alg_alloc was made
> more general with respect to algorithm types.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>

Acked-by: Kim Phillips <kim.phillips@freescale.com>

Thanks for fixing up the algorithm registration code, Lee.

Kim
