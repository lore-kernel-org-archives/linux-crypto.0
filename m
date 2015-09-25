From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCHv2 1/1] Disable fips-allowed for authenc() and des() ciphers
Date: Fri, 25 Sep 2015 07:58:10 +0200
Message-ID: <1970269.pETRl5cENR@tauon.atsec.com>
References: <1443115475-27398-1-git-send-email-john.haxby@oracle.com> <1443115475-27398-2-git-send-email-john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>
To: John Haxby <john.haxby@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34319 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754439AbbIYF6N (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 25 Sep 2015 01:58:13 -0400
In-Reply-To: <1443115475-27398-2-git-send-email-john.haxby@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 24. September 2015, 18:24:35 schrieb John Haxby:

Hi John,

>No authenc() ciphers are FIPS approved, nor is ecb(des).
>After the end of 2015, ansi_cprng will also be non-approved.
>
>Signed-off-by: John Haxby <john.haxby@oracle.com>

Acked-by: Stephan Mueller <smueller@chronox.de>


Ciao
Stephan
