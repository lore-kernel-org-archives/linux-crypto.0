From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: v4.6-rc1 regression bisected, Problem loading in-kernel X.509
 certificate (-2)
Date: Wed, 4 May 2016 06:38:46 -0700
Message-ID: <d9898765-6024-ab7c-fbcb-8c5103e10173@intel.com>
References: <45d1a06b-4ec4-17f5-2888-3068558da0bb@gmail.com>
 <20160503172536.GC20775@cucamonga.audible.transient.net>
 <20160430083248.GA20775@cucamonga.audible.transient.net>
 <26795.1462266613@warthog.procyon.org.uk>
 <11323.1462307740@warthog.procyon.org.uk>
 <20160504022608.GF20775@cucamonga.audible.transient.net>
 <21436.1462352509@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Tadeusz Struk <tstruk@gmail.com>,
	Jamie Heilman <jamie@audible.transient.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: David Howells <dhowells@redhat.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:37231 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202AbcEDNjq (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 4 May 2016 09:39:46 -0400
In-Reply-To: <21436.1462352509@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi David
On 05/04/2016 02:01 AM, David Howells wrote:
> Do you want to push this via Herbert's tree?
> 

Yes, I think Herbert has some more patches queued for rc-7.
Let me also send a proper one with the signed-off tag.

---8<---
Subject: crypto: rsa - select crypto mgr dependency

The pkcs1pad template needs CRYPTO_MANAGER so it needs
to be explicitly selected by CRYPTO_RSA.

Reported-by: Jamie Heilman <jamie@audible.transient.net>
Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 crypto/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/crypto/Kconfig b/crypto/Kconfig
index 93a1fdc..1d33beb 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -96,6 +96,7 @@ config CRYPTO_AKCIPHER
 config CRYPTO_RSA
 	tristate "RSA algorithm"
 	select CRYPTO_AKCIPHER
+	select CRYPTO_MANAGER
 	select MPILIB
 	select ASN1
 	help

-- 
TS
