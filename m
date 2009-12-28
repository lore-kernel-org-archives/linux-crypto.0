From: Milan Broz <mbroz@redhat.com>
Subject: Re: [PATCH 1/4] dm-crypt: clarify cipher vs. cipher mode
Date: Mon, 28 Dec 2009 20:37:43 +0100
Message-ID: <4B390907.8010609@redhat.com>
References: <1262026755-23056-1-git-send-email-max@hinterhof.net> <1262026755-23056-2-git-send-email-max@hinterhof.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, linux-crypto@nl.linux.org,
	Jari Ruusu <jariruusu@users.sourceforge.net>,
	Alasdair G Kergon <agk@redhat.com>
To: Max Vozeler <max@hinterhof.net>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52904 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZL1TiM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 14:38:12 -0500
In-Reply-To: <1262026755-23056-2-git-send-email-max@hinterhof.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/28/2009 07:59 PM, Max Vozeler wrote:
> The original code used cc->cipher for two things:

> @@ -1014,6 +1014,7 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
>  	char *ivopts;
>  	unsigned int key_size;
>  	unsigned long long tmpll;
> +	char ciphermode[CRYPTO_MAX_ALG_NAME];

Today is CRYPTO_MAX_ALG_NAME 64 bytes but it can increase in future.
This should not be allocated on the stack.

But anyway, I see that the reason for this is to introduce multikey feature
(compatible with loop-AES mode). That's interesting idea.

But please can you add more explanation into documentation about this mode?
Is there any paper which analyses that mode - if so can you add link
to description?
(and yes, I know loop-AES documentation:-)

Milan
--
mbroz@redhat.com
