From: Neil Horman <nhorman@tuxdriver.com>
Subject: Re: [PATCH] crypto: RNGs must return 0 in success case
Date: Fri, 6 Mar 2015 08:14:03 -0500
Message-ID: <20150306131403.GB15626@hmsreliant.think-freely.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56112 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753857AbbCFNOS (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 08:14:18 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


>Change the RNGs to always return 0 in success case.

>This patch ensures that seqiv.c works with RNGs other than krng. seqiv
>expects that any return code other than 0 is an error. Without the
>patch, rfc4106(gcm(aes)) will not work when using a DRBG or an ANSI
>X9.31 RNG.

For the X9.31 bits:
Acked-by: Neil Horman <nhorman@tuxdriver.com>
