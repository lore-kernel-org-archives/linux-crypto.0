Return-Path: <SRS0=b7+G=PP=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:29065 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725550AbfAGIbp (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 7 Jan 2019 03:31:45 -0500
From: Stephan Mueller <smueller@chronox.de>
To: Vitaly Chikunov <vt@altlinux.org>
Cc: David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] crypto: Add EC-RDSA algorithm
Date: Mon, 07 Jan 2019 09:31:40 +0100
Message-ID: <1714084.mfT8VG1pOj@tauon.chronox.de>
In-Reply-To: <20190107080710.r4bh7gkqdysxmlnn@sole.flsd.net>
References: <20190106133608.820-1-vt@altlinux.org> <1893001.R2IGJoHzOM@positron.chronox.de> <20190107080710.r4bh7gkqdysxmlnn@sole.flsd.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 7. Januar 2019, 09:07:10 CET schrieb Vitaly Chikunov:

Hi Vitaly,

> > Why do you manually parse the ASN.1 structure instead of using the ASN.1
> > parser?
> 
> I am not sure this worth effort and will not be most degenerate use of
> asn1_ber_decoder, since 1) I only need to parse one type in each case:
> OCTET STRING string above code, and OIDs in below code; 2) this data is
> said to be in DER format, which asn1_ber_decoder can not enforce. Surely
> this will also produce more code and files.

RSA public keys also only contain n and e in the ASN.1 structure for which the 
ASN.1 parser is used (see linux/crypto/rsapubkey.asn1). As ASN.1 parsing is 
always having security issues, I would rather suggest to have this parsing 
implemented in one spot and not here and there.

Regarding your comment (2), I am not sure I understand. Why do you say that 
the DER format cannot be parsed by the kernel's ASN.1 parser? For example, 
when you generate RSA keys in DER format with, say, openssl, the kernel ASN.1 
parser will happily use them. Also, when I created my (not accepted) patch to 
load PQG domain parameters for DH using the ASN.1 parser, the PQG domain 
parameters created by openssl in DER format were processed well.

Ciao
Stephan
