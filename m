Return-Path: <SRS0=FcWR=Q7=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CBDC43381
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E648204EC
	for <linux-crypto@archiver.kernel.org>; Sun, 24 Feb 2019 06:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfBXGsp (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 24 Feb 2019 01:48:45 -0500
Received: from vmicros1.altlinux.org ([194.107.17.57]:46620 "EHLO
        vmicros1.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbfBXGso (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 24 Feb 2019 01:48:44 -0500
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
        by vmicros1.altlinux.org (Postfix) with ESMTP id 046E672CCAC;
        Sun, 24 Feb 2019 09:48:41 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
        by imap.altlinux.org (Postfix) with ESMTPSA id C67134A4AE7;
        Sun, 24 Feb 2019 09:48:40 +0300 (MSK)
Date:   Sun, 24 Feb 2019 09:48:40 +0300
From:   Vitaly Chikunov <vt@altlinux.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190224064840.hii4ccjksjdnewae@altlinux.org>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190106133608.820-1-vt@altlinux.org>
 <20190106133608.820-2-vt@altlinux.org>
 <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
 <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
 <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
User-Agent: NeoMutt/20171215-106-ac61c7
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Herbert,

On Tue, Feb 19, 2019 at 12:37:32PM +0800, Herbert Xu wrote:
> On Sun, Feb 10, 2019 at 09:46:28PM +0300, Vitaly Chikunov wrote:
> >
> > >From the other point of view, set_params may never be called or
> > implemented. So, making it called first and move memory zeroing
> > into set_params may create more complications than simplicity.
> > 
> > Making both callbacks callable in any order also will not make
> > things simpler. (Need to be prepared to be called in different
> > order.)
> 
> How about encoding these parameters together with the public/private
> keys so that they can be set through the existing setkey functions?
> 
> You might want to have a look at how we handle this in crypto/dh.c.

Thanks. I viewed and thought about this idea. But, I think separate
set_params call will be the most simple and backward compatible approach.

[In the new patchset] I made set_params to be called before set_p*_key
call, thus set_p*_key will know everything to start processing the key
immediately. Also, I made set_params completely optional, so code that
rely on RSA can just not call it, and driver that actually needs
set_params may check if required parameters are set or return an error.

(I overthought about zeroing of memory (in previous mail) that turned
out completely non-problem as ctx in `struct crypto_akcipher' is always
zeroed and I don't need to use ctx from `struct akcipher_request').


More thoughts. Parameters are part of AlgorithmIdentifier which is
included in SubjectPublicKeyInfo together with subjectPublicKey.

This, to pass into set_params callback AlgorithmIdentifier is the same
as passing just parameters. But, passing SubjectPublicKeyInfo will
overlap with passing the key into set_pub_key. So, if we pass other
structure (SubjectPublicKeyInfo) into set_params we will logically
conflict with set_pub_key and that call will be alternative to
set_pub_key, making one of them redundant.

If we pass SubjectPublicKeyInfo into set_pub_key itself (making
set_params not needed) we will break ABI and compatibility with RSA
drivers, because whole SubjectPublicKeyInfo is not expected by the
drivers, or new set_pub_key need somehow signal to the driver that is
different parameters are going (callers should be aware of that too),
and/or we will need to change all RSA-centric code to use
SubjectPublicKeyInfo which will affect to much code (more than verify2
required I think). And this will offload work which is already done by
x509 parser into the drivers bloating their code needlessly.

Thus, I think to try to remove set_params will only increase complexity.
Now it's small, very flexible, and back compatible.

Thanks,

