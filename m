Return-Path: <SRS0=g5s/=PY=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728037AbfAPQPY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 16 Jan 2019 11:15:24 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190107090449.d364ii24zervlsfq@sole.flsd.net>
References: <20190107090449.d364ii24zervlsfq@sole.flsd.net> <20190106133608.820-1-vt@altlinux.org> <1893001.R2IGJoHzOM@positron.chronox.de> <20190107080710.r4bh7gkqdysxmlnn@sole.flsd.net> <1714084.mfT8VG1pOj@tauon.chronox.de>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: dhowells@redhat.com, Stephan Mueller <smueller@chronox.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] crypto: Add EC-RDSA algorithm
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <21601.1547655320.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Jan 2019 16:15:20 +0000
Message-ID: <21602.1547655320@warthog.procyon.org.uk>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Vitaly Chikunov <vt@altlinux.org> wrote:

> > Regarding your comment (2), I am not sure I understand. Why do you say that 
> > the DER format cannot be parsed by the kernel's ASN.1 parser? For example, 
> 
> It can, but DER is stricter than BER. For example, in DER 'OCTET STRING'
> length field should be encoded in just one byte if it's smaller than
> 128, in BER it could be encoded in multiple encodings. This does not
> seem like a big deal, though. With BER decoder an improperly DER-encoded
> certificate could be successfully parsed.

Whilst that is true, I don't think it's that big a deal.  DER is a subset of
BER, so a BER decoder ought to be able to parse it.  Note that X.509 is
supposed to be DER, but we use a BER decoder for that too.

David
