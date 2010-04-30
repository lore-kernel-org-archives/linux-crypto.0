From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: [PATCH 1/3] crypto: talitos - prepare for adding ahash
 algorithms
Date: Thu, 29 Apr 2010 22:01:59 -0500
Message-ID: <20100429220159.99131765.kim.phillips@freescale.com>
References: <4bd82b30.161a640a.6b45.4e9c@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: <lee.nipper@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from az33egw02.freescale.net ([192.88.158.103]:35335 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab0EAHAG (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 1 May 2010 03:00:06 -0400
Received: from az33smr01.freescale.net (az33smr01.freescale.net [10.64.34.199])
	by az33egw02.freescale.net (8.14.3/az33egw02) with ESMTP id o3U2nMRs022748
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 19:49:26 -0700 (MST)
Received: from az33exm22.fsl.freescale.net (az33exm22.am.freescale.net [10.64.32.10])
	by az33smr01.freescale.net (8.13.1/8.13.0) with ESMTP id o3U2vmvP003493
	for <linux-crypto@vger.kernel.org>; Thu, 29 Apr 2010 21:57:48 -0500 (CDT)
In-Reply-To: <4bd82b30.161a640a.6b45.4e9c@mx.google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 28 Apr 2010 05:33:52 -0700
<lee.nipper@gmail.com> wrote:

> No functional changes.
> Use a union in talitos_alg_template for the crypto_alg
> so that we can add a member later for ahash_alg.
> 
> Signed-off-by: Lee Nipper <lee.nipper@gmail.com>
> ---

Acked-By: Kim Phillips <kim.phillips@freescale.com>

Kim
