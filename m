From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto/fips: only panic on bad/missing crypto mod
 signatures
Date: Thu, 3 Jul 2014 21:44:12 +0800
Message-ID: <20140703134412.GD14291@gondor.apana.org.au>
References: <1403896374-62781-1-git-send-email-jarod@redhat.com>
 <1404329850-35509-1-git-send-email-jarod@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Stephan Mueller <stephan.mueller@atsec.com>,
	linux-crypto@vger.kernel.org
To: Jarod Wilson <jarod@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:38420 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbaGCNo3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Jul 2014 09:44:29 -0400
Content-Disposition: inline
In-Reply-To: <1404329850-35509-1-git-send-email-jarod@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 02, 2014 at 03:37:30PM -0400, Jarod Wilson wrote:
> Per further discussion with NIST, the requirements for FIPS state that
> we only need to panic the system on failed kernel module signature checks
> for crypto subsystem modules. This moves the fips-mode-only module
> signature check out of the generic module loading code, into the crypto
> subsystem, at points where we can catch both algorithm module loads and
> mode module loads. At the same time, make CONFIG_CRYPTO_FIPS dependent on
> CONFIG_MODULE_SIG, as this is entirely necessary for FIPS mode.
> 
> v2: remove extraneous blank line, perform checks in static inline
> function, drop no longer necessary fips.h include.
> 
> CC: Herbert Xu <herbert@gondor.apana.org.au>
> CC: "David S. Miller" <davem@davemloft.net>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Stephan Mueller <stephan.mueller@atsec.com>
> CC: linux-crypto@vger.kernel.org
> Signed-off-by: Jarod Wilson <jarod@redhat.com>

Patch applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
