From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 2/3] crypto: talitos - second prepare step for adding
 ahash algorithms
Date: Thu, 29 Apr 2010 22:02:24 -0500
Message-ID: <20100429220224.f8726538.kim.phillips@freescale.com>
References: <4bd82b32.0e0bca0a.3ac0.ffffa3a9@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:35342 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272Ab0EAHAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 May 2010 03:00:06 -0400
Received: from de01smr01.freescale.net (de01smr01.freescale.net [10.208.0.31])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o3U2nlKS022840
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 19:49:47 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by de01smr01.freescale.net (8.13.1/8.13.0) with ESMTP id o3U2xKl8003667
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 21:59:21 -0500 (CDT)
In-Reply-To: <4bd82b32.0e0bca0a.3ac0.ffffa3a9@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 28 Apr 2010 05:33:54 -0700
<lee.nipper@gmail.com> wrote:

> Used talitos_alg_template in talitos_crypto_alg
> so that it will accommodate ahash algorithms.
> Added some preparation code for ahash allocation and removal.
> No actual algorithms yet.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> ---

Acked-By: Kim Phillips <kim.phillips@freescale.com>

Kim
