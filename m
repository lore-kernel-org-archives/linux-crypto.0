From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH] crypto: Add support for ALG_SET_KEY_ID for skcipher
Date: Wed, 28 Oct 2015 02:08:29 +0100
Message-ID: <2166343.GZ3f8gdiNx@myon.chronox.de>
References: <1445994171-30914-1-git-send-email-marcel@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, dhowells@redhat.com,
	herbert@gondor.apana.org.au
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34425 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbbJ1BIe (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 27 Oct 2015 21:08:34 -0400
In-Reply-To: <1445994171-30914-1-git-send-email-marcel@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Oktober 2015, 02:02:51 schrieb Marcel Holtmann:

Hi Marcel,

> This adds support for a new socket options called ALG_SET_KEY_ID that
> allows providing the symmetric key via a key serial from the keys
> subsystem.
> 
> NOTE: Currently we do not have a dedicated symmetric key type and using
> the user key type is not optional. Also lookup_user_key() is currently
> private to the keys subsystem and might need to be exposed to usage by
> the crypto subystem first. This is just a RFC and not for merging !!!

First, thanks for sharing.

Albeit I have not had a deep look into that code, but I think your patch is 
incomplete: you have to tie the kernel crypto API to the key retention system 
in the Kconfig.

I guess that is one of the concerns that Herbert may have? See my other email 
regarding this.
-- 
Ciao
Stephan
