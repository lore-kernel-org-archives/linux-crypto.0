From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH v2 2/2] crypto: engine - Permit to enqueue skcipher request
Date: Tue, 06 Jun 2017 16:07:25 +0200
Message-ID: <1595132.gd3LNaoxir@tauon.chronox.de>
References: <20170606134417.18850-1-clabbe.montjoie@gmail.com> <20170606134417.18850-3-clabbe.montjoie@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170606134417.18850-3-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Dienstag, 6. Juni 2017, 15:44:17 CEST schrieb Corentin Labbe:

Hi Corentin,

> The crypto engine could actually only enqueue hash and ablkcipher request.
> This patch permit it to enqueue skcipher requets by adding all necessary
> functions.
> The only problem is that ablkcipher and skcipher id are the same, so
> only one cipher type is usable on the same crypto engine.

Why do you think this is needed? I thought that skcipher is the successor to 
ablkcipher AND blkcipher. I.e. ablkcipher and blkcipher should be phased out. 
Thus, I would infer that any ablkcipher support should or could be dropped.

Ciao
Stephan
