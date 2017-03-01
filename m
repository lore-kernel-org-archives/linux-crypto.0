From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Problem with RSA test from testmgr
Date: Wed, 01 Mar 2017 16:07:17 +0100
Message-ID: <45107561.YcGaMWr4ZQ@tauon.atsec.com>
References: <20170228155953.GA1732@Red> <9482066.IEBbAWS9B8@positron.chronox.de> <20170301120414.GA18217@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170301120414.GA18217@Red>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Mittwoch, 1. März 2017, 13:04:14 CET schrieb Corentin Labbe:

Hi Corentin,

> 
> I got the following:
> 
> [    1.086228] alg: akcipher: encrypt test failed. Invalid output
> [    1.092196] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
> [    1.098882] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
> [    1.105524] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
> [    1.112090] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
> [    1.118747] alg: akcipher: test 1 failed for rsa-generic, err=-22
> (Exactly the output of my hardare and openssl test)
> 
> So the problem is just that my hardware does not handle non-padded data.

I guess the best course of action would be to patch the test vector to use the 
padded data.

Ciao
Stephan
