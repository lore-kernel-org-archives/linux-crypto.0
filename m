From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: simd ciphers
Date: Wed, 28 Dec 2016 11:00:51 +0100
Message-ID: <3170771.4e7c0aHuJX@positron.chronox.de>
References: <3279008.xAQAe6ukNz@positron.chronox.de> <1497014.RmdRyQUAOo@positron.chronox.de> <20161228085938.GA11904@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:55180 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751193AbcL1KA6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 28 Dec 2016 05:00:58 -0500
In-Reply-To: <20161228085938.GA11904@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 28. Dezember 2016, 16:59:38 CET schrieb Herbert Xu:

Hi Herbert,

> > With 4.10-rc1, I also do not get the AES-NI implementations to work. do
> > you
> > have any ideas what may be the issue?
> 
> I'm having problems reproducing this.  Does it work for you if you
> build them as modules?

When I configure AES-NI as module, it works. When compiling it statically, the 
allocation returns an -ENOENT. 

Now, when I diff both config files after a simple toggle from AES-NI=y to =m I 
see (linux-4.10.config contains the static config, .config contains the module 
configuration):

$ diff -urN ../linux-4.10.config .config
--- ../linux-4.10.config        2016-12-28 10:56:51.805526584 +0100
+++ .config     2016-12-28 11:00:17.959608195 +0100
@@ -4062,8 +4062,8 @@
 CONFIG_CRYPTO_AUTHENC=m
 CONFIG_CRYPTO_TEST=m
 CONFIG_CRYPTO_ABLK_HELPER=m
-CONFIG_CRYPTO_SIMD=y
-CONFIG_CRYPTO_GLUE_HELPER_X86=y
+CONFIG_CRYPTO_SIMD=m
+CONFIG_CRYPTO_GLUE_HELPER_X86=m
 
 #
 # Authenticated Encryption with Associated Data
@@ -4132,7 +4132,7 @@
 #
 CONFIG_CRYPTO_AES=y
 CONFIG_CRYPTO_AES_X86_64=y
-CONFIG_CRYPTO_AES_NI_INTEL=y
+CONFIG_CRYPTO_AES_NI_INTEL=m
 CONFIG_CRYPTO_ANUBIS=m
 CONFIG_CRYPTO_ARC4=m
 CONFIG_CRYPTO_BLOWFISH=m

Ciao
Stephan
