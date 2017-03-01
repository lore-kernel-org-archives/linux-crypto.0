From: Corentin Labbe <clabbe.montjoie@gmail.com>
Subject: Re: Problem with RSA test from testmgr
Date: Wed, 1 Mar 2017 13:04:14 +0100
Message-ID: <20170301120414.GA18217@Red>
References: <20170228155953.GA1732@Red>
 <1836837.jAzr4JNxJu@tauon.atsec.com>
 <20170228164553.GA2155@Red>
 <9482066.IEBbAWS9B8@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:36196 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750993AbdCAMF6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 1 Mar 2017 07:05:58 -0500
Content-Disposition: inline
In-Reply-To: <9482066.IEBbAWS9B8@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 28, 2017 at 11:35:04PM +0100, Stephan Müller wrote:
> Am Dienstag, 28. Februar 2017, 17:45:53 CET schrieb Corentin Labbe:
> 
> Hi Corentin,
> 
> > On Tue, Feb 28, 2017 at 05:08:35PM +0100, Stephan Müller wrote:
> > > Am Dienstag, 28. Februar 2017, 16:59:53 CET schrieb Corentin Labbe:
> > > 
> > > Hi Corentin,
> > > 
> > > > hello
> > > > 
> > > > I work on the sun8i-ce crypto accelerator and I have some problem with
> > > > the
> > > > RSA part.
> > > > 
> > > > The RSA register fail at the first RSA test (encrypt 512bit) with this
> > > > output: [ 8480.146843] alg: akcipher: encrypt test failed. Invalid
> > > > output
> > > > [ 8480.146871] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
> > > > [ 8480.146897] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
> > > > [ 8480.146921] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
> > > > [ 8480.146946] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
> > > > [ 8480.146995] alg: akcipher: test 1 failed for rsa-sun8i-ce, err=-22
> > > > 
> > > > But with the same parameters (msg, n, e) openssl give me exactly this
> > > > output.
> > > > 
> > > > So what I miss for made it work ?
> > > > In which format testmgr expect the output data ?
> > > 
> > > The output should be simply the binary string from the modular
> > > exponentiation operation.
> > > 
> > > What I am wondering is: the output logged above is not found in the
> > > expected values of testmgr.h. Which input data or test vectors do you
> > > use?
> > > 
> > > Ciao
> > > Stephan
> > 
> > I use the first test from rsa_tv_template in crypto/testmgr.h
> > The test fail on the encrypt operation.
> > 
> > I have put below the openssl program that give me the same output than my
> > hardware accelerator with the same parameters.
> 
> I would think the issue is that the OpenSSL BIGNUM lib has some issues: when 
> calculating m^e mod n, m has to be equal to the key size. The kernel's MPI 
> code handles the case where m is smaller than the key size.
> 
> Note, in your code below, ptext is the 8 bytes from ptext_ex plus trailing 
> zeroes whereas the kernel uses just the 8 bytes.
> 
> It seems that your implementation has the same issue.
> 
> What about the following test: change vector->m to be 64 bytes (i.e. 
> RSA_size(key) in size in testmgr.h and check the output of crypto/rsa.c, 
> openssl's output with the app below and your RSA hardware.

I got the following:

[    1.086228] alg: akcipher: encrypt test failed. Invalid output
[    1.092196] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
[    1.098882] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
[    1.105524] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
[    1.112090] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
[    1.118747] alg: akcipher: test 1 failed for rsa-generic, err=-22
(Exactly the output of my hardare and openssl test)

So the problem is just that my hardware does not handle non-padded data.

Thanks
Regards
Corentin Labbe
