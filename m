From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead when outlen is zero
Date: Tue, 21 Mar 2017 12:43:02 +0100
Message-ID: <3894659.2TbsNqkGul@tauon.atsec.com>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com> <5047201.43uXAH9qJG@positron.chronox.de> <CAFXBA=m10UrBr1qqJ3j9F-hUXL6Bm+iEi6jLLEv9tVmCXc_p1A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58194 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932242AbdCULnN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 07:43:13 -0400
In-Reply-To: <CAFXBA=m10UrBr1qqJ3j9F-hUXL6Bm+iEi6jLLEv9tVmCXc_p1A@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. März 2017, 11:59:54 CET schrieb Harsh Jain:

Hi Harsh,

> > Executing this command on a 4.9 kernel, I get:
> > 
> > bin/kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
> > f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a "" -t
> > "5f24c68cbe6f32c29652442bf5d483ad" -q ""
> > EBADMSG
> 
> Probably because s/w implementation is not trying to access dst sg
> pointer because there's nothing to copy in destination buffer.  1
> question If we don't have data to copy to destination buffer what
> should dst pointer contains?

The dst SGL should simply be discarded by implementations in the case you 
mention above.

The implementation receives the tag size and the supplied input buffer. If 
that input buffer length is equal to the tag length (i.e. no AAD and no 
ciphertext), why would the dst SGL be ever touched during decrytion?

Ciao
Stephan
