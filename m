From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH 1/1] crypto:algif_aead - Fix kernel panic on list_del
Date: Wed, 01 Feb 2017 16:47:56 +0100
Message-ID: <32306312.dDnCIAjQMB@tauon.atsec.com>
References: <3368ebb31bd1670b8ea8ff45c81807c8c0e6bc3b.1485948732.git.harsh@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, atul.gupta@chelsio.com,
        harshjain.prof@gmail.com, linux-crypto@vger.kernel.org
To: Harsh Jain <harsh@chelsio.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55738 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752433AbdBAPsB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Feb 2017 10:48:01 -0500
In-Reply-To: <3368ebb31bd1670b8ea8ff45c81807c8c0e6bc3b.1485948732.git.harsh@chelsio.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 1. Februar 2017, 21:10:28 CET schrieb Harsh Jain:

Hi Harsh,

> Kernel panics when userspace program try to access AEAD interface.
> Remove node from Linked List before freeing its memory.

Very good catch. Thank you.

Reviewed-by: Stephan Müller <smueller@chronox.de>

(PS: Herbert, in case you want to apply my patches regarding fixing the memory 
management for algif_aead and algif_skcipher, please note that this error is 
in the new function aead_free_rsgl/skcipher_free_sgl. Thus, if you think that 
my approach is good after all, I will need to re-send the patch.)

Ciao
Stephan
