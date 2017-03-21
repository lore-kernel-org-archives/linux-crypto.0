From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: BUG: Seems un-initialed dst pointer received from algif_aead when outlen is zero
Date: Tue, 21 Mar 2017 11:04:35 +0100
Message-ID: <5047201.43uXAH9qJG@positron.chronox.de>
References: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
To: Harsh Jain <harshjain.prof@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58182 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754332AbdCUKEk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 21 Mar 2017 06:04:40 -0400
In-Reply-To: <CAFXBA==w7CK_CiiVC37NN8=7p7=a=18sNd5VTnUkDCozrMvT+w@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 21. März 2017, 07:13:53 CET schrieb Harsh Jain:

Hi Harsh,

> Hi,
> 
> For tag only AEAD decrypt operation(Zero length Payload). The dst sg
> list pointer panic with general protection fault. I think it should be
> NULL when output buffer is supposed to be empty.
> 
> Kcapi command to re-produce the issue
> 
> ./kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k
> f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a ""
> -t "5f24c68cbe6f32c29652442bf5d483ad" -q ""
> 
> Its decrypt operation. Expected result should be EBADMSG.

Executing this command on a 4.9 kernel, I get:

bin/kcapi -x 2   -c "gcm(aes)" -i 0d92aa861746b324f20ee6b7 -k 
f4a6a5e5f2066f6dd9ec6fc5169c29043560ef595c9e81e76f42d29212cc581c -a "" -t 
"5f24c68cbe6f32c29652442bf5d483ad" -q ""
EBADMSG

There is no GP or other error. Can you please provide some details about your 
system? I.e. which kernel version and what cipher implementation resolves to 
gcm(aes)?

Thanks

Ciao
Stephan
