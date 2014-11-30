From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Is ansi_cprng.c supposed to be an implmentation of X9.31?
Date: Sun, 30 Nov 2014 15:26:35 +0100
Message-ID: <2758504.R15xM8Vjc0@tauon>
References: <20141128232351.27607.qmail@ns.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, jarod@redhat.com,
	nhorman@tuxdriver.com, linux-crypto@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:54845 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958AbaK3O0k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Nov 2014 09:26:40 -0500
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S9DDA> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Sun, 30 Nov 2014 15:26:36 +0100
In-Reply-To: <20141128232351.27607.qmail@ns.horizon.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 28. November 2014, 18:23:51 schrieb George Spelvin:

Hi George,

>I've been trying to understand the crypto layer, and it's a bit of a
>struggle because I'm trying to learn how it's supposed to work by
>reading the code, and I keep finding code I want to fix.

See Documentation/DocBook/crypto-API.tmpl in the cryptodev-2.6 tree. 
There you will find tons of documentation (which will be merged during 
3.19-rc1)

Ciao
Stephan
-- 
