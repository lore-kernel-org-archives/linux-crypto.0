From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: PKCS#7: Verify internal certificate chain
Date: Thu, 31 Jul 2014 12:30:51 +0300
Message-ID: <20140731093051.GE30276@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: dhowells@redhat.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49574 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932277AbaGaJbk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 31 Jul 2014 05:31:40 -0400
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello David Howells,

This is a semi-automatic email about new static checker warnings.

The patch 8c76d79393cc: "PKCS#7: Verify internal certificate chain" 
from Jul 1, 2014, leads to the following Smatch complaint:

crypto/asymmetric_keys/pkcs7_verify.c:200 pkcs7_verify_sig_chain()
	 error: we previously assumed 'x509->issuer' could be null (see line 193)

crypto/asymmetric_keys/pkcs7_verify.c
   192	
   193			if (x509->issuer)
                            ^^^^^^^^^^^^
Check.

   194				pr_debug("- issuer %s\n", x509->issuer);
   195			if (x509->authority)
   196				pr_debug("- authkeyid %s\n", x509->authority);
   197	
   198			if (!x509->authority ||
   199			    (x509->subject &&
   200			     strcmp(x509->subject, x509->issuer) == 0)) {
                                                   ^^^^^^^^^^^^
Unchecked dereference.  But maybe a non-NULL ->subject implies ->issuer
is non-NULL?

   201				/* If there's no authority certificate specified, then
   202				 * the certificate must be self-signed and is the root
   203                           * of the chain.  Likewise if the cert is its own
   204                           * authority.
   205                           */
   206                          pr_debug("- no auth?\n");
   207                          if (x509->raw_subject_size != x509->raw_issuer_size ||
   208                              memcmp(x509->raw_subject, x509->raw_issuer,
   209                                     x509->raw_issuer_size) != 0)
   210                                  return 0;
   211  
   212                          ret = x509_check_signature(x509->pub, x509);
   213                          if (ret < 0)
   214                                  return ret;
   215                          x509->signer = x509;
   216                          pr_debug("- self-signed\n");
   217                          return 0;
   218                  }
   219  
   220                  /* Look through the X.509 certificates in the PKCS#7 message's
   221                   * list to see if the next one is there.
   222                   */
   223                  pr_debug("- want %s\n", x509->authority);
   224                  for (p = pkcs7->certs; p; p = p->next) {
   225                          pr_debug("- cmp [%u] %s\n", p->index, p->fingerprint);
   226                          if (p->raw_subject_size == x509->raw_issuer_size &&
   227                              strcmp(p->fingerprint, x509->authority) == 0 &&
   228                              memcmp(p->raw_subject, x509->raw_issuer,
   229                                     x509->raw_issuer_size) == 0)
   230                                  goto found_issuer;
   231                  }
   232  
   233                  /* We didn't find the root of this chain */
   234                  pr_debug("- top\n");
   235                  return 0;
   236  
   237          found_issuer:
   238                  pr_debug("- issuer %s\n", p->subject);
                                    ^^^^^^
Also this looks like it should be "subject" instead of "issuer" but
maybe they are the same?

   239                  if (p->seen) {
   240                          pr_warn("Sig %u: X.509 chain contains loop\n",
   241                                  sinfo->index);


regards,
dan carpenter
