From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: prevent 112bit key for 3DES
Date: Fri, 12 Feb 2016 18:04:52 +0100
Message-ID: <1595498.hX9TKYfmmS@tauon.atsec.com>
References: <alpine.LNX.2.02.1602121744210.2898@i8.fpunygfrxha.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Roman Drahtmueller <draht@schaltsekun.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:33670 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865AbcBLRFB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 12 Feb 2016 12:05:01 -0500
In-Reply-To: <alpine.LNX.2.02.1602121744210.2898@i8.fpunygfrxha.qr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 12. Februar 2016, 17:45:24 schrieb Roman Drahtmueller:

Hi Roman,

>56 bit keys are already prevented from being used, which conforms to rfc2451.
>As of 2016, 112 bit 3DES should be prevented, too, if the expectation is
>that the algorithm uses 168 bit.
>
>Signed-off-by: Roman Drahtmueller <draht@schaltsekun.de>

This code is at least needed in FIPS 140-2 mode. As a caller would manually 
need to create a 2-key TDES key which would violate the newly added check ( 
which is very unlikely) I would think this patch is also appropriate for all 
users.

Acked-by: Stephan Mueller <smueller@chronox.de>
