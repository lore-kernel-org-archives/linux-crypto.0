Return-Path: <SRS0=wbmp=RB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB9C0C10F0B
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 04:25:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5A3C21841
	for <linux-crypto@archiver.kernel.org>; Tue, 26 Feb 2019 04:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbfBZEZu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 25 Feb 2019 23:25:50 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:34086 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfBZEZu (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 25 Feb 2019 23:25:50 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id AA60072CC61;
        Tue, 26 Feb 2019 07:25:47 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id 83AF44A4AE7;
        Tue, 26 Feb 2019 07:25:47 +0300 (MSK)
Date:   Tue, 26 Feb 2019 07:25:46 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Thiago Jung Bauermann <bauerman@linux.ibm.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Subject: Re: [PATCH v5 10/10] integrity: support EC-RDSA signatures for
 asymmetric_verify
Message-ID: <20190226042546.czh6me47f7xldgk2@altlinux.org>
Mail-Followup-To: Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
References: <20190224060828.2527-1-vt@altlinux.org>
 <20190224060828.2527-11-vt@altlinux.org>
 <874l8rr2dq.fsf@morokweng.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <874l8rr2dq.fsf@morokweng.localdomain>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thiago,

On Mon, Feb 25, 2019 at 06:20:49PM -0300, Thiago Jung Bauermann wrote:
> Vitaly Chikunov <vt@altlinux.org> writes:
> 
> > Allow to use EC-RDSA signatures for IMA by determining signature type by
> > the hash algorithm name. This works good for EC-RDSA since Streebog and
> > EC-RDSA should always be used together.
> >
> > Cc: Mimi Zohar <zohar@linux.ibm.com>
> > Cc: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
> > Cc: linux-integrity@vger.kernel.org
> > Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> > ---
> >  security/integrity/digsig_asymmetric.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/security/integrity/digsig_asymmetric.c b/security/integrity/digsig_asymmetric.c
> > index d775e03fbbcc..c4a3313e0210 100644
> > --- a/security/integrity/digsig_asymmetric.c
> > +++ b/security/integrity/digsig_asymmetric.c
> > @@ -104,9 +104,14 @@ int asymmetric_verify(struct key *keyring, const char *sig,
> >
> >  	memset(&pks, 0, sizeof(pks));
> >
> > -	pks.pkey_algo = "rsa";
> >  	pks.hash_algo = hash_algo_name[hdr->hash_algo];
> > -	pks.encoding = "pkcs1";
> > +	if (!strncmp(pks.hash_algo, "streebog", 8)) {
> 
> Is it possible to test hdr->hash_algo instead of pkcs.hash_algo? IMHO if
> an integer value is available it's preferable to check it rather than
> doing a string comparison.

Yes. But we have long tradition of comparing by the name too:

  --linux$ git grep str.*cmp.*'"sha[12]'
  drivers/crypto/mxs-dcp.c:       if (strcmp(halg->base.cra_name, "sha1") == 0)
  drivers/crypto/talitos.c:                   (!strcmp(alg->cra_name, "sha224") ||
  net/sctp/sysctl.c:              if (!strncmp(tmp, "sha1", 4)) {
  scripts/sign-file.c:    if (strcmp(hash_algo, "sha1") != 0) {
  security/integrity/ima/ima_main.c:              if (strncmp(str, "sha1", 4) == 0)
  --linux$ git grep str.*cmp.*hash_algo
  fs/ubifs/sb.c:  if (strcmp(hash_algo_name[hash_algo], c->auth_hash_name)) {
  scripts/sign-file.c:    if (strcmp(hash_algo, "sha1") != 0) {
  security/integrity/ima/ima_main.c:      if (error && strcmp(hash_algo_name[ima_hash_algo],
  security/keys/trusted.c:                                if (!strcmp(args[0].from, hash_algo_name[i])) {
  --linux$ git grep str.*cmp.*cra_name
  crypto/adiantum.c:      if (strcmp(streamcipher_alg->base.cra_name, "xchacha12") != 0 &&
  crypto/adiantum.c:          strcmp(streamcipher_alg->base.cra_name, "xchacha20") != 0)
  crypto/adiantum.c:      if (strcmp(hash_alg->base.cra_name, "nhpoly1305") != 0)
  crypto/algapi.c:                if (!strcmp(q->cra_driver_name, alg->cra_name) ||
  crypto/algapi.c:                    !strcmp(q->cra_name, alg->cra_driver_name))
  crypto/algapi.c:                        if (strcmp(alg->cra_name, q->cra_name) &&
  crypto/algapi.c:                            strcmp(alg->cra_driver_name, q->cra_name))
  crypto/algapi.c:                if (strcmp(alg->cra_name, q->cra_name))
  crypto/api.c:           fuzzy = !strcmp(q->cra_name, name);
  crypto/crypto_user_base.c:                      match = !strcmp(q->cra_name, p->cru_name);
  crypto/cts.c:   if (strncmp(alg->base.cra_name, "cbc(", 4))
  crypto/simd.c:          WARN_ON(strncmp(algs[i].base.cra_name, "__", 2));
  drivers/crypto/mxs-dcp.c:       if (strcmp(halg->base.cra_name, "sha1") == 0)
  drivers/crypto/talitos.c:                   !strncmp(alg->cra_name, "authenc(hmac(sha224)", 20)) {
  drivers/crypto/talitos.c:               if (!strncmp(alg->cra_name, "hmac", 4))
  drivers/crypto/talitos.c:                   !strncmp(alg->cra_name, "hmac", 4)) {
  drivers/crypto/talitos.c:                   (!strcmp(alg->cra_name, "sha224") ||
  drivers/crypto/talitos.c:                    !strcmp(alg->cra_name, "hmac(sha224)"))) {
  lib/crc-t10dif.c:           strncmp(alg->cra_name, CRC_T10DIF_STRING, strlen(CRC_T10DIF_STRING)))


After all pkey_algo, hash_algo, cra_name are set to strings to be used
somewhere. So both ways looks equal to me.

[I more wonder if we should leave algo names to be used as they are in
x509_note_signature() (to check for "rsa" and "ecrdsa"), since there are
no other pkey_algo's set in x509_note_pkey_algo().]

> Also, it would be good to have a comment here mentioning that Streebog
> and EC-RDSA should always be used together

Thanks,

> > +		pks.pkey_algo = "ecrdsa";
> > +		pks.encoding = "raw";
> > +	} else {
> > +		pks.pkey_algo = "rsa";
> > +		pks.encoding = "pkcs1";
> > +	}
> >  	pks.digest = (u8 *)data;
> >  	pks.digest_size = datalen;
> >  	pks.s = hdr->sig;
> 
> --
> Thiago Jung Bauermann
> IBM Linux Technology Center
