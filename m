From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 1/1] Disable fips-allowed for non-FIPS authenc ciphers
Date: Thu, 24 Sep 2015 18:58:52 +0200
Message-ID: <2226648.jSMMvDJZRs@tauon.atsec.com>
References: <1443110523-23473-1-git-send-email-john.haxby@oracle.com> <1443110523-23473-2-git-send-email-john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: John Haxby <john.haxby@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34315 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbbIXQ7B (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 24 Sep 2015 12:59:01 -0400
In-Reply-To: <1443110523-23473-2-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 24. September 2015, 17:02:03 schrieb John Haxby:

Hi John,

>Tests that contain non-FIPS ciphers and hashes cannot themselves be
>.fips-allowed because they will necessarily fail.
>
>Signed-off-by: John Haxby <john.haxby@oracle.com>

This is a good finding.

In fact, all authenc() ciphers are not FIPS approved ciphers.

The flag for that should be removed for all of those.

After checking in detail, the following FIPS flags should be removed as well:

- ecb(des)

- ansi_cprng (at least at the end of this year)


Ciao
Stephan
