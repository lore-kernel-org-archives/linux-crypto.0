From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] security: integrity: Remove select to deleted option PUBLIC_KEY_ALGO_RSA
Date: Mon, 07 Mar 2016 14:59:55 +0000
Message-ID: <19733.1457362795@warthog.procyon.org.uk>
References: <1457114406-29804-1-git-send-email-andreas.ziegler@fau.de> <18370.1457105029@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells@redhat.com, James Morris <james.l.morris@oracle.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-security-module@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Valentin Rothberg <valentinrothberg@gmail.com>
To: Andreas Ziegler <andreas.ziegler@fau.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54680 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbcCGPAA (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Mar 2016 10:00:00 -0500
In-Reply-To: <1457114406-29804-1-git-send-email-andreas.ziegler@fau.de>
Content-ID: <19732.1457362795.1@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andreas Ziegler <andreas.ziegler@fau.de> wrote:

> Commit d43de6c780a8 ("akcipher: Move the RSA DER encoding check to
> the crypto layer") removed the Kconfig option PUBLIC_KEY_ALGO_RSA,
> but forgot to remove a 'select' to this option in the definition of
> INTEGRITY_ASYMMETRIC_KEYS.
> 
> Let's remove the select, as it's ineffective now.
> 
> Signed-off-by: Andreas Ziegler <andreas.ziegler@fau.de>

Applied.
