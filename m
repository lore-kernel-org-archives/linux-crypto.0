From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: kernel failure while loading X.509 certificate
Date: Tue, 16 Jan 2018 21:16:27 -0800
Message-ID: <20180117051627.GA15527@zzz.localdomain>
References: <F5505112-180F-4889-A73E-D0AB9054E58E@linaro.org>
 <CAK8P3a1E6YOXK2heCz0eiaQLpzpb6jjnvyNK_Y4Fu8bjZuPDZw@mail.gmail.com>
 <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Mark Brown <broonie@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Eric Biggers <ebiggers@google.com>,
        David Howells <dhowells@redhat.com>,
        crypto <linux-crypto@vger.kernel.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
To: Paolo Valente <paolo.valente@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:46729 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750868AbeAQFQa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 17 Jan 2018 00:16:30 -0500
Received: by mail-pl0-f65.google.com with SMTP id 66so7959382plc.13
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jan 2018 21:16:30 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <48DEA233-E708-4661-B5F0-15CEC60877E4@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Paolo,

On Fri, Jan 12, 2018 at 07:06:12AM +0100, Paolo Valente wrote:
> 
> 
> > Il giorno 11 gen 2018, alle ore 23:37, Arnd Bergmann <arnd@arndb.de> ha scritto:
> > 
> > On Thu, Jan 11, 2018 at 7:29 PM, Paolo Valente <paolo.valente@linaro.org> wrote:
> >> Hi guys,
> >> this is a help request, for a problem that has been driving me crazy
> >> all day long, without any success :(
> >> 
> >> I've compiled a 4.15-rc7 custom kernel on a freshly-installed Fedora
> >> 27, using the usual "make ; make modules_install ; make install"
> >> procedure. No error reported while building.  But at boot the
> >> kernel immediately fails as follows, apparently while loading/parsing
> >> an X.509 certificate:
> > 
> > The BUG_ON() you hit is this one in public_key_verify_signature():
> > 
> >        BUG_ON(!sig->digest);
> > 
> > There was a patch series by Eric Biggers that touched these files to
> > add some fixes
> > after v4.15-rc1.  I'm not runnig that code myself, but it sounds like
> > a real regression,
> > so I'm adding Eric (to look at the code), the corresponding mailing
> > list and Thorsten
> > (for regression tracking) to Cc.
> > 
> > x509_cert_parse() allocates the 'cert->sig' structure, and calls
> > x509_get_sig_params(),
> > which may or may not allocate a digest. It returns with
> > cert->unsupported_sig=true
> > in case it fails to allocate a digest for some reason (crypto_alloc_shash failed
> > or no sig->hash_algo).
> > 
> > The full set of Eric's patches is
> > 
> > 54c1fb39fe04 X.509: fix comparisons of ->pkey_algo
> > 18026d866801 KEYS: reject NULL restriction string when type is specified
> > 3d1f0255426a security: keys: remove redundant assignment to key_ref
> > aa3300362060 X.509: use crypto_shash_digest()
> > 72f9a07b6bfa KEYS: be careful with error codes in public_key_verify_signature()
> > a80745a6de51 pkcs7: use crypto_shash_digest()
> > 7204eb8590c7 pkcs7: fix check for self-signed certificate
> > 8ecb506d3476 pkcs7: return correct error code if pkcs7_check_authattrs() fails
> > 8dfd2f22d3bf 509: fix printing uninitialized stack memory when OID is empty
> > 47e0a208fb9d X.509: fix buffer overflow detection in sprint_oid()
> > 0f30cbea005b X.509: reject invalid BIT STRING for subjectPublicKey
> > 81a7be2cd69b ASN.1: check for error from ASN1_OP_END__ACT actions
> > e0058f3a874e ASN.1: fix out-of-bounds read when parsing indefinite length item
> > 4dca6ea1d943 KEYS: add missing permission check for request_key() destination
> > a2d8737d5c78 KEYS: remove unnecessary get/put of explicit dest_keyring
> > 
> > and it's based on -rc2. If you want to do a quicker bisection, I'd
> > suggest you try
> > 4.15-rc2 and 54c1fb39fe04 to start with.
> > 
> 
> Thank you very much Arnd.  Fortunately, for the task I'm performing, a
> 4.14 will do too.  And I'm under pressure to finally finish this task.
> Yet, even before I finish with this task, I'm willing to do any test
> that the guys you added may want me to do.  And, if more useful for
> the community, ok for me to switch to the most appropriate public
> mailing lists.
> 

Have you managed to bisect this yet?  I'm not seeing how my changes could have
caused this, but it does seem there may be an existing bug where this BUG() can
be hit if a certificate's signature uses a hash algorithm that is not built into
the kernel.  To verify whether that is happening can you try adding:

diff --git a/crypto/asymmetric_keys/x509_public_key.c b/crypto/asymmetric_keys/x509_public_key.c
index 9338b4558cdc..f1804640445a 100644
--- a/crypto/asymmetric_keys/x509_public_key.c
+++ b/crypto/asymmetric_keys/x509_public_key.c
@@ -58,6 +58,8 @@ int x509_get_sig_params(struct x509_certificate *cert)
 	tfm = crypto_alloc_shash(sig->hash_algo, 0, 0);
 	if (IS_ERR(tfm)) {
 		if (PTR_ERR(tfm) == -ENOENT) {
+			pr_err("Hash algorithm %s not supported by crypto API\n",
+			       sig->hash_algo);
 			cert->unsupported_sig = true;
 			return 0;
 		}

If the pr_err() is hit then check the status of the corresponding CONFIG_CRYPTO_
option in your .config, for example CONFIG_CRYPTO_SHA256 if the algorithm is
"sha256".

Eric
