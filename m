Return-Path: <SRS0=fnEV=PW=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p03-ob.smtp.rzone.de ([85.215.255.100]:8485 "EHLO
        mo4-p03-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfANJcR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Jan 2019 04:32:17 -0500
From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andy Lutomirski <luto@amacapital.net>,
        "Lee, Chun-Yi" <joeyli.kernel@gmail.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, keyrings@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>,
        Oliver Neukum <oneukum@suse.com>,
        Ryan Chen <yu.chen.surf@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Giovanni Gherdovich <ggherdovich@suse.cz>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jann Horn <jannh@google.com>,
        Andy Lutomirski <luto@kernel.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 2/6] crypto: kdf - SP800-108 Key Derivation Function
Date: Mon, 14 Jan 2019 10:31:53 +0100
Message-ID: <1573163.Xcg6e5WDL9@positron.chronox.de>
In-Reply-To: <20190112052758.GD639@sol.localdomain>
References: <20190103143227.9138-1-jlee@suse.com> <1830918.5I3Y3k8tQf@positron.chronox.de> <20190112052758.GD639@sol.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Samstag, 12. Januar 2019, 06:27:59 CET schrieb Eric Biggers:

Hi Eric,

[...]
> > 
> > +obj-$(CONFIG_CRYPTO_KDF) += kdf.o
> 
> This naming is too generic.  CONFIG_CRYPTO_KDF and kdf.c imply that this is
> related to all KDFs.  But actually it is an implementation of a few specific
> KDFs.  Can you give it a clearer name, like KDF_SP800?
> 
I am going to use kdf_sp800108 or CRYPTO_CONFIG_KDF_SP800108. The reason is 
that there are many SP800 documents.

Thanks

Ciao
Stephan
